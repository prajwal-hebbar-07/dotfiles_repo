return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    -- Define formatters
    formatters_by_ft = {
      -- Frontend
      javascript = { "prettier", "eslint_d" },
      typescript = { "prettier", "eslint_d" },
      javascriptreact = { "prettier", "eslint_d" },
      typescriptreact = { "prettier", "eslint_d" },
      svelte = { "prettier", "eslint_d" },
      vue = { "prettier", "eslint_d" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },

      -- Backend
      python = { "isort", "black" },
      go = { "goimports", "gofumpt" },  -- Updated Go formatters

      -- Configuration & Documentation
      markdown = { "prettier" },
      lua = { "stylua" },
      dockerfile = { "hadolint" },

      -- Fallback
      ["*"] = { "trim_whitespace", "trim_newlines" },
    },

    format_on_save = function(bufnr)
      -- Disable autoformat for files in certain directories
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match("/node_modules/") or bufname:match("/.git/") then
        return
      end

      return {
        timeout_ms = 500,
        lsp_fallback = true,
        async = false,
      }
    end,

    -- Formatter-specific configuration
    formatters = {
      prettier = {
        prepend_args = { "--config-precedence", "prefer-file" },
      },
      eslint_d = {
        prepend_args = { "--config", ".eslintrc.js" },
      },
      black = {
        args = { "--line-length=88", "--fast" },
      },
      isort = {
        args = { "--profile", "black" },
      },
      stylua = {
        args = {
          "--column-width=120",
          "--line-endings=Unix",
          "--indent-type=Spaces",
          "--indent-width=2",
        },
      },
    },
  },
  dependencies = {
    "williamboman/mason.nvim",
    "folke/which-key.nvim",
  },
  config = function()
    -- List of formatters that can be installed via Mason
    local ensure_installed = {
      "prettier",
      "eslint_d",
      "black",
      "isort",
      "stylua",
      "gofumpt", -- Updated from gofmt
      "goimports",
      "hadolint",
    }

    -- Setup conform.nvim
    require("conform").setup({
      formatters_by_ft = {
        -- Frontend
        javascript = { "prettier", "eslint_d" },
        typescript = { "prettier", "eslint_d" },
        javascriptreact = { "prettier", "eslint_d" },
        typescriptreact = { "prettier", "eslint_d" },
        svelte = { "prettier", "eslint_d" },
        vue = { "prettier", "eslint_d" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },

        -- Backend
        python = { "isort", "black" },
        go = { "goimports", "gofumpt" },

        -- Configuration & Documentation
        markdown = { "prettier" },
        lua = { "stylua" },
        dockerfile = { "hadolint" },

        -- Fallback
        ["*"] = { "trim_whitespace", "trim_newlines" },
      },
    })

    -- Ensure formatters are installed
    local function ensure_formatters()
      local registry = require("mason-registry")
      for _, tool in ipairs(ensure_installed) do
        if not registry.is_installed(tool) then
          vim.notify("Installing formatter: " .. tool)
          local pkg = registry.get_package(tool)
          pkg:install():once("closed", function()
            if pkg:is_installed() then
              vim.notify("Installed " .. tool)
            else
              vim.notify("Failed to install " .. tool, vim.log.levels.ERROR)
            end
          end)
        end
      end
    end

    -- Schedule the installation of formatters
    vim.defer_fn(function()
      ensure_formatters()
    end, 100)
  end
}
