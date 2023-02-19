const std = @import("std");
const Allocator = std.mem.Allocator;
const allocator = std.heap.page_allocator;
const dprint = std.debug.print;

// common
const String = []const u8;
const FunctionPtr = *const fn (belt: []u64) []u64;
fn initArrayList(comptime T: type, values: []const T) !std.ArrayList(T) {
    var acc = std.ArrayList(T).init(allocator);
    for (values) |it| {
        try acc.append(it);
    }
    return acc;
}

const OpCode = enum {
    Load, Call, Return
};
const Op = struct {
    op_code: OpCode,
    arguments: std.ArrayList(u64),
    call: ?String = null,
};
fn Load(value: u64) !Op {
    var arguments = try initArrayList(u64, &[_]u64{ value });
    return Op{.op_code = .Load, .arguments = arguments};
}
fn Call(name: String, _arguments: []const u64) !Op {
    var arguments = try initArrayList(u64, _arguments);
    return Op{.op_code = .Call, .arguments = arguments, .call = name};
}
fn Return(arguments: []u64) Op {
    return Op{.Return, arguments};
}

const Function = struct {
    argumentCount: u64,
    ops: std.ArrayList(Op),
    intrinsic: ?FunctionPtr = null,
};
const ProgramFunctions = std.StringHashMap(Function);
const Program = struct {
    functions: ProgramFunctions,

    fn add(self: *Program, name: String, f: Function) !void {
        try self.functions.put(name, f);
    }
    fn sim(self: *Program) void {
        return self.sim_call(Call("main"), {});
    }
    // todo
    fn sim_call(self: *Program, call_op: Operation, prev_belt: list[int]) void {
        print("sim_call", call_op)
        belt: list[int] = []
        for (call_op.arguments) |arg| {
            belt.append(prev_belt[prev_belt.len-arg])
        }
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
    }
    fn sim_op(self: *Program, op: Operation, belt: list[int]) void {
        switch(op.op_code) {
            .Load => {
                return;
            },
            .Call => {
                return self.sim_call(op, belt);
            }
        }
    }
};

pub fn main() !void {
    dprint("All your {s} are belong to us.\n", .{"codebase"});
    var program = Program{
        .functions = ProgramFunctions.init(allocator),
    };
    var ops = std.ArrayList(Op).init(allocator);
    try ops.append(try Load(42));
    try ops.append(try Call("print", &[_]u64{0, 1}));
    try program.add("main", Function{.argumentCount = 0, .ops = ops});
}
