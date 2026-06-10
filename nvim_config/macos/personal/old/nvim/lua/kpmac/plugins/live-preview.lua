return {
    'brianhuster/live-preview.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        -- import live-preview config
        local livepreview_config = require("livepreview.config")

        -- configure live-preview
        livepreview_config.set({
            port=5500,
            browser="/Applications/Zen.app/Contents/MacOS/zen",
            dynamic_root=false,
            sync_scroll=true,
            picker="",
            address="127.0.0.1",
        })
    end,
}
