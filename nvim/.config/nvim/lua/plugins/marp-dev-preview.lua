-- ~/.config/nvim/lua/plugins/marp-dev-preview.lua
-- requiere `npm install -g marp-dev-preview`
return {
	{
		"boborbt/marp-dev-preview.nvim",
		-- No necesita compilación, es Lua puro
		build = false,
		-- Opcional: cargar solo cuando se abra un archivo Markdown
		-- ft = "markdown",
		opts = {
			-- Forzar que use qutebrowser en lugar del navegador por defecto
			browser = "qutebrowser",
		},
	},
}
