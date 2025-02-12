-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

if package.config:sub(1, 1) == '\\' then
  --vim.opt.shell = 'cmd.exe'
  vim.opt.shell = 'pwsh'
else
  vim.opt.shell = 'zsh'
end

-- if vim.g.vscode then
--   return
-- end

if not vim.g.vscode then
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.o.termguicolors = true
end

return {
  -- {
  --   'github/copilot.vim',
  -- },
  {
    'rebelot/kanagawa.nvim',
    opts = function()
      return {
        terminal_colors = true,
        transparent = false,
        theme = 'dragon',
      }
    end,
    init = function()
      vim.cmd 'colorscheme kanagawa-dragon'
    end,
    lazy = false,
    priority = 1001,
  },
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup {
        filetypes = { '*' },
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = true, -- "Name" codes like Blue or blue
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = false, -- 0xAARRGGBB hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = 'background', -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          method = 'both',
          -- True is same as normal
          tailwind = true, -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          sass = { enable = true, parsers = { 'css' } }, -- Enable sass colors
          virtualtext = '■',
          -- update color values even if buffer is not focused
          -- example use: cmp_menu, cmp_docs
          always_update = true,
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {},
      }
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local bufferline = require 'bufferline'
      bufferline.setup {
        options = {
          themable = true, -- whether or not bufferline highlights can be overridden externally
          -- style_preset = preset,
          get_element_icon = nil,
          show_duplicate_prefix = true,
          duplicates_across_groups = true,
          auto_toggle_bufferline = true,
          move_wraps_at_ends = false,
          groups = { items = {}, options = { toggle_hidden_on_enter = true } },
          mode = 'buffers', -- set to "tabs" to only show tabpages instead
          numbers = 'none', -- can be "none" | "ordinal" | "buffer_id" | "both" | function
          right_mouse_command = 'vert sbuffer %d', -- can be a string | function, see "Mouse actions"
          left_mouse_command = 'buffer %d', -- can be a string | function, see "Mouse actions"
          middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
          indicator = {
            style = 'icon', -- can also be 'underline'|'none',
          },
          --- name_formatter can be used to change the buffer's label in the bufferline.
          --- Please note some names can/will break the
          --- bufferline so use this at your discretion knowing that it has
          --- some limitations that will *NOT* be fixed.
          max_name_length = 18,
          max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
          truncate_names = true, -- whether or not tab names should be truncated
          tab_size = 18,
          diagnostics = 'nvim_lsp',
          diagnostics_update_in_insert = false,
          offsets = {
            {
              filetype = 'undotree',
              text = 'Undotree',
              highlight = 'PanelHeading',
              padding = 1,
            },
            {
              filetype = 'NvimTree',
              text = 'Explorer',
              highlight = 'PanelHeading',
              padding = 1,
            },
            {
              filetype = 'DiffviewFiles',
              text = 'Diff View',
              highlight = 'PanelHeading',
              padding = 1,
            },
            {
              filetype = 'flutterToolsOutline',
              text = 'Flutter Outline',
              highlight = 'PanelHeading',
            },
            {
              filetype = 'lazy',
              text = 'Lazy',
              highlight = 'PanelHeading',
              padding = 1,
            },
          },
          color_icons = true, -- whether or not to add the filetype icon highlights
          show_close_icon = false,
          show_tab_indicators = true,
          persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
          -- can also be a table containing 2 custom separators
          -- [focused and unfocused]. eg: { '|', '|' }
          separator_style = 'thin',
          enforce_regular_tabs = false,
          always_show_bufferline = false,
          hover = {
            enabled = false, -- requires nvim 0.8+
            delay = 200,
            reveal = { 'close' },
          },
          sort_by = 'id',
          debug = { logging = false },
        },
      }
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('nvim-tree').setup {
        filters = {
          git_ignored = false,
        },
      }
      vim.keymap.set('n', '<leader>nt', '<cmd>:NvimTreeToggle<cr>', { desc = 'Toggle NeoTree' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        mode = 'topline',
        max_lines = 5,
      }
    end,
  },
}
