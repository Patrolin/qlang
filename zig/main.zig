// zig build-obj -femit-llvm-ir .\zig\main.zig
const std = @import("std");
const dprint = std.debug.print;

pub fn main() !void {
    var b = try ask_user();
    // 1) auto check for zero - slow
    // 2) Itanium exception handler?
    // 3) SEH/longjump - very slow
    var x = @as(i16, -32768) * @as(i16, b); // panic: integer overflow (-1)
    var y = @divTrunc(100, b); // panic: divide by zero (0)
    dprint("Hello world {}, {}\n", .{x, y});
}

pub fn ask_user() !i16 {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Number: ", .{});
    var buf: [20]u8 = undefined;
    const n = try stdin.read(&buf);
    return std.fmt.parseInt(i16, buf[0..n-2], 10);
}
