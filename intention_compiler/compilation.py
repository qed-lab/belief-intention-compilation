import Domain
import Problem

class CompiledProblem:
    def __init__(self, domain, problem):
        self.raw_domain = domain
        self.raw_problem = problem
        self.relevant_effects = self.find_relevant_effects()
        self.possible_intentions = self.find_possible_intentions()
        self.intention_effect_combos = cartesian_product(self.relevant_effects, self.possible_intentions)

    def find_relevant_effects(self):
        possible_relevant_effects = []
        rel_effects = set()
        rel_effects.union(self.raw_problem.goal.predicates())
        for act in self.raw_domain.actions:
            rel_effects.union(act.precondition.predicates())
        return list()

    def find_possible_intentions(self):
        return list()

def cartesian_product(left_list, right_list):
    result = []
    for i in left_list:
        for j in right_list:
            result.append((i, j))
    return result
