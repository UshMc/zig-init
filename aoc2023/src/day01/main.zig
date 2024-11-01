const std = @import("std");

const assert = std.debug.assert;
const print = std.debug.print;

const NUM_LINES = 1000;
const ESTIM_MAX_BYTES_PER_LINE = 10000;
const FILELOC = "./data/day01/file.txt";
const PART_A_ANSWER = 54951;
const PART_B_ANSWER = 55218;
const ALPHA: f32 = 0.01;
const VEC_SIZE = 16;

fn isDigit(b: u8) bool {
    return ((b >= '0') and (b <= '9'));
}

fn checkByteManual(line: []const u8, index: usize) ?u8 {
    const len_left = line.len - index;
    switch (line[index]) {
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' => return line[index] - '0',
        'o' => {
            if (len_left >= 3) {
                if (line[index + 1] == 'n') {
                    if (line[index + 2] == 'e') {
                        return 1;
                    }
                }
            }
        },
        't' => {
            if (len_left >= 3) {
                if (line[index + 1] == 'w') {
                    if (line[index + 2] == 'o') {
                        return 2;
                    }
                }
            }
            if (len_left >= 5) {
                if (line[index + 1] == 'h') {
                    if (line[index + 2] == 'r') {
                        if (line[index + 3] == 'e') {
                            if (line[index + 4] == 'e') {
                                return 3;
                            }
                        }
                    }
                }
            }
        },
        'f' => {
            if (len_left >= 4) {
                if (line[index + 1] == 'o') {
                    if (line[index + 2] == 'u') {
                        if (line[index + 3] == 'r') {
                            return 4;
                        }
                    }
                } else if (line[index + 1] == 'i') {
                    if (line[index + 2] == 'v') {
                        if (line[index + 3] == 'e') {
                            return 5;
                        }
                    }
                }
            }
        },
        's' => {
            if (len_left >= 3) {
                if (line[index + 1] == 'i') {
                    if (line[index + 2] == 'x') {
                        return 6;
                    }
                }
            }
            if (len_left >= 5) {
                if (line[index + 1] == 'e') {
                    if (line[index + 2] == 'v') {
                        if (line[index + 3] == 'e') {
                            if (line[index + 4] == 'n') {
                                return 7;
                            }
                        }
                    }
                }
            }
        },
        'e' => {
            if (len_left >= 5) {
                if (line[index + 1] == 'i') {
                    if (line[index + 2] == 'g') {
                        if (line[index + 3] == 'h') {
                            if (line[index + 4] == 't') {
                                return 8;
                            }
                        }
                    }
                }
            }
        },
        'n' => {
            if (len_left >= 4) {
                if (line[index + 1] == 'i') {
                    if (line[index + 2] == 'n') {
                        if (line[index + 3] == 'e') {
                            return 9;
                        }
                    }
                }
            }
        },
        else => {},
    }
    return null;
}

//fn checkByteComptimeDS(line: []const u8, index: usize) ?u8 {

fn checkByteStd(line: []const u8, index: usize) ?u8 {
    switch (line[index]) {
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' => return line[index] - '0',
        'o' => if (std.mem.startsWith(u8, line[index..], "one")) return 1,
        't' => {
            if (std.mem.startsWith(u8, line[index..], "two")) {
                return 2;
            } else if (std.mem.startsWith(u8, line[index..], "three")) {
                return 3;
            }
        },
        'f' => {
            if (std.mem.startsWith(u8, line[index..], "four")) {
                return 4;
            } else if (std.mem.startsWith(u8, line[index..], "five")) {
                return 5;
            }
        },
        's' => {
            if (std.mem.startsWith(u8, line[index..], "six")) {
                return 6;
            } else if (std.mem.startsWith(u8, line[index..], "seven")) {
                return 7;
            }
        },
        'e' => {
            if (std.mem.startsWith(u8, line[index..], "eight")) {
                return 8;
            }
        },
        'n' => {
            if (std.mem.startsWith(u8, line[index..], "nine")) {
                return 9;
            }
        },
        else => return null,
    }
    return null;
}

fn getCount(file_data: []u8, checkDigitFunc: *const fn ([]const u8, usize) ?u8) [2]u32 {
    const start_time = std.time.nanoTimestamp();
    //Creator iterator over lines
    var it = std.mem.splitSequence(u8, file_data, "\n");

    var count: u32 = 0;

    while (it.next()) |line| {
        var index: usize = 0;

        var first_digit: ?u8 = null;
        var last_digit: ?u8 = null;

        if (line.len == 0) {
            continue;
        }

        while (index < line.len) {
            if (checkDigitFunc(line, index)) |digit| {
                first_digit = digit;
                break;
            }
            index += 1;
        }

        index = line.len - 1;
        while (index >= 0) {
            if (checkDigitFunc(line, index)) |digit| {
                last_digit = digit;
                break;
            }
            if (index > 0) {
                index -= 1;
            } else {
                break;
            }
        }

        if ((first_digit == null) or (last_digit == null)) {
            print("NONE FOUND IN: {s}\n", .{line});
            continue;
        } else {
            count += (first_digit.? * 10) + last_digit.?;
        }
    }

    const end_time = std.time.nanoTimestamp();
    const time_diff: u32 = @intCast(end_time - start_time);
    return .{ count, time_diff };
}

const nums: [9]@Vector(VEC_SIZE, u8) = .{ @splat('1'), @splat('2'), @splat('3'), @splat('4'), @splat('5'), @splat('6'), @splat('7'), @splat('8'), @splat('9') };

fn getDigitCountSIMD(file_data: []u8) ![2]u32 {
    const start_time = std.time.nanoTimestamp();
    var it = std.mem.splitSequence(u8, file_data, "\n");

    var vector_block: @Vector(VEC_SIZE, u8) = undefined;

    var first_indicies: [9]u8 = undefined;
    var last_indicies: [9]?u4 = undefined;

    var count: u32 = 0;

    while (it.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var first_digit: ?u8 = null;
        var block_counter: u8 = 0;

        while (block_counter * VEC_SIZE < line.len) {
            const valid_len = @min(line.len - (block_counter * VEC_SIZE), VEC_SIZE);

            if (valid_len == VEC_SIZE) {
                //std.mem.copyForwards(u8, block_buffer, line[(block_counter * VEC_SIZE) .. (block_counter + 1) * VEC_SIZE]); //@Speed - dont think i need to mem.copy here - could coerce to vector from line data
                for (0..VEC_SIZE) |i| {
                    vector_block[i] = line[block_counter * VEC_SIZE + i];
                }
            } else {
                //std.mem.copyForwards(u8, vector_block, line[block_counter * VEC_SIZE ..]);
                for (0..valid_len) |i| {
                    vector_block[i] = line[block_counter * VEC_SIZE + i];
                }
                for (valid_len..VEC_SIZE) |i| {
                    vector_block[i] = 0;
                }
            }

            for (nums, 0..) |vec_of_nums, index| {
                first_indicies[index] = std.simd.firstTrue(vector_block == vec_of_nums) orelse VEC_SIZE;
            }

            var lowest_index: u8 = VEC_SIZE;
            for (first_indicies) |i| {
                if (i < lowest_index) {
                    lowest_index = i;
                }
            }

            if (lowest_index < VEC_SIZE) {
                first_digit = vector_block[lowest_index] - '0';
                break;
            }

            block_counter += 1;
        }

        var last_digit: ?u8 = null;
        block_counter = 0;

        while (block_counter * VEC_SIZE < line.len) {
            const valid_len = @min(line.len - (block_counter * VEC_SIZE), VEC_SIZE);

            if (valid_len == VEC_SIZE) {
                //std.mem.copyForwards(u8, block_buffer, line[(line.len - ((block_counter + 1) * VEC_SIZE))..(line.len - (block_counter * VEC_SIZE))]);
                for (0..VEC_SIZE) |i| {
                    vector_block[i] = line[line.len - ((block_counter + 1) * VEC_SIZE) + i];
                }
            } else {
                //std.mem.copyForwards(u8, block_buffer[(VEC_SIZE - valid_len)..], line[0..(line.len - (block_counter * VEC_SIZE))]);
                for ((VEC_SIZE - valid_len)..VEC_SIZE) |i| {
                    vector_block[i] = line[(i + line.len) - ((block_counter + 1) * VEC_SIZE)];
                }
                for (0..(VEC_SIZE - valid_len)) |i| {
                    vector_block[i] = 0;
                }
            }

            for (nums, 0..) |vec_of_nums, index| {
                last_indicies[index] = std.simd.lastTrue(vector_block == vec_of_nums);
            }

            var largest_index: ?u8 = null;
            for (last_indicies) |i| {
                if (i) |li| {
                    if ((largest_index == null) or (li > largest_index.?)) {
                        largest_index = @as(u8, i.?);
                    }
                }
            }
            if (largest_index) |li| {
                last_digit = vector_block[li] - '0';
                break;
            }

            block_counter += 1;
        }

        if ((first_digit != null) and (last_digit != null)) {
            count += first_digit.? * 10 + last_digit.?;
        }
    }
    const end_time = std.time.nanoTimestamp();
    const time_diff: u32 = @intCast(end_time - start_time);

    return .{ count, time_diff };
}

fn getDigitCount(file_data: []const u8) ![2]u32 {
    const start_time = std.time.nanoTimestamp();
    var it = std.mem.splitSequence(u8, file_data, "\n");

    var count: u32 = 0;
    //TEMP

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
    const end_time = std.time.nanoTimestamp();
    const time_diff: u32 = @intCast(end_time - start_time);

    return .{ count, time_diff };
}

pub fn main() !void {
    //Create a general purpose allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer print("GPA result: {}\n", .{gpa.deinit()});

    //Create a logging allocator
    const allocator = gpa.allocator();

    //Read the file
    const file_data = try std.fs.cwd().readFileAlloc(allocator, FILELOC, NUM_LINES * ESTIM_MAX_BYTES_PER_LINE);
    defer allocator.free(file_data);

    const part_b_functions: [2]*const fn ([]const u8, usize) ?u8 = .{ checkByteManual, checkByteStd };

    var emas: [4]f32 = .{ 0, 0, 0, 0 };
    var totals: [4]u128 = .{ 0, 0, 0, 0 };

    const num_iterations: u16 = 4200;

    for (0..num_iterations) |i| {
        const part_a_no_simd = try getDigitCount(file_data);
        const part_a_simd = try getDigitCountSIMD(file_data);

        assert(part_a_no_simd[0] == PART_A_ANSWER);
        emas[0] = (emas[0] * (1 - ALPHA)) + (@as(f32, @floatFromInt(part_a_no_simd[1])) * ALPHA);
        totals[0] = totals[0] + part_a_no_simd[1];

        assert(part_a_simd[0] == PART_A_ANSWER);
        emas[1] = (emas[1] * (1 - ALPHA)) + (@as(f32, @floatFromInt(part_a_simd[1])) * ALPHA);
        totals[1] = totals[1] + part_a_simd[1];

        for (part_b_functions, 0..) |func, func_index| {
            const results = getCount(file_data, func);
            assert(results[0] == PART_B_ANSWER);
            emas[func_index + 2] = (emas[func_index + 2] * (1 - ALPHA)) + (@as(f32, @floatFromInt(results[1])) * ALPHA);
            totals[func_index + 2] = totals[func_index + 2] + results[1];
        }

        if (((i + 1) % 100) == 0) {
            print("Progress: {}/{}\n", .{ i + 1, num_iterations });
        }
    }

    for (emas, totals, 0..) |ema, total, i| {
        if (i == 0) {
            print("Part A: NO SIMD\n", .{});
        } else if (i == 1) {
            print("Part A: SIMD\n", .{});
        } else if (i == 2) {
            print("Part B: Manual\n", .{});
        } else {
            print("Part B: stdlib\n", .{});
        }

        print("\tEMA: {d} ms, Average: {d} ms\n", .{ ema / 1e6, @as(f32, @floatFromInt(total / num_iterations)) / 1e6 });
    }
}
