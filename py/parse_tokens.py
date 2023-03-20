from common import Slice

SYMBOLS = "+-*/"
_LOWER_ALPHABET = "abcdefghijklmnopqrstuvwxyz"
ALPHABET = _LOWER_ALPHABET + _LOWER_ALPHABET.upper()
WHITESPACE = " \t\r\n"

class TokenType:
    Whitespace = 0
    # TODO: split symbol and name
    Symbol = 1
    Number = 2
    NumberFloat = 3
    BracketLeft = 4
    BracketRight = 5
    String = 6

class Token:
    def __init__(self, tokenType: int, slice: Slice, value: int | float | str):
        self.tokenType = tokenType
        self.slice = slice
        self.value = value

    def __repr__(self):
        return f"Token({self.tokenType}, {self.slice}, {repr(self.value)})"

def getNextToken(slice: Slice) -> Token:
    str = slice.data
    i = j = slice.start
    end = slice.end
    # symbol
    if str[j] in SYMBOLS:
        while j < end and str[j] in SYMBOLS:
            j += 1
        return Token(TokenType.Symbol, Slice(str, i, j), 0)
    elif str[j] in ALPHABET:
        while j < end and str[j] in ALPHABET:
            j += 1
        return Token(TokenType.Symbol, Slice(str, i, j), 0)
    # whitespace
    elif str[j] in WHITESPACE:
        while j < end and str[j] in WHITESPACE:
            j += 1
        return Token(TokenType.Whitespace, Slice(str, i, j), 0)
    # number
    elif str[j] == "0":
        j += 1
        if j < end:
            if str[j] == "x":
                while j < end and str[j] in "0123456789abcdef":
                    j += 1
                return Token(TokenType.Number, Slice(str, i, j), int(str[i:j], 16))
            elif str[j] == "b":
                while j < end and str[j] in "01":
                    j += 1
                return Token(TokenType.Number, Slice(str, i, j), int(str[i:j], 2))
    elif str[j] in "123456789":
        while j < end and str[j] in "0123456789":
            j += 1
        if j < end and str[j] == ".":
            j += 1
            while j < end and str[j] in "0123456789":
                j += 1
            return Token(TokenType.NumberFloat, Slice(str, i, j), float(str[i:j]))
        return Token(TokenType.Number, Slice(str, i, j), int(str[i:j], 10))
    # bracket
    elif str[j] == "(":
        return Token(TokenType.BracketLeft, Slice(str, i, j + 1), 0)
    elif str[j] == ")":
        return Token(TokenType.BracketRight, Slice(str, i, j + 1), 0)
    # string
    elif str[j] == "\"":
        j += 1
        acc = ""
        while j < end:
            if str[j] == "\\":
                j += 1
                if j < end:
                    if str[j] == "u":
                        code = int(str[j:j + 4])
                        acc += chr(code)
                        j += 4
                    elif str[j] in "0123456789":
                        code = int(str[j:j + 2])
                        acc += chr(code)
                        j += 2
                    else:
                        acc += str[j]
                        j += 1
            elif str[j] == "\"":
                return Token(TokenType.String, Slice(str, i, j + 1), acc)
            else:
                acc += str[j]
                j += 1
    raise SyntaxError(Slice(str, i, j))

if __name__ == "__main__":
    try:
        while True:
            s = input("input: ")
            slice = Slice(s)
            while slice.start < slice.end:
                next_token = getNextToken(slice)
                slice.start = next_token.slice.end
                print(next_token)
    except KeyboardInterrupt:
        pass
