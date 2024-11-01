const std = @import("std");

const assert = std.debug.assert;

const NUM_LINES = 1000;
const ESTIM_MAX_BYTES_PER_LINE = 100;
const FILELOC = "./data/day01/file.txt";

fn isDigit(b: u8) bool {
    return ((b >= '0') and (b <= '9'));
}

pub fn main() !void {
    //Create a general purpose allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.print("GPA result: {}\n", .{gpa.deinit()});

    //Create a logging allocator
    var logging_alloc = std.heap.loggingAllocator(gpa.allocator());
    const allocator = logging_alloc.allocator();

    //Read the file
    const file_data = try std.fs.cwd().readFileAlloc(allocator, FILELOC, NUM_LINES * ESTIM_MAX_BYTES_PER_LINE);
    defer allocator.free(file_data);

    //Creator iterator over lines
    var it = std.mem.splitSequence(u8, file_data, "\n");

    var count: i32 = 0;

    while (it.next()) |line| {
        var index: usize = 0;

        var first_digit: ?u8 = null;
        var last_digit: ?u8 = null;

        if (line.len == 0) {
            continue;
        }

        while (index < line.len) {
            if (isDigit(line[index])) {
                first_digit = line[index] - '0';
                break;
            }
            index += 1;
        }

        index = line.len - 1;
        while (index >= 0) {
            if (isDigit(line[index])) {
                last_digit = line[index] - '0';
                break;
            }
            index -= 1;
        }

        if ((first_digit == null) or (last_digit == null)) {
            continue;
        } else {
            count += (first_digit.? * 10) + last_digit.?;
        }
    }

    std.debug.print("Count: {d}\n", .{count});
}
