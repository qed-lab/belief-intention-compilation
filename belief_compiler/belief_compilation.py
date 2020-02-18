import Domain
import fluenttree
import Utils
import Problem
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
        pass

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


if __name__ == '__main__':

    dom_string = Utils.get_trimmed_string_from_file(r'../samples/rooms-domain.pddl')
    dom_child, _ = Utils.find_child(dom_string)

    prob_string = Utils.get_trimmed_string_from_file(r'../samples/rooms-problem.pddl')
    problem_child, _ = Utils.find_child(prob_string)

    prob = Problem.Problem(problem_child)
    dom = Domain.Domain(dom_child)

    bcp = BeliefCompiledProblem(dom, prob)
    print([str(x) for x in bcp.compiled_domain.predicates])


