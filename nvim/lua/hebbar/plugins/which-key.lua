return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    wk.setup({})

    -- Register mappings
    -- wk.register({
    --   ["<leader>f"] = { name = "File" },
    --   ["<leader>b"] = { name = "Buffer" },
    --   ["<leader>c"] = { name = "Code" },
    --   ["<leader>g"] = { name = "Git" },
    --   ["<leader>t"] = { name = "Test" },
    -- })
  end,
}
