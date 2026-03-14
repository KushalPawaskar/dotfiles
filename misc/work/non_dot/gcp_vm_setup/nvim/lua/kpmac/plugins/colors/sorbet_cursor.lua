-- Cursor Sorbet Colorscheme for Neovim
-- Based on the user's Cursor IDE color customizations
--
-- Features:
-- - Brightened backgrounds for better readability
-- - Optional transparency (set 'transparent = true' below)
-- - Floating windows have slight transparency (blend = 5)

vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
end

vim.o.termguicolors = true
vim.g.colors_name = 'sorbet_cursor'

local colors = {
    -- Backgrounds (brightened)
    bg = '#1a1d20',
    bg_dark = '#16181a',
    bg_light = '#1f2226',
    bg_lighter = '#252830',
    bg_selection = '#2d3640',
    bg_highlight = '#22252a',

    -- Foregrounds
    fg = '#c0c0c0',
    fg_dim = '#a0a0a0',
    fg_dark = '#808080',
    fg_bright = '#ffffff',
    fg_muted = '#606060',

    -- Line numbers
    line_nr = '#4a5057',
    line_nr_active = '#8a9097',

    -- Syntax colors
    red = '#f85149',
    orange = '#ffa657',
    yellow = '#e8ae5a',
    yellow_dark = '#d29922',
    green = '#7ee787',
    blue = '#79c0ff',
    purple = '#d2a8ff',
    cyan = '#56d4dd',

    -- UI colors
    border = '#2a3040',
    visual = '#2d3640',
    search = '#ffa657',
    error = '#f85149',
    warning = '#d29922',
    info = '#79c0ff',
    hint = '#7ee787',

    -- Git colors
    git_add = '#7ee787',
    git_change = '#e8ae5a',
    git_delete = '#f85149',
    git_ignore = '#484f58',

    -- Diff (solid colors, simulating transparency on dark bg)
    diff_add_bg = '#1a2a1f',
    diff_delete_bg = '#2a1a1a',

    -- None
    none = 'NONE',
}

-- Helper function
local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Transparency support (set to true to enable)
local transparent = false

-- Editor
if transparent then
    hi('Normal', { fg = colors.fg, bg = 'NONE' })
    hi('SignColumn', { fg = colors.fg_dim, bg = 'NONE' })
    hi('FoldColumn', { fg = colors.fg_dark, bg = 'NONE' })
else
    hi('Normal', { fg = colors.fg, bg = colors.bg })
    hi('SignColumn', { fg = colors.fg_dim, bg = colors.bg })
    hi('FoldColumn', { fg = colors.fg_dark, bg = colors.bg })
end
-- Floating windows with slight transparency
hi('NormalFloat', { fg = colors.fg, bg = colors.bg_dark, blend = 5 })
hi('FloatBorder', { fg = colors.border, bg = colors.bg_dark })
hi('FloatTitle', { fg = colors.blue, bg = colors.bg_dark })
hi('Cursor', { fg = colors.bg, bg = colors.fg_bright })
hi('CursorLine', { bg = colors.bg_highlight })
hi('CursorColumn', { bg = colors.bg_highlight })
hi('LineNr', { fg = colors.line_nr })
hi('CursorLineNr', { fg = colors.line_nr_active, bold = true })
hi('SignColumn', { fg = colors.fg_dim, bg = colors.bg })
hi('VertSplit', { fg = colors.border })
hi('WinSeparator', { fg = colors.border })
hi('ColorColumn', { bg = colors.bg_light })
hi('Visual', { bg = colors.visual })
hi('VisualNOS', { bg = colors.visual })
hi('Search', { fg = colors.bg, bg = colors.search })
hi('IncSearch', { fg = colors.bg, bg = colors.orange })
hi('CurSearch', { fg = colors.bg, bg = colors.orange })
hi('MatchParen', { fg = colors.orange, bold = true })

-- Popup menu
hi('Pmenu', { fg = colors.fg, bg = colors.bg_lighter })
hi('PmenuSel', { fg = colors.fg_bright, bg = colors.bg_selection })
hi('PmenuSbar', { bg = colors.bg_light })
hi('PmenuThumb', { bg = colors.fg_dark })

-- Tabs
hi('TabLine', { fg = colors.fg_muted, bg = colors.bg_dark })
hi('TabLineFill', { bg = colors.bg_dark })
hi('TabLineSel', { fg = colors.fg_bright, bg = colors.bg_light })

-- Status line
hi('StatusLine', { fg = colors.fg_dim, bg = colors.bg_light })
hi('StatusLineNC', { fg = colors.fg_muted, bg = colors.bg_dark })

-- Folding
hi('Folded', { fg = colors.fg_dim, bg = colors.bg_light })
hi('FoldColumn', { fg = colors.fg_dark, bg = colors.bg })

-- Messages
hi('ErrorMsg', { fg = colors.red })
hi('WarningMsg', { fg = colors.yellow_dark })
hi('ModeMsg', { fg = colors.fg, bold = true })
hi('MoreMsg', { fg = colors.green })
hi('Question', { fg = colors.green })

-- Special
hi('SpecialKey', { fg = colors.fg_dark })
hi('NonText', { fg = colors.fg_dark })
hi('Directory', { fg = colors.blue })
hi('Title', { fg = colors.blue, bold = true })
hi('Conceal', { fg = colors.fg_dark })

-- Diff
hi('DiffAdd', { bg = '#1a2a1f' })
hi('DiffChange', { bg = '#252018' })
hi('DiffDelete', { bg = '#2a1a1a' })
hi('DiffText', { bg = '#302515' })

-- Spell
hi('SpellBad', { sp = colors.red, undercurl = true })
hi('SpellCap', { sp = colors.yellow_dark, undercurl = true })
hi('SpellLocal', { sp = colors.blue, undercurl = true })
hi('SpellRare', { sp = colors.purple, undercurl = true })

-- Syntax
hi('Comment', { fg = '#888888', italic = true })
hi('Constant', { fg = colors.yellow_dark })
hi('String', { fg = colors.yellow })
hi('Character', { fg = colors.yellow })
hi('Number', { fg = colors.yellow_dark })
hi('Boolean', { fg = colors.yellow_dark })
hi('Float', { fg = colors.yellow_dark })

hi('Identifier', { fg = colors.fg })
hi('Function', { fg = colors.green })

hi('Statement', { fg = colors.red })
hi('Conditional', { fg = colors.red })
hi('Repeat', { fg = colors.red })
hi('Label', { fg = colors.red })
hi('Operator', { fg = colors.fg })
hi('Keyword', { fg = colors.red })
hi('Exception', { fg = colors.red })

hi('PreProc', { fg = colors.red })
hi('Include', { fg = colors.red })
hi('Define', { fg = colors.red })
hi('Macro', { fg = colors.red })
hi('PreCondit', { fg = colors.red })

hi('Type', { fg = colors.blue })
hi('StorageClass', { fg = colors.red })
hi('Structure', { fg = colors.blue })
hi('Typedef', { fg = colors.blue })

hi('Special', { fg = colors.orange })
hi('SpecialChar', { fg = colors.orange })
hi('Tag', { fg = colors.green })
hi('Delimiter', { fg = colors.fg })
hi('SpecialComment', { fg = colors.fg_dim })
hi('Debug', { fg = colors.orange })

hi('Underlined', { underline = true })
hi('Ignore', { fg = colors.fg_dark })
hi('Error', { fg = colors.red })
hi('Todo', { fg = colors.bg, bg = colors.yellow, bold = true })

-- LSP Diagnostics
hi('DiagnosticError', { fg = colors.error })
hi('DiagnosticWarn', { fg = colors.warning })
hi('DiagnosticInfo', { fg = colors.info })
hi('DiagnosticHint', { fg = colors.hint })
hi('DiagnosticVirtualTextError', { fg = colors.error, bg = '#1f1516' })
hi('DiagnosticVirtualTextWarn', { fg = colors.warning, bg = '#1f1a14' })
hi('DiagnosticVirtualTextInfo', { fg = colors.info, bg = '#151a1f' })
hi('DiagnosticVirtualTextHint', { fg = colors.hint, bg = '#161f17' })
hi('DiagnosticUnderlineError', { sp = colors.error, undercurl = true })
hi('DiagnosticUnderlineWarn', { sp = colors.warning, undercurl = true })
hi('DiagnosticUnderlineInfo', { sp = colors.info, undercurl = true })
hi('DiagnosticUnderlineHint', { sp = colors.hint, undercurl = true })
hi('DiagnosticFloatingError', { fg = colors.error })
hi('DiagnosticFloatingWarn', { fg = colors.warning })
hi('DiagnosticFloatingInfo', { fg = colors.info })
hi('DiagnosticFloatingHint', { fg = colors.hint })
hi('DiagnosticSignError', { fg = colors.error })
hi('DiagnosticSignWarn', { fg = colors.warning })
hi('DiagnosticSignInfo', { fg = colors.info })
hi('DiagnosticSignHint', { fg = colors.hint })

-- LSP Hover/Signature (IMPORTANT: Fixes the visibility issue)
hi('LspInfoBorder', { fg = colors.border, bg = colors.bg_dark })
hi('LspSignatureActiveParameter', { fg = colors.orange, bold = true })

-- Treesitter (if installed)
hi('@variable', { fg = colors.fg })
hi('@variable.parameter', { fg = colors.fg })
hi('@variable.builtin', { fg = colors.red })
hi('@constant', { fg = colors.yellow_dark })
hi('@constant.builtin', { fg = colors.yellow_dark })
hi('@string', { fg = colors.yellow })
hi('@string.escape', { fg = colors.orange })
hi('@string.special', { fg = colors.orange })
hi('@character', { fg = colors.yellow })
hi('@number', { fg = colors.yellow_dark })
hi('@boolean', { fg = colors.yellow_dark })
hi('@float', { fg = colors.yellow_dark })
hi('@function', { fg = colors.green })
hi('@function.builtin', { fg = colors.green })
hi('@function.call', { fg = colors.green })
hi('@function.method', { fg = colors.green })
hi('@function.method.call', { fg = colors.green })
hi('@constructor', { fg = colors.blue })
hi('@keyword', { fg = colors.red })
hi('@keyword.function', { fg = colors.red })
hi('@keyword.return', { fg = colors.red })
hi('@keyword.operator', { fg = colors.red })
hi('@keyword.import', { fg = colors.red })
hi('@conditional', { fg = colors.red })
hi('@repeat', { fg = colors.red })
hi('@label', { fg = colors.blue })
hi('@operator', { fg = colors.fg })
hi('@exception', { fg = colors.red })
hi('@type', { fg = colors.blue })
hi('@type.builtin', { fg = colors.blue })
hi('@type.qualifier', { fg = colors.red })
hi('@storageclass', { fg = colors.red })
hi('@structure', { fg = colors.blue })
hi('@namespace', { fg = colors.blue })
hi('@include', { fg = colors.red })
hi('@preproc', { fg = colors.red })
hi('@define', { fg = colors.red })
hi('@macro', { fg = colors.red })
hi('@comment', { fg = '#888888', italic = true })
hi('@punctuation', { fg = colors.fg })
hi('@punctuation.delimiter', { fg = colors.fg })
hi('@punctuation.bracket', { fg = colors.fg_dim })
hi('@punctuation.special', { fg = colors.orange })
hi('@tag', { fg = colors.green })
hi('@tag.attribute', { fg = colors.blue })
hi('@tag.delimiter', { fg = colors.fg_dim })
hi('@attribute', { fg = colors.blue })
hi('@property', { fg = colors.blue })
hi('@field', { fg = colors.blue })
hi('@parameter', { fg = colors.fg })

-- Git Signs (if installed)
hi('GitSignsAdd', { fg = colors.git_add })
hi('GitSignsChange', { fg = colors.git_change })
hi('GitSignsDelete', { fg = colors.git_delete })

-- Indent guides
hi('IndentBlanklineChar', { fg = '#2a2d30' })
hi('IndentBlanklineContextChar', { fg = '#3a4047' })
hi('IblIndent', { fg = '#2a2d30' })
hi('IblScope', { fg = '#3a4047' })

-- Telescope (if installed)
hi('TelescopeNormal', { fg = colors.fg, bg = colors.bg_dark })
hi('TelescopeBorder', { fg = colors.border, bg = colors.bg_dark })
hi('TelescopePromptNormal', { fg = colors.fg, bg = colors.bg_lighter })
hi('TelescopePromptBorder', { fg = colors.border, bg = colors.bg_lighter })
hi('TelescopePromptTitle', { fg = colors.bg, bg = colors.blue })
hi('TelescopePreviewTitle', { fg = colors.bg, bg = colors.green })
hi('TelescopeResultsTitle', { fg = colors.bg, bg = colors.yellow })
hi('TelescopeSelection', { bg = colors.bg_selection })
hi('TelescopeMatching', { fg = colors.orange, bold = true })

-- Which-key (if installed)
hi('WhichKey', { fg = colors.blue })
hi('WhichKeyGroup', { fg = colors.green })
hi('WhichKeyDesc', { fg = colors.fg })
hi('WhichKeySeperator', { fg = colors.fg_dark })
hi('WhichKeyFloat', { bg = colors.bg_dark })

-- Neotree/NvimTree (if installed)
hi('NeoTreeNormal', { fg = colors.fg, bg = colors.bg_light })
hi('NeoTreeNormalNC', { fg = colors.fg, bg = colors.bg_light })
hi('NvimTreeNormal', { fg = colors.fg, bg = colors.bg_light })
hi('NvimTreeNormalNC', { fg = colors.fg, bg = colors.bg_light })


-- =========================
-- Contrast & UX Fixups
-- =========================

-- 1. STATUSLINE / LUALINE VISIBILITY
-- Active: higher contrast (not bold for sharpness)
hi('StatusLine', {
  fg = '#e6e6e6',  -- bright but not pure white
  bg = '#2b2f36',
  bold = false,
})

-- Inactive: clearly dim but still readable
hi('StatusLineNC', {
  fg = '#9aa0a6',
  bg = '#202329',
})

-- Lualine section defaults (if lualine uses these)
hi('LualineNormal', { fg = colors.fg_bright, bg = '#2b2f36' })
hi('LualineInactive', { fg = '#9aa0a6', bg = '#202329' })

----------------------------------------------------------------

-- 2. SEARCH HIGHLIGHT DISTINCTION
-- Non-current matches
hi('Search', {
  fg = colors.bg,
  bg = colors.yellow_dark,
})

-- Current match (cursor is on this)
hi('CurSearch', {
  fg = colors.bg,
  bg = '#ff6d7e', -- pink-ish focus color (sorbet-like)
  bold = true,
})

-- While typing / incremental
hi('IncSearch', {
  fg = colors.bg,
  bg = colors.blue,
  bold = true,
})

----------------------------------------------------------------

-- 3. VISUAL MODE (MAKE IT OBVIOUS)
hi('Visual', {
  bg = '#3a4252', -- stronger blue-gray
})

hi('VisualNOS', {
  bg = '#3a4252',
})

----------------------------------------------------------------

-- 4. COMMENTS (BETTER READABILITY)
hi('Comment', {
  fg = '#a8a8a8', -- brighter than before
  italic = true,
})

-- Treesitter comment override (important)
hi('@comment', {
  fg = '#a8a8a8',
  italic = true,
})

----------------------------------------------------------------

-- Optional: improve matchparen clarity slightly
hi('MatchParen', {
  fg = colors.orange,
  bg = '#2f2a1f',
  bold = true,
})

-- =========================
-- Variable contrast tuning
-- =========================

-- General variables
hi('Identifier', { fg = '#d4d4d4' })       -- normal variables
hi('Constant', { fg = colors.yellow_dark }) -- constants like numbers, true/false
hi('Function', { fg = colors.green })       -- function names
hi('Statement', { fg = colors.red })        -- keywords, control flow

-- Lua “builtins” and module names
hi('Type', { fg = colors.purple, bold = true }) -- vim, opt, fn, etc.

-- Fields / properties
hi('Label', { fg = colors.blue, bold = true })  -- table keys like colors.fg

