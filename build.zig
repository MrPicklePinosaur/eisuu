const Builder = @import("std").build.Builder;

const c_args = [_][]const u8{
    "-Wall",
    "-std=c11",
};

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("eisuu", "src/main.zig");
    exe.linkSystemLibrary("c");
    exe.linkLibC();
    exe.addIncludeDir("./lib");
    exe.addIncludeDir("/usr/include/");
    // exe.addCSourceFile("./lib/eisuu_utils.c", &c_args);
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
