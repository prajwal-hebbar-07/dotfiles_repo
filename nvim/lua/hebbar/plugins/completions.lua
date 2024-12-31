-- ~/.config/nvim/lua/plugins/completions.lua

return {
  {
    "hrsh7th/cmp-nvim-lsp",
    event = "InsertEnter",
  },
  {
    "hrsh7th/cmp-buffer",
    event = "InsertEnter",
  },
  {
    "hrsh7th/cmp-path",
    event = "InsertEnter",
  },
  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter",
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Web Development Snippets
      luasnip.add_snippets("typescript", {
        luasnip.snippet("us", { luasnip.text_node("const [, set] = useState()") }),
        luasnip.snippet("ue", { luasnip.text_node("useEffect(() => {\n  \n}, [])") }),
        luasnip.snippet("api", {
          luasnip.text_node([[
            async () => {
              try {
                
              } catch (error) {
                console.error(error);
              }
            }
          ]]),
        }),
      })

      -- React Native Snippets
      luasnip.add_snippets("typescriptreact", {
        luasnip.snippet("rnstyle", { luasnip.text_node("const styles = StyleSheet.create({\n  \n})") }),
        luasnip.snippet("rncomp", {
          luasnip.text_node([[
            import React from 'react'
            import { View, StyleSheet } from 'react-native'

            export const Component = () => {
              return (
                <View style={styles.container}>
                  
                </View>
              )
            }

            const styles = StyleSheet.create({
              container: {
                flex: 1,
              },
            })
          ]]),
        }),
      })

      -- Python Snippets
      luasnip.add_snippets("python", {
        luasnip.snippet("adef", { luasnip.text_node("async def ") }),
        luasnip.snippet("tryex", { 
          luasnip.text_node([[
            try:
                
            except Exception as e:
                print(f'Error: {e}')
          ]]),
        }),
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local autopairs = require("nvim-autopairs.completion.cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          }),
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            priority = 1000,
            entry_filter = function(entry, ctx)
              local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]
              if ctx.filetype == "markdown" then
                return true
              end
              return kind == "Function"
                or kind == "Method"
                or kind == "Class"
                or kind == "Module"
                or kind == "Variable"
                or kind == "Keyword"
            end,
          },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
        experimental = {
          ghost_text = true,  -- Shows preview of completion as ghost text
        },
      })

      -- Command line and search completion setup
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "cmdline" },
          { name = "path" },
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Set up autopairs integration
      cmp.event:on("confirm_done", autopairs.on_confirm_done())
    end,
  },
}