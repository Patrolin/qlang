// zig build-obj -femit-llvm-ir .\zig\main.zig
const std = @import("std");
const Allocator = std.mem.Allocator;
const allocator = std.heap.page_allocator;
const dprint = std.debug.print;

pub fn main() !void {
    dprint("Hello world\n", .{});
}
