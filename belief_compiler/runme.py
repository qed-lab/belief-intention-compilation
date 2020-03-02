from fluenttree import FluentTree
import copy

def modify_leaves(ft):
    if ft.is_leaf:
        ft.identifier = "believes_" +ft.identifier
        ft.words.insert(1, "insertion_successful")
    else:
        for child in ft.child_trees:
            modify_leaves(child)

if __name__ == '__main__':
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

    ft = FluentTree(test_s)

    ft_clone = copy.deepcopy(ft)
    # ft_clone.string = ft_clone.string.replace(ft_clone.identifier, ft_clone.identifier + "DC")
    ft_clone.identifier = ft_clone.identifier + "WAHIZOW"
    modify_leaves(ft_clone)

    print("FT:\n", ft.to_string(), "FT2\n", ft_clone.to_string())
