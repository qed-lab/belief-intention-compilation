import Domain
import Problem
import copy
import Operator
import fluenttree
import itertools


class HaslumCompilation:
    def __init__(self, domain, problem):
        self.domain = domain
        self.problem = problem
        self.relevant_effects = self.find_relevant_effects()
        self.possible_intentions = self.find_possible_intentions()
        self.intention_effect_combos = itertools.product(self.relevant_effects, self.possible_intentions)

    # "Possible and relevant" means the intersection of what
    # predicates are effects of some action, and what predicates
    # are preconditions to some action
    # This finds relevant effects
    # TODO: Treat "NOT" specially
    # TODO: Treat intends effects specially
    def find_relevant_effects(self):
        rel_effects = set()
        rel_effects.update(self.problem.goal.abstracted_predicates())
        for act in self.domain.actions:
            rel_effects.update(act.precondition.abstracted_predicates())
        return rel_effects

    # TODO: Store effects as the predicate name, arity, and if "not"-ed
    def possible_effects_of_action(self, action):
        return action.effect.abstracted_predicates()

    # An intention is possible if it's in the initial state,
    # or is an effect of some action.
    # We don't care about the objects from an initial state,
    # just what predicates are there
    def find_possible_intentions(self):
        # intentions = set()
        # for action in self.domain.actions:
        #     intentions.update(action.effect.intentional_effects())
        # # for
        # return intentions
        return self.domain.predicates


    def compiled_domain(self):
        dom = Domain.Domain(None)

        # New name
        dom.name = self.domain.name + "-compiled"

        dom.prelude = f"""{self.domain.prelude}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; The domain "{self.domain.name}", compiled for use in planners{" "*max(21-len(self.domain.name), 0)};;;
;;;  that do not support intention.                                 ;;;
;;; Uses the compilation defined by Patrik Haslum (2012)            ;;;
;;; Implemented by Matthew Christensen and Jennifer Nelson (2020)   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"""

        dom.requirements = self.domain.requirements
        dom.requirements.remove(":intentionality")
        dom.requirements.remove(":delegation")
        dom.requirements.append(":adl") #TODO: May have to remove and add back in if double-adding is bad

        # Same types
        dom.type_string = self.domain.type_string

        # Same predicates, plus our predicates
        dom.predicates = self.domain.predicates
        # dom.predicates += self.second_order_predicates()

        # Non-agent actions
        dom.actions = [a for a in self.domain.actions if len(a.agents) == 0]

        dom.actions += self.get_compiled_actions()




        return dom

    def get_compiled_actions(self):
        intentional_actions = [a for a in self.domain.actions if len(a.agents) != 0]
        compiled_actions = []
        for act in intentional_actions:
            compiled_actions += self.get_compiled_actions_of_action(act)
        return compiled_actions


    def get_compiled_actions_of_action(self, action):
        # Get relevant effects from within this action
        # possible_and_relevant_effects = self.possible_effects_of_action(action).intersection(self.relevant_effects)
        possible_and_relevant_effects = [x for x in self.possible_effects_of_action(action) if x in self.relevant_effects]
        possible_intentions = self.possible_intentions

        combos = itertools.product(possible_and_relevant_effects, possible_intentions)

        actions = []
        for effect, intent in list(combos):
            effect_name = f"{'not-' if effect.is_not else ''}{'intends-' if effect.is_intention else ''}{'eq' if effect.identifier=='=' else effect.identifier}"
            act_name = f"{action.name}-for-{effect_name}-because-intends-{intent.identifier}"

            # parameters = action.parameters + [f"intent-param-{i}" for i in range(intent.arity)]
            parameters = copy.deepcopy( action.parameters)
            parameters.parameters += [f"{i}-for-intent" for i in intent.parameters] #  [f"?intent-param-{i}" for i in range(intent.arity)] +
            parameters.types += intent.types

            preconditions = fluenttree.FluentTree("and ")
            preconditions.is_leaf = False
            preconditions.child_trees.append(action.precondition)
            # TODO: What about multi-agent actions???
            preconditions.child_trees.append(fluenttree.FluentTree(
                f"(intends-{intent.identifier} {action.agents[0]} {' '.join([f'{i}-for-intent' for i in intent.parameters])})" ))

            # TODO: Delegate preconditions are complex

            effects = fluenttree.FluentTree("and ")
            effects.is_leaf = False
            effects.child_trees.append(action.effect) # TODO: Modify effect to flatten (intends ?a (pred ?x ?y)) -> (intends-pred ?a ?x ?y)

            # TODO: (justified-prec-intends-intent ?prec-params ?actor ?intent-params) for all preconditions.
            #  Tricky if preconditions not simple list, or are not-ed


            new_action = Operator.Operator(None)
            new_action.name = act_name
            new_action.parameters = parameters
            new_action.precondition = preconditions
            new_action.effect = effects
            actions.append(new_action)
        return actions

    def get_versions_of_expressioned_action(self, action):
        expression_indices = [i for i,t in enumerate(action.parameters.types) if t.lower() == "expression"]
        if len(expression_indices) == 0:
            return [action]
        else:
            versions = []
            # Enumerate all the things the expression(s) could take
            possible_expressions = itertools.product(self.domain.predicates, repeat=len(expression_indices))

            for instantiation in possible_expressions:
                parameters = copy.deepcopy(action.parameters)
                action_pre_string = action.precondition.to_string().strip("() ")
                action_eff_string = action.effect.to_string().strip("() ")

                # For each expression parameter, replace the name/types in parameter list
                for expr_index, expression_inst in zip(reversed(expression_indices), instantiation):
                    expression_name = action.parameters.parameters[expr_index]
                    new_expr_params = [f"{p}-for-{expression_name.strip('? ')}" for p in expression_inst.parameters]
                    parameters.parameters[expr_index:expr_index+1] = new_expr_params
                    parameters.types[expr_index:expr_index+1] = expression_inst.types

                    action_pre_string = action_pre_string.replace(expression_name, f"({expression_inst.identifier} {' '.join(new_expr_params)})")
                    action_eff_string = action_eff_string.replace(expression_name, f"({expression_inst.identifier} {' '.join(new_expr_params)})")

            # TODO new action from blank, not copy
                new_pre = fluenttree.FluentTree(action_pre_string)
                new_eff = fluenttree.FluentTree(action_eff_string)

                new_action = Operator.Operator(None)
                new_action.parameters = parameters
                new_action.precondition = new_pre
                new_action.effect = new_eff
                new_action.name = f"{action.name}-{'-'.join([inst.identifier for inst in instantiation])}"
                new_action.agents = action.agents

                versions.append(new_action)

            return versions




""" NOTES:

a-e-because-intends-p x y  --> {action.name}_{compNum}_{chosen effect name}_bc-intends-{intention}
chosen effect name requires special attention:
  - (not (= ?groom ?bride)) -> not-eq-groom-bride
  - (not (controls ?character ?genie)) -> not-controls-character-genie
  - (controls ?character ?genie) -> controls-character-genie

Similar translation for the intention, but it's unclear at the moment how to determine the params.
What happens if a character intends two similar things? 
>>> (intends Alex (dead goblin)) and (intends Alex (dead dragon))
In parameterized language, this is (intends ?character (dead ?monster)).

"""