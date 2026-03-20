return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	keys = {
		{ "<leader>sf", function() require("telescope.builtin").find_files() end },
		{ "<C-p>", function() require("telescope.builtin").git_files() end },
		{ "<leader><leader>", function() require("telescope.builtin").buffers() end, desc = "[ ] Find existing buffers" },
		{
			"<leader>x",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end,
			desc = "[x] Fuzzily search in current buffer",
		},
		{
			"<leader>sg",
			function()
				require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
			end,
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim"
	},

	config = function()
		require('telescope').setup({})
	end
}
