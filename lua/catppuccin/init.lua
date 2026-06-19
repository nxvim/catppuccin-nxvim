---@type Catppuccin
local M = {
	default_options = {
		flavour = "auto",
		background = {
			light = "latte",
			dark = "mocha",
		},
		transparent_background = false,
		float = {
			transparent = false,
			solid = false,
		},
		term_colors = false,
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.15,
		},
		no_italic = false,
		no_bold = false,
		no_underline = false,
		styles = {
			comments = { "italic" },
			conditionals = { "italic" },
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
		},
		lsp_styles = {
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
				ok = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
				ok = { "underline" },
			},
			inlay_hints = {
				background = true,
			},
		},
		color_overrides = {},
		highlight_overrides = {},
		-- Knobs read by the restored plugin integrations. The highlight-group
		-- integrations (cmp/coc/copilot/barbar/buffon) need no config; only
		-- blink.cmp's border style and lualine's colour overrides are read here.
		integrations = {
			blink_cmp = { style = "bordered" },
			lualine = false,
		},
	},
	flavours = { latte = 1, frappe = 2, macchiato = 3, mocha = 4 },
}

M.options = M.default_options

local function get_flavour(default)
	local flavour
	if default and default == M.flavour and vim.o.background ~= (M.flavour == "latte" and "light" or "dark") then
		flavour = M.options.background[vim.o.background]
	else
		flavour = default
	end

	if flavour and not M.flavours[flavour] then
		vim.notify(
			string.format(
				"Catppuccin (error): Invalid flavour '%s', flavour must be 'latte', 'frappe', 'macchiato', 'mocha' or 'auto'",
				flavour
			),
			vim.log.levels.ERROR
		)
		flavour = nil
	end
	return flavour or M.options.flavour or vim.g.catppuccin_flavour or M.options.background[vim.o.background]
end

local did_setup = false

function M.load(flavour)
	if M.options.flavour == "auto" then -- set colorscheme based on o:background
		M.options.flavour = nil -- ensure that this will only run once on startup
	end
	if not did_setup then M.setup() end
	M.flavour = get_flavour(flavour)
	require("catppuccin.lib.loader").load(M.flavour)
end

---@type fun(user_conf: CatppuccinOptions?)
function M.setup(user_conf)
	did_setup = true
	user_conf = user_conf or {}
	M.options = vim.tbl_deep_extend("keep", user_conf, M.default_options)
	M.options.highlight_overrides.all = user_conf.custom_highlights or M.options.highlight_overrides.all
end

vim.api.nvim_create_user_command(
	"Catppuccin",
	function(inp) vim.cmd("colorscheme catppuccin-" .. get_flavour(inp.args)) end,
	{
		nargs = 1,
		complete = function(line)
			local matches = {}
			for name in pairs(M.flavours) do
				if vim.startswith(name, line) then matches[#matches + 1] = name end
			end
			return matches
		end,
	}
)

return M
