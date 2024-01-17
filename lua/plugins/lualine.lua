return {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    opts = function()
        return {
			sections = {
				lualine_c = {{"filename", path = 4}}
			}
	}
    end
}
