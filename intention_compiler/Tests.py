from unittest import TestCase

from fluenttree import FluentTree
from fluenttree import AbstractPredicate

class TestFluentTreeStuff(TestCase):

    def test_not_leaves(self):

        test_s = """
        (and 
            (not (p1 ?x ?y ?z))
            (not (intends ?a (p2 ?x ?y z)))
            (not (not (p3 ?x)))
            (not (and (p4) (p5)))
            (intends ?a (p6 ?x ?y))
            (p7 ?x)
            (p7 ?z)
            (not (intends ?a (not (p8 ?x ?y z))))
        )"""

        ft = FluentTree(test_s)

        leaves = ft.leaves()
        leaves_not = ft.leaves_including_not()
        debound = ft.abstracted_predicates()
        # for db in debound:
            # self.assertNotEqual(db.identifier, "not")
        print("HEY")
