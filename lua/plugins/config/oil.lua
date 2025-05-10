return {
	"stevearc/oil.nvim",
	lazy = false,
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			lsp_file_methods = {
				-- Time to wait for LSP file operations to complete before skipping
				timeout_ms = 1000,
				-- Set to true to autosave buffers that are updated with LSP willRenameFiles
				-- Set to "unmodified" to only save unmodified buffers
				autosave_changes = true,
			},
			columns = {
				"permissions",
				"size",
			},
			keymaps = {
				["<leader>e"] = "actions.close",
				["q"] = "actions.close",
			},
		})
	end,
	init = function()
		local mappings = {
			n = {
				["<leader>e"] = { ":lua require('oil').open()<CR>", "open directory browser" },
			},
		}

		require("core.utils").load_mappings(mappings)
	end,
}
