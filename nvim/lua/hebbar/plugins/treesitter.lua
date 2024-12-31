require("nvim-treesitter.configs").setup({
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    -- Disables for large files (>100KB) for better performance
    disable = function(_, buf)
      local max_filesize = 100 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },

  -- Indentation (disabled for Python and YAML where it might cause issues)
  indent = {
    enable = true,
    disable = { "python", "yaml" },
  },

  -- Auto-closing and renaming tags for JSX/TSX/HTML
  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
    filetypes = {
      "html", "xml", "javascript", "javascriptreact",
      "typescript", "typescriptreact", "svelte", "vue",
      "tsx", "jsx", "markdown", "mdx",
    },
  },

  -- Enhanced text objects for better code navigation
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["ar"] = "@parameter.outer",
        ["ir"] = "@parameter.inner",
        ["at"] = "@comment.outer",
      },
    },
    -- Text object movements
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]i"] = "@conditional.outer",
        ["]l"] = "@loop.outer",
        ["]s"] = "@statement.outer",
        ["]z"] = "@fold",
        ["]a"] = "@parameter.inner",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[i"] = "@conditional.outer",
        ["[l"] = "@loop.outer",
        ["[s"] = "@statement.outer",
        ["[z"] = "@fold",
        ["[a"] = "@parameter.inner",
      },
    },
  },

  -- Parsers for your tech stack
  ensure_installed = {
    -- Web Frontend
    "javascript", "typescript", "tsx", "html", "css", "scss",
    "json", "jsonc", "vue", "svelte", "graphql", "prisma",
    "jsx", "regex", "jsdoc",
    
    -- Mobile
    "swift", "kotlin",
    
    -- Backend
    "python", "go", "gomod", "gowork", "gosum",
    
    -- DevOps
    "dockerfile", "yaml", "toml", "bash", "fish",
    
    -- Git
    "git_rebase", "gitcommit", "gitignore",
    
    -- Documentation
    "markdown", "markdown_inline",
    
    -- Web3
    "solidity",
    
    -- Config
    "vim", "query", "lua"
  },

  -- Incremental selection
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<nop>",
      node_decremental = "<bs>",
    },
  },
})

-- Folding configuration
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
vim.opt.foldlevel = 99