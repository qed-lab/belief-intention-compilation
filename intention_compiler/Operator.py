import PDDLPart
import Parameter
import fluenttree
import re
import Utils


class Operator(PDDLPart.PDDLPart):
    def __init__(self, to_parse):
        if to_parse is not None:

            super().__init__(to_parse)
            self.base_string = to_parse
            self.name = re.split(r'\s', self.base_string)[1]
            tokens = Utils.get_colon_sections(self.base_string)
            self.agents = []
            self.parameters = []
            self.precondition = None
            for token in tokens:
                title = token.split()[0]
                if title == ":action":
                    self.name = token.split()[1]
                    # self.name = fluenttree.first_word(token)
                elif title == ":parameters":
                    self.parameters = Parameter.parameter_list(Utils.find_child(token)[0])
                elif title == ":precondition":
                    self.precondition = fluenttree.FluentTree(Utils.find_child(token)[0])
                elif title == ":effect":
                    self.effect = fluenttree.FluentTree(Utils.find_child(token)[0])
                elif title == ":agents":
                    self.agents = Utils.get_question_mark_sections(Utils.find_child(token)[0])
        else:
            super().__init__("")
            self.base_string = "blank"
            self.name = "blank"
            self.agents = []
            self.parameters = []
            self.precondition = None
            self.effect = None

    def __str__(self):
        # TODO: Consistentify what is str() and what's .to_string()
        nl = "\n"
        res = f"""
(:action {self.name}
    :parameters   ({" ".join([str(x) for x in self.parameters])})
    :precondition 
{self.precondition.to_string(2)}
    :effect
{self.effect.to_string(2)}
    {":agents (" if len(self.agents) > 0 else ""}{" ".join(self.agents)}{")" if len(self.agents) > 0 else ""}
)
"""
        return res
