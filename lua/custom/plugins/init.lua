-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

vim.opt.shell = 'powershell'

return {
  {
    'github/copilot.vim',
  },

  {
    'rebelot/kanagawa.nvim',
    init = function()
      vim.cmd.colorscheme 'kanagawa-dragon'
    end,
    lazy = false,
  },
}
