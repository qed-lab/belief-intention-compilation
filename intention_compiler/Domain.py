import PDDLPart
import Operator
import re


class Domain(PDDLPart.PDDLPart):
    def __init__(self, dom_string):
        super().__init__(dom_string)
        self.actions = []
        for child in self.children:
            tokens = re.split(r'\s', child)  # child.split('\n \t')
            identifier = tokens[0]
            if identifier == 'domain':
                self.name = tokens[1]
            elif identifier == ':requirements':
                self.requirements = Operator.get_colon_sections(child)[1:]
            elif identifier == ':types':
                self.type_string = child
            elif identifier == ':predicates':
                self.predicates = PDDLPart.PDDLPart(child).children  # Map these to their own objects eventually?
            elif identifier == ':action':
                self.actions.append(Operator.Operator(child))
        self.summary = self.name + "\nPredicates: " + str(len(self.predicates)) + "\nActions: " + str(len(self.actions))

    def print_actions(self):
        for action in self.actions:
            print(action.precondition.to_string())
            print(action.effect.to_string())
            print(action.parameters)




