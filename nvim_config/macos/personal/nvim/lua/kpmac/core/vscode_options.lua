local opt = vim.opt

-- search settings
opt.ignorecase = true       -- ignore case when searching
opt.smartcase = true        -- if you include mixed case in your search, assumes you want case sensitivity
opt.hlsearch = true         -- highlight matches
opt.incsearch = true        -- search as characters are entered

-- completion menu
opt.completeopt = {"menu", "menuone", "noselect"}

-- backspace
opt.backspace = "indent,eol,start"      -- allow backspace on indent, end of lin, or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus")     -- use system clipboard as default register

-- netrw settings
vim.g.netrw_keepdir = 0     -- 1 means that current directory will be immune from browsing directory, 0 means that current directory will change with browsing directory
