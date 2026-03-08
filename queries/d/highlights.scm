; highlights.scm
;
; Highlighting queries for D code for use by Tree-Sitter.
;
; Copyright 2024 Garrett D'Amore
;
; Distributed under the MIT License.
; (See accompanying file LICENSE.txt or https://opensource.org/licenses/MIT)
; SPDX-License-Identifier: MIT

(string_literal) @string
(int_literal) @number
(float_literal) @number
(char_literal) @number
((identifier) @variable)
(declarator (identifier) @variable)
(auto_declaration (identifier) @variable *)
(at_attribute) @property

[
    (lazy)
    (align)
    (extern)
    (static)
    (abstract)
    (final)
    (override)
    (synchronized)
    (auto)
    (scope)
    (gshared)
    (ref)
    (deprecated)
    (nothrow)
    (pure)
    (type_ctor)
] @keyword.storage

(parameter_attribute (return) @keyword.storage)
(parameter_attribute (in) @keyword.storage)
(parameter_attribute (out) @keyword.storage)


(template_instance (identifier) @function)

(function_declaration (identifier) @function)

(struct_declaration ((identifier) @type))
(class_declaration ((identifier) @type))
(enum_declaration ((identifier) @type))

(template_parameter (identifier) @type)
(template_parameter (type (identifier)) @variable)


(arguments (expression (property_expression (identifier)) @variable) )

(type (template_instance (identifier)) @type)
(function_declaration (type (identifier)) @type)
(parameter (type (identifier) @type))
(variable_declaration (type (identifier) @type))

(call_expression
  (type
    (identifier) @function .))

[
    (abstract)
    (alias)
    (align)
    (asm)
    (assert)
    (auto)
    (cast)
    (class)
    (const)
    (debug)
    (delegate)
    (delete)
    (deprecated)
    (enum)
    (export)
    (extern)
    (final)
    (function)
    (immutable)
    (import)
    (in)
    (inout)
    (interface)
    (invariant)
    (is)
    (lazy)
    ; "macro" - obsolete
    (mixin)
    (module)
    (new)
    (nothrow)
    (out)
    (override)
    (package)
    (pragma)
    (private)
    (protected)
    (public)
    (pure)
    (ref)
    (scope)
    (shared)
    (static)
    (struct)
    (super)
    (synchronized)
    (template)
    (this)
    (throw)
    (typeid)
    (typeof)
    (union)
    (unittest)
    (version)
    (with)
    (gshared)
    (traits)
    (vector)
    (parameters_)
] @keyword

[
    (break)
    (case)
    (catch)
    (continue)
    (do)
    (default)
    (finally)
    (else)
    (for)
    (foreach)
    (foreach_reverse)
    (goto)
    (if)
    (switch)
    (try)
    (return)
    (while)
] @keyword.control

[
    (not_in)
    (not_is)
    "/="
    "/"
    ".."
    "..."
    "&"
    "&="
    "&&"
    "|"
    "|="
    "||"
    "-"
    "-="
    "--"
    "+"
    "+="
    "++"
    "<"
    "<="
    "<<"
    "<<="
    ">"
    ">="
    ">>="
    ">>>="
    ">>"
    ">>>"
    "!"
    "!="
    "?"
    "$"
    "="
    "=="
    "*"
    "*="
    "%"
    "%="
    "^"
    "^="
    "^^"
    "^^="
    "~"
    "~="
    "@"
    "=>"
] @operator

[
    ";"
    "."
    ":"
    ","
] @punctuation.delimiter

[
    "("
    ")"
    "["
    "["
    "{"
    "}"
] @punctuation.bracket

[
    (null)
    (true)
    (false)
] @constant.language

(special_keyword) @constant.language

(directive) @keyword.directive
(shebang) @keyword.directive

(comment) @comment

[
    (void)
    (bool)
    (byte)
    (ubyte)
    (char)
    (short)
    (ushort)
    (wchar)
    (dchar)
    (int)
    (uint)
    (long)
    (ulong)
    (real)
    (double)
    (float)
    (size_t)
    (ptrdiff_t)
    (string)
    (cstring)
    (dstring)
    (wstring)
    (noreturn)
] @type.builtin

[
    (cent)
    (ucent)
    (ireal)
    (idouble)
    (ifloat)
    (creal)
    (double)
    (cfloat)
] @type.deprecated

(label (identifier) @label)
(goto_statement (goto) @keyword.control (identifier) @label)




; these are listed last, because they override keyword queries
(identity_expression (in) @operator)
(identity_expression (is) @operator)
((htmlentity) @string.special)
((escape_sequence) @string.escape)

; everything after __EOF_ is plain text
(end_file) @text
