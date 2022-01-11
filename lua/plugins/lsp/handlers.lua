local M = {}

-- TODO: backfill this to template
M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "✘" },
		{ name = "DiagnosticSignWarn", text = "❗" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "❓" },
	}
	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text
		virtual_text = true,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
			false
		)
	end
end

local keymap = vim.api.nvim_buf_set_keymap

local lua_command = function(name, fn)
	vim.cmd(string.format("command! %s %s", name, fn))
end

lua_command("LspFormatting", "vim.lsp.buf.formatting()")
lua_command("LspHover", "vim.lsp.buf.hover()")
lua_command("LspRename", "vim.lsp.buf.rename()")
lua_command("LspDiagPrev", "vim.diagnostic.goto_prev()")
lua_command("LspDiagNext", "vim.diagnostic.goto_next()")
lua_command("LspDiagLine", "vim.diagnostic.open_float(nil, global.lsp.border_opts)")
lua_command("LspDiagQuickfix", "vim.diagnostic.setqflist()")
lua_command("LspSignatureHelp", "vim.lsp.buf.signature_help()")
lua_command("LspTypeDef", "vim.lsp.buf.type_definition()")

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	keymap(bufnr, "n", "gd", ":LspDef<CR>", opts)
	keymap(bufnr, "n", "gr", ":LspRename<CR>", opts)
	keymap(bufnr, "n", "gy", ":LspTypeDef<CR>", opts)
	keymap(bufnr, "n", "K", ":LspHover<CR>", opts)
	keymap(bufnr, "n", "[a", ":LspDiagPrev<CR>", opts)
	keymap(bufnr, "n", "]a", ":LspDiagNext<CR>", opts)
	keymap(bufnr, "n", "ga", ":LspCodeAction<CR>", opts)
	keymap(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>", opts)
	keymap(bufnr, "i", "<C-k>", "<cmd> LspSignatureHelp<CR>", opts)
	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false

		local ts_utils = require("nvim-lsp-ts-utils")
		ts_utils.setup({})
		ts_utils.setup_client(client)

		keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>")
		keymap(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
		keymap(bufnr, "n", "go", ":TSLspImportAll<CR>")
		-- capabilities.textDocument.completion.completionItem.snippetSupport = true
		-- capabilities.textDocument.completion.completionItem.preselectSupport = true
		-- capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
		-- capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
		-- capabilities.textDocument.completion.completionItem.deprecatedSupport = true
		-- capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
		-- capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
		-- capabilities.textDocument.completion.completionItem.resolveSupport = {
		-- 	properties = {
		-- 		"documentation",
		-- 		"detail",
		-- 		"additionalTextEdits",
		-- },
		-- }
	end

	if client.name == "tailwindcss" then
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.colorProvider = { dynamicRegistration = false }
	end

	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
