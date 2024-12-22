return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = "VeryLazy",
  opts = function()
    return {
      sections = {
        lualine_a = {
          {
            "buffers",
            hide_filename_extension = false, -- Hide filename extension when set to true.
            show_modified_status = false,    -- Shows indicator when the buffer is modified.

            mode = 2,                        -- 0: Shows buffer name
            -- 1: Shows buffer index
            -- 2: Shows buffer name + buffer index
            -- 3: Shows buffer number
            -- 4: Shows buffer name + buffer number
          }
        },
        lualine_c = { { "filename", path = 4 } },
        lualine_x = {
          {
            "filetype"
          }
        }
      }
    }
  end
}
