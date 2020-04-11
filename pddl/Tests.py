from unittest import TestCase
import copy
from pddl.fluenttree import FluentTree
from pddl.Domain import Domain
from pddl.Problem import Problem
from compilation import HaslumCompilation

class TestFluentTreeStuff(TestCase):

    def test_f_tree_copy(self):
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

        ft_clone = copy.deepcopy(ft)
        ft_clone.identifier = ft_clone.identifier + "DC"

        print("FT:\n", ft.to_string(), "FT2\n", ft_clone.to_string())


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

    def testGet_version_of_expressioned_action(self):

        dom_str = """define (domain aladdin)
  (:requirements :adl :domain-axioms :expression-variables :intentionality :delegation)
  (:types character thing place - object
          male female monster - character
          knight king - male
          genie dragon - monster
          magic-lamp - thing)
  (:predicates (alive ?character - character)
               (scary ?monster - monster)
               (beautiful ?character - character)
               (confined ?character - character)
               (single ?character - character)
               (married ?character - character)
               (at ?character - character ?place - place)
               (in ?genie - genie ?magic-lamp - magic-lamp)
               (has ?character - character ?thing - thing)
               (loyal-to ?knight - knight ?king - king)
               (controls ?character - character ?genie - genie)
               (loves ?lover - character ?love-interest - character)
               (married-to ?character1 - character ?character2 - character))

  ;; A character delegates a goal to a genie.
  (:action command
    :parameters   (?character - character ?genie - genie ?lamp - magic-lamp ?objective - expression)
    :precondition (and (not (= ?character ?genie))
                       (alive ?character)
                       (has ?character ?lamp)
                       (controls ?character ?genie)
                       (alive ?genie))
    :effect       (and (intends ?genie ?objective)
                       (delegated ?character ?objective ?genie))
    :agents       (?character))
  (:action commplexand
    :parameters   (?character - character ?thought - expression ?genie - genie ?lamp - magic-lamp ?objective - expression)
    :precondition (and (not (= ?character ?genie))
                       (alive ?character)
                       (has ?character ?lamp)
                       (intends ?genie ?thought)
                       (believes ?character ?objective)
                       (controls ?character ?genie)
                       (alive ?genie))
    :effect       (and (intends ?genie ?objective)
                       (delegated ?character ?objective ?genie)
                       (intends ?lamp ?thought))
    :fail       (and (intends ?genie ?objective)
                       (delegated ?character ?objective ?genie)
                       (intends ?lamp ?thought))
    :agents       (?character))
  )"""

        prob_str = """define (problem aladdin-cave)
  (:domain aladdin)
  (:objects hero - knight
            king - king
            jasmine - female
            dragon - dragon
            genie - genie
            castle mountain - place
            lamp - magic-lamp)
  (:init (alive hero) (single hero) (at hero castle) (loyal-to hero king)
         (alive king) (single king) (at king castle)
         (alive jasmine) (beautiful jasmine) (single jasmine) (at jasmine castle) 
         (alive dragon) (scary dragon) (at dragon mountain) (has dragon lamp)
         (alive genie) (scary genie) (confined genie) (in genie lamp))
  (:goal (and (not (alive genie))
              (married-to king jasmine)))"""
        dom = Domain(dom_str)
        prob = Problem(prob_str)

        comp = HaslumCompilation(dom, prob)

        versions = comp.get_versions_of_expressioned_action(dom.actions[1])
        for v in versions:
            print(v)

