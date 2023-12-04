const std = @import("std");
const day01 = @import("day01.zig");
const day02 = @import("day02.zig");
const day03 = @import("day03.zig");
const day04 = @import("day04.zig");

pub fn main() !void {
    std.debug.print("Advent of Code 2023!\n", .{});

    {
        const start = std.time.microTimestamp();
        try day01.part1();
        const end = std.time.microTimestamp();
        const elapsed = end - start;
        std.debug.print("Elapsed time: {}µs\n", .{elapsed});
    }
    {
        const start = std.time.microTimestamp();
        try day01.part2();
        const end = std.time.microTimestamp();
        const elapsed = end - start;
        std.debug.print("Elapsed time: {}µs\n\n", .{elapsed});
    }

    {
        const start = std.time.microTimestamp();
        try day02.part1();
        const end = std.time.microTimestamp();
        const elapsed = end - start;
        std.debug.print("Elapsed time: {}µs\n", .{elapsed});
    }
    {
        const start = std.time.microTimestamp();
        try day02.part2();
        const end = std.time.microTimestamp();
        const elapsed = end - start;
        std.debug.print("Elapsed time: {}µs\n\n", .{elapsed});
    }

    {
        const start = std.time.microTimestamp();
        try day03.part1();
        const end = std.time.microTimestamp();
        const elapsed = end - start;
        std.debug.print("Elapsed time: {}µs\n", .{elapsed});
    }
    {
        const start = std.time.microTimestamp();
        try day03.part2();
        const end = std.time.microTimestamp();
        const elapsed = end - start;
        std.debug.print("Elapsed time: {}µs\n\n", .{elapsed});
    }

    {
        const start = std.time.microTimestamp();
        try day04.part1();
        const end = std.time.microTimestamp();
        const elapsed = end - start;
        std.debug.print("Elapsed time: {}µs\n", .{elapsed});
    }
    {
        const start = std.time.microTimestamp();
        try day04.part2();
        const end = std.time.microTimestamp();
        const elapsed = end - start;
        std.debug.print("Elapsed time: {}µs\n\n", .{elapsed});
    }
}
