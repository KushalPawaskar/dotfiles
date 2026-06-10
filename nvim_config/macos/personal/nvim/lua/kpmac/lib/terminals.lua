local M = {}

local CLAUDE_LAYOUTS = { "float", "sidebar" }
local SHELL_LAYOUTS = { "float", "bottom" }
local CLAUDE_SIDEBAR_WIDTH = 0.30 -- claudecode.nvim default (main branch)

local function claude_default_layout()
    return vim.g.kpmac_claude_layout or "sidebar"
end

function M.claude_win_opts(layout)
    layout = layout or claude_default_layout()
    if layout == "sidebar" then
        return {
            position = "right",
            width = CLAUDE_SIDEBAR_WIDTH,
            height = 0,
            border = "rounded",
        }
    end
    return {
        position = "float",
        width = 0.85,
        height = 0.85,
        border = "rounded",
    }
end

function M.shell_win_opts(layout)
    layout = layout or vim.g.kpmac_shell_layout or "float"
    if layout == "bottom" then
        return {
            position = "bottom",
            height = 0.35,
            border = "rounded",
        }
    end
    return {
        position = "float",
        width = 0.9,
        height = 0.5,
        border = "rounded",
    }
end

---@param term snacks.win?
---@param win_opts snacks.win.Config
local function set_win_layout(term, win_opts)
    if not term or not term:buf_valid() then
        return false
    end

    local resolved = Snacks.win.resolve("terminal", win_opts)
    term.opts = vim.tbl_deep_extend("force", term.opts, resolved)

    local pos = term.opts.position or "float"
    if pos == "float" then
        term.opts = Snacks.win.resolve("float", term.opts)
    else
        term.opts = Snacks.win.resolve("split", term.opts)
        local vertical = pos == "left" or pos == "right"
        term.opts.wo = vim.tbl_deep_extend("force", term.opts.wo or {}, {
            winfixheight = not vertical,
            winfixwidth = vertical,
        })
    end

    if not term:win_valid() then
        return true
    end

    local focused = vim.api.nvim_get_current_buf() == term.buf
    term:hide()
    term:show()
    if focused then
        pcall(function()
            term:focus()
        end)
    end
    return true
end

function M.claude_terminal_opts()
    local layout = claude_default_layout()
    return {
        split_side = "right",
        split_width_percentage = CLAUDE_SIDEBAR_WIDTH,
        snacks_win_opts = M.claude_win_opts(layout),
    }
end

function M.apply_claude_layout(layout)
    vim.g.kpmac_claude_layout = layout
    local ok, terminal = pcall(require, "claudecode.terminal")
    if ok then
        terminal.defaults.snacks_win_opts = M.claude_win_opts(layout)
        terminal.defaults.split_side = "right"
        terminal.defaults.split_width_percentage = CLAUDE_SIDEBAR_WIDTH
    end
end

local function cycle_layout(current, layouts)
    for i, name in ipairs(layouts) do
        if name == current then
            return layouts[i % #layouts + 1]
        end
    end
    return layouts[1]
end

local function claude_terminal_module()
    local ok, terminal = pcall(require, "claudecode.terminal")
    return ok and terminal or nil
end

local function claude_snacks_terminal()
    local ok, provider = pcall(require, "claudecode.terminal.snacks")
    if not ok then
        return nil
    end
    return provider._get_terminal_for_test()
end

function M.toggle_claude()
    local terminal = claude_terminal_module()
    if not terminal then
        vim.notify("claudecode terminal module unavailable", vim.log.levels.ERROR)
        return
    end
    M.apply_claude_layout(claude_default_layout())
    terminal.simple_toggle(M.claude_terminal_opts())
end

function M.focus_claude()
    local terminal = claude_terminal_module()
    if not terminal then
        return
    end
    M.apply_claude_layout(claude_default_layout())
    terminal.focus_toggle(M.claude_terminal_opts())
end

function M.cycle_claude_layout()
    local next_layout = cycle_layout(claude_default_layout(), CLAUDE_LAYOUTS)
    M.apply_claude_layout(next_layout)
    set_win_layout(claude_snacks_terminal(), M.claude_win_opts(next_layout))
    vim.notify("Claude layout: " .. next_layout, vim.log.levels.INFO, { title = "Claude Code" })
end

function M.get_shell_terminal()
    return Snacks.terminal.get(nil, { create = false })
end

function M.toggle_shell()
    local layout = vim.g.kpmac_shell_layout or "float"
    Snacks.terminal(nil, { win = M.shell_win_opts(layout) })
end

function M.cycle_shell_layout()
    local next_layout = cycle_layout(vim.g.kpmac_shell_layout or "float", SHELL_LAYOUTS)
    vim.g.kpmac_shell_layout = next_layout
    set_win_layout(M.get_shell_terminal(), M.shell_win_opts(next_layout))
    vim.notify("Shell terminal layout: " .. next_layout, vim.log.levels.INFO, { title = "Terminal" })
end

function M.claude_config()
    vim.g.kpmac_claude_layout = vim.g.kpmac_claude_layout or "sidebar"
    vim.g.kpmac_shell_layout = vim.g.kpmac_shell_layout or "float"

    return {
        terminal = {
            provider = "snacks",
            split_side = "right",
            split_width_percentage = CLAUDE_SIDEBAR_WIDTH,
            snacks_win_opts = M.claude_win_opts(vim.g.kpmac_claude_layout),
        },
        diff_opts = {
            open_in_new_tab = true,
            keep_terminal_focus = false, -- focus the new diff tab (true keeps focus on Claude terminal)
            hide_terminal_in_new_tab = true,
            layout = "vertical",
        },
    }
end

return M
