from common import *

class Slice:
    data: list | str
    start: int
    end: int

    def __init__(self, data: list | str, start=0, end=-1):
        self.data = data
        self.start = start
        self.end = end if end >= 0 else len(data)

    def __repr__(self) -> str:
        return f"Slice({repr(self.data[self.start:self.end])}, {self.start}, {self.end})"

    def __getitem__(self, i: int):
        return self.data[i]

SYMBOLS = "+-*/"
_LOWER_ALPHABET = "abcdefghijklmnopqrstuvwxyz"
ALPHABET = _LOWER_ALPHABET + _LOWER_ALPHABET.upper()

def getNextToken(slice: Slice) -> Slice:
    str = slice.data
    i = j = slice.start
    end = slice.end
    if str[j] == "0":
        j += 1
        if j < end:
            if str[j] == "x":
                while j < end and str[j] in "0123456789abcdef":
                    j += 1
            elif str[j] == "b":
                while j < end and str[j] in "01":
                    j += 1
    elif str[j] in "123456789":
        while j < end and str[j] in "0123456789":
            j += 1
        if j < end and str[j] == ".":
            j += 1
            while j < end and str[j] in "0123456789":
                j += 1
    elif str[j] in SYMBOLS:
        while j < end and str[j] in SYMBOLS:
            j += 1
    elif str[j] in " \t\r\n":
        i += 1
        j += 1
    elif str[j] in ALPHABET:
        while str[j] in ALPHABET:
            j += 1
    else:
        raise SyntaxError(Slice(str, i, j))
    return Slice(str, i, j)

if __name__ == "__main__":
    slice = Slice("a+1")
    while True:
        next_token = getNextToken(slice)
        print(next_token)
        slice = Slice(slice.data, next_token.end, slice.end)
        if slice.start >= slice.end: break
