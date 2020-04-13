from pddl.PDDLPart import PDDLPart
from pddl.Domain import Domain
from pddl import Utils


# TODO: This whole decomp process
def get_steps(plan):
    pddl = PDDLPart(plan)
    plan_summary = PDDLPart(pddl.children[0])
    step_section = PDDLPart(plan_summary.children[2])
    steps = step_section.children
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
        if ":untaken" in step:
            continue
        trimmed_name = step[:max(step.find("_success"), step.find("_fail"))]
        trimmed_params = 2
        int_str = trimmed_name + str(trimmed_params)
        decompiled_plan.append(trimmed_name)
        # if trimmed_name in action_names:
        #     decompiled_plan.append(int_str)
        # else:
        #     pass

    return str(decompiled_plan)