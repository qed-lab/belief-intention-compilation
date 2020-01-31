import Utils

class PDDLPart:
    def __init__(self, init_string):
        self.string = init_string
        self.children = self.find_children()

    def find_children(self):
        remaining = self.string
        result = []
        child, new_start = Utils.find_child(remaining)
        while new_start >= 0:
            remaining = remaining[new_start:]
            result.append(child)
            child, new_start = Utils.find_child(remaining)
        return result

