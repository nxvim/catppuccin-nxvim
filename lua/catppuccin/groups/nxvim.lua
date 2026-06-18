local M = {}

-- Highlight groups for nxvim's own native UI surfaces — the ones with no vim
-- equivalent that the standard editor/syntax/lsp groups would cover. Colours
-- follow catppuccin's conventions (mauve keys, blue groups, lavender accents)
-- so the native picker, which-key popup, statusline and file tree match the
-- rest of the theme. Everything else (Pmenu, StatusLine, Visual, Search,
-- Diagnostic*, terminal_color_*, @captures) is themed by the standard groups.
function M.get()
	return {
		-- which-key popup
		WhichKey = { fg = C.maroon }, -- the key chord
		WhichKeyGroup = { fg = C.blue }, -- a "+prefix" group entry
		WhichKeyDesc = { fg = C.mauve }, -- the action description
		WhichKeySeparator = { fg = C.overlay0 },

		-- statusline segments
		StatusLineMode = { fg = C.base, bg = C.mauve, style = { "bold" } }, -- NORMAL/INSERT/… badge
		StatusLineModified = { fg = C.peach }, -- the [+] dirty flag

		-- nxtree / explorer
		NxTreeRootName = { fg = C.peach, style = { "bold" } },
		NxTreeDir = { fg = C.blue, style = { "bold" } },
		NxTreeFolder = { fg = C.blue },
		NxTreeFile = { fg = C.text },
		NxTreeLink = { fg = C.sky, style = { "italic" } },
		NxTreeIndent = { fg = C.surface1 },

		-- nxtree file-type icons
		NxTreeIconDefault = { fg = C.overlay2 },
		NxTreeIconRust = { fg = C.peach },
		NxTreeIconLua = { fg = C.blue },
		NxTreeIconJs = { fg = C.yellow },
		NxTreeIconTs = { fg = C.blue },
		NxTreeIconMd = { fg = C.text },
		NxTreeIconJson = { fg = C.yellow },
		NxTreeIconToml = { fg = C.peach },
		NxTreeIconPy = { fg = C.yellow },
		NxTreeIconGo = { fg = C.sky },
		NxTreeIconSh = { fg = C.green },
		NxTreeIconGit = { fg = C.peach },
		NxTreeIconText = { fg = C.subtext1 },

		-- nxtree git status decorators
		NxTreeGitNew = { fg = C.green },
		NxTreeGitModified = { fg = C.yellow },
		NxTreeGitDeleted = { fg = C.red },
		NxTreeGitDirty = { fg = C.yellow },
	}
end

return M
