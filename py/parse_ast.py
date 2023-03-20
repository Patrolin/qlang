from typing import Any
from common import Slice, assert_equals, assert_not_equals
from parse_tokens import getNextToken, TokenType, Token
from typed_ir import Type, TypeType

current_indent = 0

def parseAst(s: str):
    types: dict[str, Any] = dict()

    slice = Slice(s)
    while slice.start < slice.end:
        global_statement = parseGlobalStatement(slice)
        print("global_statement:", global_statement)
        token = getNextToken(slice)
        slice.start = token.slice.end

def parseGlobalStatement(slice: Slice):
    token1 = parseWhitespace(slice)
    slice.start = token1.slice.end

    token2 = parseWhitespace(slice)
    slice.start = token2.slice.end

    print(token1, token2)
    assert_equals(token1.tokenType, TokenType.Symbol)
    if token1.slice == "opaque":
        return Type(TypeType.Opaque, Slice(token1.slice.data, token1.slice.start, token2.slice.end), token2.slice)
    else:
        raise SyntaxError(token1)

def parseWhitespace(slice: Slice) -> Token:
    token = getNextToken(slice)
    while token.tokenType == TokenType.Whitespace:
        slice.start = token.slice.end
        token = getNextToken(slice)
    return token

if __name__ == "__main__":
    parseAst("""
    opaque WindowHandle
main()
    print(1)""")
