-- ~/.config/nvim/lua/plugins/image.lua
return {
	"3rd/image.nvim",
	build = false,
	opts = {
		backend = "sixel",
		processor = "magick_cli",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = true,
				only_render_image_at_cursor_mode = "popup",
				filetypes = { "markdown", "vimwiki" },
			},
			neorg = { enabled = true, filetypes = { "norg" } },
		},
		max_width = 100,
		max_height = 12,
		window_overlap_clear_enabled = true,
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
	},
}
