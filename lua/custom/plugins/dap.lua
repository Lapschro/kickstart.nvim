return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'mxsdev/nvim-dap-vscode-js',
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'NicholasMata/nvim-dap-cs',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'theHamsta/nvim-dap-virtual-text',
    },
    init = function() end,
    config = function()
      local dap = require 'dap'

      local ui = require 'dapui'

      ui.setup()

      require('mason').setup()

      local api = vim.api

      local keymap_restore = {}

      require('nvim-dap-virtual-text').setup()

      for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Auto Attach',
            cwd = vim.fn.getcwd(),
            protocol = 'inspector',
          },
        }
      end

      dap.set_log_level 'DEBUG'

      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[b] Debug: Toggles breakpoint' })
      vim.keymap.set('n', '<F5>', dap.continue, { desc = '[c] Debug: Continue' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[c] Debug: Continue' })
      vim.keymap.set('n', '<F10>', dap.step_over, { desc = '[o] Debug: Step Over' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = '[o] Debug: Step Over' })
      vim.keymap.set('n', '<F11>', dap.step_into, { desc = '[i] Debug: Step Into' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = '[i] Debug: Step Into' })
      vim.keymap.set('n', '<F12>', dap.repl.open, { desc = '[o] Debug: Open State' })
      vim.keymap.set('n', '<leader>dv', dap.repl.open, { desc = '[v] Debug: Open State' })
      vim.keymap.set('n', '<leader>drc', dap.run_to_cursor, { desc = '[rc] Debug: Run to cursor' })

      dap.listeners.after['event_initialized']['me'] = function()
        for _, buf in pairs(api.nvim_list_bufs()) do
          local keymaps = api.nvim_buf_get_keymap(buf, 'n')
          for _, keymap in pairs(keymaps) do
            if keymap == 'K' then
              table.insert(keymap_restore, keymap)
              api.nvim_buf_del_keymap(buf, 'n', 'K')
            end
          end
        end
        api.nvim_set_keymap('n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
      end

      dap.listeners.after['event_terminated']['me'] = function()
        for _, keymap in pairs(keymap_restore) do
          api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, { silent = keymap.silent == 1 })
        end
        keymap_restore = {}
      end

      local js_based_languages = {
        'typescript',
        'javascript',
        'typescriptreact',
        'javascriptreact',
      }

      if vim.fn.filereadable '.vscode/launch.json' then
        require('dap.ext.vscode').load_launchjs(nil, {
          ['pwa-node'] = js_based_languages,
          ['chrome'] = js_based_languages,
          ['pwa-chrome'] = js_based_languages,
          ['node'] = js_based_languages,
        })
      end

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end

      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end

      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end

      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end

      function Debugger_path()
        if package.config:sub(1, 1) == '\\' then
          return 'G:\\Programas\\vscode-js-debug'
        else
          local file = io.open('.config', 'r')
          local path = '/Users/gokita/Development/vscode-js-debug'
          if file ~= nil then
            local content = file.read(string)
            path = content
          end
          return path
        end
      end

      require('dap-vscode-js').setup {
        debugger_path = Debugger_path(),
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
        node_path = 'node',
      }

      local dap_cs = require 'dap-cs'
      dap_cs.setup {
        netcoredbg = {
          path = 'netcoredbg',
        },
      }

      require('mason-nvim-dap').setup {
        ensure_installed = { 'python', 'coreclr', 'node2', 'js', 'elixir' },
        automatic_installation = true,
        handlers = {},
      }
    end,
  },
}
