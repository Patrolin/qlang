from typing import Any
from common import Slice, assert_equals, assert_not_equals
from parse_tokens import getNextToken, TokenType, Token
from typed_ir import Type, TypeClass, Function, Module

DEFAULT_MODULE_NAME = ".default"
ALL_MODULE_NAME = ".all"

class AstParser:
    # common
    def __init__(self):
        # default types
        defaultModule = Module(DEFAULT_MODULE_NAME)
        for prefix in "isf":
            for width in ["8", "16", "32", "64"]:
                name = Slice(f"{prefix}{width}")
                defaultModule.types[name.value()] = Type(name, TypeClass.Intrinsic, export=True)
        defaultModule.types["char"] = defaultModule.types["i8"]
        defaultModule.types["word"] = defaultModule.types["i16"]
        defaultModule.types["dword"] = defaultModule.types["i32"]
        defaultModule.types["qword"] = defaultModule.types["i64"]
        self.modules: dict[str, Module] = {DEFAULT_MODULE_NAME: defaultModule}
        # state
        self.current_indent: int = 0
        self.current_module: Module = defaultModule

    def newModule(self, module_name: str):
        module = Module(module_name)
        for type_name, type in self.modules[DEFAULT_MODULE_NAME].types.items():
            module.types[type_name] = type
        self.modules[module_name] = module
        return module

    def addType(self, type: Type):
        name = type.name.value()
        if name in self.current_module.types:
            raise SyntaxError(f"Redeclaration of type {type.name}")
        self.current_module.types[name] = type

    def addFunction(self, f: Function):
        name = f.name.value()
        if name in self.current_module.functions:
            raise SyntaxError(f"Redeclaration of function {f.name}")
        self.current_module.functions[name] = f

    # parsing
    def parseAst(self, module_name: str, text: str):
        self.current_module = self.newModule(module_name)
        slice = Slice(text)
        while slice.start < slice.end:
            self.parseGlobalStatement(slice)
            print(self.current_module)
            token = getNextToken(slice)
            slice.start = token.slice.end

    def parseGlobalStatement(self, slice: Slice):
        export = False
        token1 = self.parseWhitespace(slice)
        assert_equals(token1.tokenType, TokenType.Symbol)
        if token1.slice == "export":
            export = True
            slice.start = token1.slice.end
            token1 = self.parseWhitespace(slice)
        assert_equals(token1.tokenType, TokenType.Symbol)
        if token1.slice == "opaque":
            slice.start = token1.slice.end
            name = self.parseWhitespace(slice)
            slice.start = name.slice.end
            self.addType(Type(name.slice, TypeClass.Opaque, export=export))
        elif token1.slice == "link":
            slice.start = token1.slice.end
            f = self.parseFunctionHeader(slice)
            self.addFunction(f)
        else:
            self.parseFunction(slice, export)

    def parseFunction(self, slice: Slice, export: bool):
        print("parseFunction", slice)
        ...

    def parseFunctionHeader(self, slice: Slice) -> Function:
        f = Function()
        print("parseFunctionHeader", slice)
        ...
        return f

    def parseWhitespace(self, slice: Slice) -> Token:
        token = getNextToken(slice)
        while True:
            if token.tokenType == TokenType.Whitespace:
                slice.start = token.slice.end
            elif token.tokenType == TokenType.Symbol and token.slice == "//":
                i = slice.start
                while i < slice.end and slice.data[i] != "\n":
                    i += 1
                slice.start = i
            else:
                break
            token = getNextToken(slice)
        return token

if __name__ == "__main__":
    parser = AstParser()
    parser.parseAst("hello.qlang", """
    // hello world
    opaque WindowHandle
main()
    print(1)""")
