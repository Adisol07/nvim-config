vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>b', '<C-^>', { noremap = true, desc = 'Switch to previous buffer' })

vim.keymap.set('n', '<leader>vc', ':CodeCompanionChat<enter>')
vim.keymap.set('n', '<leader>ve', ':CodeCompanion ')
vim.keymap.set('v', '<leader>ve', ':CodeCompanion ')
vim.keymap.set('v', '<leader>vc', ':CodeCompanionChat<enter>')
vim.keymap.set('n', '<leader>va', ':CodeCompanionActions<enter>')
vim.keymap.set('v', '<leader>va', ':CodeCompanionActions<enter>')
