const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

fn Matrix(
    comptime T: type,
    comptime width: comptime_int,
    comptime height: comptime_int,
) type {
    return [height][width]T;
}

const Coord = struct { y: usize, x: usize };

pub fn part1() !void {
    std.debug.print("Day 03, Part 1\n", .{});

    const file = try std.fs.cwd().openFile("src/day03.input.txt", .{});
    defer file.close();

    const width: i16 = 140;
    const height: i16 = 140;
    var matrix: Matrix(u8, width, height) = undefined;

    var reader = std.io.bufferedReader(file.reader());
    var in_stream = reader.reader();
    var buf: [1024]u8 = undefined;
    var i: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        @memcpy(&matrix[i], line);
        i += 1;
    }

    var answer: u32 = 0;
    var num = [3]u8{ 0, 0, 0 };
    var numIdx: u8 = 0;

    for (0..height) |y| {
        for (0..width) |x| {
            const char = matrix[y][x];
            var doCheck = false;

            if (std.ascii.isDigit(char)) {
                num[numIdx] = char;
                numIdx += 1;
                doCheck = x == width - 1;
            } else {
                // if we reached a non-digit (aka symbol)
                // check surroundings for symbols
                doCheck = numIdx > 0;
            }

            if (doCheck) {
                var touchesSymbol = false;

                const y_i16: i16 = @intCast(y);
                const x_i16: i16 = @intCast(x);

                const startingX =
                    if (x == width - 1 and std.ascii.isDigit(char)) @max(x_i16 - numIdx, 0) else @max(x_i16 - numIdx - 1, 0);

                check: for (@max(y_i16 - 1, 0)..@min(y + 2, height)) |y_| {
                    for (startingX..@min(x + 1, width)) |x_| {
                        if (matrix[y_][x_] == '.' or std.ascii.isDigit(matrix[y_][x_])) continue;

                        touchesSymbol = true;
                        break :check;
                    }
                }

                if (touchesSymbol) {
                    const currentNumber = try std.fmt.parseInt(u16, num[0..numIdx], 10);
                    answer += currentNumber;
                }

                @memset(&num, 0);
                numIdx = 0;
            }
        }
        @memset(&num, 0);
        numIdx = 0;
    }

    std.debug.print("Answer: {any}\n", .{answer});
}

pub fn part2() !void {
    std.debug.print("Day 03, Part 2\n", .{});

    const file = try std.fs.cwd().openFile("src/day03.input.txt", .{});
    defer file.close();

    const width: i16 = 140;
    const height: i16 = 140;
    var matrix: Matrix(u8, width, height) = undefined;

    var reader = std.io.bufferedReader(file.reader());
    var in_stream = reader.reader();
    var buf: [1024]u8 = undefined;

    var i: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        @memcpy(&matrix[i], line);
        i += 1;
    }

    var num = [3]u8{ 0, 0, 0 };
    var numIdx: u8 = 0;

    var map = std.AutoHashMap([2]u16, [2]u64).init(allocator);
    defer map.deinit();

    for (0..height) |y| {
        for (0..width) |x| {
            const char = matrix[y][x];
            var doCheck = false;

            if (std.ascii.isDigit(char)) {
                num[numIdx] = char;
                numIdx += 1;
                doCheck = x == width - 1;
            } else {
                // if we reached a non-digit (aka symbol)
                // check surroundings for symbols
                doCheck = numIdx > 0;
            }

            if (doCheck) {
                const currentNumber = try std.fmt.parseInt(u64, num[0..numIdx], 10);

                const y_i16: i16 = @intCast(y);
                const x_i16: i16 = @intCast(x);

                const startingX =
                    if (x == width - 1 and std.ascii.isDigit(char)) @max(x_i16 - numIdx, 0) else @max(x_i16 - numIdx - 1, 0);

                check: for (@max(y_i16 - 1, 0)..@min(y + 2, height)) |y_| {
                    for (startingX..@min(x + 1, width)) |x_| {
                        if (matrix[y_][x_] == '.' or std.ascii.isDigit(matrix[y_][x_]) or matrix[y_][x_] != '*') continue;

                        const loc = [2]u16{ @intCast(y_), @intCast(x_) };
                        if (map.getPtr(loc)) |ptr| {
                            ptr.*[1] = currentNumber;
                        } else {
                            try map.put(loc, [2]u64{ currentNumber, 0 });
                        }
                        break :check;
                    }
                }

                @memset(&num, 0);
                numIdx = 0;
            }
        }
        @memset(&num, 0);
        numIdx = 0;
    }

    var answer: u128 = 0;
    var iter = map.iterator();
    while (iter.next()) |entry| {
        var items = entry.value_ptr.*;
        if (items[1] != 0) {
            answer += items[0] * items[1];
        }
    }

    std.debug.print("Answer: {any}\n", .{answer});
}
