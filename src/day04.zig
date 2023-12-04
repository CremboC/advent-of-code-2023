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

pub fn part1() !void {
    std.debug.print("Day 04, Part 1\n", .{});

    const file = try std.fs.cwd().openFile("src/day04.input.txt", .{});
    defer file.close();

    const width: i16 = 116;
    const height: i16 = 206;
    var matrix: Matrix(u8, width, height) = undefined;

    var reader = std.io.bufferedReader(file.reader());
    var in_stream = reader.reader();
    var buf: [1024]u8 = undefined;
    var i: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        @memcpy(&matrix[i], line);
        i += 1;
    }

    var answer: i32 = 0;
    var num = [2]u8{ 0, 0 };
    var numIdx: u8 = 0;

    for (0..height) |y| {
        var set = std.AutoHashMap(u8, void).init(allocator);
        defer set.deinit();

        var split = std.mem.splitAny(u8, &matrix[y], ":|");
        _ = split.next(); // skip header
        var winningNumbers = split.next();
        var myNumbers = split.next();

        for (winningNumbers.?) |char| {
            if (std.ascii.isDigit(char)) {
                num[numIdx] = char;
                numIdx += 1;
            } else if (numIdx > 0) {
                const number = try std.fmt.parseInt(u8, num[0..numIdx], 10);
                try set.put(number, {});
                @memset(&num, 0);
                numIdx = 0;
            }
        }

        @memset(&num, 0);
        numIdx = 0;

        var matches: i32 = -1;

        for (myNumbers.?) |char| {
            if (std.ascii.isDigit(char)) {
                num[numIdx] = char;
                numIdx += 1;
            } else if (numIdx > 0) {
                const number = try std.fmt.parseInt(u8, num[0..numIdx], 10);
                if (set.contains(number)) {
                    matches += 1;
                }
                @memset(&num, 0);
                numIdx = 0;
            }
        }

        if (numIdx > 0) {
            const number = try std.fmt.parseInt(u8, num[0..numIdx], 10);
            if (set.contains(number)) {
                matches += 1;
            }
        }
        @memset(&num, 0);
        numIdx = 0;

        if (matches != -1) {
            answer += std.math.pow(i32, 2, matches);
        }
    }

    std.debug.print("Answer: {any}\n", .{answer});
}

pub fn part2() !void {
    std.debug.print("Day 04, Part 2\n", .{});

    const file = try std.fs.cwd().openFile("src/day04.input.txt", .{});
    defer file.close();

    const width: i16 = 116;
    const height: i16 = 206;
    var matrix: Matrix(u8, width, height) = undefined;

    var reader = std.io.bufferedReader(file.reader());
    var in_stream = reader.reader();
    var buf: [1024]u8 = undefined;
    var i: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        @memcpy(&matrix[i], line);
        i += 1;
    }

    var answer: usize = 0;
    var num = [3]u8{ 0, 0, 0 };
    var numIdx: u8 = 0;

    var sizes = std.AutoHashMap(u8, usize).init(allocator);
    defer sizes.deinit();

    var y: i16 = height - 1;
    while (y >= 0) : (y -= 1) {
        var set = std.AutoHashMap(u8, void).init(allocator);
        defer set.deinit();

        var split = std.mem.splitAny(u8, &matrix[@intCast(y)], ":|");
        var header = split.next(); // skip header

        for (header.?) |char| {
            if (std.ascii.isDigit(char)) {
                num[numIdx] = char;
                numIdx += 1;
            }
        }
        const cardNumber = try std.fmt.parseInt(u8, num[0..numIdx], 10);
        @memset(&num, 0);
        numIdx = 0;

        var winningNumbers = split.next();
        var myNumbers = split.next();

        for (winningNumbers.?) |char| {
            if (std.ascii.isDigit(char)) {
                num[numIdx] = char;
                numIdx += 1;
            } else if (numIdx > 0) {
                const number = try std.fmt.parseInt(u8, num[0..numIdx], 10);
                try set.put(number, {});
                @memset(&num, 0);
                numIdx = 0;
            }
        }

        @memset(&num, 0);
        numIdx = 0;

        var matches: u8 = 0;
        for (myNumbers.?) |char| {
            if (std.ascii.isDigit(char)) {
                num[numIdx] = char;
                numIdx += 1;
            } else if (numIdx > 0) {
                const number = try std.fmt.parseInt(u8, num[0..numIdx], 10);
                if (set.contains(number)) {
                    matches += 1;
                }
                @memset(&num, 0);
                numIdx = 0;
            }
        }

        if (numIdx > 0) {
            const number = try std.fmt.parseInt(u8, num[0..numIdx], 10);
            if (set.contains(number)) {
                matches += 1;
            }
        }
        @memset(&num, 0);
        numIdx = 0;

        var idx: u8 = cardNumber + 1;
        var size: usize = matches;
        while (idx <= cardNumber + matches) : (idx += 1) {
            if (sizes.get(idx)) |v| {
                size += v;
            }
        }

        try sizes.put(cardNumber, size);
        answer += 1 + size;
    }

    std.debug.print("Answer: {any}\n", .{answer});
}
