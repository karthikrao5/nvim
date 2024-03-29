return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "folke/neodev.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig",
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    "j-hui/fidget.nvim",
  },
  config = function()
    require('neodev').setup({})
    require('fidget').setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls", "tsserver", "eslint", "clangd"
      }
    })

    -- Setup language servers.
    local lspconfig = require('lspconfig')

    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace"
          }
        }
      }
    })
    lspconfig.dartls.setup({})

    local function organize_imports()
      local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = ""
      }
      vim.lsp.buf.execute_command(params)
    end

    lspconfig.tsserver.setup({
      commands = {
        OrganizeImports = {
          organize_imports,
          description = "Organize Imports"
        }
      }
    })
    lspconfig.eslint.setup({
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        if client.server_capabilities.documentFormattingProvider then
          local au_lsp = vim.api.nvim_create_augroup("eslint_lsp", { clear = true })
          vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
            command = 'silent! EslintFixAll',
            group = au_lsp
          })
        end
      end,

      settings = {
        codeAction = {
          showDocumentation = {
            enable = true,
          },
        },
        codeActionOnSave = {
          enable = true,
          mode = "all",
        },
        lintTask = {
          enable = true
        },
        format = true,
        autoFixOnSave = true,
        nodePath = "",
        onIgnoredFiles = "off",
        packageManager = "npm",
        quiet = false,
        rulesCustomizations = {},
        run = "onType",
        useESLintClass = false,
        validate = "on",
        workingDirectory = {
          mode = "location",
        },
      }
    })

    lspconfig.clangd.setup({
      on_attach = function()
        require("clangd_extensions.inlay_hints").setup_autocmd()
        require("clangd_extensions.inlay_hints").set_inlay_hints()
      end,
      capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    })

    local cmp = require('cmp')
    cmp.setup({
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' }
      },
      mapping = {
        ['<Tab>'] = cmp.mapping.confirm({ select = false }),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Up>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
        ['<Down>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
        ['<C-p>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item({ behavior = 'insert' })
          else
            cmp.complete()
          end
        end),
        ['<C-n>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item({ behavior = 'insert' })
          else
            cmp.complete()
          end
        end),
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
    })
    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    vim.diagnostic.config({
      virtual_text = false
    })
    vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local nmap = function(mode, keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end

          vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = desc })
        end

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        nmap('n', 'gD', vim.lsp.buf.declaration, "Go to declaration")
        nmap('n', 'gd', vim.lsp.buf.definition, "Go to definition")
        nmap('n', 'gv', function()
          vim.cmd [[
          vsplit
          ]]
          vim.lsp.buf.definition()
        end, "Go to definition")
        nmap('n', 'K', vim.lsp.buf.hover, "Hover")
        nmap('n', 'gi', vim.lsp.buf.implementation, "Go to impl")
        nmap('n', 'gt', vim.lsp.buf.type_definition, "Type defn")
        nmap('n', 'gr', vim.lsp.buf.references, "Go to references")
        nmap('n', '<C-k>', vim.lsp.buf.signature_help, "Signature help?")
        nmap('n', '<space>wa', vim.lsp.buf.add_workspace_folder, "")
        nmap('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, "")
        nmap('n', '<space>rn', vim.lsp.buf.rename, "Rename")
        nmap({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, "Code actions")
        nmap('n', '<space>f', function()
          vim.lsp.buf.format { async = true }
        end, "Format")
      end
    })
  end
}
