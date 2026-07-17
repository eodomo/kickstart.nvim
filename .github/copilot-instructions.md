# Copilot instructions for eodomo/kickstart.nvim

Purpose: give future Copilot sessions repository-specific guidance so suggestions, edits, and automated agents understand how this Neovim configuration is structured and validated.

---

## Build / test / lint commands
- No automated test suite in this repo.
- Formatting (CI): the repo uses stylua. Check formatting (CI step):
  - Check all files: `stylua --config .stylua.toml --check .`
  - Fix (format) a single file: `stylua --config .stylua.toml -w lua/path/to/file.lua`
  - Format entire repo: `stylua --config .stylua.toml -w .`
- In-editor formatting: Conform is configured. Use the keybinding defined in init.lua:
  - Format current buffer: press `<leader>f` (calls `require('conform').format`)
- Validate runtime config in Neovim:
  - Launch Neovim and run `:checkhealth` to verify installed tooling and LSP/DAP integrations.
- Plugin management (lazy.nvim):
  - Open plugin UI: `:Lazy`
  - Update plugins: `:Lazy update`

Notes: GitHub Actions contains `.github/workflows/stylua.yml` which runs `stylua --check .`. Follow `.stylua.toml` for styling rules.

---

## High-level architecture (big picture)
- This repository is a personal Neovim configuration (kickstart.nvim fork).
- Entry point: `init.lua` — sets editor options, keymaps, installs `lazy.nvim`, and calls `require('lazy').setup()` with plugin specs and imports.
- Plugins and configuration are modularized under `lua/`:
  - `lua/kickstart/*` — core example plugin modules shipped with the kickstart template (e.g., `plugins/debug.lua`, `health.lua`).
  - `lua/custom/plugins/*` — user customization area; `init.lua` imports `custom.plugins` so files here are treated as additional plugin specs.
  - `lua/misc` and `lua/lsp` — additional grouped configuration (e.g., LSP server setups in `lua/lsp/lsp.lua`).
- LSP & tooling:
  - Mason + mason-lspconfig + mason-tool-installer are used to install LSPs and tools. `mason-tool-installer`'s `ensure_installed` is populated in `lua/lsp/lsp.lua` (includes `stylua`, language servers, etc.).
  - DAP configuration example is in `lua/kickstart/plugins/debug.lua` and uses `mason-nvim-dap`.
- Formatting: `conform.nvim` (configured in `init.lua`) integrates with `stylua` for Lua formatting.

---

## Key conventions and repo-specific patterns
- lazy.nvim module style: plugin modules return a plugin table (e.g., `return { 'owner/repo', opts = {}, config = function() ... end }`). Use this pattern for new plugin specs under `lua/custom/plugins/`.
- Import-based organization: `require('lazy').setup()` imports `custom.plugins`, `misc`, and `lsp`. Put custom plugin specs under `lua/custom/plugins/*.lua` so they are automatically loaded.
- Formatting: rely on `.stylua.toml` for repository formatting rules and prefer using Conform `<leader>f` from inside Neovim for interactive formatting.
- Feature flags: `vim.g.have_nerd_font` is used to toggle icon choices across config — respect this variable when adding icon-dependent behavior.
- Neovim version: some modules expect Neovim 0.11+ (see README/Blink requirements). Ensure the runtime meets that minimum.
- LSP special cases: `powershell_es` and `gdscript` have custom startup handling in `lua/lsp/lsp.lua`; follow those patterns when adding similar language adapters.

---

## Other assistant / AI config files checked
- No CLAUDE.md, AGENTS.md, .cursorrules, .windsurfrules, CONVENTIONS.md, or other AI assistant rule files were found. The README and `doc/kickstart.txt` were used for context.

---

If any additional CI, test harness, or external tooling is added later (unit tests, linters), append the concrete commands here (how to run a single test/file and how to run the whole suite).

Summary: added repository-specific guidance to help Copilot and other automated agents edit and validate this Neovim config safely. Want any adjustments, or coverage for a particular area (e.g., DAP, Mason tool list, or Windows-specific install steps)?
