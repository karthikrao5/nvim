return {{
	'akinsho/flutter-tools.nvim',
	lazy = false,
	dependencies = {
		'nvim-lua/plenary.nvim',
		'stevearc/dressing.nvim', -- optional for vim.ui.select
	},
	config = true,
},-- for dart syntax hightling
	{
		"dart-lang/dart-vim-plugin"
	},
}
