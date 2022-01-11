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
		vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
		vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
		vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
		vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
		vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
		vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
		vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
		vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
		vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
		vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
		vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
		vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

		--format on save
		if client.resolved_capabilities.document_formatting then
			vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
		end
	end,
	debug = false,
	sources = {
		formatting.prettier.with({ extra_args = { "--print-width 80", "--single-quote", "--jsx-single-quote" } }),
		codeAction.gitsigns,
		codeAction.eslint_d,
		-- formatting.black.with { extra_args = { "--fast" } },
		-- formatting.yapf,
		formatting.stylua,
		diagnostics.eslint_d,
	},
})
