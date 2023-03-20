from common import Slice, StringBuilder

# module
class Module:
    def __init__(self, name: str):
        self.name = name
        self.types: dict[str, Type] = dict()
        self.functions: dict[str, Function] = dict()

    def __repr__(self):
        typesString = ',\n    '.join(f"{repr(k)}: {repr(v)}" for k, v in self.types.items())
        functionsString = ',\n    '.join(f"{repr(k)}: {repr(v)}" for k, v in self.functions.items())
        return f"Module(\n  name={repr(self.name)},\n  types={{{typesString}}},\n  functions={{{functionsString}}})"

# type
class Type:
    def __init__(self, name: Slice, class_: int, export: bool):
        self.name = name
        self.class_ = class_
        self.other_type: Type | None = None
        self.export = export

    def __repr__(self):
        return f"Type(class_={self.class_}, name={self.name}, other_type={self.other_type}, export={self.export})"

class TypeClass:
    Intrinsic = 0
    Opaque = 1
    Array = 2
    Pointer = 3

class VariableSection:
    Const = 0
    Var = 1
    Alloc = 2

# TODO: constants?
class Function:
    name: Slice
    link: bool
    return_type: list["ValueType"]
    arguments: list["Expression"]
    statements: list["Expression"]

    def codegen(self, acc=StringBuilder(), variables: dict[str, "Expression"] = dict()) -> str:
        acc.write(f"define {self.return_type} {{\n")
        i = 0
        for statement in self.statements:
            acc.write("\n    ")
            acc.write(statement.codegen(acc, variables, i))
            i += 1
        acc.write("}")
        return acc.string

# TODO: full types
class ValueType:
    Type = 0
    Number = 1
    String = 2

class OpType:
    NumberConstant = 0 # i32 123
    StringConstant = 1 # @.1 = private unnamed_addr constant [13 x i8] c"hello world\0A\00" // @.1
    Call = 2 # call i1 @WriteConsoleA(...)
    Return = 3 # ret i32 0
    SetVariable = 4
    # int a = 123 # %1 = i32 123
    # int* a = 123 # %1 = alloca ptr, align 8 \n store i32 123, ptr %1, align 8
    GetVariable = 5
    # a # i32 %1
    # &a # %2 = load i32, ptr %1, align 8 // %2
    Add = 6 # %2 = add i32 %1, i32 123 // %2
    Sub = 7 # ...
    Mul = 8
    Div = 9

class Expression:
    # 1 + 2*3
    value_type: ValueType
    op_type: OpType
    left: "Expression | str | None"
    right: "Expression | list[Expression] | None"

    def codegen(self, i: int) -> str:
        ...

if __name__ == "__main__":
    """
    opaque WindowHandle
    link i32 MessageBoxA(WindowHandle* %window_handle, i8* %message, i8* %title, i32 %options)

    main()
        MessageBoxA(0, "hello world\0A\00", 0, 64)
    """
    f = Function()
    f.statements = []
    f.statements.append(Expression())
