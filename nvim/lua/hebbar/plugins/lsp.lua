return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Helper function for LSP setup
      local function setup_lsp(server, extra_config)
        local config = {
          capabilities = capabilities,
          flags = {
            debounce_text_changes = 150,
          },
        }

        if extra_config then
          for k, v in pairs(extra_config) do
            config[k] = v
          end
        end

        lspconfig[server].setup(config)
      end

      -- TypeScript/JavaScript setup
      setup_lsp("ts_ls", {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
            },
          },
        },
        root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git"),
      })

      -- React/Next.js specific setup
      setup_lsp("tailwindcss", {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              },
            },
          },
        },
      })

      -- Python setup
      setup_lsp("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- Go setup
      setup_lsp("gopls", {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = true,
          },
        },
      })

      -- Docker and related tools
      setup_lsp("dockerls")
      setup_lsp("docker_compose_language_service")

      -- ESLint setup with auto-fix
      setup_lsp("eslint", {
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

      -- Basic setup for other servers
      local basic_servers = {
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "prismals",
        "graphql",
      }

      for _, server in ipairs(basic_servers) do
        setup_lsp(server)
      end

      -- LSP UI Customization
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = "rounded" }
      )

      -- Keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(event)
          local opts = { buffer = event.buf }
          
          -- Navigation
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          
          -- Documentation
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          
          -- Code Actions
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          
          -- Diagnostics
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        end,
      })

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "always",
        },
        float = {
          border = "rounded",
          source = "always",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
  },
}
