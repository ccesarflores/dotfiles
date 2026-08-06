-- ~/.config/nvim/after/ftplugin/markdown.lua

-- Función específica de Markdown (local, no exportada)
local function generate_wikilink_toc()
	local bufnr = vim.api.nvim_get_current_buf()
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
	if not ok then
		return
	end

	local tree = parser:parse()[1]
	local root = tree:root()

	local query = vim.treesitter.query.parse(
		"markdown",
		[[
        (atx_heading) @heading
    ]]
	)

	local toc = { "# Índice", "" }
	local has_headings = false

	for _, node, _ in query:iter_captures(root, bufnr) do
		local text = vim.treesitter.get_node_text(node, bufnr)
		-- Capturamos el nivel y el texto
		local symbols, title = text:match("^(#+)%s*(.-)%s*$") -- (.-) captura mínima para limpiar espacios finales

		if title and title ~= "" then
			has_headings = true
			local level = #symbols
			-- Ignoramos el H1 si es el título principal (opcional, si quieres incluirlo borra el 'if level > 1')
			if level > 0 then
				local indent = string.rep("  ", level - 1)
				-- Formato [[#Título]] para que sea un ancla interna
				table.insert(toc, indent .. "- [[#" .. title .. "]]")
			end
		end
	end

	if has_headings then
		vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, toc)
		vim.api.nvim_buf_set_lines(bufnr, #toc, #toc, false, { "" })
		print("Índice de Wikilinks generado con anclas (#).")
	end
end

-- Keymap que usa la función
vim.keymap.set("n", "<leader>toc", generate_wikilink_toc, {
	buffer = true,
	desc = "Generar TOC de wikilinks",
})

-- Keymaps específicas
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { buffer = true, desc = "Preview Start" })
vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", { buffer = true, desc = "Preview Stop" })

-- Otras configuraciones específicas de Markdown
-- 1. Configuración básica de texto y corrector bilingüe por defecto
-- Traemos nuestra función utilitaria
local utils = require("config.utils")
utils.setup_bilingual_spell()

vim.opt_local.wrap = true
vim.opt_local.linebreak = true
