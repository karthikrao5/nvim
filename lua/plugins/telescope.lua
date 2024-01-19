return {
  "nvim-telescope/telescope.nvim",
  dependencies = {'nvim-lua/plenary.nvim'},
  keys = { -- disable the keymap to grep files
    {"<leader>/", false}, -- change a keymap
    {
      "<leader>ff",
      "<cmd>Telescope find_files<cr>",
      desc = "Find Files"
    }, -- add a keymap to browse plugin files
    {
      "<leader>fp",
      function()
        require("telescope.builtin").find_files({
          cwd = require("lazy.core.config").options.root
        })
      end,
      desc = "Find Plugin File"
    }, 
    {
      "<leader>fg",
      function()
        require("telescope.builtin").git_files()
      end,
      desc = "Find git files"
    }, 
    {
      "<leader>gs",
      function()
        require("telescope.builtin").grep_string({
          search = vim.fn.input("Grep > ")
        })
      end,
      desc = "Grep string search"
    }}
}
