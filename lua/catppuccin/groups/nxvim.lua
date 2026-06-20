local M = {}

-- Highlight groups for nxvim's own native UI surfaces — the ones with no vim
-- equivalent that the standard editor/syntax/lsp groups would cover. Colours
-- follow catppuccin's conventions (mauve keys, blue groups, lavender accents)
-- so the native picker, which-key popup and statusline match the rest of the
-- theme. Everything else (Pmenu, StatusLine, Visual, Search, Diagnostic*,
-- terminal_color_*, @captures) is themed by the standard groups; the file tree
-- and fuzzy picker are themed via the NvimTree*/Telescope* integrations.
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
	}
end

return M
