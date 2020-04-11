from pddl.fluenttree import FluentTree, AbstractPredicate
import copy
from belief_compilation import generate_belief_action, simplify_formula, super_simplify_formula
from pddl.Operator import  Operator

def modify_leaves(ft):
    if ft.is_leaf:
        ft.identifier = "believes_" +ft.identifier
        ft.words.insert(1, "insertion_successful")
    else:
        for child in ft.child_trees:
            modify_leaves(child)


def flatten_beliefs_2(ft):
    if ft.is_leaf:
        return
    else:
        new_children = []
        for c in ft.child_trees:
            if not c.is_belief:
                new_children.append(c)
            else:
                if len(c.child_trees) > 0 and c.child_trees[0].is_not:
                    leaf = AbstractPredicate(c.child_trees[0].child_trees[0])
                    upper = AbstractPredicate(c)
                    new_child = FluentTree("believes_not_" + leaf.identifier + ' ' + ' '.join([upper.parameters[0]] + leaf.parameters), depth=c.depth)
                else:
                    c_predicate_form = AbstractPredicate(c)
                    new_child = FluentTree("believes_" + c_predicate_form.identifier + ' ' + ' '.join(c_predicate_form.parameters), depth=c.depth)
                new_children.append(new_child)
        ft.child_trees = new_children
        for c in ft.child_trees:
            flatten_beliefs_2(c)


dom = """

"""


def test_super_flat():

    test_1 = """
    not 
        (and 
            (f1 ?x ?y) 
            (not 
                (f2 ?x ?y)
            ) 
            (and 
                (f3) 
                (f4)
            ) 
            (or 
                (f5) 
                (not (f6))
            )
        )
    """

    test_2 = """
    and
        (not 
            (not 
                (not 
                    (not 
                        (f1)
                    )
                )
            )
        )
        (not 
            (not 
                (not 
                    (not 
                        (not 
                            (f2)
                        )
                    )
                )
            )
        )
        """

    test_3 = """
    and 
        (and 
            (f1) 
            (f2) 
        ) 
        (not 
            (not 
                (or 
                    (f3) 
                    (f4) 
                ) 
            ) 
        )"""

    test_4 = """
    and 
        (f1)
        (f2)
        (not 
            (and 
                (or 
                    (f3) 
                    (f4) 
                )
            ) 
        )"""

    test_5 = """
    and  
        (not  
            (locked ?room)
        )
	"""

    # ft = FluentTree(test_1)
    # ft = FluentTree(test_2)
    # ft = FluentTree(test_3)
    # ft = FluentTree(test_4)
    ft = FluentTree(test_5)
    new_ft = super_simplify_formula(ft)
    print(ft.to_string())
    print(new_ft.to_string())


    # print(new_ft.to_string())



if __name__ == '__main__':

    test_super_flat()

    exit(0)

    test_s = """
    and 
        (not (p1 ?x ?y ?z))
        (not (intends ?a (p2 ?x ?y z)))
        (not (not (p3 ?x)))
        (not (and (p4) (p5)))
        (intends ?a (p6 ?x ?y))
        (p7 ?x)
        (p7 ?z)
        (not (intends ?a (not (p8 ?x ?y z))))
    """

    test_degenerate = """
    and ( and ( and (not (h 2)) (h 3)
            ) 
            ( and (h 1) (h 4)
            )
        )
        (   and ( and (h 5) (h 6)
            ) 
            ( and (h 7) (h 8)
        )
    )
    """

    action_s = """
    :action search-for
        :parameters  (?character - character ?thing - thing ?room - room)
        :precondition
            (and
                (at ?character ?room)
                (in ?thing ?room)
                (not (in ?room ?thing))
            )
        :effect
            (and
                (has ?character ?thing)
                (not (in ?thing ?room))
            )
        :fail
            (when (and (not (in ?thing ?room)) (at ?character ?room))
                (not (believes ?character (in ?thing ?room)))
                (believes ?character (not (in ?thing ?room)))
            )
        :agents (?character)
        """

    ft = FluentTree(test_s)
    op = Operator(action_s)
    deg = FluentTree(test_degenerate)
    simplify_formula(deg)
    print(deg.to_string())
    succ = generate_belief_action(op, "success")
    fail = generate_belief_action(op, "fail")

    print("SUCC", str(succ))
    print("NOT SUCC", str(fail))

    ft_clone = copy.deepcopy(ft)
    op_clone = copy.deepcopy(op.fail)

    flatten_beliefs_2(op_clone)
    # ft_clone.string = ft_clone.string.replace(ft_clone.identifier, ft_clone.identifier + "DC")
    ft_clone.identifier = ft_clone.identifier + "WAHIZOW"
    modify_leaves(ft_clone)

    print("FT:\n", ft.to_string(), "FT2\n", ft_clone.to_string())
    print("---\n\n", op_clone.to_string())

