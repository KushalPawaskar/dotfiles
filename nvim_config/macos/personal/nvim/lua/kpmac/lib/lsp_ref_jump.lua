--- Jump between LSP references on ]] / [[.
--- Python's ftplugin maps buffer-local ]] to the next `def`; we re-bind after FileType.
local M = {}

local CYCLE = true

local function item_bufnr(item)
    if item.bufnr and item.bufnr > 0 then
        return item.bufnr
    end
    if item.filename and item.filename ~= "" then
        return vim.fn.bufnr(item.filename, true)
    end
    return -1
end

---@param cursor number[]
---@param loc {row: number, col: number}
local function strictly_after(cursor, loc)
    return loc.row > cursor[1] or (loc.row == cursor[1] and loc.col > cursor[2])
end

---@param cursor number[]
---@param loc {row: number, col: number}
local function strictly_before(cursor, loc)
    return loc.row < cursor[1] or (loc.row == cursor[1] and loc.col < cursor[2])
end

---@param buf integer
---@param fn fun(locs: {row: number, col: number}[])
local function with_references(buf, fn)
    vim.lsp.buf.references({ includeDeclaration = true }, {
        on_list = function(list)
            local locs = {} ---@type {row: number, col: number}[]
            local seen = {}

            for _, item in ipairs(list.items or {}) do
                if item_bufnr(item) ~= buf then
                    goto continue
                end
                local key = ("%d:%d"):format(item.lnum, item.col)
                if seen[key] then
                    goto continue
                end
                seen[key] = true
                locs[#locs + 1] = { row = item.lnum, col = item.col }
                ::continue::
            end

            table.sort(locs, function(a, b)
                if a.row ~= b.row then
                    return a.row < b.row
                end
                return a.col < b.col
            end)

            fn(locs)
        end,
    })
end

local function jump_to(locs, target)
    if not target then
        return false
    end
    vim.cmd.normal({ "m`", bang = true })
    vim.api.nvim_win_set_cursor(0, { target.row, target.col })
    vim.cmd.normal({ "zv", bang = true })
    return true
end

---@param locs {row: number, col: number}[]
---@param cursor number[]
---@param count integer
local function next_loc(locs, cursor, count)
    if #locs == 0 or count <= 0 then
        return nil
    end

    local after = vim.tbl_filter(function(loc)
        return strictly_after(cursor, loc)
    end, locs)

    if #after >= count then
        return after[count]
    end
    if CYCLE and count == 1 then
        return locs[1]
    end
    return nil
end

---@param locs {row: number, col: number}[]
---@param cursor number[]
---@param count integer positive distance backward
local function prev_loc(locs, cursor, count)
    if #locs == 0 or count <= 0 then
        return nil
    end

    local before = {} ---@type {row: number, col: number}[]
    for i = #locs, 1, -1 do
        if strictly_before(cursor, locs[i]) then
            before[#before + 1] = locs[i]
        end
    end

    if #before >= count then
        return before[count]
    end
    if CYCLE and count == 1 then
        return locs[#locs]
    end
    return nil
end

function M.jump(count)
    count = count or vim.v.count1
    local buf = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)

    if Snacks.words.is_enabled({ buf = buf, modes = true }) then
        vim.lsp.buf.document_highlight()
    end

    with_references(buf, function(locs)
        if #locs == 0 then
            return
        end

        local n = math.abs(count)
        local target
        if count > 0 then
            target = next_loc(locs, cursor, n)
        else
            target = prev_loc(locs, cursor, n)
        end

        jump_to(locs, target)
    end)
end

function M.setup_keymaps()
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("kpmac_lsp_ref_jump", { clear = true }),
        callback = function(ev)
            vim.schedule(function()
                if not vim.api.nvim_buf_is_valid(ev.buf) then
                    return
                end
                vim.keymap.set("n", "]]", function()
                    M.jump(vim.v.count1)
                end, { buffer = ev.buf, desc = "Next reference" })
                vim.keymap.set("n", "[[", function()
                    M.jump(-vim.v.count1)
                end, { buffer = ev.buf, desc = "Prev reference" })
            end)
        end,
    })
end

return M
