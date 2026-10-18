-- ~/.config/nvim/lua/config/autocmds.lua

local autocmd = vim.api.nvim_create_autocmd

-- Resaltar texto al copiar (Yank)
autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch", -- El color que se va a ver
			timeout = 150, -- Cuánto dura el resaltado (ms)
		})
	end,
})

-- Limpia espacios en blanco al final de la linea
autocmd("BufWritePre", {
	desc = "Limpiar espacios en blanco al final de la línea",
	pattern = { "*.c", "*.cpp", "*.lua", "*.py", "*.sh", "*.tex" },
	callback = function()
		local save_cursor = vim.api.nvim_win_get_cursor(0)
		vim.cmd([[%s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, save_cursor)
	end,
})

-- Autocomando para manejar enlaces inteligentes en Markdown con <Enter> sobre la ruta
-- Importante: si el link es de la forma [ver link](/ruta/al/link.pdf), entonces posicionarse sobre la ruta y luego dar enter
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "markdown",
-- 	callback = function()
-- 		vim.keymap.set("n", "<CR>", function()
-- 			-- ... (captura del archivo bajo el cursor)
-- 			local file = vim.fn.expand("<cfile>")
--
-- 			-- Convertimos la ruta relativa (ej: ../02_Projects/archivo.tex)
-- 			-- en una ruta absoluta real dentro de tu sistema de archivos (:p)
-- 			local ruta_absoluta = vim.fn.fnamemodify(file, ":p")
--
-- 			-- 1. Si son archivos que abrimos con aplicaciones externas
-- 			if file:match("%.pdf$") or file:match("%.png$") then
-- 				vim.fn.jobstart({ "zathura", ruta_absoluta }, { detach = true })
-- 				return
--
-- 			-- Imágenes con imv (todos los formatos soportados)
-- 			elseif
-- 				file:match("%.jpg$")
-- 				or file:match("%.jpeg$")
-- 				or file:match("%.gif$")
-- 				or file:match("%.svg$")
-- 				or file:match("%.tiff$")
-- 				or file:match("%.tif$")
-- 				or file:match("%.webp$")
-- 				or file:match("%.bmp$")
-- 				or file:match("%.heic$")
-- 				or file:match("%.heif$")
-- 				or file:match("%.avif$")
-- 			then
-- 				vim.fn.jobstart({ "imv", ruta_absoluta }, { detach = true })
-- 				return
--
-- 			-- Videos y audio con mpv
-- 			elseif
-- 				file:match("%.mp4$")
-- 				or file:match("%.mkv$")
-- 				or file:match("%.webm$")
-- 				or file:match("%.avi$")
-- 				or file:match("%.mov$")
-- 				or file:match("%.mpg$")
-- 				or file:match("%.mpeg$")
-- 				or file:match("%.flv$")
-- 				or file:match("%.wmv$")
-- 				or file:match("%.3gp$")
-- 				-- Formatos de audio
-- 				or file:match("%.mp3$")
-- 				or file:match("%.flac$")
-- 				or file:match("%.aac$")
-- 				or file:match("%.ogg$")
-- 				or file:match("%.opus$")
-- 				or file:match("%.wav$")
-- 				or file:match("%.m4a$")
-- 			then
-- 				vim.fn.jobstart({ "mpv", ruta_absoluta }, { detach = true })
-- 				return
--
-- 			-- URLs de YouTube
-- 			elseif file:match("^http") or file:match("^https") then
-- 				if file:match("youtube%.com") or file:match("youtu%.be") then
-- 					vim.fn.jobstart({ "mpv", file }, { detach = true })
-- 					-- Fuerza a mpv a buscar la mejor calidad que sea igual o menor a 720p a menor costo hardware
-- 					-- vim.fn.jobstart(
-- 					-- 	{ "mpv", "--ytdl-format=bestvideo[height<=720]+bestaudio/best[height<=720]", file },
-- 					-- 	{ detach = true }
-- 					-- )
-- 					return
-- 				end
-- 				vim.fn.jobstart({ "qutebrowser", file }, { detach = true })
-- 				return
--
-- 			-- Documentos de oficina
-- 			-- Intercepta ODT y DOCX y los demas usando la ruta absoluta antes de que caiga en 'gf'
-- 			elseif
-- 				file:match("%.odt$")
-- 				or file:match("%.docx$")
-- 				or file:match("%.ODT$")
-- 				or file:match("%.DOCX$")
-- 				or file:match("%.xls$")
-- 				or file:match("%.xlsx$")
-- 				or file:match("%.ppt$")
-- 				or file:match("%.pptx$")
-- 			then
-- 				-- Ejecuta xdg-open con la ruta absoluta real del sistema
-- 				vim.fn.jobstart({ "xdg-open", ruta_absoluta }, { detach = true })
-- 				return
-- 			end
--
-- 			-- Capturamos la línea actual y la posición del cursor para ver si estamos dentro de un [[Wikilink]]
-- 			local linea_actual = vim.api.nvim_get_current_line()
-- 			local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- Base 1 para Lua
--
-- 			-- Buscamos si el cursor está parado dentro de algo con [[ ]]
-- 			-- Una forma simple es ver si el archivo capturado viene de un wikilink o si la línea contiene corchetes
-- 			if file:match("^%[%[") or linea_actual:match("%[%[.-%]%]") then
-- 				-- Ejecutamos la acción nativa de ir a definición del LSP (lo mismo que hace gd)
-- 				local clientes_lsp = vim.lsp.get_clients({ bufnr = 0 })
-- 				if #clientes_lsp > 0 then
-- 					vim.lsp.buf.definition()
-- 					return
-- 				end
-- 			end
-- 			local status, _ = pcall(vim.cmd, "normal! gf")
-- 			if not status then
-- 				-- Si 'gf' da error porque no es una ruta, hacemos un Enter común (bajar de línea)
-- 				return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
-- 			end
-- 		end, { buffer = true, silent = true, desc = "Abrir enlace inteligente" })
-- 	end,
-- })

-- Autocomando para manejar enlaces inteligentes en Markdown con <Enter> sobre la ruta
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.keymap.set("n", "<CR>", function()
			-- Captura del archivo bajo el cursor
			local file = vim.fn.expand("<cfile>")

			-- --- RESOLUCIÓN INTELIGENTE DE RUTAS ---
			local ruta_final = ""

			if file:sub(1, 1) == "~" then
				-- Si empieza con ~, expandimos el HOME del sistema (~/uncuyo/... -> /home/usuario/uncuyo/...)
				ruta_final = vim.fn.expand(file)
			elseif file:sub(1, 1) == "/" then
				-- Si empieza con /, comprobamos si existe en la raíz del sistema operativo.
				-- Si NO existe en el sistema raíz (ej: /uncuyo/...), asumimos que es relativa a la raíz del Vault.
				if vim.uv.fs_stat(file) then
					ruta_final = file
				else
					-- Le sacamos la barra inicial para convertirla en ruta relativa al Vault activo
					local ruta_relativa_vault = file:sub(2)
					ruta_final = vim.fn.fnamemodify(ruta_relativa_vault, ":p")
				end
			else
				-- Rutas relativas normales (03_Attachments/..., ../...)
				ruta_final = vim.fn.fnamemodify(file, ":p")
			end
			-- ----------------------------------------

			-- 1. Si son archivos que abrimos con aplicaciones externas
			if file:match("%.pdf") then
				-- Extrae la ruta limpia y el número de página si existe (soporta #page=X, #12 o :12)
				local pdf_path, pagina = file:match("^(.-)%.pdf[:#]?%a*=?%s*(%d*)$")

				if pdf_path then
					-- Reconstruimos la ruta terminada en .pdf
					ruta_final = vim.fn.fnamemodify(pdf_path .. ".pdf", ":p")

					local cmd = { "zathura" }

					-- Si detectó un número de página, le pasamos la bandera -P
					if pagina and pagina ~= "" then
						table.insert(cmd, "-P")
						table.insert(cmd, pagina)
					end

					table.insert(cmd, ruta_final)
					vim.fn.jobstart(cmd, { detach = true })
					return
				end

			-- Imágenes con imv (todos los formatos soportados)
			elseif
				file:match("%.jpg$")
				or file:match("%.jpeg$")
				or file:match("%.png$")
				or file:match("%.gif$")
				or file:match("%.svg$")
				or file:match("%.tiff$")
				or file:match("%.tif$")
				or file:match("%.webp$")
				or file:match("%.bmp$")
				or file:match("%.heic$")
				or file:match("%.heif$")
				or file:match("%.avif$")
			then
				vim.fn.jobstart({ "imv", ruta_final }, { detach = true })
				return

			-- Videos y audio con mpv
			elseif
				file:match("%.mp4$")
				or file:match("%.mkv$")
				or file:match("%.webm$")
				or file:match("%.avi$")
				or file:match("%.mov$")
				or file:match("%.mpg$")
				or file:match("%.mpeg$")
				or file:match("%.flv$")
				or file:match("%.wmv$")
				or file:match("%.3gp$")
				-- Formatos de audio
				or file:match("%.mp3$")
				or file:match("%.flac$")
				or file:match("%.aac$")
				or file:match("%.ogg$")
				or file:match("%.opus$")
				or file:match("%.wav$")
				or file:match("%.m4a$")
			then
				vim.fn.jobstart({ "mpv", ruta_final }, { detach = true })
				return

			-- URLs de YouTube
			elseif file:match("^http") or file:match("^https") then
				if file:match("youtube%.com") or file:match("youtu%.be") then
					vim.fn.jobstart({ "mpv", file }, { detach = true })
					return
				end
				vim.fn.jobstart({ "qutebrowser", file }, { detach = true })
				return

			-- Documentos de oficina
			elseif
				file:match("%.odt$")
				or file:match("%.docx$")
				or file:match("%.ODT$")
				or file:match("%.DOCX$")
				or file:match("%.xls$")
				or file:match("%.xlsx$")
				or file:match("%.ppt$")
				or file:match("%.pptx$")
			then
				vim.fn.jobstart({ "xdg-open", ruta_final }, { detach = true })
				return
			end

			-- Capturamos la línea actual y la posición del cursor para ver si estamos dentro de un [[Wikilink]]
			local linea_actual = vim.api.nvim_get_current_line()

			if file:match("^%[%[") or linea_actual:match("%[%[.-%]%]") then
				local clientes_lsp = vim.lsp.get_clients({ bufnr = 0 })
				if #clientes_lsp > 0 then
					vim.lsp.buf.definition()
					return
				end
			end
			local status, _ = pcall(vim.cmd, "normal! gf")
			if not status then
				return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
			end
		end, { buffer = true, silent = true, desc = "Abrir enlace inteligente" })
	end,
})

-- Extrae el target (URL o ruta) de un enlace Markdown [texto](target) bajo el cursor
local function target_de_enlace_markdown()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local init = 1
	while true do
		local s, e, _, target = line:find("%[([^%]]*)%]%(([^%)]+)%)", init)
		if not s then
			return nil
		end
		if col >= s and col <= e then
			return target
		end
		init = e + 1
	end
end

-- Detecta si el cursor está DENTRO de un [[wikilink]]
local function cursor_en_wikilink()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local init = 1
	while true do
		local s, e = line:find("%[%[.-%]%]", init)
		if not s then
			return false
		end
		if col >= s and col <= e then
			return true
		end
		init = e + 1
	end
end

-- Keymap global: actúa solo en markdown y tex
vim.keymap.set("n", "<CR>", function()
	local ft = vim.bo.filetype
	if ft ~= "markdown" and ft ~= "tex" then
		return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
	end

	-- 0. Enlace Markdown [texto](target): URL o ruta local
	local target_md = target_de_enlace_markdown()
	if target_md then
		-- 0a. URL externa
		if target_md:match("^https?://") then
			if target_md:match("youtube%.com") or target_md:match("youtu%.be") then
				vim.fn.jobstart({ "mpv", target_md }, { detach = true })
			else
				vim.fn.jobstart({ "qutebrowser", target_md }, { detach = true })
			end
			return
		end

		-- 0b. Ruta local: resolverla respecto al directorio del buffer actual
		local ruta_md
		if target_md:sub(1, 1) == "/" then
			ruta_md = target_md
		elseif target_md:sub(1, 1) == "~" then
			ruta_md = vim.fn.expand(target_md)
		else
			local bufdir = vim.fn.expand("%:p:h")
			ruta_md = vim.fn.fnamemodify(bufdir .. "/" .. target_md, ":p")
		end

		-- 0c. Despachar por extensión usando ruta_md
		if ruta_md:match("%.pdf$") then
			local ruta_limpia, pagina = ruta_md:match("^(.-)%.pdf[:#]?%a*=?%s*(%d*)$")
			if ruta_limpia then
				local cmd = { "zathura" }
				if pagina and pagina ~= "" then
					table.insert(cmd, "-P")
					table.insert(cmd, pagina)
				end
				table.insert(cmd, ruta_limpia .. ".pdf")
				vim.fn.jobstart(cmd, { detach = true })
				return
			end
		elseif
			ruta_md:match("%.jpg$")
			or ruta_md:match("%.jpeg$")
			or ruta_md:match("%.png$")
			or ruta_md:match("%.gif$")
			or ruta_md:match("%.svg$")
			or ruta_md:match("%.webp$")
			or ruta_md:match("%.bmp$")
			or ruta_md:match("%.avif$")
		then
			vim.fn.jobstart({ "imv", ruta_md }, { detach = true })
			return
		elseif
			ruta_md:match("%.mp4$")
			or ruta_md:match("%.mkv$")
			or ruta_md:match("%.webm$")
			or ruta_md:match("%.mov$")
			or ruta_md:match("%.mp3$")
			or ruta_md:match("%.flac$")
			or ruta_md:match("%.opus$")
			or ruta_md:match("%.wav$")
			or ruta_md:match("%.m4a$")
		then
			vim.fn.jobstart({ "mpv", ruta_md }, { detach = true })
			return
		elseif
			ruta_md:match("%.odt$")
			or ruta_md:match("%.docx$")
			or ruta_md:match("%.xlsx$")
			or ruta_md:match("%.pptx$")
		then
			vim.fn.jobstart({ "xdg-open", ruta_md }, { detach = true })
			return
		end

		-- 0d. Cualquier otra extensión (ej. .tex): editarla con Neovim si existe
		if vim.uv.fs_stat(ruta_md) then
			vim.cmd("edit " .. vim.fn.fnameescape(ruta_md))
			return
		end
		-- Si no existe, dejamos que caiga al resto de la lógica (gf, LSP, etc.)
	end

	-- 1. Captura del archivo bajo el cursor (para enlaces wiki y casos sin paréntesis)
	local file = vim.fn.expand("<cfile>")

	-- Resolución de rutas (para casos sin formato [texto](target))
	local ruta_final = ""
	if file:sub(1, 1) == "~" then
		ruta_final = vim.fn.expand(file)
	elseif file:sub(1, 1) == "/" then
		if vim.uv.fs_stat(file) then
			ruta_final = file
		else
			ruta_final = vim.fn.fnamemodify(file:sub(2), ":p")
		end
	else
		ruta_final = vim.fn.fnamemodify(file, ":p")
	end

	-- PDF suelto
	if file:match("%.pdf") then
		local pdf_path, pagina = file:match("^(.-)%.pdf[:#]?%a*=?%s*(%d*)$")
		if pdf_path then
			ruta_final = vim.fn.fnamemodify(pdf_path .. ".pdf", ":p")
			local cmd = { "zathura" }
			if pagina and pagina ~= "" then
				table.insert(cmd, "-P")
				table.insert(cmd, pagina)
			end
			table.insert(cmd, ruta_final)
			vim.fn.jobstart(cmd, { detach = true })
			return
		end
	-- Imágenes sueltas
	elseif
		file:match("%.jpg$")
		or file:match("%.jpeg$")
		or file:match("%.png$")
		or file:match("%.gif$")
		or file:match("%.svg$")
		or file:match("%.tiff$")
		or file:match("%.tif$")
		or file:match("%.webp$")
		or file:match("%.bmp$")
		or file:match("%.heic$")
		or file:match("%.heif$")
		or file:match("%.avif$")
	then
		vim.fn.jobstart({ "imv", ruta_final }, { detach = true })
		return
	-- Vídeos y audio sueltos
	elseif
		file:match("%.mp4$")
		or file:match("%.mkv$")
		or file:match("%.webm$")
		or file:match("%.avi$")
		or file:match("%.mov$")
		or file:match("%.mpg$")
		or file:match("%.mpeg$")
		or file:match("%.flv$")
		or file:match("%.wmv$")
		or file:match("%.3gp$")
		or file:match("%.mp3$")
		or file:match("%.flac$")
		or file:match("%.aac$")
		or file:match("%.ogg$")
		or file:match("%.opus$")
		or file:match("%.wav$")
		or file:match("%.m4a$")
	then
		vim.fn.jobstart({ "mpv", ruta_final }, { detach = true })
		return
	-- Documentos de oficina sueltos
	elseif
		file:match("%.odt$")
		or file:match("%.docx$")
		or file:match("%.ODT$")
		or file:match("%.DOCX$")
		or file:match("%.xls$")
		or file:match("%.xlsx$")
		or file:match("%.ppt$")
		or file:match("%.pptx$")
	then
		vim.fn.jobstart({ "xdg-open", ruta_final }, { detach = true })
		return
	end

	-- 2. Wikilink: SOLO si el cursor está dentro de [[...]]
	if cursor_en_wikilink() then
		local clientes_lsp = vim.lsp.get_clients({ bufnr = 0 })
		if #clientes_lsp > 0 then
			vim.lsp.buf.definition()
			return
		end
	end

	-- 3. Fallback: gf normal
	local ok = pcall(vim.cmd, "normal! gf")
	if not ok then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", false)
	end
end, { silent = true, desc = "Abrir enlace inteligente" })

local utils = require("config.utils")

-- Grupo para agrupar nuestros autocomandos de notas
local notes_group = vim.api.nvim_create_augroup("NotesAutomation", { clear = true })

-- -- Actualizar fecha de modificación automáticamente antes de guardar en Markdown
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	group = notes_group,
-- 	pattern = "*.md",
-- 	callback = function()
-- 		utils.update_markdown_modified_date()
-- 	end,
-- })

-- -- Autocomando para compilar LaTeX con Tectonic mostrando su salida nativa
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "tex",
-- 	callback = function()
-- 		vim.keymap.set("n", "<leader>cf", function()
-- 			-- 1. Guardar cambios en el archivo .tex
-- 			vim.cmd("write")
--
-- 			local ruta_tex = vim.fn.expand("%:p")
-- 			local carpeta_destino = "03_Attachments"
--
-- 			-- 2. Ejecutar de forma síncrona para heredar la salida por defecto de la terminal
-- 			-- Usamos :! para que Neovim dibuje el output crudo de la herramienta
-- 			vim.cmd(string.format("!tectonic --outdir %s %s", carpeta_destino, vim.fn.shellescape(ruta_tex)))
-- 		end, { buffer = true, silent = true, desc = "Compilar LaTeX con Tectonic nativo" })
-- 	end,
-- })

-- Agregar mapeo a imagen en modo insercion en archivo markdown
-- Equivale al mapeo en modo normal que esta en fzf-lua.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(ev)
		vim.keymap.set("i", "@@", function()
			-- Borrar las dos @ recién insertadas
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-h><C-h>", true, false, true), "n", false)
			require("fzf-lua").files({
				cwd = "~/uncuyo/1_Recursos/images",
				prompt = "🖼️ Insertar imagen> ",
				actions = {
					["default"] = function(selected)
						if not selected or not selected[1] then
							return
						end
						local file = require("fzf-lua.path").entry_to_file(selected[1])
						if not file then
							return
						end
						local filename = file.path
						local link = string.format("![%s](/1_Recursos/images/%s)", filename, filename)
						vim.api.nvim_put({ link }, "", false, true)
					end,
				},
			})
		end, { buffer = ev.buf, noremap = true })
	end,
})
