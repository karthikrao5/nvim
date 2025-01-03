return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-symbols.nvim',
    'nvim-tree/nvim-web-devicons'
  },
  defaults = {
    file_ignore_patterns = {
      "^node_modules/"
    }
  },
  config = function()
    -- require("telescope").load_extension("flutter")
  end,
  keys = {                  -- disable the keymap to grep files
    { "<leader>/", false }, -- change a keymap
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
    },
    {
      "<leader>gf",
      function()
        require("telescope.builtin").live_grep({
          search = vim.fn.input("Grep > ")
        })
      end,
      desc = "Search in files"
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Buffers find"
    } }
}
