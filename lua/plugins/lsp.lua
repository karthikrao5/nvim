return {{
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {{
        "<leader>cm",
        "<cmd>Mason<cr>",
        desc = "Mason"
    }},
    build = ":MasonUpdate",
    opts = {
        ensure_installed = {"stylua", "shfmt", "tsserver", "eslint", "html"}
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
        require("mason").setup(opts)
        local mr = require("mason-registry")
        local function ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end
        if mr.refresh then
            mr.refresh(ensure_installed)
        else
            ensure_installed()
        end
    end
}, "williamboman/mason-lspconfig.nvim", {
    "neovim/nvim-lspconfig",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {{
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        config = false,
        dependencies = {"nvim-lspconfig"}
    }, {
        "folke/neodev.nvim",
        opts = {}
    }, "mason.nvim", "williamboman/mason-lspconfig.nvim"}
}, {"neovim/nvim-lspconfig"}, {
    "jose-elias-alvarez/null-ls.nvim",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"mason.nvim"},
    opts = function()
        local nls = require("null-ls")
        return {
            root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
            sources = {nls.builtins.formatting.fish_indent, nls.builtins.diagnostics.fish,
                       nls.builtins.formatting.stylua, nls.builtins.formatting.shfmt -- nls.builtins.diagnostics.flake8,
            },
            on_attach = function(client, bufnr)
                -- Enable formatting on sync
                if client.supports_method("textDocument/formatting") then
                    local format_on_save = vim.api.nvim_create_augroup("LspFormatting", {
                        clear = true
                    })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = format_on_save,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                bufnr = bufnr,
                                filter = function(_client)
                                    return _client.name == "null-ls"
                                end
                            })
                        end
                    })
                end
            end
        }
    end
}, {
    "jay-babu/mason-null-ls.nvim",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim"},
    config = function()
        ensure_installed = {}
    end
}}
