return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-symbols.nvim',
  },
  config = function()
    require("telescope").load_extension("flutter")
    local harpoon = require('harpoon')
    harpoon:setup({})

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
      { desc = "Open harpoon window" })
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
    } }
}
