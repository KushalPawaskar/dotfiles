return {
  'saghen/blink.cmp',
  version = '*',
  dependencies = 'rafamadriz/friendly-snippets',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'manual' mode for the Enter key mimics your 'select = false' logic
    keymap = {
      preset = 'none', -- We'll define them manually to match your old config
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-c>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },

      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },

      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },

      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- Use the built-in engine (safer/faster) since you don't use custom LuaSnip files
    snippets = { preset = 'default' },

    completion = {
      -- 'menuone' and 'noselect' behavior
      list = { selection = { preselect = false, auto_insert = false } },
      menu = { draw = { columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } } } },
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
  },
}
