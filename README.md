<h3 align="center">
    <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/logos/exports/1544x1544_circle.png" width="100" alt="Logo"/><br/>
    Catppuccin for nxvim
</h3>

<p align="center">
A native <a href="https://github.com/catppuccin/">Catppuccin</a> port for <b>nxvim</b> — the soothing pastel theme, rewritten against the <code>nx.*</code> plugin API instead of neovim's runtime.
</p>

This is a fork of [catppuccin/nvim](https://github.com/catppuccin/nvim) migrated to
run natively on [nxvim](https://github.com/davidrios/nxvim). The four flavours, the
palettes, and the highlight-group definitions are the upstream ones; everything that
touched neovim's runtime has been replaced or removed. See [What's different from the
neovim port](#whats-different-from-the-neovim-port) for the boundary.

## Flavours

- 🌻 **Latte** — the light flavour
- 🪴 **Frappé** — a less vibrant dark flavour
- 🌺 **Macchiato** — medium-contrast dark flavour
- 🌿 **Mocha** — the darkest flavour

## Installation

nxvim loads colorschemes from any directory on its `runtimepath`. Clone this repo and
add it to your runtimepath in `init.lua`:

```lua
nx.o.runtimepath = nx.o.runtimepath .. ",/path/to/catppuccin-nxvim"
```

(or `vim.opt.runtimepath:append("/path/to/catppuccin-nxvim")` using the muscle-memory
alias). There is no plugin manager and no compile/cache step — the colorscheme is
applied directly when you select it.

## Usage

```vim
" catppuccin (auto), catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
colorscheme catppuccin-mocha
```

```lua
vim.cmd.colorscheme("catppuccin-mocha")
```

`catppuccin` (no flavour suffix) picks a flavour from `background` (`dark` → mocha,
`light` → latte by default). The `:Catppuccin <flavour>` command switches flavour at
runtime with completion.

## Configuration

Calling `setup` is optional — the defaults work out of the box. Call it **before**
selecting the colorscheme to change options.

```lua
require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = { -- maps :set background to a flavour
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color
    float = {
        transparent = false, -- transparent floating windows
        solid = false, -- solid border styling for floats
    },
    term_colors = false, -- sets g:terminal_color_0..15
    dim_inactive = {
        enabled = false, -- dims the background of inactive windows
        shade = "dark",
        percentage = 0.15,
    },
    no_italic = false, -- force no italic
    no_bold = false, -- force no bold
    no_underline = false, -- force no underline
    styles = { -- per-group style overrides (see :h highlight-args)
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
    lsp_styles = { -- styles for diagnostic/LSP groups
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
    custom_highlights = {},
})

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin-mocha")
```

> The neovim port's `integrations`, `default_integrations`, `auto_integrations`, and
> `compile_path` options are gone — see [below](#whats-different-from-the-neovim-port).

## Native UI theming

Beyond the standard groups (`Normal`, `Comment`, `Pmenu`, `StatusLine`, `Visual`,
`Search`, `Diagnostic*`, treesitter `@captures`, …), the port themes nxvim's own UI
surfaces:

- **which-key** — `WhichKey`, `WhichKeyGroup`, `WhichKeyDesc`, `WhichKeySeparator`
- **statusline** — `StatusLineMode`, `StatusLineModified`
- **nxtree** — `NxTreeRootName`, `NxTreeDir`, `NxTreeFolder`, `NxTreeFile`,
  `NxTreeLink`, `NxTreeIndent`, the `NxTreeIcon*` file-type icons, and the
  `NxTreeGit*` status decorators

These live in [`lua/catppuccin/groups/nxvim.lua`](lua/catppuccin/groups/nxvim.lua).

## Customization

### Getting colors

```lua
local mocha = require("catppuccin.palettes").get_palette("mocha")
-- latte / frappe / macchiato likewise
```

Returns a table mapping each Catppuccin color name (`rosewater`, `mauve`, `blue`,
`text`, `base`, …) to its hex code.

### Overwriting colors

```lua
require("catppuccin").setup({
    color_overrides = {
        all = { text = "#ffffff" },
        latte = { base = "#ff0000" },
        frappe = {},
        macchiato = {},
        mocha = {},
    },
})
```

### Overwriting highlight groups

All highlight groups, including the nxvim-native ones, can be overridden.
`custom_highlights` applies to every flavour:

```lua
require("catppuccin").setup({
    custom_highlights = function(colors)
        return {
            Comment = { fg = colors.flamingo },
            Pmenu = { bg = colors.none },
            NxTreeFolder = { fg = colors.mauve },
        }
    end,
})
```

`highlight_overrides` applies per flavour (and `all`):

```lua
require("catppuccin").setup({
    highlight_overrides = {
        all = function(colors)
            return { Normal = { fg = colors.text } }
        end,
        mocha = function(mocha)
            return { Comment = { fg = mocha.flamingo } }
        end,
    },
})
```

## What's different from the neovim port

Catppuccin's color data and highlight-group definitions are pure and port cleanly. The
neovim-runtime machinery does not, so it was rewritten or removed:

- **No bytecode compiler / cache.** The upstream `lib/compiler.lua` precompiled each
  flavour to a `string.dump` blob under `compile_path` and invalidated it with a config
  hash. nxvim folds queued highlight effects into its core registry, so the port just
  defines every group directly via `nx.hl.define` on load
  ([`lib/loader.lua`](lua/catppuccin/lib/loader.lua)). No `compile_path`, no
  `:CatppuccinCompile`, no `io`/`stdpath`/`mkdir`/hashing.
- **No plugin integrations.** The 69 `groups/integrations/*` files themed neovim plugins
  (telescope, cmp, gitsigns, …) that don't exist in nxvim; their group names are never
  read here. They — and `default_integrations`/`auto_integrations`/`detect_integrations`
  — are removed. nxvim's real UI surfaces are themed via the native groups above instead.
- **No neovim-only `vim.*`.** nxvim exposes only a bounded `vim.*` muscle-memory
  whitelist over the `nx.*` API; calls outside it fail loud rather than no-op. The port
  drops the `vim.fn.has`/`vim.o.pumborder` version checks, the
  `vim.treesitter.highlighter.hl_map` deprecation warnings, the kitty palette hack, and
  the statusline helpers (lualine/feline/barbecue/bufferline) and tree-sitter `after/`
  queries that targeted neovim.

## Credits

Based on [catppuccin/nvim](https://github.com/catppuccin/nvim) and the wider
[Catppuccin](https://github.com/catppuccin/catppuccin) project. Licensed under
[MIT](LICENSE.md).
