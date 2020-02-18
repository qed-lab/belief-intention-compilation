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


    def testAbstractPredicate(self):

        # test_string = """(and
        # (believes ?jim (at ?it ?place))
        # (believes ?jim ?belief)
        # (intends ?jim (at ?the ?place))
        # (intends ?jim ?intent)
        # (intends ?jim (not (at ?the ?place)))
        # (not (intends ?jim (at ?the ?place)))
        # (not (intends ?jim ?intent))
        # (not (intends ?jim (not (at ?the ?place))))
        # )"""
        test_string = """(and
        (believes ?jim (at ?the ?place))
        (believes ?jim ?belief)
        (intends ?jim (at ?the ?place))
        (intends ?jim ?intent)
        (intends ?jim ?otherintent)
        (not (intends ?jim (at ?the ?place)))
        (not (intends ?jim ?intent))
        (at ?the ?place)
        )"""

        ft = FluentTree(test_string)

        dem_preds = ft.abstracted_predicates()

        for pred in dem_preds:
            print(pred.__str__())
            print(pred.__repr__())

