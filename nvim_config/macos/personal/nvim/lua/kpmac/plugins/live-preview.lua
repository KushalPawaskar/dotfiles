return {
    'brianhuster/live-preview.nvim',
    config = function()
        require("livepreview.config").set({
            port = 5500,
            browser = "default",
            dynamic_root = false,
            sync_scroll = true,
            picker = "",
            address = "127.0.0.1",
        })
    end,
}
