const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "tree-sitter",
        .target = target,
        .optimize = optimize,
    });

    const flags = [_][]const u8{};

    lib.linkLibC();
    lib.linkLibCpp();
    lib.addIncludePath(.{ .path = "tree-sitter/lib/include" });
    lib.addIncludePath(.{ .path = "tree-sitter/lib/src" });
    lib.addCSourceFiles(.{
        .files = &.{
            "tree-sitter/lib/src/lib.c",
            "tree-sitter-agda/src/parser.c",
            "tree-sitter-agda/src/scanner.c",
            "tree-sitter-bash/src/parser.c",
            "tree-sitter-bash/src/scanner.c",
            "tree-sitter-c-sharp/src/parser.c",
            "tree-sitter-c-sharp/src/scanner.c",
            "tree-sitter-c/src/parser.c",
            "tree-sitter-cpp/src/parser.c",
            "tree-sitter-cpp/src/scanner.c",
            "tree-sitter-css/src/parser.c",
            "tree-sitter-css/src/scanner.c",
            "tree-sitter-diff/src/parser.c",
            "tree-sitter-gitcommit/src/parser.c",
            "tree-sitter-gitcommit/src/scanner.c",
            "tree-sitter-git-rebase/src/parser.c",
            "tree-sitter-go/src/parser.c",
            "tree-sitter-haskell/src/parser.c",
            "tree-sitter-haskell/src/scanner.c",
            "tree-sitter-html/src/parser.c",
            "tree-sitter-html/src/scanner.c",
            "tree-sitter-java/src/parser.c",
            "tree-sitter-javascript/src/parser.c",
            "tree-sitter-javascript/src/scanner.c",
            "tree-sitter-jsdoc/src/parser.c",
            "tree-sitter-json/src/parser.c",
            "tree-sitter-julia/src/parser.c",
            "tree-sitter-julia/src/scanner.c",
            "tree-sitter-lua/src/parser.c",
            "tree-sitter-lua/src/scanner.c",
            "tree-sitter-make/src/parser.c",
            "tree-sitter-markdown/tree-sitter-markdown/src/parser.c",
            "tree-sitter-markdown/tree-sitter-markdown/src/scanner.c",
            "tree-sitter-markdown/tree-sitter-markdown-inline/src/parser.c",
            "tree-sitter-markdown/tree-sitter-markdown-inline/src/scanner.c",
            "tree-sitter-nasm/src/parser.c",
            "tree-sitter-ninja/src/parser.c",
            "tree-sitter-nix/src/parser.c",
            "tree-sitter-nix/src/scanner.c",
            "tree-sitter-ocaml/interface/src/parser.c",
            "tree-sitter-ocaml/interface/src/scanner.c",
            "tree-sitter-ocaml/ocaml/src/parser.c",
            "tree-sitter-ocaml/ocaml/src/scanner.c",
            "tree-sitter-php/php/src/parser.c",
            "tree-sitter-php/php/src/scanner.c",
            "tree-sitter-purescript/src/parser.c",
            "tree-sitter-purescript/src/scanner.c",
            "tree-sitter-python/src/parser.c",
            "tree-sitter-python/src/scanner.c",
            "tree-sitter-regex/src/parser.c",
            "tree-sitter-ruby/src/parser.c",
            "tree-sitter-ruby/src/scanner.cc",
            "tree-sitter-rust/src/parser.c",
            "tree-sitter-rust/src/scanner.c",
            "tree-sitter-scala/src/parser.c",
            "tree-sitter-scala/src/scanner.c",
            "tree-sitter-scheme/src/parser.c",
            "tree-sitter-ssh-config/src/parser.c",
            "tree-sitter-toml/src/parser.c",
            "tree-sitter-toml/src/scanner.c",
            "tree-sitter-tsq/src/parser.c",
            "tree-sitter-typescript/tsx/src/parser.c",
            "tree-sitter-typescript/tsx/src/scanner.c",
            "tree-sitter-typescript/typescript/src/parser.c",
            "tree-sitter-typescript/typescript/src/scanner.c",
            "tree-sitter-verilog/src/parser.c",
            "tree-sitter-zig/src/parser.c",
        },
        .flags = &flags,
    });
    b.installArtifact(lib);
    lib.installHeadersDirectory("tree-sitter/lib/include/tree_sitter", "tree_sitter");

    installQueries(b, "agda");
    installQueries(b, "bash");
    installQueries(b, "c-sharp");
    installQueries(b, "c");
    installQueries(b, "cpp");
    installQueries(b, "css");
    installQueries(b, "diff");
    installQueries(b, "gitcommit");
    installQueries(b, "git-rebase");
    installQueries(b, "go");
    installQueries(b, "haskell");
    installQueries(b, "html");
    installQueries(b, "java");
    installQueries(b, "javascript");
    installQueries(b, "jsdoc");
    installQueries(b, "json");
    installQueries(b, "lua");
    installQueries(b, "make");
    installQueriesBase(b, "markdown", "tree-sitter-markdown/tree-sitter-markdown");
    installQueriesBase(b, "markdown-inline", "tree-sitter-markdown/tree-sitter-markdown-inline");
    installQueries(b, "nasm");
    installQueries(b, "ninja");
    installQueries(b, "nix");
    installQueries(b, "ocaml");
    installQueries(b, "php");
    installQueries(b, "purescript");
    installQueries(b, "python");
    installQueries(b, "regex");
    installQueries(b, "ruby");
    installQueries(b, "rust");
    installQueries(b, "scala");
    installQueries(b, "scheme");
    installQueries(b, "ssh-config");
    installQueries(b, "toml");
    installQueries(b, "typescript");
    installQueries(b, "zig");
}

fn installQueries(b: *std.Build, comptime lang: []const u8) void {
    installQueriesBase(b, lang, "tree-sitter-" ++ lang);
}

fn installQueriesBase(b: *std.Build, comptime lang: []const u8, comptime base: []const u8) void {
    b.installDirectory(.{
        .source_dir = .{ .path = base ++ "/queries" },
        .include_extensions = &[_][]const u8{".scm"},
        .install_dir = .{ .custom = "queries" },
        .install_subdir = lang,
    });
}
