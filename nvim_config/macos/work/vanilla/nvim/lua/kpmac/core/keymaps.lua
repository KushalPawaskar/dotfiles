-- Set leader key to space
vim.g.mapleader = ' '

local keymap = vim.keymap   -- for conciseness

-----------------
-- Normal mode --
-----------------

-- Hint: See `:h vim.map.set()`
-- Better window navigation
-- Commenting because this does not work well with vim_tmux_navigator (in fedora setup, works fine in macos setup), installing vim_tmux_navigator plugin with Lazy instead
keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move cursor to the left window' })     -- C denotes control key
keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move cursor to the bottom window' })
keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move cursor to the top window' })
keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move cursor to the right window' })

-- Resize with arrows
-- delta: 2 lines
keymap.set('n', '<A-Up>', ':resize -2<CR>', { desc = 'Decrease window size vertically' })   -- A denotes option key
keymap.set('n', '<A-Down>', ':resize +2<CR>', { desc = 'Increase window size vertically' })
keymap.set('n', '<A-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window size horizontally' })   -- <A-Left> has been mapped to ^[ b, which is <M-b> for backward-word, in iterm profile settings; it cannot be overridden from nvim
keymap.set('n', '<M-b>', ':vertical resize -2<CR>', { desc = 'Decrease window size horizontally' })
keymap.set('n', '<A-Right>', ':vertical resize +2<CR>', { desc = 'Increase window size horizontally' })   -- <A-Right> has been mapped to ^[ f, which is <M-f> for forward-word, in iterm profile settings; it cannot be overridden from nvim
keymap.set('n', '<M-f>', ':vertical resize +2<CR>', { desc = 'Increase window size horizontally' })

-- Change tabs
keymap.set('n', '<C-S-Right>', 'gt', { desc = 'Go to next tab' })           -- D denotes command key
keymap.set('n', '<C-S-Left>', 'gT', { desc = 'Go to previous tab' })        -- S denotes shift key
keymap.set('n', '<C-1>', ':tabfirst<CR>', {desc = 'Go to first tab' })      -- ctrl-1 is not detected
-- keymap.set('n', '<C-2>', '2gt', {})           -- ctrl-2 is ctrl-@ (hex 0x00)
-- keymap.set('n', '<C-3>', '3gt', {})           -- ctrl-3 is ctrl-[ (esc)
-- keymap.set('n', '<C-4>', '4gt', {})           -- ctrl-4 is ctrl-\
-- keymap.set('n', '<C-5>', '5gt', {})           -- ctrl-5 is ctrl-]
-- keymap.set('n', '<C-6>', '6gt', {})           -- ctrl-6 is ctrl-^
-- keymap.set('n', '<C-7>', '7gt', {})           -- ctrl-7 is ctrl-_
-- keymap.set('n', '<C-8>', '8gt', {})           -- ctrl-8 is ctrl-? (backspace)
-- keymap.set('n', '<C-9>', '9gt', {})           -- ctrl-9 is not detected
keymap.set('n', '<C-0>', ':tablast<CR>', { desc = 'Go to last tab' })       -- ctrl-0 is not detected
keymap.set('n', '<leader>1', ':tabfirst<CR>', { desc = 'Go to first tab' }) -- <leader> key was <\> key but has been set to < > (space) key
keymap.set('n', '<leader>2', '2gt', { desc = 'Go to second tab' })          -- go to 2nd tab
keymap.set('n', '<leader>3', '3gt', { desc = 'Go to third tab' })
keymap.set('n', '<leader>4', '4gt', { desc = 'Go to fourth tab' })
keymap.set('n', '<leader>5', '5gt', { desc = 'Go to fifth tab' })
keymap.set('n', '<leader>6', '6gt', { desc = 'Go to sixth tab' })
keymap.set('n', '<leader>7', '7gt', { desc = 'Go to seventh tab' })
keymap.set('n', '<leader>8', '8gt', { desc = 'Go to eighth tab' })
keymap.set('n', '<leader>9', '9gt', { desc = 'Go to ninth tab' })           -- go to 9th tab
keymap.set('n', '<leader>0', ':tablast<CR>', { desc = 'Go to last tab' })

-- window management
keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' })                   -- split window vertically
keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' })                 -- split window horizontally
keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' })                    -- make split windows equal width & height
keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' })               -- close current split window (cmd denotes : key)

-- tab management
keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'Open new tab' })                     -- open new tab
keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close current tab' })              -- close current tab
keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = 'Go to next tab' })                     -- go to next tab
keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = 'Go to previous tab' })                 -- go to previous tab
keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', { desc = 'Open current buffer in new tab' }) -- move current buffer to new tab

-- clear search highlights
keymap.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights' })

-----------------
-- LSP keymaps --
-----------------

-- Diagnostics navigation
keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic message' })
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- LSP actions (work when LSP is attached, e.g., ty/ruff for Python)
keymap.set('n', '<leader>lr', '<cmd>LspRestart<CR>', { desc = 'Restart LSP servers' })
keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover information' })
keymap.set('n', 'gd', function()
    -- Get word under cursor and set as search pattern
    local word = vim.fn.expand('<cword>')
    vim.fn.setreg('/', '\\<' .. vim.fn.escape(word, '\\/') .. '\\>')
    vim.opt.hlsearch = true
    -- Then go to definition
    vim.lsp.buf.definition()
end, { desc = 'Go to definition (and set search)' })
keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Show references' })
keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action (quick fixes)' })
keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, { desc = 'Format buffer' })

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
keymap.set('v', '<', '<gv', { desc = 'Remove indentation by one tab' })     -- Less than key (when in normal mode, press key twice) 
keymap.set('v', '>', '>gv', { desc = 'Add indentation by one tab' })        -- Greater than key (when in normal mode, press key twice)

-------------------
-- Terminal mode --
-------------------

keymap.set('t', '<C-\\>h', '<C-\\><C-n><C-w>h', {desc = 'Move cursor to the left window' })     -- To move cursor to the left window while in terminal mode
keymap.set('t', '<C-\\>j', '<C-\\><C-n><C-w>j', {desc = 'Move cursor to the bottom window' })   -- To move cursor to the bottom window
keymap.set('t', '<C-\\>k', '<C-\\><C-n><C-w>k', {desc = 'Move cursor to the top window' })      -- To move cursor to the top window
keymap.set('t', '<C-\\>l', '<C-\\><C-n><C-w>l', {desc = 'Move cursor to the right window' })    -- To move cursor to the right window

-----------------
-- Insert mode --
-----------------

-- exit insert mode
keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })

-- Completion menu navigation
keymap.set('i', '<C-n>', '<C-n>', { desc = 'Next completion item' })
keymap.set('i', '<C-p>', '<C-p>', { desc = 'Previous completion item' })
keymap.set('i', '<C-y>', '<C-y>', { desc = 'Accept completion' })
keymap.set('i', '<C-e>', '<C-e>', { desc = 'Close completion menu' })
keymap.set('i', '<C-Space>', '<C-x><C-o>', { desc = 'Trigger LSP completion manually' })

-- Tab/Shift-Tab for completion navigation
keymap.set('i', '<Tab>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-n>'
    else
        return '<Tab>'
    end
end, { expr = true, desc = 'Next completion or tab' })

keymap.set('i', '<S-Tab>', function()
    if vim.fn.pumvisible() == 1 then
        return '<C-p>'
    else
        return '<S-Tab>'
    end
end, { expr = true, desc = 'Previous completion or shift-tab' })
