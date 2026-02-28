return {
  "lambdalisue/suda.vim",
  lazy = false,
  config = function()
    -- 让 suda 自动检测，当你保存一个没有写权限的文件时，它会自动触发 sudo
    vim.g.suda_smart_edit = 1
  end,
}
