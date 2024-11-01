const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) !void {
    const file_name = b.option([]const u8, "file", "filename that you want to build and run- eg 1a") orelse "1a";

    var path_string = std.ArrayList(u8).init(b.allocator);
    try path_string.appendSlice("src/");
    try path_string.appendSlice(file_name);
    try path_string.appendSlice(".zig");

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "aoc2023",
        .root_source_file = b.path(path_string.items),
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