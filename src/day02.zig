const std = @import("std");

pub fn part1() !void {
    std.debug.print("Day 02, Part 1\n", .{});

    const file = try std.fs.cwd().openFile("src/day02input.txt", .{});
    defer file.close();

    var reader = std.io.bufferedReader(file.reader());
    var in_stream = reader.reader();
    var buffer: [1024]u8 = undefined;

    var valid_games: u32 = 0;
    line: while (try in_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var split = std.mem.splitAny(u8, line, ":;");
        const gameIdx = gm: {
            var gameSplit = std.mem.splitBackwardsAny(u8, split.next().?, " ");
            break :gm try std.fmt.parseInt(u32, gameSplit.next().?, 10);
        };
        while (split.next()) |game| {
            var gameSplit = std.mem.splitSequence(u8, game, ", ");
            while (gameSplit.next()) |round| {
                const trimmed = std.mem.trim(u8, round, " ");
                var pickSplit = std.mem.splitScalar(u8, trimmed, ' ');
                const count = try std.fmt.parseInt(u8, pickSplit.next().?, 10);
                const color = pickSplit.next().?;
                if (std.mem.eql(u8, color, "red")) {
                    if (count > 12) {
                        continue :line;
                    }
                } else if (std.mem.eql(u8, color, "green")) {
                    if (count > 13) {
                        continue :line;
                    }
                } else if (std.mem.eql(u8, color, "blue")) {
                    if (count > 14) {
                        continue :line;
                    }
                }
            }
        }
        valid_games += gameIdx;
    }

    std.debug.print("Answer: {any}\n", .{valid_games});
}

pub fn part2() !void {
    std.debug.print("Day 02, Part 2\n", .{});
    const file = try std.fs.cwd().openFile("src/day02input.txt", .{});
    defer file.close();

    var reader = std.io.bufferedReader(file.reader());
    var in_stream = reader.reader();
    var buffer: [1024]u8 = undefined;

    var answer: u32 = 0;
    var red_min: u32 = 0;
    var blue_min: u32 = 0;
    var green_min: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var split = std.mem.splitAny(u8, line, ":;");
        _ = split.next(); // skip game index
        while (split.next()) |game| {
            var gameSplit = std.mem.splitSequence(u8, game, ", ");
            while (gameSplit.next()) |round| {
                const trimmed = std.mem.trim(u8, round, " ");
                var pickSplit = std.mem.splitScalar(u8, trimmed, ' ');
                const count = try std.fmt.parseInt(u8, pickSplit.next().?, 10);
                const color = pickSplit.next().?;
                if (std.mem.eql(u8, color, "red")) {
                    if (red_min < count) {
                        red_min = count;
                    }
                } else if (std.mem.eql(u8, color, "green")) {
                    if (green_min < count) {
                        green_min = count;
                    }
                } else if (std.mem.eql(u8, color, "blue")) {
                    if (blue_min < count) {
                        blue_min = count;
                    }
                }
            }
        }
        answer += (green_min * blue_min * red_min);

        green_min = 0;
        red_min = 0;
        blue_min = 0;
    }

    std.debug.print("Answer: {any}\n", .{answer});
}
