return {
  -- Plenary is required by many plugins
  "nvim-lua/plenary.nvim",

  -- Mason package manager configuration
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- LSP
        "typescript-language-server", -- TS/JS
        "css-lsp", -- CSS
        "html-lsp", -- HTML
        "tailwindcss-language-server", -- Tailwind
        "pyright", -- Python
        "gopls", -- Go
        "lua-language-server", -- Lua
        "prettier", -- Formatter
        "eslint_d", -- JS/TS Linter
        "shellcheck", -- Shell script linter
        "dockerfile-language-server", -- Dockerfile
        "docker-compose-language-service", -- Docker Compose
        "prisma-language-server", -- Prisma

        -- DAP (Debuggers)
        "js-debug-adapter", -- JavaScript/TypeScript
        "debugpy", -- Python debugger (replacing python-debug-adapter)
        "delve", -- Go

        -- Formatters
        "black", -- Python
        "isort", -- Python imports
        "gofumpt", -- Go
        "goimports", -- Go imports
        "stylua", -- Lua

        -- Linters
        "eslint_d", -- JavaScript/TypeScript
        "ruff", -- Python
        "golangci-lint", -- Go
        "hadolint", -- Dockerfile
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        keymaps = {
          toggle_package_expand = "<CR>",
          install_package = "i",
          update_package = "u",
          check_package_version = "c",
          update_all_packages = "U",
          check_outdated_packages = "C",
          uninstall_package = "X",
          cancel_installation = "<C-c>",
          apply_language_filter = "<C-f>",
        },
      },
      max_concurrent_installers = 10,
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Install listed packages
      local registry = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = registry.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      if registry.refresh then
        registry.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  }
}
