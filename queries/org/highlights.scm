(timestamp "<") @constant.numeric
(timestamp "[") @comment

(headline (item) @markup.heading)
(headline (stars) @punctuation.definition.tag)

(item . (expr) @keyword
  (#any-of? @keyword
    "NEXTUP" "TODO" "DOING" "IN-REVIEW"
    "PAUSE" "CHAT" "EMAIL" "MEETING" "GEEK"))

(item . (expr) @comment
  (#any-of? @comment
    "DONE" "DROPPED" "CHILLING"))

(item priority: (priority) @constant.numeric)

(bullet) @markup.list
(checkbox) @constant
(checkbox status: (expr "-") @constant)
(checkbox status: (expr "str") @constant
  (#any-of? @constant "x" "X"))

(block "#+begin_" @keyword "#+end_" @keyword)
(inline_code_block open: (open) @keyword close: (close) @keyword)
(block name: (expr) @keyword)
(block end_name: (expr) @keyword)
(block parameter: (expr) @string)
(dynamic_block name: (expr) @keyword)
(dynamic_block end_name: (expr) @keyword)
(dynamic_block parameter: (expr) @string)

(property_drawer (property name: (expr) @property)) @comment
(latex_env) @markup.raw
(inline_math_block) @markup.raw
(display_math_block) @markup.raw
(drawer) @property
(tag_list) @entity.name.label

(directive name: (expr) @keyword value: (value) @string) @keyword
(plan) @comment
(comment) @comment

(row "|" @comment)
(cell "|" @comment)
(table . (row (cell (contents) @markup.heading)))
(table (hr) @comment)

(fndef label: (expr) @entity.name.label (description) @string) @markup.link
(fnref) @markup.link

(link url: (expr) @string) @markup.link
(link_desc url: (expr) @string desc: (expr) @string) @markup.link
