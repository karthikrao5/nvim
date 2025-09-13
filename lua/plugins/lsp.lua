return {
    "mason-org/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    opts = {},
    config = function(_, opts)
        require("mason").setup(opts)
        require("mason-lspconfig").setup({
            automatic_installation = true,
            ensure_installed = {
                "lua_ls",
                "pyright",
            },
        })
    end,
}