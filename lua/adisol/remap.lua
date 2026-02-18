-- vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-w>t", "<C-w>v<esc>:term<CR>a", { desc = "Open a new terminal window" })

vim.keymap.set("n", "<leader>b", "<C-^>", { noremap = true, desc = "Switch to previous buffer" })
vim.keymap.set("n", ",", "`.", { noremap = true, desc = "Last cursor position in the current buffer" })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-f>", ":!Open .<CR><CR>")

vim.keymap.set("t", "<C-w><Esc>", "<C-\\><C-n>", { noremap = true })

vim.keymap.set("n", "<leader>vc", ":CodeCompanionChat<enter>")
vim.keymap.set("n", "<leader>ve", ":CodeCompanion ")
vim.keymap.set("v", "<leader>ve", ":CodeCompanion ")
vim.keymap.set("v", "<leader>vc", ":CodeCompanionChat<enter>")
vim.keymap.set("n", "<leader>va", ":CodeCompanionActions<enter>")
vim.keymap.set("v", "<leader>va", ":CodeCompanionActions<enter>")

vim.keymap.set("n", "<leader>dt", ":lua require('dapui').toggle()<CR>")
vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>")
vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>")

-- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { noremap = true })
vim.keymap.set("n", "-", "<ESC>:lua ToggleTransparency()<CR>", { noremap = true })
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { noremap = true })

vim.keymap.set("n", "<leader>gd", ":Git diff %<CR>", { noremap = true })

vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d')

vim.keymap.set({ "n", "v", "x" }, "<C-s>", [[<esc>:'<,'>s/\V/]])

vim.keymap.set("n", "K", vim.lsp.buf.hover)

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- vim.keymap.set("i", "(", "()<Esc>i")
-- vim.keymap.set("i", "[", "[]<Esc>i")
-- vim.keymap.set("i", "{", "{}<Esc>i")

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })

vim.keymap.set("n", "gl", "$")
vim.keymap.set("n", "<leader><backspace>", ":q<CR>")
-- vim.keymap.set("n", "<C-M-S-D-j>", "<esc>")

vim.keymap.set("n", "<leader>tt", ":lua ToggleTransparency()<CR>")

vim.keymap.set("n", "<leader>cm", ":lua ToggleCipherMode()<CR>")

local cipher_mode = false
function ToggleCipherMode()
  cipher_mode = not cipher_mode
  if cipher_mode then
    vim.keymap.set("i", " ", "<esc>vbg?ea ")
  else
    vim.keymap.del("i", " ")
  end
end
