(block
  parameter: (expr) @injection.language
  (contents) @injection.content)

((latex_env) @injection.content
  (#set! injection.language "latex"))
