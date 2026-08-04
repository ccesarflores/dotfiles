-- ~\.config/nvim/lua/plugins/oil.lua
return {
	"stevearc/oil.nvim",
	keys = { { "-", "<cmd>Oil --float<CR>", desc = "Open Parent Directory in Oil" } },
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		-- keymaps = {
		-- 	-- Mapea 'gO' (u otra tecla que prefieras) para abrir con el sistema
		-- 	["gO"] = { "actions.open_external", desc = "Abrir con programa externo (Zathura/MPV/etc)" },
		-- },

		-- keymaps = {
		-- 	["<CR>"] = function()
		-- 		local oil = require("oil")
		-- 		local entry = oil.get_cursor_entry()
		--
		-- 		if entry then
		-- 			local name = entry.name
		-- 			-- Detectar la extensión del archivo (ignorando mayúsculas/minúsculas)
		-- 			if name:match("%.pdf$") or name:match("%.PDF$") then
		-- 				local path = oil.get_current_dir() .. name
		-- 				-- Ejecuta zathura en segundo plano liberando Neovim
		-- 				vim.fn.jobstart({ "zathura", path }, { detach = true })
		-- 				return
		-- 			elseif name:match("%.mp4$") or name:match("%.mkv$") then
		-- 				-- Ejemplo extra: abrir videos con mpv automáticamente
		-- 				local path = oil.get_current_dir() .. name
		-- 				vim.fn.jobstart({ "mpv", path }, { detach = true })
		-- 				return
		-- 			end
		-- 		end
		-- 		-- Si no es un PDF o formato especial, usa el comportamiento normal de Oil
		-- 		oil.select()
		-- 	end,
		-- },
		--
		keymaps = {
			["<CR>"] = function()
				local oil = require("oil")
				local entry = oil.get_cursor_entry()

				if entry then
					local name = entry.name
					local path = oil.get_current_dir() .. name

					-- 1. PDFs con Zathura
					if name:match("%.pdf$") or name:match("%.PDF$") then
						vim.fn.jobstart({ "zathura", path }, { detach = true })
						return

					-- 2. Imágenes con imv (todos los formatos soportados)
					elseif
						name:match("%.jpg$")
						or name:match("%.jpeg$")
						or name:match("%.png$")
						or name:match("%.gif$")
						or name:match("%.svg$")
						or name:match("%.tiff$")
						or name:match("%.tif$")
						or name:match("%.webp$")
						or name:match("%.bmp$")
						or name:match("%.heic$")
						or name:match("%.heif$")
						or name:match("%.avif$")
					then
						vim.fn.jobstart({ "imv", path }, { detach = true })
						return

					-- 3. Videos y audio con mpv
					elseif
						name:match("%.mp4$")
						or name:match("%.mkv$")
						or name:match("%.webm$")
						or name:match("%.avi$")
						or name:match("%.mov$")
						or name:match("%.mpg$")
						or name:match("%.mpeg$")
						or name:match("%.flv$")
						or name:match("%.wmv$")
						or name:match("%.3gp$")
						-- Formatos de audio (todos con --force-window)
						or name:match("%.mp3$")
						or name:match("%.flac$")
						or name:match("%.aac$")
						or name:match("%.ogg$")
						or name:match("%.opus$")
						or name:match("%.wav$")
						or name:match("%.m4a$")
					then
						vim.fn.jobstart({ "mpv", "--force-window", path }, { detach = true })
						return

					-- 4. Documentos de oficina
					elseif
						name:match("%.odt$")
						or name:match("%.docx$")
						or name:match("%.ODT$")
						or name:match("%.DOCX$")
						or name:match("%.xls$")
						or name:match("%.xlsx$")
						or name:match("%.ppt$")
						or name:match("%.pptx$")
					then
						vim.fn.jobstart({ "xdg-open", path }, { detach = true })
						return
					end
				end
				-- Si no es ningún formato especial, usar el comportamiento normal de Oil
				oil.select()
			end,
			["<C-v>"] = { "actions.select", opts = { vertical = true } },
			["<C-x>"] = { "actions.select", opts = { horizontal = true } },
		},
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	--lazy = false,
}
