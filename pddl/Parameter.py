class Parameter:
    def __init__(self, param_string):
        self.string = param_string
        trimmed = self.string.strip()
        if trimmed.find(" - ") >= 0:
            dash_index = trimmed.find(" - ")
            self.key = trimmed[1:dash_index].strip()
            self.type = trimmed[dash_index + 2:].strip()
        else:
            self.key = trimmed
            self.type = None

    def __str__(self):
        return self.string

def parameter_list(s):
    split = s.split("?")
    params = []
    for str in split:
        if str.strip():
            params.append(Parameter("?" + str))
    return params

