const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "tree-sitter",
        .target = target,
        .optimize = optimize,
    });

    const flags = [_][]const u8{
        "-std=c99",
    };

    lib.linkLibC();
    lib.addIncludePath(.{ .path = "tree-sitter/lib/include" });
    lib.addIncludePath(.{ .path = "tree-sitter/lib/src" });
    lib.addCSourceFiles(&.{
        "tree-sitter/lib/src/lib.c",
        "tree-sitter-agda/src/parser.c",
        "tree-sitter-bash/src/parser.c",
        "tree-sitter-c-sharp/src/parser.c",
        "tree-sitter-c/src/parser.c",
        "tree-sitter-cpp/src/parser.c",
        "tree-sitter-css/src/parser.c",
        "tree-sitter-haskell/src/parser.c",
        "tree-sitter-java/src/parser.c",
        "tree-sitter-javascript/src/parser.c",
        "tree-sitter-jsdoc/src/parser.c",
        "tree-sitter-json/src/parser.c",
        "tree-sitter-julia/src/parser.c",
        "tree-sitter-php/src/parser.c",
        "tree-sitter-python/src/parser.c",
        "tree-sitter-rust/src/parser.c",
        "tree-sitter-scala/src/parser.c",
        "tree-sitter-typescript/tsx/src/parser.c",
        "tree-sitter-typescript/typescript/src/parser.c",
        "tree-sitter-verilog/src/parser.c",
        "tree-sitter-zig/src/parser.c",
    }, &flags);

    b.installArtifact(lib);
    lib.installHeadersDirectory("tree-sitter/lib/include/tree_sitter", "tree_sitter");
}
