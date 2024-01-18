return {{
	"nvim-treesitter/nvim-treesitter",
	commit = "33eb472b459f1d2bf49e16154726743ab3ca1c6d",
	build = ":TSUpdate",
	config = function () 
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "typescript", "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" , "dart"},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },  
		})
	end
},
	{
		"nvim-treesitter/playground"
	}

}
