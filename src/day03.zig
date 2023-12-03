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

    const file = try std.fs.cwd().openFile("src/day03.example.txt", .{});
    defer file.close();

    const width: i16 = 10;
    const height: i16 = 10;
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
        std.debug.print("{?s} // \n", .{matrix[y]});
        for (0..width) |x| {
            const char = matrix[y][x];
            // std.debug.print("cur char: {s} at {},{}\n", .{ [1]u8{char}, y, x });
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
                const currentNumber = try std.fmt.parseInt(u16, num[0..numIdx], 10);
                std.debug.print("Doing check for {} at {},{}\n", .{ currentNumber, y, x });
                var touchesSymbol = false;
                var y_loc: usize = 0;
                var x_loc: usize = 0;

                const y_i16: i16 = @intCast(y);
                const x_i16: i16 = @intCast(x);

                // const checks = std.ArrayList(Coord).init(allocator);
                // defer checks.deinit();
                // if (y > 0) {
                //     if (x > 0) {
                //         try checks.append(Coord { .y = y - 1, .x = x - num });
                //     }

                // }

                check: for (@max(y_i16 - 1, 0)..@min(y + 2, height)) |y_| {
                    for (@max(x_i16 - numIdx - 1, 0)..@min(x + 1, width)) |x_| {
                        std.debug.print("checking at {}, {} -- got: {s}\n", .{ y_, x_, [1]u8{matrix[y_][x_]} });
                        if (matrix[y_][x_] == '.' or std.ascii.isDigit(matrix[y_][x_])) continue;

                        touchesSymbol = true;
                        // std.debug.print("Touches at loc: {s}\n", .{[1]u8{matrix[y_][x_]}});
                        y_loc = y_;
                        x_loc = x_;
                        break :check;
                    }
                }

                if (touchesSymbol) {
                    // const currentNumber = try std.fmt.parseInt(u16, num[0..numIdx], 10);
                    // std.debug.print("+{}, ", .{currentNumber});
                    answer += currentNumber;
                }

                @memset(&num, 0);
                numIdx = 0;
            }
        }
        @memset(&num, 0);
        numIdx = 0;
        std.debug.print("\n", .{});
        // if (y == 28) break;
    }

    std.debug.print("{}\n", .{std.ascii.isDigit('$')});
    // std.debug.print("{s}\n", .{matrix[6..8][1]});
    // std.debug.print("{s}", .{matrix[6..10][1]});
    // std.debug.print("{s}", .{matrix[6..10][2]});

    std.debug.print("Answer: {any}\n", .{answer});
}

pub fn part2() !void {
    std.debug.print("Day 03, Part 2\n", .{});

    const file = try std.fs.cwd().openFile("src/day03.example.txt", .{});
    defer file.close();

    var reader = std.io.bufferedReader(file.reader());
    var in_stream = reader.reader();
    var buffer: [1024]u8 = undefined;

    var answer: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        _ = line;
    }

    std.debug.print("Answer: {any}\n", .{answer});
}
