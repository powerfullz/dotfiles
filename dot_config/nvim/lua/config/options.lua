-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LazyVim 默认 spelllang 只有 en：Markdown 里每个中文词都会被当成拼写错误标红。
-- 加上 cjk 后中文不再做拼写检查，英文单词照样检查。
vim.opt.spelllang = { "en", "cjk" }
