import Domain
import fluenttree
import Utils
import Problem
from Operator import Operator
from copy import deepcopy
import parsee

class BeliefCompiledProblem():
    def __init__(self, domain, problem):
        self.base_domain = domain
        self.base_problem = problem

        self.compiled_domain = Domain.Domain(None)
        self.compiled_problem = Problem.Problem(None)

        # Compiling Problem
        self.compiled_problem.init_state = self.find_init_state()
        self.compiled_problem.goal = self.base_problem.goal   # TODO: Flatten belief in goal? Can belief even be a goal?
        self.compiled_problem.name = self.base_problem.name + '-bompiled'
        self.compiled_problem.dom_name = self.base_problem.dom_name + '-bompiled'
        self.compiled_problem.objects = self.base_problem.objects

        # Compiling Domain
        self.compiled_domain.name = self.base_domain.name + '-bompiled'
        self.compiled_domain.type_string = self.base_domain.type_string
        self.compiled_domain.prelude = f"""{self.base_domain.prelude}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; The domain "{self.base_domain.name}", compiled for use in planners{" "*max(21-len(self.base_domain.name), 0)};;;
;;;  that support intention.                                        ;;;
;;;                                                                 ;;;
;;; Compilation by Matthew Christensen and Jennifer Nelson (2020)   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"""
        self.compiled_domain.requirements = self.base_domain.requirements
        self.compiled_domain.requirements.remove(':belief')
        self.compiled_domain.predicates = self.find_predicates()
        self.compiled_domain.actions = self.find_actions()


    def find_actions(self):
        actions = []
        for act in self.compiled_domain.actions:
            if len(act.agents) == 0:
                actions.append(act)
            else:
                generate_belief_action(act, "success")
                generate_belief_action(act, "fail")


    def find_predicates(self):
        base_preds = self.base_domain.predicates
        breds = []
        for pred in base_preds:
            breds.append(fluenttree.AbstractPredicate(f"believes-{pred.identifier} ?who - character " + ' '.join([p + ' - ' + t for p, t in zip(pred.parameters, pred.types)])))
        return base_preds + breds

    def find_init_state(self):
        state = []
        for pred in [fluenttree.AbstractPredicate(c) for c in self.base_problem.init_state]:
            if pred.is_belief:
                pred = fluenttree.AbstractPredicate(f"believes-{pred.identifier} {' '.join(pred.parameters)}")
            state.append(pred)


        return state


def generate_belief_action(original_action, suffix):
    """
    Creates a new Operator object with all preconditions converted into belief preconditions.
    :param original_action:
    :param suffix:
    :return:
    """
    dupe = Operator(None)
    dupe.name = original_action.name + "_" + suffix
    dupe.agents = original_action.agents
    dupe.parameters = original_action.parameters

    belief_sets = []
    for agent in original_action.agents:
        copied_preconditions = deepcopy(original_action.precondition)
        make_beleaves(copied_preconditions, agent)
        belief_sets.append(copied_preconditions)
    # dupe.precondition = convert_to_belief_string(original_action.precondition)
    dupe.precondition = fluenttree.FluentTree("and ")
    dupe.precondition.is_leaf = False
    dupe.precondition.child_trees += belief_sets

    if suffix == "success":
        dupe.precondition.child_trees.append(deepcopy(original_action.precondition))
        dupe.effect = convert_effects( original_action.effect, original_action.agents)

    elif suffix == "fail":
        prec_not_met_tree = fluenttree.FluentTree("not ")
        prec_not_met_tree.is_leaf = False
        prec_not_met_tree.child_trees.append(deepcopy(original_action.precondition))
        dupe.precondition.child_trees.append(prec_not_met_tree)
        dupe.effect = convert_effects( original_action.fail, original_action.agents)

    return dupe


def make_beleaves(ft, agent):
    if ft.is_leaf:
        ft.identifier = "believes_" + ft.identifier
        ft.words.insert(1, agent)
    else:
        ft.child_trees = [c for c in ft.child_trees if not c.is_belief]
        for child in ft.child_trees:
            make_beleaves(child, agent)


def flatten_beliefs(ft):
    if ft.is_leaf:
        return
    else:
        new_children = []
        for c in ft.child_trees:
            if not c.is_belief:
                new_children.append(c)
            else:
                c_predicate_form = fluenttree.AbstractPredicate(c)
                new_child = fluenttree.FluentTree("believes_" + c_predicate_form.identifier + ' ' + ' '.join(c_predicate_form.parameters))
                new_children.append(new_child)
        ft.child_trees = new_children
        for c in ft.child_trees:
            flatten_beliefs(c)



def convert_effects(ft, agent_list):
    res = fluenttree.FluentTree("and ")
    res.is_leaf = False
    believe_effect_sets = []
    for agent in agent_list:
        believe_effects = deepcopy(ft)
        make_beleaves(believe_effects, agent)
        believe_effect_sets.append(believe_effects)
    flattened_effects = deepcopy(ft)
    flatten_beliefs(flattened_effects)
    res.child_trees += believe_effect_sets
    res.child_trees.append(flattened_effects)
    return res


if __name__ == '__main__':

    dom_string = Utils.get_trimmed_string_from_file(r'../samples/rooms-domain.pddl')
    dom_child, _ = Utils.find_child(dom_string)

    prob_string = Utils.get_trimmed_string_from_file(r'../samples/rooms-problem.pddl')
    problem_child, _ = Utils.find_child(prob_string)

    prob = Problem.Problem(problem_child)
    dom = Domain.Domain(dom_child)

    bcp = BeliefCompiledProblem(dom, prob)
    print([str(x) for x in bcp.compiled_domain.predicates])


