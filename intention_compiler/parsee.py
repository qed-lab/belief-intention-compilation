import argparse
from pddl import Problem, Utils, Domain
from compilation import HaslumCompilation


def verify_parens(domain_string):
    count = 0
    remaining_string = domain_string
    while remaining_string.find('(') >= 0 or remaining_string.find(')') >= 0:
        left_idx = remaining_string.find('(')
        right_idx = remaining_string.find(')')
        if right_idx > left_idx >= 0:
            split = left_idx
            count += 1
        else:
            split = right_idx
            count -= 1
        remaining_string = remaining_string[split + 1:]
        if count < 0:
            return False
    return count == 0


if __name__ == '__main__':
    args = argparse.ArgumentParser(description='Process Domain and Problem Files.')
    args.add_argument('-d','--domain', type=str, help='The Domain File', default=r'../samples/aladdin-domain.pddl')
    args.add_argument('-p','--problem', type=str, help='The Problem File', default=r'../samples/aladdin-problem.pddl')
    arguments = args.parse_args()

    domain_string = ''
    prob_string = ''
    with open(arguments.domain) as domF:
        for line in domF:
            trimmed = line[:line.find(';')].strip()
            if trimmed:
                domain_string += trimmed + '\n'
    verify_parens(domain_string)
    child, _ = Utils.find_child(domain_string)
    # print(child)

    with open(arguments.problem) as probF:
        for line in probF:
            trimmed = line[:line.find(';')].strip()
            if trimmed:
                prob_string += trimmed + '\n'

    verify_parens(prob_string)
    problem_child, _ = Utils.find_child(prob_string)

    prob = Problem.Problem(problem_child)
    dom = Domain.Domain(child)

    # print(dom.string)
    # print("------------")
    # for kid in dom.predicates:
    #     print("<" + kid.replace('\n', ' | ') + ">")
    # dom.print_actions()

    compilation = HaslumCompilation(dom, prob)

    print(compilation.compiled_domain().to_pddl())





