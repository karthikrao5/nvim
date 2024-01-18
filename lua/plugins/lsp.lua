return { { {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v3.x',
	lazy = true,
	config = false,
	init = function()
		-- Disable automatic setup, we are doing it manually
		vim.g.lsp_zero_extend_cmp = 0
		vim.g.lsp_zero_extend_lspconfig = 0
	end
}, {
		'williamboman/mason.nvim',
		lazy = false,
		config = true
	}, -- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = { { 'L3MON4D3/LuaSnip' } },
		config = function()
			-- Here is where you configure the autocompletion settings.
			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_cmp()
			local cmp = require('cmp')
			local cmp_select_opts = {behavior = cmp.SelectBehavior.Select}

			cmp.setup({
				sources = {
					{name = 'nvim_lsp'},
				},
				mapping = {
					['<C-y>'] = cmp.mapping.confirm({select = true}),
					['<C-e>'] = cmp.mapping.abort(),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
					['<Up>'] = cmp.mapping.select_prev_item(cmp_select_opts),
					['<Down>'] = cmp.mapping.select_next_item(cmp_select_opts),
					['<C-p>'] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_prev_item(cmp_select_opts)
						else
							cmp.complete()
						end
					end),
					['<C-n>'] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_next_item(cmp_select_opts)
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
				window = {
					documentation = {
						max_height = 15,
						max_width = 60,
					}
				},
				formatting = {
					fields = {'abbr', 'menu', 'kind'},
					format = function(entry, item)
						local short_name = {
							nvim_lsp = 'LSP',
							nvim_lua = 'nvim'
						}

						local menu_name = short_name[entry.source.name] or entry.source.name

						item.menu = string.format('[%s]', menu_name)
						return item
					end,
				},
			})
		end
	}, -- LSP
	{
		'neovim/nvim-lspconfig',
		cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = { { 'hrsh7th/cmp-nvim-lsp' }, { 'williamboman/mason-lspconfig.nvim' } },
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_lspconfig()
			--			lsp_zero.setup_servers({"dartls", force=true})
			--- if you want to know more about lsp-zero and mason.nvim
			--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
			lsp_zero.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({
					buffer = bufnr,
					preserve_mappings = false
				})
				local opts = { buffer = bufnr }

				vim.keymap.set({ 'n', 'x' }, 'gq', function()
					vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
				end, opts)
			end)

			require('mason-lspconfig').setup({
				ensure_installed = { "tsserver" },
				handlers = {
					lsp_zero.default_setup,
					tsserver = function()
						require('lspconfig').tsserver.setup({
							settings = {
								completions = {
									completeFunctionCalls = true
								}
							}
						})
					end,
					lua_ls = function()
						-- (Optional) Configure lua language server for neovim
						local lua_opts = lsp_zero.nvim_lua_ls()
					require('lspconfig').lua_ls.setup(lua_opts)
					end
				}
			})
		end
} } }
