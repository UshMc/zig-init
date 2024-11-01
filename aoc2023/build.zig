const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) !void {
    const day_option = b.option(u8, "day", "day that should be ran - eg '1'") orelse 1;

    var day_string: [2]u8 = undefined;
    if (day_option < 10) {
        day_string[0] = '0';
        day_string[1] = day_option + '0';
    } else {
        _ = try std.fmt.bufPrint(&day_string, "{}", .{day_option});
    }

    const path_string = try std.fmt.allocPrint(b.allocator, "src/day{s}/main.zig", .{day_string});

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "aoc2023",
        .root_source_file = b.path(path_string),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
