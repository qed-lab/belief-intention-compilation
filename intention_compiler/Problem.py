import fluenttree
import PDDLPart
import Utils
import re


class Problem(PDDLPart.PDDLPart):
    def __init__(self, raw_string):
        if raw_string is not None:
            super().__init__(raw_string)
            for child in self.children:
                tokens = re.split(r'\s', child)
                identifier = tokens[0]
                if identifier == "problem":
                    self.name = tokens[1]
                elif identifier == ":domain":
                    self.dom_name = tokens[1]
                elif identifier == ":objects":
                    self.objects = child
                elif identifier == ":init":
                    self.init_state = [fluenttree.FluentTree(c) for c in PDDLPart.PDDLPart(child).children]
                elif identifier == ":goal":
                    self.goal = fluenttree.FluentTree(Utils.find_child(child)[0])
        else:
            super().__init__('')
            self.name = ''
            self.dom_name = ''
            self.objects = ''
            self.init_state = []
            self.goal = None

    def to_pddl(self):
        res = ""

        nl = "\n"
        tab = "\t"
        res += f"""
(define (problem {self.name})
    (:domain {self.dom_name})
    (:objects
        {self.objects}
    )
    (:init
        {(nl+tab).join([str(p) for p in self.init_state])}
    )
    (:goal
{self.goal.to_string(2)}
    )
)

"""
        return res