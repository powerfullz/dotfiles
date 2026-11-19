-- Go template 支持：chezmoi + Hugo
--
-- Hugo：layouts/** 下的 .html/.xml/.json/.txt 都是 Go 模板。
-- 注意：vim.filetype.add 的 pattern 会自动加 ^...$，这里不能再写结尾的 $，
-- 否则会变成要求文件名真的以 "$" 结尾，匹配不到。
vim.filetype.add({
  pattern = {
    [".*/layouts/.*%.html"] = "gotmpl",
    [".*/layouts/.*%.xml"] = "gotmpl",
    [".*/layouts/.*%.json"] = "gotmpl",
    [".*/layouts/.*%.txt"] = "gotmpl",
  },
})

-- Hugo 的 text 节点要按扩展名注入成 html / xml / json。
-- 不能靠 chezmoi-template.nvim 的自动回退：它按文件名推断，但 layouts 下的
-- .html 已经被上面的 pattern 改成了 gotmpl，回退会推断成 gotmpl 自己。
-- 必须在任何 gotmpl tree 解析之前注册 directive，所以放在插件 spec 顶层。
vim.treesitter.query.add_directive("inject-hugo-lang!", function(_, _, source, _, metadata)
  local bufnr = type(source) == "number" and source or vim.api.nvim_get_current_buf()
  local name = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
  if not name:match("/layouts/") then
    return
  end
  local lang = ({ html = "html", xml = "xml", json = "json" })[name:match("%.([%w]+)$") or ""]
  if lang and pcall(vim.treesitter.language.add, lang) then
    metadata["injection.language"] = lang
    metadata["injection.combined"] = true
  end
end, { force = true })

return {
  -- gotmpl parser，以及 chezmoi 目标语言会用到的 parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "gotmpl", "zsh", "kdl", "ini", "css" },
    },
  },

  -- chezmoi：*.tmpl -> gotmpl，并把底层语言（zsh/toml/kdl/...）注入进来
  {
    "dpezto/chezmoi-template.nvim",
    lazy = false, -- 必须：filetype 检测要在启动时注册
    opts = {
      -- 默认保存即 chezmoi apply；先关掉，确认工作流后再打开
      apply = { on_save = false },
      -- Hugo 的 layouts/** 由上面的 #inject-hugo-lang! 处理，这里不要重复注入
      inject = { exclude = { ".*/layouts/.*" } },
      -- 可选：写死源目录，省一次 `chezmoi source-path`
      -- source_dir = vim.fn.expand("~/.local/share/chezmoi"),
    },
  },

  -- 模板表达式补全：.chezmoi.xxx / sprig / chezmoi 函数 / if-range 片段
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- LazyVim 的 opts_extend 会把这个列表追加到默认源后面
        default = { "chezmoi" },
        providers = {
          chezmoi = { name = "chezmoi", module = "chezmoi-template.blink", score_offset = 100 },
        },
      },
      completion = {
        accept = {
          auto_brackets = {
            blocked_filetypes = { "gotmpl" },
          },
        },
      },
    },
  },

  -- chezmoi/Hugo 模板不在 Go module 里，gopls 帮不上忙。
  -- 而且 gopls 在 gotmpl 上会返回覆盖整段文件的 documentHighlight，
  -- LazyVim 默认启用的 Snacks.words 会用 LspReferenceText 把范围画成背景块，
  -- 看起来就是每行文字后面一层阴影。所以不让 gopls attach 到 gotmpl。
  -- 如果你也在 Go 项目里写模板并想要 gopls 的模板支持，删掉这段，并在
  -- gopls.settings.gopls 里加 templateExtensions = { "tmpl", "gotmpl" }。
  {
    "neovim/nvim-lspconfig",
    opts = { servers = { gopls = { filetypes = { "go", "gomod", "gowork" } } } },
  },
}
