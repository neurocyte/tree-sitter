const std = @import("std");

const flags = [_][]const u8{
    "-fno-sanitize=undefined",
};

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
    lib.addIncludePath(b.path("tree-sitter/lib/include"));
    lib.addIncludePath(b.path("tree-sitter/lib/src"));
    lib.addCSourceFiles(.{ .files = &.{"tree-sitter/lib/src/lib.c"}, .flags = &flags });

    addParser(b, lib, "agda", null);
    addParser(b, lib, "bash", null);
    addParser(b, lib, "c-sharp", null);
    addParser(b, lib, "c", null);
    addParser(b, lib, "cpp", null);
    addParser(b, lib, "css", null);
    addParser(b, lib, "diff", null);
    addParser(b, lib, "dockerfile", null);
    addParser(b, lib, "elixir", null);
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
    addParser(b, lib, "kdl", null);
    addParser(b, lib, "lua", null);
    addParser(b, lib, "make", null);
    addParser(b, lib, "markdown", "tree-sitter-markdown");
    addParser(b, lib, "markdown", "tree-sitter-markdown-inline");
    addParser(b, lib, "nasm", null);
    addParser(b, lib, "nim", null);
    addParser(b, lib, "ninja", null);
    addParser(b, lib, "nix", null);
    addParser(b, lib, "nu", null);
    addParser(b, lib, "ocaml", "grammars/interface");
    addParser(b, lib, "ocaml", "grammars/ocaml");
    addParser(b, lib, "ocaml", "grammars/type");
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
    addParser(b, lib, "superhtml", "tree-sitter-superhtml");
    addParser(b, lib, "toml", null);
    addParser(b, lib, "tsq", null);
    addParser(b, lib, "typescript", "tsx");
    addParser(b, lib, "typescript", "typescript");
    addParser(b, lib, "typst", null);
    addParser(b, lib, "verilog", null);
    addParser(b, lib, "vim", null);
    addParser(b, lib, "xml", "dtd");
    addParser(b, lib, "xml", "xml");
    addParser(b, lib, "yaml", null);
    addParser(b, lib, "zig", null);
    addParser(b, lib, "ziggy", "tree-sitter-ziggy");
    addParser(b, lib, "ziggy", "tree-sitter-ziggy-schema");
    b.installArtifact(lib);
    lib.installHeadersDirectory(b.path("tree-sitter/lib/include/tree_sitter"), "tree_sitter", .{});

    const mod = b.addModule("treez", .{
        .root_source_file = b.path("treez/treez.zig"),
    });
    mod.linkLibrary(lib);
}

fn addParser(b: *std.Build, lib: *std.Build.Step.Compile, comptime lang: []const u8, comptime subdir: ?[]const u8) void {
    const basedir = "tree-sitter-" ++ lang;
    const srcdir = if (subdir) |sub| basedir ++ "/" ++ sub ++ "/src" else basedir ++ "/src";
    const qrydir = if (subdir) |sub| if (exists(b, basedir ++ "/" ++ sub ++ "/queries")) basedir ++ "/" ++ sub ++ "/queries" else basedir ++ "/queries" else basedir ++ "/queries";
    const parser = srcdir ++ "/parser.c";
    const scanner = srcdir ++ "/scanner.c";
    const scanner_cc = srcdir ++ "/scanner.cc";

    lib.addCSourceFiles(.{ .files = &.{parser}, .flags = &flags });
    if (exists(b, scanner_cc))
        lib.addCSourceFiles(.{ .files = &.{scanner_cc}, .flags = &flags });
    if (exists(b, scanner))
        lib.addCSourceFiles(.{ .files = &.{scanner}, .flags = &flags });
    lib.addIncludePath(b.path(srcdir));

    if (exists(b, qrydir)) {
        b.installDirectory(.{
            .source_dir = b.path(qrydir),
            .include_extensions = &[_][]const u8{".scm"},
            .install_dir = .{ .custom = "queries" },
            .install_subdir = lang,
        });
    }
}

fn exists(b: *std.Build, path: []const u8) bool {
    std.fs.cwd().access(b.pathFromRoot(path), .{ .mode = .read_only }) catch return false;
    return true;
}
