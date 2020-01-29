import PDDLPart
import re


class FluentTree(PDDLPart.PDDLPart):

    # TODO: A logically sound equality function (make sure python "set" uses it!)
    def __init__(self, to_parse, depth=0):
        super().__init__(to_parse)
        self.depth = depth
        self.child_preconditions = []
        self.identifier = first_word(self.string)
        self.is_intends = False

        if self.identifier == "intends" or not self.children:
            self.is_leaf = True
            if self.identifier == "intends":
                self.is_intends = True
        else:
            self.is_leaf = False
            for child in self.children:
                self.child_preconditions.append(FluentTree(child, depth + 1))

    def to_string(self):
        if self.is_leaf:
            return "\t"*self.depth + self.string
        else:
            res = "\t"*self.depth + self.string[:self.string.find('(')].strip()
            for child in self.child_preconditions:
                res += "\n" + child.to_string()
            return res

    def leaves(self):
        if self.is_leaf:
            return [self]
        else:
            leaves = list()
            for child in self.children:
                leaves = leaves + child.leaves()
            return leaves

    # TODO: Deal with "NOT" predicates
    def predicates(self):
        result = set()
        for leaf in self.leaves():
            if not leaf.is_intends:
                result.add(leaf.identifier)
        return result

    def intentional_effects(self):
        result = set()
        for leaf in self.leaves():
            if leaf.is_intends:
                result.add(leaf.identifier)
        return result



def first_word(s):
    tokens = re.split(r"\s", s)
    for token in tokens:
        if token:
            return token
    return ""

