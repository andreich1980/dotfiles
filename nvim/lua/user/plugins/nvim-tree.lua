require('nvim-tree').setup({
  git = {
    ignore = false,
  },
  renderer = {
    highlight_opened_files = '1',
    group_empty = true,
    icons = {
      show = {
        folder_arrow = false,
      },
    },
    indent_markers = {
      enable = true,
    },
  },
  view = {
    side = 'right',
  },
})

vim.keymap.set('n', '<Leader>s', ':NvimTreeFindFileToggle<CR>')

