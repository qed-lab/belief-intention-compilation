import PDDLPart
import Parameter
import fluenttree
import re


class Operator(PDDLPart.PDDLPart):
    def __init__(self, to_parse):
        super().__init__(to_parse)
        self.base_string = to_parse
        self.name = re.split(r'\s', self.base_string)[1]
        tokens = get_colon_sections(self.base_string)
        self.agents = []
        self.parameters = []
        self.precondition = None
        for token in tokens:
            title = token.split()[0]
            if title == ":action":
                self.name = token.split()[1]
                # self.name = fluenttree.first_word(token)
            elif title == ":parameters":
                self.parameters = Parameter.parameter_list(PDDLPart.find_child(token)[0])
            elif title == ":precondition":
                self.precondition = fluenttree.FluentTree(PDDLPart.find_child(token)[0])
            elif title == ":effect":
                self.effect = fluenttree.FluentTree(PDDLPart.find_child(token)[0])
            elif title == ":agents":
                self.agents = get_question_mark_sections(PDDLPart.find_child(token)[0])


def get_colon_sections(string_to_split):
    split = string_to_split.split(":")
    tokens = []
    for str in split:
        if str.strip():
            tokens.append(":" + str.strip())
    return tokens


def get_question_mark_sections(to_split):
    split = to_split.split("?")
    tokens = []
    for s in split:
        if s.strip():
            tokens.append("?" + s.strip())
    return tokens

