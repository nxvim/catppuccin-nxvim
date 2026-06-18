local M = {}

function M.apply(flavour)
	flavour = flavour or require("catppuccin").flavour

	local _O, _C, _U = O, C, U -- Borrowing global var (setfenv doesn't work with require)
	O = require("catppuccin").options
	C = require("catppuccin.palettes").get_palette(flavour)
	U = require "catppuccin.utils.colors"

	C.none = "NONE"

	local dim_percentage = O.dim_inactive.percentage
	C.dim = O.dim_inactive.shade == "dark"
			and U.vary_color(
				{ latte = U.darken(C.base, dim_percentage, C.mantle) },
				U.darken(C.base, dim_percentage, C.mantle)
			)
		or U.vary_color(
			{ latte = U.lighten("#FBFCFD", dim_percentage, C.base) },
			U.lighten(C.surface0, dim_percentage, C.base)
		)

	local theme = {}
	theme.editor =
		vim.tbl_deep_extend("force", require("catppuccin.groups.editor").get(), require("catppuccin.groups.lsp").get())

	theme.syntax = {}
	local syntax_modules = { "syntax", "semantic_tokens", "treesitter" }
	for i = 1, #syntax_modules do
		theme.syntax =
			vim.tbl_deep_extend("force", theme.syntax, require("catppuccin.groups." .. syntax_modules[i]).get())
	end

	theme.nxvim = require("catppuccin.groups.nxvim").get() -- nxvim native UI surfaces
	theme.terminal = require("catppuccin.groups.terminal").get() -- terminal colors
	local user_highlights = O.highlight_overrides
	if type(user_highlights[flavour]) == "function" then user_highlights[flavour] = user_highlights[flavour](C) end
	theme.custom_highlights = vim.tbl_deep_extend(
		"keep",
		user_highlights[flavour] or {},
		type(user_highlights.all) == "function" and user_highlights.all(C) or user_highlights.all or {}
	)

	O, C, U = _O, _C, _U -- Returning global var

	return theme
end

return M
