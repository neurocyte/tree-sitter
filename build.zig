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

    const language_list = .{
        .{ "agda", null },
        .{ "astro", null },
        .{ "bash", null },
        .{ "c-sharp", null },
        .{ "c", null },
        .{ "cmake", null },
        .{ "cpp", null },
        .{ "css", null },
        .{ "diff", null },
        .{ "dockerfile", null },
        .{ "elixir", null },
        .{ "fish", null },
        .{ "odin", null },
        .{ "gitcommit", null },
        .{ "git-rebase", null },
        .{ "gleam", null },
        .{ "go", null },
        .{ "hare", null },
        .{ "haskell", null },
        .{ "html", null },
        .{ "java", null },
        .{ "javascript", null },
        .{ "jsdoc", null },
        .{ "json", null },
        .{ "julia", null },
        .{ "kdl", null },
        .{ "lua", null },
        .{ "mail", null },
        .{ "make", null },
        .{ "markdown", "tree-sitter-markdown" },
        .{ "markdown", "tree-sitter-markdown-inline" },
        .{ "nasm", null },
        .{ "nim", null },
        .{ "ninja", null },
        .{ "nix", null },
        .{ "nu", null },
        .{ "ocaml", "grammars/interface" },
        .{ "ocaml", "grammars/ocaml" },
        .{ "ocaml", "grammars/type" },
        .{ "openscad", null },
        .{ "org", null },
        .{ "php", "php" },
        .{ "proto", null },
        .{ "purescript", null },
        .{ "python", null },
        .{ "regex", null },
        .{ "rpmspec", null },
        .{ "ruby", null },
        .{ "rust", null },
        .{ "scala", null },
        .{ "scheme", null },
        .{ "sql", null },
        .{ "ssh-config", null },
        .{ "superhtml", "tree-sitter-superhtml" },
        .{ "swift", null },
        .{ "toml", null },
        .{ "tsq", null },
        .{ "typescript", "tsx" },
        .{ "typescript", "typescript" },
        .{ "typst", null },
        .{ "uxntal", null },
        .{ "systemverilog", null },
        .{ "vim", null },
        .{ "xml", "dtd" },
        .{ "xml", "xml" },
        .{ "yaml", null },
        .{ "zig", null },
        .{ "ziggy", "tree-sitter-ziggy" },
        .{ "ziggy", "tree-sitter-ziggy-schema" },
    };
    inline for (language_list) |list| {
        addParser(b, lib, list[0], list[1]);
    }

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
    const qrydir = find_query_dir(b, lang, subdir);
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

fn find_query_dir(b: *std.Build, comptime lang: []const u8, comptime subdir: ?[]const u8) []const u8 {
    const basedir = "tree-sitter-" ++ lang;

    var qrydir: ?[]const u8 = if (subdir) |sub| if (exists(b, basedir ++ "/" ++ sub ++ "/queries"))
        basedir ++ "/" ++ sub ++ "/queries"
    else
        null else null;

    if (qrydir == null and exists(b, "queries/" ++ lang))
        qrydir = "queries/" ++ lang;

    return qrydir orelse basedir ++ "/queries";
}
