from pddl.PDDLPart import PDDLPart
from pddl.Domain import Domain
from pddl import Utils
import Math


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
    action_names = [x.name for x in orig_actions]
    decompiled_plan = []
    for step in steps:
        if ":untaken" in step.string:
            continue
        trimmed_name = step.string[:Math.max(step.find("_success"), step.find("_fail"))]
        trimmed_params = 2
        int_str = trimmed_name + str(trimmed_params)
        if trimmed_name in action_names:
            decompiled_plan.append(int_str)
        else:
            pass

    return plan_str