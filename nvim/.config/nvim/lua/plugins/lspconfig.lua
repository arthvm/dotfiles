local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})

return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
							disable = { "different-requires" },
						},
					},
				},
			})

			lspconfig.ts_ls.setup({})
			lspconfig.eslint.setup({})

			lspconfig.rust_analyzer.setup({})

			lspconfig.gopls.setup({
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				settings = {
					env = {
						GOEXPERIMENT = "rangefunc",
					},
					formatting = {
						gofumpt = true,
					},
				},
			})

			lspconfig.tailwindcss.setup({
				settings = {
					includeLanguages = {
						templ = "html",
					},
				},
			})

			lspconfig.templ.setup({})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = augroup,
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", function()
						vim.lsp.buf.definition()
					end, opts)
					vim.keymap.set("n", "K", function()
						vim.lsp.buf.hover()
					end, opts)
					vim.keymap.set("n", "<leader>vws", function()
						vim.lsp.buf.workspace_symbol()
					end, opts)
					vim.keymap.set("n", "<leader>vd", function()
						vim.diagnostic.open_float()
					end, opts)
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.goto_next()
					end, opts)
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.goto_prev()
					end, opts)
					vim.keymap.set("n", "<leader>vca", function()
						vim.lsp.buf.code_action()
					end, opts)
					vim.keymap.set("n", "<leader>vrr", function()
						vim.lsp.buf.references()
					end, opts)
					vim.keymap.set("n", "<leader>vrn", function()
						vim.lsp.buf.rename()
					end, opts)
				end,
			})
		end,
	},
}
