return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
        return {
			sections = {
				lualine_c = {{"filename", path = 4}}
			}
	}
    end
}