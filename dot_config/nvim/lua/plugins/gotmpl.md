# Go Template / chezmoi / Hugo 配置说明

这份说明对应同目录下的 `gotmpl.lua`，以及
`dot_config/nvim/after/queries/gotmpl/injections.scm`。
改 nvim 配置请改 chezmoi 源目录里的文件，再 `chezmoi apply ~/.config/nvim`。

## 这套配置做了什么

| 文件 | 作用 |
| --- | --- |
| `*.tmpl`（chezmoi） | 由 `chezmoi-template.nvim` 设成 `gotmpl`，并按部署目标注入 zsh/toml/kdl/ini/… |
| `layouts/**/*.{html,xml,json,txt}`（Hugo） | `vim.filetype.add` 设成 `gotmpl` |
| Hugo 的静态文本 | 由 `#inject-hugo-lang!` 按扩展名注入 html/xml/json |
| `{{ ... }}` 表达式 | 由 nvim-treesitter 的 `gotmpl` queries 高亮 |

需要这些 parser：

```vim
:TSInstall gotmpl zsh kdl ini css
```

`nvim-treesitter` main 分支安装 parser 需要 `tree-sitter` CLI（Arch 上是
`tree-sitter-cli`，不是 `tree-sitter` 库）。没有 CLI 时只能手动编译到
`~/.local/share/nvim/site/parser/`，并且要把 `runtime/queries/<lang>` 复制到
`~/.local/share/nvim/site/queries/`。

## 两个容易踩的坑

1. **`vim.filetype.add` 的 pattern 不要再写结尾 `$`**。API 会自动包成
   `^...$`，再写一个 `$` 会要求文件名真的以 `$` 结尾，导致匹配不到。

2. **gopls 不要 attach 到 `gotmpl`**。gopls 会在模板文件上返回覆盖整段文件的
   `textDocument/documentHighlight` 范围，LazyVim 默认启用的 `Snacks.words`
   会用 `LspReferenceText` 把这些范围画成背景块，看起来就是每行文字后面
   多了一层阴影。chezmoi/Hugo 模板也没有 Go module，gopls 帮不上忙。
   所以 `gotmpl.lua` 里把 gopls 的 filetypes 改成了 `go/gomod/gowork`。

   如果你确实需要在 Go 项目里用 gopls 的模板功能：
   - 删掉 `gotmpl.lua` 里 `filetypes` 的覆盖；
   - 加 `settings.gopls.templateExtensions = { "tmpl", "gotmpl" }`；
   - 如果阴影回来，单独对 `gotmpl` 关掉 Snacks.words：
     ```lua
     { "snacks.nvim", opts = { words = { filter = function(buf)
         return vim.bo[buf].filetype ~= "gotmpl"
       end } } }
     ```

## chezmoi 插件

`dpezto/chezmoi-template.nvim`，`apply.on_save = false`（保存不会自动
`chezmoi apply`）。确认工作流后可以在 `gotmpl.lua` 里改成 `true`。

常用：

- `:Chezmoi preview` — 实时预览渲染结果
- `:Chezmoi diff` — 和已部署文件对比
- `:checkhealth chezmoi-template`
- `:Inspect` / `:InspectTree` — 排查高亮和注入

## 更新插件后的 lock 文件

`lazy-lock.json` 由 Lazy 更新后，执行：

```bash
chezmoi re-add ~/.config/nvim/lazy-lock.json
```

否则下次 `chezmoi apply` 会把 lock 回退成旧版本。
