const std = @import("std");
const day01 = @import("day01.zig");
const day02 = @import("day02.zig");
const day03 = @import("day03.zig");

pub fn main() !void {
    std.debug.print("Advent of Code 2023!\n", .{});

    try day01.part1();
    try day01.part2();

    try day02.part1();
    try day02.part2();

    try day03.part1();
    try day03.part2();
}
