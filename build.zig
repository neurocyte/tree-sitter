const std = @import("std");

const flags = [_][]const u8{
    "-fno-sanitize=undefined",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const opts: std.Build.Module.CreateOptions = .{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    };

    const lib = b.addLibrary(.{
        .name = "tree-sitter",
        .linkage = .static,
        .root_module = b.createModule(opts),
    });

    lib.root_module.link_libc = true;
    lib.root_module.link_libcpp = true;
    lib.root_module.addIncludePath(b.path("tree-sitter/lib/include"));
    lib.root_module.addIncludePath(b.path("tree-sitter/lib/src"));
    lib.root_module.addCSourceFiles(.{ .files = &.{"tree-sitter/lib/src/lib.c"}, .flags = &flags });

    const language_list = .{
        .{ "agda", null },
        .{ "asciidoc", "tree-sitter-asciidoc" },
        .{ "asciidoc", "tree-sitter-asciidoc_inline" },
        .{ "asm", null },
        .{ "astro", null },
        .{ "awk", null },
        .{ "bash", null },
        .{ "bibtex", null },
        .{ "cmake", null },
        .{ "c", null },
        .{ "c3", null},
        .{ "capnp", null },
        .{ "comment", null },
        .{ "commonlisp", null },
        .{ "cpp", null },
        .{ "c-sharp", null },
        .{ "css", null },
        .{ "diff", null },
        .{ "d", null },
        .{ "devicetree", null },
        .{ "dockerfile", null },
        .{ "dot", null },
        .{ "elixir", null },
        .{ "elm", null },
        .{ "fish", null },
        .{ "fortran", null },
        .{ "fsharp", "fsharp" },
        .{ "fsharp", "fsharp_signature" },
        .{ "gdscript", null },
        .{ "gdshader", null },
        .{ "gitcommit", null },
        .{ "git-rebase", null },
        .{ "gleam", null },
        .{ "go", null },
        .{ "godot-resource", null },
        .{ "hare", null },
        .{ "haskell", null },
        .{ "hcl", null },
        .{ "heex", null },
        .{ "html", null },
        .{ "hurl", null },
        .{ "idris", null },
        .{ "ink", null },
        .{ "java", null },
        .{ "javascript", null },
        .{ "jsdoc", null },
        .{ "json", null },
        .{ "julia", null },
        .{ "just", null },
        .{ "kdl", null },
        .{ "kotlin", null },
        .{ "latex", null },
        .{ "llvm", null },
        .{ "lua", null },
        .{ "mail", null },
        .{ "make", null },
        .{ "markdown", "tree-sitter-markdown" },
        .{ "markdown", "tree-sitter-markdown-inline" },
        .{ "mojo", null },
        .{ "nasm", null },
        .{ "nickel", null },
        .{ "nim", null },
        .{ "ninja", null },
        .{ "nix", null },
        .{ "nu", null },
        .{ "objc", null },
        .{ "ocaml", "grammars/interface" },
        .{ "ocaml", "grammars/ocaml" },
        .{ "ocaml", "grammars/type" },
        .{ "odin", null },
        .{ "openscad", null },
        .{ "org", null },
        .{ "pascal", null },
        .{ "perl", null },
        .{ "php", "php" },
        .{ "po", null },
        .{ "powershell", null },
        .{ "prolog", "tree-sitter-prolog" },
        .{ "proto", null },
        .{ "purescript", null },
        .{ "python", null },
        .{ "query", null },
        .{ "regex", null },
        .{ "roc", null },
        .{ "rpmspec", "rpmbash" },
        .{ "rpmspec", "rpmspec" },
        .{ "rst", null },
        .{ "ruby", null },
        .{ "rust", null },
        .{ "scala", null },
        .{ "scheme", null },
        .{ "scss", null },
        .{ "sql", null },
        .{ "ssh-config", null },
        .{ "superhtml", "tree-sitter-superhtml" },
        .{ "supermd", "tree-sitter/supermd" },
        .{ "supermd", "tree-sitter/supermd-inline" },
        .{ "svelte", null },
        .{ "swift", null },
        .{ "systemverilog", null },
        .{ "thrift", null },
        .{ "toml", null },
        .{ "typescript", "tsx" },
        .{ "typescript", "typescript" },
        .{ "typst", null },
        .{ "unison", null },
        .{ "uxntal", null },
        .{ "v", "tree_sitter_v" },
        .{ "vim", null },
        .{ "vue", null },
        .{ "wat", null },
        .{ "wgsl", null },
        .{ "wikitext", null },
        .{ "xml", "dtd" },
        .{ "xml", "xml" },
        .{ "yaml", null },
        .{ "ziggy", "tree-sitter-ziggy" },
        .{ "ziggy", "tree-sitter-ziggy-schema" },
        .{ "zig", null },
    };
    inline for (language_list) |list| {
        addParser(b, lib, list[0], list[1], opts);
    }

    b.installArtifact(lib);
    lib.installHeadersDirectory(b.path("tree-sitter/lib/include/tree_sitter"), "tree_sitter", .{});

    const mod = b.addModule("treez", .{
        .root_source_file = b.path("treez/treez.zig"),
    });
    mod.linkLibrary(lib);
}

fn addParser(b: *std.Build, lib: *std.Build.Step.Compile, comptime lang: []const u8, comptime subdir: ?[]const u8, opts: std.Build.Module.CreateOptions) void {
    const basedir = "tree-sitter-" ++ lang;
    const srcdir = if (subdir) |sub| basedir ++ "/" ++ sub ++ "/src" else basedir ++ "/src";
    const qrydir = find_query_dir(b, lang, subdir);
    const parser = srcdir ++ "/parser.c";
    const scanner = srcdir ++ "/scanner.c";
    const scanner_cc = srcdir ++ "/scanner.cc";

    {
        const obj = b.addObject(.{
            .name = basedir ++ "-parser",
            .root_module = b.createModule(opts),
        });
        obj.root_module.addCSourceFiles(.{ .files = &.{parser}, .flags = &flags });
        obj.root_module.addIncludePath(b.path(srcdir));
        lib.root_module.addObject(obj);
    }

    if (exists(b, scanner)) {
        const obj = b.addObject(.{
            .name = basedir ++ "-scanner",
            .root_module = b.createModule(opts),
        });
        const scanner_flags = if (comptime std.mem.eql(u8, lang, "just"))
            flags ++ [_][]const u8{"-UNDEBUG"}
        else
            flags;
        obj.root_module.addCSourceFiles(.{ .files = &.{scanner}, .flags = &scanner_flags });
        obj.root_module.addIncludePath(b.path(srcdir));
        lib.root_module.addObject(obj);
    }

    if (exists(b, scanner_cc)) {
        const obj = b.addObject(.{
            .name = basedir ++ "-scanner-cc",
            .root_module = b.createModule(opts),
        });
        obj.root_module.addCSourceFiles(.{ .files = &.{scanner_cc}, .flags = &flags });
        obj.root_module.addIncludePath(b.path(srcdir));
        lib.root_module.addObject(obj);
    }

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
    b.root.access(b.graph.io, path, .{ .read = true }) catch return false;
    return true;
}

fn find_query_dir(b: *std.Build, comptime lang: []const u8, comptime subdir: ?[]const u8) []const u8 {
    const basedir = "tree-sitter-" ++ lang;

    const qrydir: ?[]const u8 = if (exists(b, "queries/" ++ lang))
        "queries/" ++ lang
    else if (subdir) |sub| if (exists(b, basedir ++ "/" ++ sub ++ "/queries"))
        basedir ++ "/" ++ sub ++ "/queries"
    else
        null else null;

    return qrydir orelse basedir ++ "/queries";
}
