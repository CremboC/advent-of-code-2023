const std = @import("std");
const day01 = @import("day01.zig");

pub fn main() !void {
    std.debug.print("Advent of Code 2023!\n", .{});

    try day01.part1();
    try day01.part2();
}
