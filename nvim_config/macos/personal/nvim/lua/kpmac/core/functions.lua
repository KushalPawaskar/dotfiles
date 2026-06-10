-- Save the current session
function save_session()
  -- Create the directory if it doesn't exist
  vim.fn.mkdir(vim.fn.expand('~/.local/share/nvim/sessions'), 'p')

  -- Save the session to the specified path
  vim.cmd('mksession! ~/.local/share/nvim/sessions/session.vim')
  print("Session saved to ~/.local/share/nvim/sessions/session.vim")
end

-- Recover the session
function recover_session()
  local session_file = vim.fn.expand('~/.local/share/nvim/sessions/session.vim')

  -- Check if the session file exists
  if vim.fn.filereadable(session_file) == 1 then
    vim.cmd('source ' .. session_file)
    print("Session recovered from ~/.local/share/nvim/sessions/session.vim")
  else
    print("No session file found at ~/.local/share/nvim/sessions/")
  end
end

-- Create commands to easily run the functions
vim.api.nvim_create_user_command('SaveSession', save_session, {})
vim.api.nvim_create_user_command('RecoverSession', recover_session, {})
