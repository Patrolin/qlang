from dataclasses import dataclass
from typing import Callable

@dataclass
class Operation:
    op_code: int
    arguments: tuple[int, ...]
    call: str = ""

def Load(value: int):
    return Operation(0, (value, ))

def Call(name: str, *args: int):
    return Operation(1, args, call=name)

def Return(*args: int):
    return Operation(2, args)

@dataclass
class Function:
    arguments: int
    operations: list[Operation]
    intrinsic: Callable | None = None

class Program:
    functions: dict[str, Function] = {}

    def add(self, name: str, f: Function):
        self.functions[name] = f

    def sim(self):
        return self.sim_call(Call("main"), [])

    def sim_call(self, call_op: Operation, prev_belt: list[int]):
        print("sim_call", call_op)
        belt: list[int] = []
        for arg in call_op.arguments:
            belt.append(prev_belt[-arg])
        f = self.functions[call_op.call]
        if f.intrinsic:
            return f.intrinsic(belt)
        for op in f.operations:
            print("sim_call.2", op)
            result = self.sim_op(op, belt)
            if result:
                for r in result[::-1]:
                    belt.append(r)
            if op.op_code == 2:
                result = []
                for arg in op.arguments[::-1]:
                    result.append(belt[-arg])
                return result

    def sim_op(self, op: Operation, belt: list[int]):
        if op.op_code == 0:
            return [op.arguments[0]]
        elif op.op_code == 1:
            return self.sim_call(op, belt)
        else:
            raise ValueError("Unknown op_code")

if __name__ == "__main__":
    program = Program()
    program.add("main", Function(0, [ \
        Load(42),
        Call("print", 0)
    ]))
    program.add("print", Function(1, [], lambda belt: print(belt[-1])))
    program.sim()
