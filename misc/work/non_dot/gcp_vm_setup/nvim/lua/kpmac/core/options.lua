-- Hint: Use `:h <option>` to figure out the meaning if needed.

local opt = vim.opt -- for conciseness

-- Add plugins directory to runtimepath so colors/ inside it is discovered
opt.runtimepath:prepend(vim.fn.stdpath('config') .. '/lua/kpmac/plugins')

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
-- opt.signcolumn = 'yes'		-- show sign column so that text doesn't shift
opt.showmode = true		-- show mode hint

-- mouse
opt.mouse = 'a'			-- allow mouse to be used   (use opt+click+drag to select by overriding visual mode, then cmd+c to copy)

-- completion menu (for LSP completion in Neovim 0.11+)
opt.completeopt = {'menu', 'menuone', 'noselect', 'noinsert'}

-- backspace
opt.backspace = 'indent,eol,start'	-- allow backspace on indent, end of line or insert mode start position

-- clipboard
local in_tmux = vim.env.TMUX ~= nil     -- check if neovim is running within tmux
local is_ssh = vim.env.SSH_TTY ~= nil   -- check if neovim is running directly within ssh tty

-- Raw SSH Neovim (no tmux): disable builtin provider early
if is_ssh and not in_tmux then
    -- Headless SSH, raw Neovim → OSC 52
    vim.g.loaded_clipboard = 1

    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        -- paste = {        -- paste does not work directly with p (need to use cmd + v), also this causes pressing p to give an annoying iterm2 popup
        --     ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        --     ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
        -- },
    }
end

-- Default behavior everywhere
opt.clipboard = "unnamedplus"


-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- netrw settings
vim.g.netrw_keepdir = 0   -- 1 means that current directory will be immune from browsing directory, 0 means that current directory will change with browsing directory

-- colorscheme
-- vim.cmd("colorscheme unokai")
-- vim.cmd("colorscheme sorbet")
vim.cmd("colorscheme sorbet_cursor")

-- -- (not required in iterm2) highlighting visibility improvements (note that these lines should be below the colorscheme call line, otherwise they will be overridden) (run ```for i in {0..255}; do printf "\x1b[48;5;${i}m%3d " "$i"; [ $(( (i + 1) % 16 )) -eq 0 ] && echo; done``` to see the supported 256 colors)
-- vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 233, ctermfg = "NONE" })
