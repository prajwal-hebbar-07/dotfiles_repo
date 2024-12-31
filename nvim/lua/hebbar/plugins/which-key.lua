return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },

    window = {
      border = "rounded",
      padding = { 2, 2, 2, 2 },
    },

    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },

    ignore_missing = true,
    show_help = true,
    show_keys = true,

    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Register key groups
    wk.register({
      -- File operations
      ["<leader>f"] = {
        name = "File",
        f = { "Find files" },
        g = { "Live grep" },
        b = { "File browser" },
        r = { "Recent files" },
        n = { "New file" },
      },

      -- Buffer operations
      ["<leader>b"] = {
        name = "Buffer",
        d = { "Delete buffer" },
        n = { "Next buffer" },
        p = { "Previous buffer" },
        s = { "Save buffer" },
      },

      -- Code operations
      ["<leader>c"] = {
        name = "Code",
        a = { "Code action" },
        d = { "Go to definition" },
        r = { "References" },
        n = { "Rename" },
        f = { "Format" },
        l = { "Line diagnostics" },
      },

      -- LSP operations
      ["<leader>l"] = {
        name = "LSP",
        i = { "LSP Info" },
        r = { "Restart LSP" },
        s = { "LSP Start" },
        t = { "Toggle inlay hints" },
      },

      -- Git operations
      ["<leader>g"] = {
        name = "Git",
        s = { "Status" },
        b = { "Branches" },
        c = { "Commits" },
        d = { "Diff" },
        p = { "Push" },
        P = { "Pull" },
      },

      -- Testing
      ["<leader>t"] = {
        name = "Test",
        t = { "Run test" },
        f = { "Test file" },
        s = { "Test suite" },
        l = { "Test last" },
      },

      -- Debug operations
      ["<leader>d"] = {
        name = "Debug",
        b = { "Toggle breakpoint" },
        c = { "Continue" },
        s = { "Step over" },
        i = { "Step into" },
        o = { "Step out" },
      },

      -- Project operations
      ["<leader>p"] = {
        name = "Project",
        f = { "Find in project" },
        r = { "Recent projects" },
        s = { "Project settings" },
      },

      -- Window operations
      ["<leader>w"] = {
        name = "Window",
        v = { "Split vertical" },
        s = { "Split horizontal" },
        h = { "Focus left" },
        j = { "Focus down" },
        k = { "Focus up" },
        l = { "Focus right" },
        q = { "Close window" },
      },

      -- Toggle operations
      ["<leader>u"] = {
        name = "Toggle",
        t = { "Terminal" },
        f = { "File tree" },
        g = { "Git signs" },
        l = { "Line numbers" },
        w = { "Word wrap" },
        s = { "Spell check" },
      },

      -- Web Development specific
      ["<leader>w"] = {
        name = "Web Dev",
        c = { "Component" },
        p = { "Page" },
        a = { "API route" },
        s = { "Style" },
        t = { "Type" },
      },

      -- Docker/DevOps
      ["<leader>k"] = {
        name = "DevOps",
        d = { "Docker" },
        c = { "Compose" },
        k = { "Kubernetes" },
        p = { "Pipeline" },
      },

      -- Database operations
      ["<leader>db"] = {
        name = "Database",
        u = { "UI" },
        m = { "Migrations" },
        s = { "Seed" },
        r = { "Reset" },
      },
    })

    -- Register mode specific bindings
    wk.register({
      -- Visual mode bindings
      ["<leader>"] = {
        name = "VISUAL",
        c = {
          name = "Code",
          r = { "Refactor" },
          e = { "Extract" },
          f = { "Format" },
        },
      },
    }, { mode = "v" })

    -- Terminal mode bindings
    wk.register({
      ["<Esc>"] = { "Exit terminal" },
      ["<C-h>"] = { "Go to left window" },
      ["<C-j>"] = { "Go to down window" },
      ["<C-k>"] = { "Go to up window" },
      ["<C-l>"] = { "Go to right window" },
    }, { mode = "t" })
  end,
}