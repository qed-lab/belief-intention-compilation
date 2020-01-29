import Domain
import Problem
import itertools

class CompiledProblem:
    def __init__(self, domain, problem):
        self.raw_domain = domain
        self.raw_problem = problem
        self.relevant_effects = self.find_relevant_effects()
        self.possible_intentions = self.find_possible_intentions()
        self.intention_effect_combos = itertools.product(self.relevant_effects, self.possible_intentions)
        # self.intention_effect_combos = cartesian_product(self.relevant_effects, self.possible_intentions)

    # "Possible and relevant" means the intersection of what
    # predicates are effects of some action, and what predicates
    # are preconditions to some action
    # TODO: Treat "NOT" specially
    # TODO: Treat intends effects specially
    def find_relevant_effects(self):
        possible_relevant_effects = []
        rel_effects = set()
        rel_effects.union(self.raw_problem.goal.predicates())
        for act in self.raw_domain.actions:
            rel_effects.union(act.precondition.predicates())
        return rel_effects

    # An intention is possible if it's in the initial state,
    # or is an effect of some action.
    # We don't care about the objects from an initial state,
    # just what predicates are there
    def find_possible_intentions(self):
        intentions = set()
        for action in self.raw_domain.actions:
            intentions.update(action.effect.intentional_effects())
        # for
        return intentions


# def cartesian_product(left_list, right_list):
#     result = []
#     for i in left_list:
#         for j in right_list:
#             result.append((i, j))
#     return result
