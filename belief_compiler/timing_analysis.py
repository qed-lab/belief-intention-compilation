import os, sys
TOP_PATH = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
sys.path.append(TOP_PATH)
import time as TIMER
import argparse
import belief_compilation
import decompile_glaive


from scipy import stats
import numpy as np
from collections import defaultdict
import matplotlib.pyplot as plt


DEVNULL = " > /dev/null"
# DEVNULL = " "


ERROR_LOG_FILE="errors.log"
def log_error(message):
    with open(ERROR_LOG_FILE, "a") as err_log:
        err_log.write(message)


def confidence_interval(data, confidence=.95):
    a = 1.0 * np.array(data)
    n = len(a)
    m, se = np.mean(a), stats.sem(a)
    h = se * stats.t.ppf((1 + confidence) / 2., n - 1)
    return m, h

def set_axis_style(ax, labels, name):
    ax.get_xaxis().set_tick_params(direction='out')
    ax.xaxis.set_ticks_position('bottom')
    ax.set_xticks(np.arange(1, len(labels) + 1))
    ax.set_xticklabels(labels)
    ax.set_xlim(0.25, len(labels) + 0.75)
    ax.set_xlabel(name)

if __name__ == '__main__':
    intermediate_dom = TOP_PATH + "/TestFiles/glaive-dom.pddl"
    intermediate_prob = TOP_PATH+ "/TestFiles/glaive-prob.pddl"
    glaive_path = TOP_PATH + "/resources/glaive.jar"
    glaive_plan = TOP_PATH + "/TestFiles/glaive-plan.txt"

    dom_filepath = TOP_PATH + "/paper_domains/"
    prob_filepath = TOP_PATH + "/paper_domains/"
    domains = ["hubris-domain.pddl", "journey-domain.pddl", "rooms-domain.pddl"]
    problems = ["hubris-problem.pddl", "journey-problem.pddl", "rooms-problem.pddl"]
    labels = ["Hubris", "Journey", "Rooms"]

    comp_times = defaultdict(list)
    plan_times = defaultdict(list)

    for problem, domain in zip(problems, domains):

        print(f"Problem: {problem}")
        print(f"Domain: {domain}")

        for i in range(25):
            start_time = TIMER.time()
            comp_dom, comp_prob = belief_compilation.get_compiled_pddl_from_filenames(dom_filepath + domain, prob_filepath + problem)
            comp_time = TIMER.time() - start_time
            # print(f"Compiled Domain took {time:5.5f} seconds")

            with open(intermediate_dom, 'w') as dom_out:
                dom_out.write(comp_dom)

            with open(intermediate_prob, 'w') as prob_out:
                prob_out.write(comp_prob)

            cmd = f"java -jar {glaive_path} -d {intermediate_dom} -p {intermediate_prob} -o {glaive_plan}"


            # Send to GLAIVE
            # print(cmd)
            start_time = TIMER.time()
            os.system(cmd + DEVNULL)
            plan_time = TIMER.time() - start_time

            # print(f"Glaive took {time:5.5f} seconds")

            print(f"Comp: {comp_time:5.5f}\tPlan: {plan_time:5.5f}")

            comp_times[problem].append(comp_time)
            plan_times[problem].append(plan_time)


    print("Problem\tCompilation Time\tPlanning Time")
    for problem in problems:
        comp_mean, comp_err = confidence_interval(comp_times[problem])
        plan_mean, plan_err = confidence_interval(plan_times[problem])
        print(f"{problem}\t{comp_mean:5.5f} +/- {comp_err:5.5f} \t{plan_mean:5.5f} +\- {plan_err:5.5f}")
    total_comp_mean, total_comp_err = confidence_interval([time for timelist in comp_times.values() for time in timelist])
    total_plan_mean, total_plan_err = confidence_interval([time for timelist in plan_times.values() for time in timelist])

    print(f"Total: \t{total_comp_mean:5.5f} +/- {total_comp_err:5.5f} \t{total_plan_mean:5.5f} +\- {total_plan_err:5.5f}")


    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    ax1.violinplot(plan_times.values(), showmedians=True)
    set_axis_style(ax1, labels, "Glaive Planning Time")

    plt.subplots_adjust(bottom=0.15, wspace=0.05)
    plt.show()

    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    ax1.violinplot(comp_times.values(), showmedians=True)
    set_axis_style(ax1, labels, "Compilation Time")

    plt.subplots_adjust(bottom=0.15, wspace=0.05)
    plt.show()