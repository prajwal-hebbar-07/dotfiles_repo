return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("todo-comments").setup({
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { 
              "FIXME", 
              "BUG", 
              "FIXIT", 
              "ISSUE", 
              "ERROR", 
              "FIX-NEXT", 
              "NEED-FIX" 
            },
          },
          TODO = {
            icon = " ",
            color = "todo",
            alt = { 
              "IMPLEMENT", 
              "IMPLEMENTATION", 
              "TBD", 
              "PENDING" 
            },
          },
          HACK = {
            icon = " ",
            color = "hack",
            alt = { 
              "TEMP", 
              "TEMPORARY", 
              "WORKAROUND", 
              "HORRIBLE", 
              "FUGLY" 
            },
          },
          WARN = {
            icon = " ",
            color = "warning",
            alt = { 
              "WARNING", 
              "CAUTION", 
              "CAREFUL", 
              "XXX", 
              "WATCHOUT" 
            },
          },
          PERF = {
            icon = "󰅒 ",
            color = "perf",
            alt = { 
              "OPTIM", 
              "PERFORMANCE", 
              "OPTIMIZE", 
              "COMPLEXITY", 
              "REFACTOR" 
            },
          },
          NOTE = {
            icon = " ",
            color = "note",
            alt = { 
              "INFO", 
              "EXPLAIN", 
              "DESC", 
              "REF", 
              "REFERENCE" 
            },
          },
          TEST = {
            icon = "⏲ ",
            color = "test",
            alt = { 
              "TESTING", 
              "PASSED", 
              "FAILED", 
              "UNIT", 
              "SPEC", 
              "E2E", 
              "INTEGRATION" 
            },
          },
          -- Web Development specific
          API = {
            icon = "󰘦 ",
            color = "api",
            alt = { 
              "ENDPOINT", 
              "ROUTE", 
              "REST", 
              "GRAPHQL", 
              "WS", 
              "SOCKET" 
            },
          },
          SECURITY = {
            icon = "󰿈 ",
            color = "security",
            alt = { 
              "AUTH", 
              "JWT", 
              "OAUTH", 
              "ROLE", 
              "PERMISSION", 
              "SEC" 
            },
          },
          UI = {
            icon = "󰃤 ",
            color = "ui",
            alt = { 
              "STYLE", 
              "CSS", 
              "ANIMATION", 
              "LAYOUT", 
              "RESPONSIVE", 
              "MOBILE", 
              "COMPONENT" 
            },
          },
          STATE = {
            icon = "󰘻 ",
            color = "state",
            alt = { 
              "STORE", 
              "REDUX", 
              "CONTEXT", 
              "RECOIL", 
              "ZUSTAND", 
              "DATA" 
            },
          },
          -- Infrastructure specific
          DOCKER = {
            icon = " ",
            color = "docker",
            alt = { 
              "CONTAINER", 
              "K8S", 
              "KUBERNETES", 
              "DEPLOY", 
              "CI", 
              "CD" 
            },
          },
          ENV = {
            icon = "󰙪 ",
            color = "env",
            alt = { 
              "ENVIRONMENT", 
              "CONFIG", 
              "VARIABLE", 
              "SECRET" 
            },
          }
        },

        highlight = {
          multiline = true,
          multiline_pattern = "^.",
          multiline_context = 10,
          before = "",
          keyword = "wide",
          after = "fg",
          pattern = [[.*<(KEYWORDS)\s*:]],
          comments_only = true,
          max_line_len = 400,
        },

        -- Tokyo Night colors
        colors = {
          error = { "DiagnosticError", "ErrorMsg", "#f7768e" },     -- Red
          warning = { "DiagnosticWarn", "WarningMsg", "#ff9e64" },  -- Orange
          todo = { "Todo", "#7aa2f7" },                             -- Blue
          hack = { "DiagnosticWarn", "#e0af68" },                  -- Yellow
          perf = { "Special", "#2ac3de" },                         -- Cyan
          note = { "DiagnosticInfo", "#bb9af7" },                  -- Purple
          test = { "Identifier", "#9ece6a" },                      -- Green
          api = { "Function", "#7dcfff" },                         -- Light Blue
          security = { "String", "#f7768e" },                      -- Red
          ui = { "Character", "#bb9af7" },                         -- Purple
          state = { "Type", "#89ddff" },                          -- Light Cyan
          docker = { "Special", "#7aa2f7" },                       -- Blue
          env = { "Constant", "#e0af68" },                        -- Yellow
        },

        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git",
            "--glob=!node_modules",
            "--glob=!dist",
            "--glob=!build",
          },
          pattern = [[\b(KEYWORDS):]],
        },

        merge_keywords = false,

        -- Better highlighting
        highlight = {
          before = "",
          keyword = "wide",
          after = "fg",
          pattern = [[.*<(KEYWORDS)\s*:]],
          comments_only = true,
          max_line_len = 400,
          exclude = {},
        },

        -- GUI options
        gui_style = {
          fg = "NONE",
          bg = "BOLD",
        },
      })

      -- Navigation keymaps
      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })

      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })

      -- Telescope integration with category-specific searches
      vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find all TODOs" })
      vim.keymap.set("n", "<leader>fb", "<cmd>TodoTelescope keywords=FIX,BUG,ERROR<cr>", { desc = "Find bugs" })
      vim.keymap.set("n", "<leader>fi", "<cmd>TodoTelescope keywords=API,ENDPOINT,ROUTE<cr>", { desc = "Find API related" })
      vim.keymap.set("n", "<leader>fs", "<cmd>TodoTelescope keywords=SECURITY,AUTH<cr>", { desc = "Find security notes" })
      vim.keymap.set("n", "<leader>fu", "<cmd>TodoTelescope keywords=UI,STYLE,COMPONENT<cr>", { desc = "Find UI notes" })
      vim.keymap.set("n", "<leader>fp", "<cmd>TodoTelescope keywords=PERF,OPTIM<cr>", { desc = "Find performance notes" })
      vim.keymap.set("n", "<leader>fd", "<cmd>TodoTelescope keywords=DOCKER,K8S,DEPLOY<cr>", { desc = "Find DevOps notes" })
      vim.keymap.set("n", "<leader>fe", "<cmd>TodoTelescope keywords=ENV,CONFIG<cr>", { desc = "Find env/config notes" })
    end,
  },
}