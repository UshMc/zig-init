const std = @import("std");

pub fn main() !void {
    const vs = std.simd.suggestVectorLength(u8);
    if (vs) |vector_length| {
        std.debug.print("Suggested vector length: {}\n", .{vector_length});
    } else {
        std.debug.print("No suggested vector length\n");
    }
    const res = try std.math.divCeil(u8, 17, 8);
    std.debug.print("res: {}\n", .{res});

    var line_vec: @Vector(8, u8) = @splat(0);
    const pred_vec: @Vector(8, bool) = .{ true, true, true, true, false, false, false, false };
    const null_vec: @Vector(8, u8) = .{ 0, 0, 0, 0, 0, 0, 0, 0 };
    const bosh_vec: @Vector(8, u8) = .{ 'b', 'o', 's', 'h', 1, 0, 0, 0 };

    line_vec = @select(u8, pred_vec, bosh_vec, null_vec);
    std.debug.print("Line vec: {}\n", .{line_vec});

    const b: @Vector(4, bool) = .{ true, false, true, false };
    std.debug.print("Last true type: {?}\n", .{@TypeOf(std.simd.lastTrue(b))});
}
