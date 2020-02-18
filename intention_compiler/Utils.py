
import re


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
            # print(right_idx)
            return to_parse[start_idx+1:running_idx - 1], running_idx + 1
    return '', -1


def get_trimmed_string_from_file(file):
    res = ''
    with open(file) as f:
        for line in f:
            trimmed = line[:line.find(';') if line.find(';') >= 0 else len(line)].strip()
            if trimmed:
                res += trimmed + '\n'
    return res
