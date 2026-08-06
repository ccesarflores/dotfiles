-- ~/.config/nvim/lua/plugins/markdown-preview.lua
-- requiere `nodejs` y `npm`. `sudo pacman -S nodejs npm`
return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
		-- Aquí configuras el navegador para que use qutebrowser
		vim.g.mkdp_browser = "qutebrowser"
		-- Opcional: si quieres asegurarte de que se use la ruta completa
		-- vim.g.mkdp_browser = "/usr/bin/qutebrowser"
	end,
	ft = { "markdown" },
}
