const std = @import("std");

const flags = [_][]const u8{};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "tree-sitter",
        .target = target,
        .optimize = optimize,
    });

    lib.linkLibC();
    lib.linkLibCpp();
    lib.addIncludePath(.{ .path = "tree-sitter/lib/include" });
    lib.addIncludePath(.{ .path = "tree-sitter/lib/src" });
    lib.addCSourceFiles(.{ .files = &.{"tree-sitter/lib/src/lib.c"}, .flags = &flags });

    addParser(b, lib, "agda", null);
    addParser(b, lib, "bash", null);
    addParser(b, lib, "c-sharp", null);
    addParser(b, lib, "c", null);
    addParser(b, lib, "cpp", null);
    addParser(b, lib, "css", null);
    addParser(b, lib, "diff", null);
    addParser(b, lib, "dockerfile", null);
    addParser(b, lib, "fish", null);
    addParser(b, lib, "gitcommit", null);
    addParser(b, lib, "git-rebase", null);
    addParser(b, lib, "go", null);
    addParser(b, lib, "haskell", null);
    addParser(b, lib, "html", null);
    addParser(b, lib, "java", null);
    addParser(b, lib, "javascript", null);
    addParser(b, lib, "jsdoc", null);
    addParser(b, lib, "json", null);
    addParser(b, lib, "julia", null);
    addParser(b, lib, "lua", null);
    addParser(b, lib, "make", null);
    addParser(b, lib, "markdown", "tree-sitter-markdown");
    addParser(b, lib, "markdown", "tree-sitter-markdown-inline");
    addParser(b, lib, "nasm", null);
    addParser(b, lib, "ninja", null);
    addParser(b, lib, "nix", null);
    addParser(b, lib, "ocaml", "interface");
    addParser(b, lib, "ocaml", "ocaml");
    addParser(b, lib, "openscad", null);
    addParser(b, lib, "org", null);
    addParser(b, lib, "php", "php");
    addParser(b, lib, "purescript", null);
    addParser(b, lib, "python", null);
    addParser(b, lib, "regex", null);
    addParser(b, lib, "ruby", null);
    addParser(b, lib, "rust", null);
    addParser(b, lib, "scala", null);
    addParser(b, lib, "scheme", null);
    addParser(b, lib, "ssh-config", null);
    addParser(b, lib, "toml", null);
    addParser(b, lib, "tsq", null);
    addParser(b, lib, "typescript", "tsx");
    addParser(b, lib, "typescript", "typescript");
    addParser(b, lib, "verilog", null);
    addParser(b, lib, "xml", "dtd");
    addParser(b, lib, "xml", "xml");
    addParser(b, lib, "zig", null);
    addParser(b, lib, "ziggy", "tree-sitter-ziggy");
    b.installArtifact(lib);
    lib.installHeadersDirectory("tree-sitter/lib/include/tree_sitter", "tree_sitter");

    const mod = b.addModule("treez", .{
        .root_source_file = .{ .path = "treez/treez.zig" },
    });
    mod.linkLibrary(lib);
}

fn addParser(b: *std.Build, lib: *std.Build.Step.Compile, comptime lang: []const u8, comptime subdir: ?[]const u8) void {
    const basedir = "tree-sitter-" ++ lang;
    const srcdir = if (subdir) |sub| basedir ++ "/" ++ sub ++ "/src" else basedir ++ "/src";
    const qrypath = if (subdir) |sub| if (exists(basedir ++ "/" ++ sub ++ "/queries")) basedir ++ "/" ++ sub ++ "/queries" else basedir ++ "/queries" else basedir ++ "/queries";
    const qrydir = b.pathFromRoot(qrypath);
    const parser = b.pathFromRoot(srcdir ++ "/parser.c");
    const scanner = b.pathFromRoot(srcdir ++ "/scanner.c");
    const scanner_cc = b.pathFromRoot(srcdir ++ "/scanner.cc");

    if (exists(parser))
        lib.addCSourceFiles(.{ .files = &.{parser}, .flags = &flags });
    if (exists(scanner_cc))
        lib.addCSourceFiles(.{ .files = &.{scanner_cc}, .flags = &flags });
    if (exists(scanner))
        lib.addCSourceFiles(.{ .files = &.{scanner}, .flags = &flags });
    lib.addIncludePath(.{ .path = b.pathFromRoot(srcdir) });

    if (exists(qrydir)) {
        b.installDirectory(.{
            .source_dir = .{ .path = qrydir },
            .include_extensions = &[_][]const u8{".scm"},
            .install_dir = .{ .custom = "queries" },
            .install_subdir = lang,
        });
    }
}

fn exists(path: []const u8) bool {
    std.fs.cwd().access(path, .{ .mode = .read_only }) catch return false;
    return true;
}
