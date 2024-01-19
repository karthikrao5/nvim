return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig",
  },
  config = function() 
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls", "tsserver", "eslint"
      }
    })

    -- Setup language servers.
    local lspconfig = require('lspconfig')
    lspconfig.tsserver.setup({})
    lspconfig.eslint.setup({
      on_attach = function(client, bufnr) 
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll"
        })
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
        format = false,
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

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

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

          vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc }, opts)
        end

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        nmap('n', 'gD', vim.lsp.buf.declaration, "Go to declaration")
        nmap('n', 'gd', vim.lsp.buf.definition, "Go to definition")
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
