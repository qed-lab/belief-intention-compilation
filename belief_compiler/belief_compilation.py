import Domain

class BeliefCompiledProblem():
    def __init__(self, domain, problem):
        self.base_domain = domain
        self.base_problem = problem
        self.initial_state = self.find_init_state()

    def find_init_state(self):
        state = []
        for pred in self.problem.init_state:
            if pred.is_belief:
                agent = pred.parameters[0]
                
            state.append(pred)


        return 2



if __name__ == '__main__':
    print("2")

