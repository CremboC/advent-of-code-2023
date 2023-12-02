const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn part1() !void {
    std.debug.print("Day 01, Part 1\n", .{});

    const file = try std.fs.cwd().openFile("src/day01input.txt", .{});
    defer file.close();

    var reader = std.io.bufferedReader(file.reader());
    var in_stream = reader.reader();
    var buffer: [1024]u8 = undefined;

    var answer: u128 = 0;
    var nums = [2]u8{ 0, 0 };
    while (try in_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        for (line) |char| {
            if (std.ascii.isDigit(char)) {
                if (nums[0] == 0) {
                    nums[0] = char;
                }

                nums[1] = char;
            }
        }

        const result = try std.fmt.parseInt(u8, &nums, 10);

        answer += result;
        nums[0] = 0;
        nums[1] = 0;
    }

    std.debug.print("Answer: {any}\n", .{answer});
}

const Digit = struct {
    idx: usize,
    ascii: u8,
};

fn sortDigit(_: void, lhs: Digit, rhs: Digit) bool {
    return lhs.idx < rhs.idx;
}

pub fn part2() !void {
    std.debug.print("Day 01, Part 2\n", .{});
    const file = try std.fs.cwd().openFile("src/day01input.txt", .{});
    defer file.close();

    var map = std.StringHashMap(u8).init(allocator);
    try map.put("one", 1 + 48);
    try map.put("two", 2 + 48);
    try map.put("three", 3 + 48);
    try map.put("four", 4 + 48);
    try map.put("five", 5 + 48);
    try map.put("six", 6 + 48);
    try map.put("seven", 7 + 48);
    try map.put("eight", 8 + 48);
    try map.put("nine", 9 + 48);
    defer map.deinit();

    var reader = std.io.bufferedReader(file.reader());
    var in_stream = reader.reader();
    var buffer: [1024]u8 = undefined;

    var answer: u32 = 0;
    var nums = [2]u8{ 0, 0 };

    var digits = std.ArrayList(Digit).init(allocator);
    defer digits.deinit();

    while (try in_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        for (line, 0..) |char, index| {
            if (std.ascii.isDigit(char)) {
                try digits.append(Digit{ .idx = index, .ascii = char });
            }
        }

        var entries = map.iterator();
        while (entries.next()) |entry| {
            if (std.mem.indexOf(u8, line, entry.key_ptr.*)) |idx| {
                try digits.append(Digit{ .idx = idx, .ascii = entry.value_ptr.* });
            }
            if (std.mem.lastIndexOf(u8, line, entry.key_ptr.*)) |idx| {
                try digits.append(Digit{ .idx = idx, .ascii = entry.value_ptr.* });
            }
        }

        const o = try digits.toOwnedSlice(); // also clears the array for next line
        std.mem.sort(Digit, o, {}, sortDigit);
        nums[0] = o[0].ascii;
        nums[1] = o[o.len - 1].ascii;

        const result = try std.fmt.parseInt(u8, &nums, 10);

        answer += result;
        nums[0] = 0;
        nums[1] = 0;
    }

    std.debug.print("Answer: {any}\n", .{answer});
}
