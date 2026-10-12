-- [[ Options ]]
-- See `:help option-list`

vim.opt.number = true
vim.opt.relativenumber = true -- only in the focused window, see config/autocmds.lua
vim.opt.mouse = 'a'
vim.opt.showmode = false -- already in the statusline

-- Sync clipboard with the OS (scheduled because it can slow startup)
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.breakindent = true
vim.opt.undofile = true

-- Case-insensitive searching unless \C or a capital letter is used
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.inccommand = 'split' -- live preview of :substitute

vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
vim.opt.fillchars = { eob = ' ' } -- hide the ~ lines past the end of the buffer

vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.colorcolumn = '80'
vim.opt.winborder = 'rounded'

-- Undotree shells out to `diff`, which Git for Windows installs outside PATH.
if vim.fn.executable 'diff' == 0 then
  local git = vim.fn.exepath 'git'
  if git ~= '' then
    local git_root = vim.fs.dirname(vim.fs.dirname(git))
    local diff_dir = git_root .. '/usr/bin'
    local diff_exe = diff_dir .. '/diff.exe'
    if vim.fn.executable(diff_exe) == 1 then
      vim.env.PATH = diff_dir .. (vim.fn.has 'win32' == 1 and ';' or ':') .. vim.env.PATH
    end
  end
end
