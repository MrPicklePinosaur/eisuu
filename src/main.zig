const std = @import("std");
const c = @cImport({
    @cInclude("eisuu_utils.h");
    @cInclude("libpng16/png.h");
});

const Point = struct { x: i32, y: i32 };

pub fn main() !void {

    // allocator setup
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    std.debug.print("using libpng version: {s}n", .{c.PNG_LIBPNG_VER_STRING});

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    std.debug.print("filepath: {s}\n", .{args[1]});

    var file = try std.fs.cwd().openFile(args[1], .{ .read = true });
    defer file.close();

    // const buf = try file.reader().readAllAlloc(allocator, 1024);
    // defer allocator.free(buf);

    // var help_flag = false;
    // var output_dim = Point{ .x = 20, .y = 20 };
    // for (args) |arg| {
    //     std.debug.print("arg: {s}\n", .{arg});
    // }

    // c.readpng_init(file, 800, 600);

    const header = try file.reader().readBytesNoEof(8);

    // if (!c.png_check_sig(@ptrCast([*c]const u8, &header), 8)) {
    //     std.debug.print("invalid png header\n", .{});
    // }

    const valid_header = c.png_sig_cmp(@ptrCast([*c]const u8, &header), 0, 8);
    if (valid_header != 0) {
        std.debug.print("invalid png header\n", .{});
    }
}
