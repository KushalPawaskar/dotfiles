-- Set leader key to space
vim.g.mapleader = ' '

local keymap = vim.keymap   -- for conciseness

-----------------
-- Normal mode --
-----------------

-- Hint: See `:h vim.map.set()`

-- Better window navigation
keymap.set('n', '<C-h>', "<cmd>lua require('vscode').action('workbench.action.focusLeftGroup')<CR>", { desc = 'Move cursor to the left split' })     -- C denotes control key
keymap.set('n', '<C-j>', "<cmd>lua require('vscode').action('workbench.action.focusBelowGroup')<CR>", { desc = 'Move cursor to the bottom split' })
keymap.set('n', '<C-k>', "<cmd>lua require('vscode').action('workbench.action.focusAboveGroup')<CR>", { desc = 'Move cursor to the top split' })
keymap.set('n', '<C-l>', "<cmd>lua require('vscode').action('workbench.action.focusRightGroup')<CR>", { desc = 'Move cursor to the right split' })

-- Resize with arrows (does not work, need to figure out a good keybinding)
keymap.set('n', '<C-S-k>', "<cmd>lua require('vscode').action('workbench.action.decreaseViewHeight')<CR>", { desc = 'Decrease window size vertically' })     -- A denotes option key
keymap.set('n', '<C-S-j>', "<cmd>lua require('vscode').action('workbench.action.increaseViewHeight')<CR>", { desc = 'Increase window size vertically' })
keymap.set('n', '<C-S-h>', "<cmd>lua require('vscode').action('workbench.action.decreaseViewWidth')<CR>", { desc = 'Decrease window size horizontally' })
keymap.set('n', '<C-S-l>', "<cmd>lua require('vscode').action('workbench.action.increaseViewWidth')<CR>", { desc = 'Increase window size horizontally' })

-- -- Change tabs
-- keymap.set('n', '<C-S-Right>', 'gt', { desc = 'Go to next tab' })           -- D denotes command key
-- keymap.set('n', '<C-S-Left>', 'gT', { desc = 'Go to previous tab' })        -- S denotes shift key
-- keymap.set('n', '<C-1>', ':tabfirst<CR>', {desc = 'Go to first tab' })      -- ctrl-1 is not detected
-- keymap.set('n', '<C-2>', '2gt', {})           -- ctrl-2 is ctrl-@ (hex 0x00)
-- keymap.set('n', '<C-3>', '3gt', {})           -- ctrl-3 is ctrl-[ (esc)
-- keymap.set('n', '<C-4>', '4gt', {})           -- ctrl-4 is ctrl-\
-- keymap.set('n', '<C-5>', '5gt', {})           -- ctrl-5 is ctrl-]
-- keymap.set('n', '<C-6>', '6gt', {})           -- ctrl-6 is ctrl-^
-- keymap.set('n', '<C-7>', '7gt', {})           -- ctrl-7 is ctrl-_
-- keymap.set('n', '<C-8>', '8gt', {})           -- ctrl-8 is ctrl-? (backspace)
-- keymap.set('n', '<C-9>', '9gt', {})           -- ctrl-9 is not detected
-- keymap.set('n', '<C-0>', ':tablast<CR>', { desc = 'Go to last tab' })       -- ctrl-0 is not detected
-- keymap.set('n', '<leader>1', ':tabfirst<CR>', { desc = 'Go to first tab' }) -- <leader> key was <\> key but has been set to < > (space) key
-- keymap.set('n', '<leader>2', '2gt', { desc = 'Go to second tab' })          -- go to 2nd tab
-- keymap.set('n', '<leader>3', '3gt', { desc = 'Go to third tab' })
-- keymap.set('n', '<leader>4', '4gt', { desc = 'Go to fourth tab' })
-- keymap.set('n', '<leader>5', '5gt', { desc = 'Go to fifth tab' })
-- keymap.set('n', '<leader>6', '6gt', { desc = 'Go to sixth tab' })
-- keymap.set('n', '<leader>7', '7gt', { desc = 'Go to seventh tab' })
-- keymap.set('n', '<leader>8', '8gt', { desc = 'Go to eighth tab' })
-- keymap.set('n', '<leader>9', '9gt', { desc = 'Go to ninth tab' })           -- go to 9th tab
-- keymap.set('n', '<leader>0', ':tablast<CR>', { desc = 'Go to last tab' })

-- window management
keymap.set('n', '<leader>sv', "<cmd>lua require('vscode').action('workbench.action.splitEditor')<CR>", { desc = 'Split window vertically' })
keymap.set('n', '<leader>sh', "<cmd>lua require('vscode').action('workbench.action.splitEditorOrthogonal')<CR>", { desc = 'Split window horizontally' })
keymap.set('n', '<leader>se', "<cmd>lua require('vscode').action('workbench.action.evenEditorWidths')<CR>", { desc = 'Make splits equal size' })
keymap.set('n', '<leader>sx', "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<CR>", { desc = 'Close current split' })

-- tab management
keymap.set('n', '<leader>to', "<cmd>lua require('vscode').action('workbench.action.files.newUntitledFile')<CR>", { desc = 'Open new tab' })
keymap.set('n', '<leader>tx', "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<CR>", { desc = 'Close current tab' })
keymap.set('n', '<leader>tn', "<cmd>lua require('vscode').action('workbench.action.nextEditor')<CR>", { desc = 'Go to next tab' })
keymap.set('n', '<leader>tp', "<cmd>lua require('vscode').action('workbench.action.previousEditor')<CR>", { desc = 'Go to previous tab' })

-- clear search highlights
keymap.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights' })

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
keymap.set('v', '<', '<gv', { desc = 'Remove indentation by one tab' })     -- Less than key (when in normal mode, press key twice) 
keymap.set('v', '>', '>gv', { desc = 'Add indentation by one tab' })        -- Greater than key (when in normal mode, press key twice)

-- -------------------
-- -- Terminal mode --
-- -------------------
-- 
-- keymap.set('t', '<C-\\>h', '<C-\\><C-n><C-w>h', {desc = 'Move cursor to the left window' })     -- To move cursor to the left window while in terminal mode
-- keymap.set('t', '<C-\\>j', '<C-\\><C-n><C-w>j', {desc = 'Move cursor to the bottom window' })   -- To move cursor to the bottom window
-- keymap.set('t', '<C-\\>k', '<C-\\><C-n><C-w>k', {desc = 'Move cursor to the top window' })      -- To move cursor to the top window
-- keymap.set('t', '<C-\\>l', '<C-\\><C-n><C-w>l', {desc = 'Move cursor to the right window' })    -- To move cursor to the right window

-----------------
-- Insert mode --
-----------------

-- exit insert mode
keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode with jk' })   -- Note that the following needs to be added to settings.json for this to work
-- {
--   "vscode-neovim.compositeKeys": {
--     "jk": {
--       "command": "vscode-neovim.escape"
--     }
--   }
-- }

--------------------------
-- Normal + Visual mode --
--------------------------

-- system clipboard
keymap.set({"n", "v"}, "<leader>y", '"+y', {desc = "Yank to system clipboard"})
keymap.set({"n", "v"}, "<leader>p", '"+p', {desc = "Paste from system clipboard"})

-------------------
-- Miscellaneous --
-------------------
-- defaults write com.todesktop.230313mzl4w4u92 ApplePressAndHoldEnabled -bool false
-- Run the above to enable repeated key press to work properly
