-- ~/.config/nvim/lua/plugins/obsidian.lua
return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- Usa la última release estable
	ft = "markdown", -- Carga el plugin solo para archivos markdown
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "uncuyo",
				path = "~/uncuyo", -- Ruta a la raíz de tu vault
			},
		},

		-- ¡Importante! Desactiva la UI para evitar conflictos con render-markdown
		ui = {
			enabled = false,
		},

		-- Configuración de la integración con blink.cmp
		completion = {
			nvim_cmp = false, -- Desactiva nvim-cmp
			blink = true, -- Activa blink.cmp
			min_chars = 2, -- Caracteres mínimos para disparar la sugerencia
		},

		-- (Opcional) Configuración del picker para usar fzf-lua
		picker = {
			name = "fzf-lua",
			note_mappings = {
				new = "<C-x>",
				insert_link = "<C-l>",
			},
		},

		-- (Opcional) Mapeos útiles dentro de las notas
		mappings = {
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
			["gd"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
		},
		attachments = {
			-- Ruta absoluta a tu carpeta de imágenes existente
			img_folder = "1_Recursos/images",

			-- Funcion para normalizar el nombre
			img_name_func = function()
				-- Nombre base: "Pasted image 20260926121435"
				local name = "Pasted image " .. os.date("%Y%m%d%H%M%S")
				-- Normalizar: minúsculas y guiones
				name = name:lower()
				name = name:gsub("%s+", "-") -- espacios → guiones
				name = name:gsub("[^%w%-_]", "") -- quita caracteres raros
				name = name:gsub("%-+", "-") -- colapsa guiones repetidos
				name = name:gsub("^%-+", ""):gsub("%-+$", "") -- recorta extremos
				return name
			end,

			-- -- Esta función inserta un enlace Markdown estándar
			-- img_text_func = function(path)
			-- 	-- 'path' es el objeto de la imagen, con su nombre y ruta completa
			-- 	-- Construimos la ruta relativa a la raíz del vault
			-- 	local rel_path = "/1_Recursos/images/" .. path.name
			-- 	return string.format("![%s](%s)", path.name, rel_path)
			-- end,

			-- Opcional: nombre personalizado para las imágenes pegadas
			-- img_name_func = function()
			--   return string.format("img_%s", os.date("%Y%m%d%H%M%S"))
			-- end,

			-- Opcional: insertar como enlace wiki de Obsidian (![[...]])
			-- Si lo dejas comentado, usará enlaces Markdown estándar (![](ruta))
			-- img_text_func = function(path)
			--   return string.format("![[%s]]", path.name)
			-- end,
		},
		-- Dentro de opts = { ... }
		templates = {
			folder = "templates", -- Relativo a la raíz del vault
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
		frontmatter = {
			-- Orden de las claves en el YAML
			sort = { "id", "title", "aliases", "tags", "created", "type", "updated" },
			-- Actualiza 'updated' automáticamente al guardar
			func = function(note)
				local out = {
					id = note.id,
					title = note.title,
					aliases = note.aliases,
					tags = note.tags,
					updated = os.date("%Y-%m-%d %H:%M"),
				}
				if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end
				-- Asegura que 'updated' siempre tenga la hora actual
				out.updated = os.date("%Y-%m-%d %H:%M")
				return out
			end,
		},
		-- Dentro de opts = { ... }
		daily_notes = {
			folder = "0_Inbox/Daily", -- O donde prefieras
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily" },
			template = "daily", -- Plantilla opcional para notas diarias
		},
	},

	-- Fuera de opts = { ... },
	keys = {
		-- Crear nota preguntando tipo y título
		{
			"<leader>on",
			function()
				vim.ui.select({ "inbox", "zettel", "moc", "proyecto" }, {
					prompt = "📝 Tipo de nota:",
				}, function(choice)
					if not choice then
						return
					end
					vim.ui.input({ prompt = "Título: " }, function(title)
						if title and title ~= "" then
							require("obsidian.actions").new_from_template(title, choice)
						end
					end)
				end)
			end,
			desc = "Obsidian: Nueva nota (elige tipo)",
		},
		-- Ir a la raíz del vault
		-- { "<leader>ov", ":Ex<CR>", desc = "Vault Root" },
		{
			"<leader>ov",
			function()
				require("oil").open(vim.fn.expand("~/uncuyo"))
			end,
			desc = "Vault Root (Oil)",
		},
		-- Ir a notas diarias
		{ "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: Nota de hoy" },
		-- Dentro de la tabla keys = { ... }
		-- Crear nota desde plantilla (versión simplificada, sin preguntar tipo)
		{ "<leader>oN", "<cmd>ObsidianNewFromTemplate<cr>", desc = "Obsidian: Nueva desde plantilla" },
		-- Buscar en el vault
		{ "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: Buscar en vault" },
		-- Quick switch (cambio rápido de nota)
		{ "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: Quick switch" },
		-- Backlinks (notas que te enlazan)
		{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian: Backlinks" },
		-- Enlaces salientes
		{ "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Obsidian: Enlaces salientes" },
		-- Renombrar nota (actualiza enlaces)
		{ "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Obsidian: Renombrar" },
		-- Extraer selección a nota nueva (modo visual)
		{ "<leader>oe", ":ObsidianExtractNote<cr>", desc = "Obsidian: Extraer nota", mode = "v" },
		-- Tabla de contenidos
		{ "<leader>ot", "<cmd>ObsidianTOC<cr>", desc = "Obsidian: TOC" },
		-- Toggle checkbox
		{ "<leader>ox", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Obsidian: Toggle checkbox" },
		-- Buscar por tags
		{ "<leader>o#", "<cmd>ObsidianTags<cr>", desc = "Obsidian: Buscar por tag" },
		-- Añadir archivos adjuntos mediante un selector de archivos. Esto te permite insertar imágenes sin necesidad de pegarlas desde el portapapeles
		{
			"<leader>oA",
			function()
				require("obsidian.actions").add_attachment()
			end,
			desc = "Obsidian: Añadir adjunto",
		},
	},
}
