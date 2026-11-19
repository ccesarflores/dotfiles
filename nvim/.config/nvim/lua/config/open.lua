-- ~/.config/nvim/lua/config/open.lua
local default_open = vim.ui.open

local function launch(command, target)
	return vim.fn.jobstart({ command, target }, { detach = true })
end

vim.ui.open = function(target, opts)
	if type(target) ~= "string" then
		return default_open(target, opts)
	end

	-- Enlaces web
	if target:match("^https?://") then
		if target:match("^https?://(www%.)?youtube%.com/") or target:match("^https?://youtu%.be/") then
			return launch("mpv", target)
		end
		return launch("qutebrowser", target)
	end

	-- Para decidir por extensión, ignoramos query y fragmento.
	local path = target:gsub("[?#].*$", "")
	local ext = path:match("%.([^./]+)$")
	ext = ext and ext:lower()

	local image_ext = {
		jpg = true,
		jpeg = true,
		png = true,
		gif = true,
		svg = true,
		tiff = true,
		tif = true,
		webp = true,
		bmp = true,
		heic = true,
		heif = true,
		avif = true,
	}

	local media_ext = {
		mp4 = true,
		mkv = true,
		webm = true,
		avi = true,
		mov = true,
		mpg = true,
		mpeg = true,
		flv = true,
		wmv = true,
		["3gp"] = true,
		mp3 = true,
		flac = true,
		aac = true,
		ogg = true,
		opus = true,
		wav = true,
		["m4a"] = true,
	}

	if image_ext[ext] then
		return launch("imv", target)
	elseif media_ext[ext] then
		return launch("mpv", target)
	end

	return default_open(target, opts)
end
