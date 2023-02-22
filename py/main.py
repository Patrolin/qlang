from dataclasses import dataclass
from sys import argv

# tokens
@dataclass
class Token:
    location: int
    token: str

def tokenize(string: str, tokens: str):
    accTokens = []
    for character in string:
        for token in tokens:
            if character == token:
                accTokens.append(token)
    return accTokens

LOWER_ALPHABET = "abcdefghijklmnopqrstuvxyz"
ALPHABET = LOWER_ALPHABET + LOWER_ALPHABET.upper()
NUMBERS = "0123456789"
SYMBOLS = "()"
VALID_TOKENS = ALPHABET + NUMBERS + SYMBOLS

def main(src: str):
    file = open(src, "r", encoding="utf8")
    tokens = tokenize(file.read(), VALID_TOKENS)
    i = 0
    while True:
        token = tokens[i]
        # TODO: parse
    # TODO: call sim for constants
    # TODO: write .ll # https://llvm.org/docs/LangRef.html
    # TODO: run f"clang {name}.ll -o {name}.exe -nostdinc -nostdlib -nostdlib++ -no-integrated-cpp -z /subsystem:windows /entry:main -z User32.lib"

    file.close()

if __name__ == "__main__":
    main(argv[1])
