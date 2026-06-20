local M = {}

-- Highlight groups for nxvim's own native UI surfaces — the ones with no vim
-- equivalent that the standard editor/syntax/lsp groups would cover. Colours
-- follow catppuccin's conventions (mauve keys, blue groups, lavender accents)
-- so the native picker, which-key popup and statusline match the rest of the
-- theme. Everything else (Pmenu, StatusLine, Visual, Search, Diagnostic*,
-- terminal_color_*, @captures) is themed by the standard groups; the file tree
-- is themed via the NvimTree* integration.
function M.get()
	return {
		-- which-key popup
		WhichKey = { link = "NormalFloat" }, -- the key chord
		WhichKeyGroup = { fg = C.blue }, -- a "+prefix" group entry
		WhichKeyDesc = { fg = C.pink }, -- the action description
		WhichKeySeparator = { fg = C.overlay0 },
		WhichKeyBorder = { link = "FloatBorder" }, -- the popup border
		WhichKeyValue = { fg = C.overlay0 }, -- a key's mapped value

		-- statusline segments
		StatusLineMode = { fg = C.base, bg = C.mauve, style = { "bold" } }, -- NORMAL/INSERT/… badge
		StatusLineModified = { fg = C.peach }, -- the [+] dirty flag

		-- telescope's well-known group names, kept so custom plugins can reuse
		-- these conventional catppuccin values instead of redefining their own.
		TelescopeBorder = { link = "FloatBorder" },
		TelescopeNormal = { link = "NormalFloat" },
		TelescopePreviewNormal = { link = "TelescopeNormal" },
		TelescopePromptNormal = { link = "TelescopeNormal" },
		TelescopeResultsNormal = { link = "TelescopeNormal" },
		TelescopeTitle = { link = "FloatTitle" },
		TelescopeSelectionCaret = { fg = C.flamingo, bg = C.surface0 },
		TelescopeSelection = { fg = C.flamingo, bg = C.surface0, style = { "bold" } },
		TelescopeMatching = { fg = C.blue },
		TelescopePromptPrefix = { fg = C.flamingo },
		TelescopePreviewTitle = O.float.solid and { fg = C.crust, bg = C.green } or nil,
		TelescopePromptTitle = O.float.solid and { fg = C.crust, bg = C.red } or nil,
		TelescopeResultsTitle = O.float.solid and { fg = C.crust, bg = C.lavender } or nil,
	}
end

return M
