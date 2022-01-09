local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
local codeAction = null_ls.builtins.code_actions
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	-- you can reuse a shared lspconfig on_attach callback here
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
		end
	end,
	debug = false,
	sources = {
		formatting.prettier.with({ extra_args = { "--print-width 80", "--single-quote", "--jsx-single-quote" } }),
		codeAction.gitsigns,
		-- formatting.black.with { extra_args = { "--fast" } },
		-- formatting.yapf,
		formatting.stylua,
		-- diagnostics.flake8,
	},
})
