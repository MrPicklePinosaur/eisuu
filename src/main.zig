const std = @import("std");
const c = @cImport({
    @cInclude("eisuu_utils.h");
});

const Point = struct { x: i32, y: i32 };

pub fn main() !void {

    // allocator setup
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const sum = c.sum(1, 2);
    std.debug.print("c sum function: {}\n", .{sum});

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    std.debug.print("filepath: {s}\n", .{args[1]});

    var file = try std.fs.cwd().openFile(args[1], .{ .read = true });
    defer file.close();

    const buf = try file.reader().readAllAlloc(allocator, 1024);
    defer allocator.free(buf);

    // var help_flag = false;
    // var output_dim = Point{ .x = 20, .y = 20 };
    // for (args) |arg| {
    //     std.debug.print("arg: {s}\n", .{arg});
    // }
}
