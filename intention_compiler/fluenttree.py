import PDDLPart
import re


class AbstractPredicate:
    def __init__(self, leaf):
        if isinstance(leaf, str):
            if "?" in leaf: # Parse with types (e.g. the predicates in a domain)
                # in ?genie - genie ?magic-lamp - magic-lamp
                self.identifier = first_word(leaf)
                tokens = re.split(r"\?", leaf.split(r"?",1)[1])
                params = [tok.strip() for tok in tokens if tok!=""]
                self.arity = len(params)
                self.types = []
                self.parameters = []
                for param in params:
                    self.types.append(param.split(" - ")[1])
                    self.parameters.append("?" + param.split(" - ")[0])
                self.is_not = False
                self.is_intention = False
                self.intention_is_not = False
                self.is_belief = False
            else: # Parse from string, no types
                self.identifier = first_word(leaf)
                tokens = re.split(r" ", leaf)
                self.parameters = [tok.strip() for tok in tokens if tok!=""][1:]
                self.arity = len(self.parameters)
                self.types = []
                self.is_not = False
                self.is_intention = False
                self.intention_is_not = False
                self.is_belief = False


        elif isinstance(leaf, FluentTree):

            if not (leaf.is_leaf or (leaf.is_not and len(leaf.child_preconditions)==1 and leaf.child_preconditions[0].is_leaf)):
                raise SyntaxError("Tried to debind a predicate that was not a leaf")
            self.is_not = False
            self.is_belief = False
            self.is_intention = False
            self.has_expression_parameter = False

            # E.g. "believes ?agent (predicate ?x ?y))"
            if (not leaf.is_not) and leaf.is_belief and len(leaf.child_preconditions)==1:
                self.is_belief = True
                intended_predicate = leaf.child_preconditions[0]
                self.identifier = intended_predicate.identifier
                self.parameters = leaf.words[1:] + intended_predicate.words[1:]
                self.arity = len(self.parameters)

            # E.g "believes ?agent ?belief"
            if (not leaf.is_not) and leaf.is_belief and len(leaf.child_preconditions)==0:
                self.is_belief = True
                self.has_expression_parameter = True
                self.identifier = None
                self.parameters = leaf.words[1:]
                self.arity = len(self.parameters)

            # E.g "not( predicate ?x ?y ?z)"
            if leaf.is_not and not leaf.child_preconditions[0].is_intends:
                self.is_not = True
                self.identifier = leaf.child_preconditions[0].identifier
                self.parameters = leaf.child_preconditions[0].words[1:]
                self.arity = len(self.parameters)

            # E.g "not( intends ?agent (predicate ?x ?y ?z)) "
            if leaf.is_not and leaf.child_preconditions[0].is_intends  and len(leaf.child_preconditions[0].child_preconditions)==1:
                self.is_not = True
                self.is_intention = True
                intention = leaf.child_preconditions[0]
                intended_predicate = intention.child_preconditions[0]
                self.identifier = intended_predicate.identifier
                self.parameters = intention.words[1:] + intended_predicate.words[1:]
                self.arity = len(self.parameters)

            # E.g "intends ?agent (predicate ?x ?y ?z)"
            if (not leaf.is_not) and leaf.is_intends and len(leaf.child_preconditions)==1:
                self.is_intention = True
                intended_predicate = leaf.child_preconditions[0]
                self.identifier = intended_predicate.identifier
                self.parameters = leaf.words[1:] + intended_predicate.words[1:]
                self.arity = len(self.parameters)

            # E.g "not( intends ?agent ?intent) "
            if leaf.is_not and leaf.child_preconditions[0].is_intends and len(leaf.child_preconditions[0].child_preconditions)==0:
                self.is_not = True
                self.is_intention = True
                self.has_expression_parameter = True
                intention = leaf.child_preconditions[0]
                # intended_predicate = intention.child_preconditions[0]
                self.identifier = None
                self.parameters = leaf.child_preconditions[0].words[1:]
                self.arity = len(self.parameters)

            # E.g "intends ?agent ?intent"
            if (not leaf.is_not) and leaf.is_intends and len(leaf.child_preconditions)==0:
                self.is_intention = True
                self.has_expression_parameter = True
                # intended_predicate = leaf.child_preconditions[0]
                self.identifier = None
                self.parameters = leaf.words[1:]
                self.arity = len(self.parameters)

            # E.g "predicate ?x ?y ?z "
            if (not leaf.is_not) and (not leaf.is_intends) and (not leaf.is_belief):
                self.identifier = leaf.identifier
                self.arity = len(leaf.words)-1
                self.parameters = leaf.words[1:]
            self.types = [None] * self.arity

    def abstract_repr(self):
        if self.has_expression_parameter:
            res = f"{'intends' if self.is_intention else 'believes'} " + "?a ?expression"
        else:
            res = f"{self.identifier}" +(" " if self.arity>0 else "") + " ".join([f"?x{i}" for i in range(self.arity - (1 if self.is_belief or self.is_intention else 0))])
            res = f"{'intends' if self.is_intention else 'believes'} ?a ({res})" if self.is_intention or self.is_belief else res
        res = f"not ({res})" if self.is_not else res
        res = f"({res})"
        return res

    def __repr__(self):
        return self.abstract_repr()

    def __str__(self):
        if self.has_expression_parameter:
            res = f"{'intends' if self.is_intention else 'believes'} " + " ".join(self.parameters)
        else:
            res = f"{self.identifier}" + (" " if self.arity > 0 else "") + " ".join(self.parameters[1:] if self.is_intention or self.is_belief else self.parameters)
            res = f"{'intends' if self.is_intention else 'believes'} {self.parameters[0]} ({res})" if self.is_intention or self.is_belief else res

        res = f"not ({res})" if self.is_not else res
        res = f"({res})"
        return res


    # def __eq__(self, other):
    #     if isinstance(other, self.__class__):
    #         return self.is_not == other.is_not \
    #                and self.is_intention==other.is_intention \
    #                and self.identifier==other.identifier \
    #                and self.arity == other.arity
    #     return False
    #
    def __eq__(self, other):
        if isinstance(other, self.__class__):
            return self.abstract_repr() == other.abstract_repr()
    def __ne__(self, other):
        return not self.__eq__(other)
    def __hash__(self):
        return self.__str__().__hash__()




class FluentTree(PDDLPart.PDDLPart):

    # TODO: A logically sound equality function (make sure python "set" uses it!)
    def __init__(self, to_parse, depth=0):
        super().__init__(to_parse)
        self.depth = depth
        self.child_preconditions = []
        self.identifier = first_word(self.string)
        self.words = all_words(self.string)
        self.is_intends = False
        self.is_belief = False
        self.is_not = False
        self.actor = None

        if self.identifier == "intends" or self.identifier=="believes" or not self.children:
            self.is_leaf = True
            if self.identifier == "intends":
                self.is_intends = True
                self.actor = self.words[1]
                if len(self.children) == 1:
                    self.child_preconditions.append(FluentTree(self.children[0], depth + 1))
                elif len(self.children) == 0:
                    pass
                else:
                    raise SyntaxError("Intends predicates should have a parameter or one predicate. \ne.g. (intends ?actor ?intention) or (intends ?actor (predicate ?x ?y))")
            if self.identifier == "believes":
                self.is_belief = True
                self.actor = self.words[1]
                if len(self.children) == 1:
                    self.child_preconditions.append(FluentTree(self.children[0], depth + 1))
                elif len(self.children) == 0:
                    pass
                else:
                    raise SyntaxError("Belief predicates should have a parameter or one predicate. \ne.g. (believes ?actor ?intention) or (believes ?actor (predicate ?x ?y))")

        else:
            self.is_not = self.identifier.lower() == "not"
            self.is_leaf = False
            for child in self.children:
                self.child_preconditions.append(FluentTree(child, depth + 1))

    # def to_string(self):
    #     if self.is_leaf:
    #         return "\t"*self.depth + self.string
    #     else:
    #         res = "\t"*self.depth + self.string[:self.string.find('(')].strip()
    #         for child in self.child_preconditions:
    #             res += "\n" + child.to_string()
    #         return res

    def to_string(self, pad=0):
        if self.is_leaf:
            return "\t"*(self.depth+pad) + "(" +  self.string + ")"
        else:
            res = "\t"*(self.depth+pad) + "(" + self.string[:self.string.find('(')].strip() #TODO: Why the find '('?
            for child in self.child_preconditions:
                res += "\n" + child.to_string(pad)
            res += "\n" + "\t"*(self.depth+pad) + ")"
            return res

    def leaves(self):
        if self.is_leaf:
            return [self]
        else:
            leaves = list()
            for child in self.child_preconditions:
                leaves = leaves + child.leaves()
            return leaves

    def leaves_including_not(self):
        if self.is_leaf:
            return [self]
        if self.is_not and len(self.child_preconditions)==1 and self.child_preconditions[0].is_leaf:
            return [self]
        else:
            leaves = list()
            for child in self.child_preconditions:
                leaves = leaves + child.leaves_including_not()
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

    def abstracted_predicates(self):
        result = []
        for leaf in self.leaves_including_not():
            result.append(AbstractPredicate(leaf))
        return result



#TODO: Why does this have a foreach loop?
def first_word(s):
    tokens = re.split(r"\s", s)
    for token in tokens:
        if len(token)>0:
            return token
    return ""

def all_words(s):
    tokens = re.split(r"\s", s.split("(")[0])
    words = []
    for token in tokens:
        if len(token)>0:
            words.append(token)
    return words
