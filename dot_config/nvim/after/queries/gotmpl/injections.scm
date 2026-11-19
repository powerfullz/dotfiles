;; extends

; Hugo 的 layouts/** 文件：text 节点按文件扩展名注入 html / xml / json
; 具体语言由 lua/plugins/gotmpl.lua 里的 #inject-hugo-lang! directive 决定
((text) @injection.content
  (#inject-hugo-lang! @injection.content))
