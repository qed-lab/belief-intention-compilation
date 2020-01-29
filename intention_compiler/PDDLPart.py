class PDDLPart:
    def __init__(self, init_string):
        self.string = init_string
        self.children = self.find_children()

    def find_children(self):
        remaining = self.string
        result = []
        child, new_start = find_child(remaining)
        while new_start >= 0:
            remaining = remaining[new_start:]
            result.append(child)
            child, new_start = find_child(remaining)
        return result


# TODO: Move to a utils file
# TODO: Make a utils file
def find_child(to_parse):

    count = 0
    remaining_string = to_parse
    start_idx = remaining_string.find('(')
    running_idx = 0
    while remaining_string.find('(') >= 0 or remaining_string.find(')') >= 0:
        left_idx = remaining_string.find('(')
        right_idx = remaining_string.find(')')
        if right_idx > left_idx >= 0:
            split = left_idx
            count += 1
        else:
            split = right_idx
            count -= 1
        remaining_string = remaining_string[split + 1:]
        running_idx += split + 1
        if count == 0:
            print(right_idx)
            return to_parse[start_idx+1:running_idx - 1], running_idx + 1
    return '', -1

