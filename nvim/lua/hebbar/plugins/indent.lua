return {
  {
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Enhanced sleuth configuration
      vim.g.sleuth_automatic = 1
      vim.g.sleuth_neighbor_limit = 5

      -- File type specific indentation
      local indent_configs = {
        -- Frontend
        javascript = { sw = 2, expandtab = true },
        typescript = { sw = 2, expandtab = true },
        javascriptreact = { sw = 2, expandtab = true },
        typescriptreact = { sw = 2, expandtab = true },
        html = { sw = 2, expandtab = true },
        css = { sw = 2, expandtab = true },
        scss = { sw = 2, expandtab = true },
        vue = { sw = 2, expandtab = true },
        json = { sw = 2, expandtab = true },
        graphql = { sw = 2, expandtab = true },

        -- Backend
        python = { sw = 4, expandtab = true },
        go = { sw = 4, expandtab = false }, -- Go uses tabs by convention

        -- Configuration & Documentation
        yaml = { sw = 2, expandtab = true },
        dockerfile = { sw = 2, expandtab = true },
        markdown = { sw = 2, expandtab = true },

        -- Smart defaults for other files
        lua = { sw = 2, expandtab = true },
      }

      -- Apply file type specific configurations
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          local ft = vim.bo.filetype
          local config = indent_configs[ft]
          if config then
            vim.bo.shiftwidth = config.sw
            vim.bo.expandtab = config.expandtab
            -- Sync tabstop with shiftwidth for consistency
            vim.bo.tabstop = config.sw
            vim.bo.softtabstop = config.sw
          end
        end,
      })
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          notify = false,
          use_treesitter = true,
          support_filetypes = {
            "*", -- Support all filetypes
          },
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = ">",
          },
          style = {
            { fg = "#806d9c" },    -- indent line
            { fg = "#806d9c" },    -- indent connector
          },
        },
        indent = {
          enable = false,          -- Disable global indent markers
        },
        line_num = {
          enable = false,          -- Disable line number highlighting
        },
        blank = {
          enable = false,          -- Disable blank space visualization
        },
      })

      -- Support for JSX/TSX indentation
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
        },
        callback = function()
          vim.opt_local.indentexpr = "nvim_treesitter#indent()"
        end,
      })
    end,
  },
}
