return {
  "mfussenegger/nvim-lint",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    local lint = require("lint")

    -- Configure linters for different filetypes
    lint.linters_by_ft = {
      -- Web Development
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      vue = { "eslint_d" },

      -- Next.js specific
      ["next.js"] = { "eslint_d" },

      -- React Native
      ["react-native"] = { "eslint_d" },

      -- Python
      python = { "ruff", "mypy" }, -- ruff is faster than pylint

      -- Go
      go = { "golangci_lint" },

      -- Docker and Configuration
      dockerfile = { "hadolint" },
      yaml = { "yamllint" },
      
      -- Smart Contract Development
      solidity = { "solhint" },

      -- Shell Scripts
      sh = { "shellcheck" },
      bash = { "shellcheck" },

      -- CSS/SCSS
      css = { "stylelint" },
      scss = { "stylelint" },

      -- HTML
      html = { "tidy" },

      -- JSON
      json = { "jsonlint" },
      jsonc = { "jsonlint" },

      -- GraphQL
      graphql = { "gqlint" },

      -- CI/CD
      ["github-actions-yaml"] = { "actionlint" },
    }

    -- Configure specific linter settings
    lint.linters.ruff.args = {
      "check",
      "--format=text",
      "--select=E,F,W,I,N,B,A,C4,RUF,ERA,UP",
      "--ignore=E501", -- Skip line length violations
      "-" 
    }

    lint.linters.mypy.args = {
      "--show-column-numbers",
      "--show-error-codes",
      "--hide-error-context",
      "--no-color-output",
      "--no-error-summary",
      "--no-pretty",
    }

    lint.linters.golangci_lint.args = {
      "run",
      "--out-format=line-number",
      "--print-issued-lines=false",
      "--max-issues-per-linter=0",
      "--max-same-issues=0",
      "--disable-all",
      "--enable=deadcode,errcheck,gosimple,govet,ineffassign,staticcheck,typecheck,unused,varcheck",
    }

    -- Create autocmd group for linting
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- Setup autocommands for automatic linting
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        -- Don't lint if the file is too large
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
        if ok and stats and stats.size > max_filesize then
          return
        end

        -- Don't lint certain directories
        local filepath = vim.api.nvim_buf_get_name(0)
        if filepath:match("node_modules") or 
           filepath:match("dist") or 
           filepath:match("build") or 
           filepath:match(".next") then
          return
        end

        lint.try_lint()
      end,
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
      vim.diagnostic.setloclist({ open = true })
    end, { desc = "Trigger linting and show diagnostics" })

    -- Quick actions for common fixes
    vim.keymap.set("n", "<leader>lf", function()
      -- Try ESLint fix first
      vim.cmd("EslintFixAll")
      -- Then run general linting
      lint.try_lint()
    end, { desc = "Fix linting issues" })

    -- Add keymap for toggling auto-linting
    local auto_lint_enabled = true
    vim.keymap.set("n", "<leader>lt", function()
      auto_lint_enabled = not auto_lint_enabled
      if auto_lint_enabled then
        vim.notify("Auto-linting enabled")
        -- Re-enable autocommands
        vim.api.nvim_clear_autocmds({ group = lint_augroup })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
          group = lint_augroup,
          callback = function()
            lint.try_lint()
          end,
        })
      else
        vim.notify("Auto-linting disabled")
        vim.api.nvim_clear_autocmds({ group = lint_augroup })
      end
    end, { desc = "Toggle auto-linting" })

    -- Register which-key group
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.register({
        ["<leader>l"] = {
          name = "Linting",
          l = "Lint and show diagnostics",
          f = "Fix linting issues",
          t = "Toggle auto-linting",
        },
      })
    end
  end,
}