return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "Telescope",
		init = function()
			local builtin = require("telescope.builtin")
			local wk = require("which-key")
			wk.register({
				["pf"] = { builtin.find_files, "Find File" },
				["pb"] = { builtin.buffers, "Find Buffer" },
				["pg"] = { builtin.git_files, "Find Git Files" },
				["ps"] = { builtin.live_grep, "Find with Grep" },
				["fh"] = { builtin.help_tags, "Find Help" },
			}, { prefix = "<leader>" })

			local keymaps = {
				["<leader>pf"] = { builtin.find_files, {} },
				["<leader>pb"] = { builtin.buffers, {} },
				["<leader>pg"] = { builtin.git_files, {} },
				["<leader>ps"] = { builtin.live_grep, {} },
				["<leader>pws"] = {
					function()
						local word = vim.fn.expand("<cword>")
						builtin.grep_string({ search = word })
					end,
					{},
				},
				["<leader>pWs"] = {
					function()
						local word = vim.fn.expand("<cWORD>")
						builtin.grep_string({ search = word })
					end,
					{},
				},
				["<leader>fh"] = { builtin.help_tags, {} },
			}
			for key, map in pairs(keymaps) do
				vim.keymap.set("n", key, map[1], map[2])
			end
		end,
		opts = function()
			return {
				defaults = {
					vimgrep_arguments = {
						"rg",
						"-L",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					previewer = true,
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
				},
				extensions = {
					file_browser = {
						theme = "ivy",
						hijack_netrw = true,
					},
				},
				extensions_list = {
					"file_browser",
				},
			}
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)

			-- load extensions
			for _, ext in ipairs(opts.extensions_list) do
				telescope.load_extension(ext)
			end
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
}
