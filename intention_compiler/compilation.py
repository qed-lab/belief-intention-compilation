import Domain
import Problem
import Operator
import itertools

class CompiledProblem:
    def __init__(self, domain, problem):
        self.domain = domain
        self.problem = problem
        self.relevant_effects = self.find_relevant_effects()
        self.possible_intentions = self.find_possible_intentions()
        self.intention_effect_combos = itertools.product(self.relevant_effects, self.possible_intentions)

    # "Possible and relevant" means the intersection of what
    # predicates are effects of some action, and what predicates
    # are preconditions to some action
    # TODO: Treat "NOT" specially
    # TODO: Treat intends effects specially
    def find_relevant_effects(self):
        possible_relevant_effects = []
        rel_effects = set()
        rel_effects.union(self.problem.goal.predicates())
        for act in self.domain.actions:
            rel_effects.union(act.precondition.predicates())
        return rel_effects

    # An intention is possible if it's in the initial state,
    # or is an effect of some action.
    # We don't care about the objects from an initial state,
    # just what predicates are there
    def find_possible_intentions(self):
        intentions = set()
        for action in self.domain.actions:
            intentions.update(action.effect.intentional_effects())
        # for
        return intentions


    def compiled_domain(self):
        dom = Domain.Domain(None)
        # Do stuff
        return dom



    def compiled_domain_string(self):
        prelude = """;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; The domain "{}", compiled for use in planners 
;;;  that do not support intention.
;;; Uses the compilation defined by Patrik Haslum (2012)
;;; Implemented by Matthew Christensen and Jennifer Nelson (2020)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"""\
            .format(self.domain.name)

        domain_name = self.domain.name + "-compiled"

        body = ""
        # body = f"""
# (define (domain {domain_name})
#     (:requirements {OG_reqs_except_intentionality} {our_requirements})
#     (:types
#     {types}
#     )
#     (:predicates
#     {OG_predicates}
#     {new_predicates}
#     )
#     {compiled_actions}
# )
#
# """\



        return prelude + body

    def get_compiled_action(self, action):
        return ""

    def get_compiled_action_preconditions(self, action, intention, chosen_effect):
        action_precondition = action.precondition

        gotta_intend_it_precondition = ""
