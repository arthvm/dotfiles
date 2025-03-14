local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})

return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*.templ" }, callback = vim.lsp.buf.format })

			local on_attach = function(_client, _bufnr)
				-- other configuration options
			end

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

			lspconfig.biome.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				default_config = {
					cmd = { "biome", "lsp-proxy" },
					filetypes = {
						"astro",
						"css",
						"graphql",
						"javascript",
						"javascriptreact",
						"json",
						"jsonc",
						"svelte",
						"typescript",
						"typescript.tsx",
						"typescriptreact",
						"vue",
					},
					root_dir = lspconfig.util.root_pattern("biome.json", "biome.jsonc"),
					single_file_support = false,
				},
			})

			lspconfig.tailwindcss.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = {
					"templ",
					"astro",
					"javascript",
					"typescript",
					"react",
					"javascriptreact",
					"typescriptreact",
				},
				settings = {
					tailwindCSS = {
						includeLanguages = {
							templ = "html",
						},
					},
				},
			})

			lspconfig.templ.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.nil_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.ts_ls.setup({})

			lspconfig.eslint.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.html.setup({
				capabilities = capabilities,
				filetypes = { "html", "templ" },
			})

			lspconfig.htmx.setup({
				capabilities = capabilities,
				filetypes = { "html", "templ" },
			})

			lspconfig.omnisharp.setup({
				cmd = { "dotnet", vim.fn.expand("~/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll") },
				enable_editorconfig_support = true,
				enable_ms_build_load_projects_on_demand = false,
				enable_roslyn_analyzers = false,
				organize_imports_on_format = true,
				enable_import_completion = true,
				sdk_include_prereleases = true,
				analyze_open_documents_only = false,
			})

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
