from typing import cast

class Function:
    return_type: list["ValueType"]
    statements: list["Statement"]

    def codegen(self) -> str:
        NEWLINE = "\n"
        return f"define {self.return_type} {NEWLINE.join(self.statements[i].codegen(i) for i in range(len(self.statements)))}"

class StatementType:
    Declare = 0
    Call = 1
    Return = 2

class Statement:
    # int a = 1
    # print(a)
    # return a, b
    statement_type: StatementType
    name: str | None
    value: "Expression | list[Expression]"

    def codegen(self, i: int) -> str:
        if self.statement_type == StatementType.Declare:
            value = cast(Expression, self.value)
            return value.codegen(i)
        elif self.statement_type == StatementType.Call:
            return ""
        elif self.statement_type == StatementType.Return: # TODO: ???
            return f"return {', '.join(v.codegen(i) for v in cast(list[Expression], self.value))}"
        return "..."

class ValueType:
    Type = 0
    Number = 1
    String = 2

class OpType:
    NumberConstant = 0
    StringConstant = 1
    Variable = 2
    Add = 3
    Sub = 4
    Mul = 5
    Div = 6

class Expression:
    # 1 + 2*3
    value_type: ValueType
    op_type: OpType
    left: "Expression" | None
    right: "Expression" | None

    def codegen(self, i: int) -> str:
        ...

if __name__ == "__main__":
    f = Function()
    f.statements = []
    f.statements.append(Statement())
