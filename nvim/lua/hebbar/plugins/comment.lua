return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- Skip ts_context_commentstring module automatic setup as we will do it ourselves
      vim.g.skip_ts_context_commentstring_module = true

      require("Comment").setup({
        -- Disable default mappings to use our custom ones
        mappings = {
          basic = false,
          extra = false,
        },
        
        -- Use treesitter for context-aware commenting (especially for JSX/TSX)
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })

      -- Line commenting
      vim.keymap.set("n", "<leader>/", function()
        require("Comment.api").toggle.linewise.current()
      end, { desc = "Toggle comment" })

      vim.keymap.set(
        "v",
        "<leader>/",
        '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
        { desc = "Toggle comment on selection" }
      )

      -- Block commenting
      vim.keymap.set("n", "<leader>bc", function()
        require("Comment.api").toggle.blockwise.current()
      end, { desc = "Toggle block comment" })

      vim.keymap.set(
        "v",
        "<leader>bc",
        '<ESC><cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<CR>',
        { desc = "Toggle block comment on selection" }
      )
    end,
  }
}