import re
from pddl import Utils, PDDLPart, fluenttree, Operator


class Domain(PDDLPart.PDDLPart):
    def __init__(self, dom_string):
        if dom_string is not None:
            super().__init__(dom_string)
            self.prelude = ""
            self.actions = []
            for child in self.children:
                tokens = re.split(r'\s', child)
                identifier = tokens[0]
                if identifier == 'domain':
                    self.name = tokens[1]
                elif identifier == ':requirements':
                    self.requirements = Utils.get_colon_sections(child)[1:]
                elif identifier == ':types':
                    self.type_string = child.replace(":types", "")
                elif identifier == ':predicates':
                    # self.predicates = PDDLPart.PDDLPart(child).children  # TODO: Map these to their own objects eventually?
                    self.predicates = [fluenttree.AbstractPredicate(ch) for ch in PDDLPart.PDDLPart(child).children]
                elif identifier == ':action':
                    self.actions.append(Operator.Operator(child))
            self.summary = self.name + "\nPredicates: " + str(len(self.predicates)) + "\nActions: " + str(len(self.actions))
        else: # Blank domain for writing into
            super().__init__("")
            self.actions = []
            self.name = "EMPTY-DOMAIN"
            self.requirements = []
            self.type_string = ""
            self.predicates = []
            self.summary = self.name + "\nPredicates: " + str(len(self.predicates)) + "\nActions: " + str(len(self.actions))
            self.prelude = ""


    def to_pddl(self):
        res = self.prelude + "\n"

        nl = "\n"
        tab = "\t"
        res += f"""
(define (domain {self.name})
    (:requirements {" ".join(self.requirements)})
    (:types
    {self.type_string}
    )
    (:predicates
        {(nl+tab+tab).join([str(p) for p in self.predicates])}
    )
    {(nl+tab).join([str(x) for x in self.actions])}
)

"""
        return res

    def print_actions(self):
        for action in self.actions:
            print("\n\n", str(action))
            # print("Pre:\n",action.precondition.to_string())
            # print("Eff:\n",action.effect.to_string())
            # print("Params:\n",action.parameters)



