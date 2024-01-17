return {{
	"nvim-treesitter/nvim-treesitter",

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
