-- LSP Completion Configuration
-- Enables automatic completions from LSP servers (ty, ruff, etc.)

local M = {}

-- Helper to trigger completion manually
local function trigger_lsp_completion()
    -- Only trigger if:
    -- 1. Completion menu is not already visible
    -- 2. We're in insert mode
    -- 3. omnifunc is actually set
    if vim.fn.pumvisible() == 0 
       and vim.api.nvim_get_mode().mode:match('^[iR]')
       and vim.bo.omnifunc ~= '' then
        local keys = vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true)
        vim.api.nvim_feedkeys(keys, 'n', false)
    end
end

-- Setup completion for LSP-attached buffers
function M.setup()
    -- Enable completion when LSP attaches to a buffer
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('LspCompletion', { clear = true }),
        callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            
            -- Enable omnifunc for LSP completion
            if client and client.server_capabilities.completionProvider then
                vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
                
                -- Auto-trigger completion on text change
                vim.api.nvim_create_autocmd('TextChangedI', {
                    buffer = bufnr,
                    group = vim.api.nvim_create_augroup('LspCompletionTrigger_' .. bufnr, { clear = true }),
                    callback = function()
                        -- Double-check omnifunc is still set (in case LSP disconnected)
                        if vim.bo[bufnr].omnifunc == '' then
                            return
                        end
                        
                        local line = vim.api.nvim_get_current_line()
                        local col = vim.api.nvim_win_get_cursor(0)[2]
                        
                        if col > 0 then
                            local char_before = line:sub(col, col)
                            local char_before_before = col > 1 and line:sub(col - 1, col - 1) or ''
                            
                            -- Trigger on: dot, or after typing 2+ word characters
                            local should_trigger = char_before == '.' or 
                                                   (char_before:match('%w') and char_before_before:match('%w'))
                            
                            if should_trigger then
                                vim.defer_fn(trigger_lsp_completion, 50)
                            end
                        end
                    end,
                })
            end
        end,
        desc = 'Setup LSP completion for attached buffer',
    })
    
    -- Clean up when LSP detaches
    vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('LspCompletionDetach', { clear = true }),
        callback = function(args)
            local bufnr = args.buf
            -- Clear omnifunc if no other LSP clients are attached
            local clients = vim.lsp.get_clients({ bufnr = bufnr })
            if #clients == 0 then
                vim.bo[bufnr].omnifunc = ''
            end
            -- Clean up the autocmd group for this buffer
            pcall(vim.api.nvim_del_augroup_by_name, 'LspCompletionTrigger_' .. bufnr)
        end,
        desc = 'Cleanup LSP completion on detach',
    })
end

-- Create LspRestart command
vim.api.nvim_create_user_command('LspRestart', function()
    -- Get all active LSP clients
    local clients = vim.lsp.get_clients()
    
    if #clients == 0 then
        vim.notify('No LSP clients running', vim.log.levels.WARN)
        return
    end
    
    -- Stop all clients
    for _, client in ipairs(clients) do
        vim.notify('Stopping ' .. client.name, vim.log.levels.INFO)
        client.stop()
    end
    
    -- Wait a bit then trigger LSP restart by re-sourcing current buffer
    vim.defer_fn(function()
        -- Just edit current buffer (doesn't affect unsaved changes)
        local bufnr = vim.api.nvim_get_current_buf()
        local ft = vim.bo[bufnr].filetype
        
        if ft ~= '' then
            -- Re-trigger FileType event to restart LSP
            vim.cmd('doautocmd FileType ' .. ft)
            vim.notify('LSP servers restarted', vim.log.levels.INFO)
        end
    end, 500)
end, { desc = 'Restart all LSP servers' })

-- Initialize
M.setup()

return M

