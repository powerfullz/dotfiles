return {
  -- 让 markdownlint 读取全局配置（~/.config/markdownlint/markdownlint.jsonc）
  -- 否则中文文档会被 MD013 行宽规则刷满红线
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("~/.config/markdownlint/markdownlint.jsonc"), "-" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          args = {
            "--fix",
            "--config",
            vim.fn.expand("~/.config/markdownlint/markdownlint.jsonc"),
            "$FILENAME",
          },
        },
      },
    },
  },
}
