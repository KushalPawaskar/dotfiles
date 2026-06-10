-- Hint: Use `:h <option>` to figure out the meaning if needed.

local opt = vim.opt -- for conciseness

-- -- Add plugins directory to runtimepath so colors/ inside it is discovered
-- opt.runtimepath:prepend(vim.fn.stdpath('config') .. '/lua/kpmac/plugins')

-- line numbers
opt.relativenumber = true	-- show relative line numbers
opt.number = true		-- shows absolute line numbers

-- tabs & indentation
opt.tabstop = 4		-- number of visual spaces per tab
opt.shiftwidth = 4 	-- number of spaces for indent width
opt.expandtab = true 	-- expand tab to spaces
opt.autoindent = true 	-- copy indent from current line when starting new one
opt.softtabstop = 4	-- number of spaces in tab when editing

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true	-- ignore case when searching
opt.smartcase = true	-- if you include mixed case in your search, assumes you want case-sensitive
opt.hlsearch = true	-- highlight matches
opt.incsearch = true	-- search as characters are entered

-- cursor line
opt.cursorline = true	-- highlight the current cursor line underneath the cursor horizontally

-- appearance
-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true	-- enable 24-bit RGB color in the TUI
opt.background = 'dark' 	-- colorschemes that can be light or dark will be made dark
opt.signcolumn = 'yes'		-- show sign column so that text doesn't shift
opt.showmode = true		-- show mode hint

-- mouse
opt.mouse = 'a'			-- allow mouse to be used

-- completion menu
opt.completeopt = {'menu', 'menuone', 'noselect'}

-- backspace
opt.backspace = 'indent,eol,start'	-- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append('unnamedplus')	-- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- netrw settings
vim.g.netrw_keepdir = 0   -- 1 means that current directory will be immune from browsing directory, 0 means that current directory will change with browsing directory

-- colorscheme
if vim.g.diff_mode then
    vim.cmd("colorscheme sorbet")
else
    vim.cmd("colorscheme sorbet_cursor")
end
