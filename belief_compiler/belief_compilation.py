import Domain
import fluenttree

class BeliefCompiledProblem():
    def __init__(self, domain, problem):
        self.base_domain = domain
        self.base_problem = problem
        self.initial_state = self.find_init_state()



    def find_init_state(self):
        state = []
        for pred in [fluenttree.AbstractPredicate(c) for c in self.base_problem.init_state]:
            if pred.is_belief:
                pred = fluenttree.AbstractPredicate(f"believes-{pred.identifier} {' '.join(pred.parameters)}")
            state.append(pred)


        return 2

    def compiled_problem(self):
        pass

    def compiled_domain(self):
        pass




if __name__ == '__main__':
    print("2")

