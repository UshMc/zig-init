const std = @import("std");

const NUM_LINES = 1000;
const ESTIM_MAX_BYTES_PER_LINE = 100;
const FILELOC = "./data/day01/file.txt";
const NEW_FILELOC = "./data/day01/padded_file.txt";

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const file_data = try std.fs.cwd().readFileAlloc(allocator, FILELOC, NUM_LINES * ESTIM_MAX_BYTES_PER_LINE);
    defer allocator.free(file_data);

    var new_file = try std.fs.cwd().createFile(NEW_FILELOC, .{});
    defer new_file.close();

    //write to file:
    var new_file_writer = new_file.writer();

    var it = std.mem.splitSequence(u8, file_data, "\n");

    while (it.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        _ = try new_file_writer.write("asdf" ** 42);
        _ = try new_file_writer.write(line);
        _ = try new_file_writer.write("asdf" ** 42);
        _ = try new_file_writer.write("\n");
        //     for (0..10) |_| {
        //        _ = try new_file_writer.write(line);
        //   }
        //  _ = try new_file_writer.write("\n");
    }
}
