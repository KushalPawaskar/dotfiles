return {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()

        local set = vim.keymap.set

        -- Add or skip cursor above/below the main cursor.
        set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end, { desc = "add cursor and move above" })
        set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end, { desc = "add cursor and move below" })
        set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end, { desc = "skip line and move above" })
        set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end, { desc = "skip line and move below" })

        -- Add or skip adding a new cursor by matching word/selection
        set({"n", "x"}, "<leader>mn", function() mc.matchAddCursor(1) end, { desc = "add cursor and move to next match" })
        set({"n", "x"}, "<leader>ms", function() mc.matchSkipCursor(1) end, { desc = "move to next match skipping current" })
        set({"n", "x"}, "<leader>mN", function() mc.matchAddCursor(-1) end, { desc = "add cursor and move to previous match" })
        set({"n", "x"}, "<leader>mS", function() mc.matchSkipCursor(-1) end, { desc = "move to previous match skipping current" })
        set({"n", "x"}, "<leader>ma", mc.matchAllAddCursors, { desc = "add cursors to all matches" })
        set({"n", "x"}, "<A-n>", function() mc.matchAddCursor(1) end, { desc = "add cursor and move to next match" })       -- meta key works (not option)
        set({"n", "x"}, "<A-N>", function() mc.matchSkipCursor(1) end, { desc = "move to next match skipping current" })    -- meta key works (not option)

        -- Add and remove cursors with option + left click.     -- does not work (probably some mouse reporting issue)
        -- set("n", "<A-leftmouse>", mc.handleMouse)
        -- set("n", "<A-leftdrag>", mc.handleMouseDrag)
        -- set("n", "<A-leftrelease>", mc.handleMouseRelease)

        -- Disable and enable cursors.
        set({"n", "x"}, "<A-q>", mc.toggleCursor, { desc = "add/remove cursor" })   -- press esc after finishing add/remove to enable cursors, pressing esc again deletes cursors (use meta key, not option)

        -- Mappings defined in a keymap layer only apply when there are
        -- multiple cursors. This lets you have overlapping mappings.
        mc.addKeymapLayer(function(layerSet)

            -- Select a different cursor as the main one.
            layerSet({"n", "x"}, "<left>", mc.prevCursor, { desc = "select previous cursor" })
            layerSet({"n", "x"}, "<right>", mc.nextCursor, { desc = "select next cursor" })

            -- Delete the main cursor.
            layerSet({"n", "x"}, "<leader>mx", mc.deleteCursor, { desc = "delete main cursor" })

            -- Enable and clear cursors using escape.
            layerSet("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)

        -- Customize how cursors look.
        local hl = vim.api.nvim_set_hl
        hl(0, "MultiCursorCursor", { reverse = true })
        hl(0, "MultiCursorVisual", { link = "Visual" })
        hl(0, "MultiCursorSign", { link = "SignColumn"})
        hl(0, "MultiCursorMatchPreview", { link = "Search" })
        hl(0, "MultiCursorDisabledCursor", { reverse = true })
        hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
    end
}
