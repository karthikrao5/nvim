return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require('gitsigns').setup {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Navigation
        vim.keymap.set('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = "Git: Go to next git chunk" })

        vim.keymap.set('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = "Git: Go to previous git chunk" })

        -- Actions
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {desc = "Git: Stage hunk"})
        vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {desc = "Git: Reset hunk"})
        vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, {desc = "Git: Reset hunk"})
        vim.keymap.set('n', '<leader>hS', gs.stage_buffer, {desc = "Git: Stage Buffer"})
        vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, {desc = "Git: Undo Stage"})
        vim.keymap.set('n', '<leader>hR', gs.reset_buffer, {desc = "Git: Reset Buffer"})
        vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {desc = "Preview hunk"})
        vim.keymap.set('n', '<leader>hb', function() gs.blame_line { full = true } end, {desc = "Git: Blame Line"})
        vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, {desc = "Git: Toggle current line blame"})
        vim.keymap.set('n', '<leader>hd', gs.diffthis, {desc = "Git: Diff"})
        vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, {desc = "Git: Another diff?"})
        vim.keymap.set('n', '<leader>td', gs.toggle_deleted, {desc = "Git: Toggle deleted"})

        -- Text object
        vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    }
  end
}
