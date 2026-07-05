local M = {}

-- Native nxvim applier. Replaces catppuccin's neovim bytecode compiler/cache:
-- nxvim queues highlight effects (`nx.hl.define`) and folds them into the core
-- registry between turns, so there is nothing to precompile — on load we build
-- the theme in memory and define every group directly.
function M.load(flavour)
	local O = require("catppuccin").options
	local theme = require("catppuccin.lib.mapper").apply(flavour)

	vim.o.termguicolors = true
	vim.o.background = flavour == "latte" and "light" or "dark"
	vim.g.colors_name = "catppuccin-" .. flavour

	if O.term_colors then
		for k, v in pairs(theme.terminal) do
			vim.g[k] = v
		end
	end

	-- "keep" → leftmost wins: user overrides beat the native UI groups and plugin
	-- integrations, which beat syntax/treesitter, which beat editor chrome. Same
	-- precedence the upstream compiler used (custom → integrations → syntax →
	-- editor); nxvim native groups sit alongside integrations in that slot.
	local groups = vim.tbl_deep_extend(
		"keep",
		theme.custom_highlights,
		theme.nxvim,
		theme.integrations,
		theme.syntax,
		theme.editor
	)

	local h = nx.hl.define
	for group, color in pairs(groups) do
		-- nx.hl.define reads boolean attrs (bold/italic/…), not a `style` array.
		if color.style then
			for _, style in ipairs(color.style) do
				color[style] = true
				if O.no_italic and style == "italic" then color[style] = false end
				if O.no_bold and style == "bold" then color[style] = false end
				if O.no_underline and style == "underline" then color[style] = false end
			end
			color.style = nil
		end
		-- A user override without its own link strips the default link.
		if color.link and theme.custom_highlights[group] and not theme.custom_highlights[group].link then
			color.link = nil
		end
		h(0, group, color)
	end

	-- Notify ColorScheme listeners (statuslines, tree sidebars, …) so a DIRECT
	-- `require("catppuccin").load(flavour)` — not just `:colorscheme catppuccin-<flavour>`
	-- — makes them re-theme. Fired last, after colors_name + every group is applied,
	-- so handlers read the fully-active theme. (`:colorscheme <name>` also fires
	-- ColorScheme from the core after sourcing colors/*.lua; the extra fire here is
	-- idempotent — a well-behaved handler just re-applies the same result.)
	nx.autocmd.exec("ColorScheme", { pattern = vim.g.colors_name })
end

return M
