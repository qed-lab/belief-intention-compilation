import os
import time as TIMER
import argparse

import belief_compilation
import decompile_glaive

# DEVNULL = " > /dev/null"
DEVNULL = " "


ERROR_LOG_FILE="errors.log"
def log_error(message):
    with open(ERROR_LOG_FILE, "a") as err_log:
        err_log.write(message)


# start_time = TIMER.time()
# os.system(cmd + DEVNULL)
# time = TIMER.time() - start_time

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="")
    parser.add_argument('domain', help="The belief-intention domain (PDDL)")
    parser.add_argument('problem', help="The belief-intention problem (PDDL)")
    parser.add_argument('solution', help="Where the resulting plan is stored")

    parser.add_argument('--glaive-path', default='../Glaive/glaive.jar', nargs='?', required=False, help="Path to the GLAIVE .jar (or other narrative planner)")
    parser.add_argument('--glaive-dom', default='../TestFiles/glaive-dom.pddl', nargs='?', required=False, help="Optionally choose the place to store the intermediate intentional domain that is fed to GLAIVE")
    parser.add_argument('--glaive-prob', default='../TestFiles/glaive-prob.pddl', nargs='?', required=False, help="Optionally choose the place to store the intermediate intentional problem that is fed to GLAIVE")
    parser.add_argument('--glaive-plan', default='../TestFiles/glaive-plan.pddl', nargs='?', required=False, help="Optionally choose the place to store the intermediate plan that is gathered from GLAIVE")
    parser.add_argument('--glaive-args', default=[], nargs=argparse.REMAINDER, required=False, help="Other arguments to pass to GLAIVE")

    # args = parser.parse_args()
    args = parser.parse_args("samples/rooms-domain.pddl samples/rooms-problem.pddl samples/rooms-plan.txt --glaive-args -s".split()) # -pp samples/rooms-partial-plan.txt -ws TestFiles/ss.txt
    print(args)

    comp_dom, comp_prob = belief_compilation.get_compiled_pddl_from_filenames(args.domain, args.problem)
    print("Compiled Domain")

    with open(args.glaive_dom, 'w') as dom_out:
        dom_out.write(comp_dom)

    with open(args.glaive_prob, 'w') as prob_out:
        prob_out.write(comp_prob)

    cmd = f"java -jar {args.glaive_path} -d {args.glaive_dom} -p {args.glaive_prob} -o {args.glaive_plan} {' '.join(args.glaive_args)}"


    # Send to GLAIVE
    print(cmd)
    start_time = TIMER.time()
    os.system(cmd + DEVNULL)
    time = TIMER.time() - start_time

    print(f"Glaive took {time:5.5f} seconds")
    # Decompile solved plan

    with open(args.glaive_plan, 'r') as glaive_plan_in:
        plan_str = glaive_plan_in.read()

    decompiled_plan = decompile_glaive.decompile(plan_str, '../samples/rooms-domain.pddl')


    with open(args.solution, 'w') as plan_out:
        plan_out.write(decompiled_plan)
