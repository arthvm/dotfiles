return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.biome.with({
					filetypes = {
						"javascript",
						"javascriptreact",
						"json",
						"jsonc",
						"typescript",
						"typescriptreact",
						"css",
					},
					args = {
						"check",
						"--write",
						"--unsafe",
						"--formatter-enabled=true",
						"--organize-imports-enabled=true",
						"--skip-errors",
						"--stdin-file-path=$FILENAME",
					},
				}),
			},
		})

		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})
	end,
}
