from common import Slice, StringBuilder

# module
class Module:
    def __init__(self, name: str):
        self.name = name
        self.types: dict[str, Type] = dict()
        self.functions: dict[str, Function] = dict()
        self.variables: dict[str, Variable] = dict()

    def __repr__(self):
        typesString = ',\n    '.join(f"{repr(k)}: {repr(v)}" for k, v in self.types.items())
        functionsString = ',\n    '.join(f"{repr(k)}: {repr(v)}" for k, v in self.functions.items())
        variablesString = ',\n    '.join(f"{repr(k)}: {repr(v)}" for k, v in self.variables.items())
        return f"Module(\n  name={repr(self.name)},\n  types={{{typesString}}},\n  functions={{{functionsString}}},\n  variables={{{variablesString}}})"

# TODO: wtf do you do according to https://llvm.org/docs/OpaquePointers.html ?
# type
class Type:
    def __init__(self, name: Slice, category: int):
        self.name = name
        # TODO: normalized_name
        self.category = category
        self.other_type: Type | None = None

    def __repr__(self):
        return f"Type(category={self.category}, name={self.name}, other_type={self.other_type})"

class TypeCategory:
    Intrinsic = 0
    Opaque = 1
    Array = 2
    Pointer = 3

# variable
class Variable:
    def __init__(self, type_id: int, name: Slice):
        self.export = False
        self.category = VariableCategory.Alloc
        self.typeId = type_id
        self.name = name

class VariableCategory:
    Alloc = 0
    Const = 1
    Var = 2

# if link external: ccc
# else: internal fastcc
class Function:
    name: Slice
    link: bool
    return_type: list[Type]
    argument_count: int
    variablesNameToId: dict[str, int]
    variables: list[Variable]
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

class Expression:
    # 1 + 2*3
    value_type: Type
    op_type: "OpType"
    left: "Expression | str | None"
    right: "Expression | list[Expression] | None"

    def codegen(self, i: int) -> str:
        ...

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
    #Cast?

if __name__ == "__main__":
    input = """
    opaque WindowHandle
    link i32 MessageBoxA(WindowHandle* %window_handle, i8* %message, i8* %title, i32 %options)

    main()
        MessageBoxA(0, "hello world\0A\00", 0, 64)
    """
    f = Function()
    f.statements = []
    f.statements.append(Expression())

    # goal = output: """
    #link i32 @MessageBoxA(ptr %window_handle, ptr %message, ptr %title, i32 %options)
    #define i32 @main() {
    #    call void @MessageBoxA(0, "hello world\0A\00", 0, 64)
    #}
    #"""
