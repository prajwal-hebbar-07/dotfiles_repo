return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- Prevent automatic setup, we will do it manually
      vim.g.skip_ts_context_commentstring_module = true

      -- Set up ts_context_commentstring first
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
        -- Optional configuration for specific languages
        languages = {
          typescript = '// %s',
          css = '/* %s */',
          scss = '/* %s */',
          html = '<!-- %s -->',
          svelte = '<!-- %s -->',
          vue = '<!-- %s -->',
          jsonc = '// %s',
        },
      }

      require("Comment").setup({
        -- Disable default mappings
        mappings = {
          basic = false,
          extra = false,
        },
        
        -- Use the ts_context_commentstring pre_hook
        pre_hook = function(ctx)
          -- Only calculate commentstring for tsx/jsx files
          if vim.bo.filetype == 'typescriptreact' or vim.bo.filetype == 'javascriptreact' then
            local U = require('Comment.utils')
            
            -- Determine whether to use line or block comment
            local type = ctx.ctype == U.ctype.linewise and '__default' or '__multiline'
            
            -- Get the commentstring
            local location = nil
            if ctx.ctype == U.ctype.blockwise then
              location = require('ts_context_commentstring.utils').get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
              location = require('ts_context_commentstring.utils').get_visual_start_location()
            end

            return require('ts_context_commentstring.internal').calculate_commentstring({
              key = type,
              location = location,
            })
          end
        end,
      })

      -- Keymaps
      local api = require('Comment.api')
      
      -- Line commenting
      vim.keymap.set("n", "<leader>/", api.toggle.linewise.current, 
        { desc = "Toggle comment" })
      vim.keymap.set("v", "<leader>/",
        '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
        { desc = "Toggle comment on selection" })

      -- Block commenting
      vim.keymap.set("n", "<leader>bc", api.toggle.blockwise.current,
        { desc = "Toggle block comment" })
      vim.keymap.set("v", "<leader>bc",
        '<ESC><cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<CR>',
        { desc = "Toggle block comment on selection" })
    end,
  }
}