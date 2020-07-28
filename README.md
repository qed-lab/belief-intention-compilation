# belief-intention-compilation
A compiler that will convert Belief and Intentional PDDL into a form that can be handled by an intentional Planner, such as [Glaive](https://nil.cs.uno.edu/projects/glaive/)

Belief and Intentional PDDL differs from PDDL by supporting 2nd order `(intends ?character ?predicate)` and `(believes ?character ?predicate)` predicates. 
Intentional PDDL supports actions that a character *tries* and *may fail* at, causing a separate set of failure effects.

Written by Matthew Christensen and Jennifer Nelson for the following paper:

> Using Domain Compilation to Add Belief to Narrative Planners    
> Matthew Christensen, Jennifer M. Nelson, and Rogelio E. Cardona-Rivera    
> The 16th AAAI Conference on Artificial Intelligence and Interactive Digital Entertainment (AIIDE-20) 


### Using the tool

    usage: belief-intention-system.py [-h] [--glaive-path [GLAIVE_PATH]]
                                      [--glaive-dom [GLAIVE_DOM]]
                                      [--glaive-prob [GLAIVE_PROB]]
                                      [--glaive-plan [GLAIVE_PLAN]]
                                      [--glaive-args ...]
                                      domain problem solution

    positional arguments:
      domain                The belief-intention domain (PDDL)
      problem               The belief-intention problem (PDDL)
      solution              Where the resulting plan is stored

    optional arguments:
      -h, --help            show this help message and exit
      --glaive-path [GLAIVE_PATH]
                            Path to the GLAIVE .jar (or other narrative planner)
                            Default: resources/glaive.jar
      --glaive-dom [GLAIVE_DOM]
                            Optionally choose the place to store the intermediate
                            intentional domain that is fed to GLAIVE
                            Defualt: TestFiles/glaive-dom.pddl
      --glaive-prob [GLAIVE_PROB]
                            Optionally choose the place to store the intermediate
                            intentional problem that is fed to GLAIVE
                            Default: TestFiles/glaive-prob.pddl
      --glaive-plan [GLAIVE_PLAN]
                            Optionally choose the place to store the plan that is
                            gathered from GLAIVE
                            Default: TestFiles/glaive-plan.pddl
      --glaive-args ...     Other arguments to pass to GLAIVE
      
Notes:
 - A Glaive .jar is found in resources, or you may substitute another planner capable of handling intentional PDDL. The full Glaive narrative plannner is available at https://nil.cs.uno.edu/projects/glaive/
 - The belief-intention-system.py script runs easiest from the main directory.
 
 
### Replicating the Paper

