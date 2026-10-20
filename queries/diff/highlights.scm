; Forked from https://github.com/the-mikedavis/tree-sitter-diff
; Copyright (c) 2021 Michael Davis
; Licensed under the MIT license.
; Scopes follow the VS Code diff grammar (extensions/diff/syntaxes/diff.tmLanguage.json)

(comment) @comment

(addition) @diff.plus

(deletion) @diff.minus

(command) @meta.diff.header.git

(index) @meta.diff.index.git

(old_file) @meta.diff.header.from-file

(new_file) @meta.diff.header.to-file

(location) @meta.diff.range.unified

(location
  (linerange) @meta.toc-list.line-number.diff)

(location
  "@@" @punctuation.definition.range.diff)

(old_file
  "---" @punctuation.definition.from-file.diff)

(new_file
  "+++" @punctuation.definition.to-file.diff)

(addition
  [
    "+"
    "++"
    "+++"
    "++++"
  ] @punctuation.definition.inserted.diff)

(deletion
  [
    "-"
    "--"
    "---"
    "----"
  ] @punctuation.definition.deleted.diff)
