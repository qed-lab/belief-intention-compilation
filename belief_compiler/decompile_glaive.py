from pddl.PDDLPart import PDDLPart
from pddl.Domain import Domain
from pddl import Utils


# TODO: This whole decomp process
def get_steps(plan):
    pddl = PDDLPart(plan)
    steps = pddl.children[0].children[2].children
    return steps

def decompile(plan_str, original_domain_file):
    steps = get_steps(plan_str)
    dom_string = Utils.get_trimmed_string_from_file(original_domain_file)
    dom_child, _ = Utils.find_child(dom_string)
    orig_dom = Domain(dom_child)
    orig_actions = orig_dom.actions
    for step in steps:
        pass
    return plan_str