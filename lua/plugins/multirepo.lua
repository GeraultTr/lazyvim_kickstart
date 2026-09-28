-- ~/.config/nvim/lua/plugins/multirepo.lua
-- Git helpers for when nvim is started from a directory containing several repos.

-- Where to look for repos, relative to nvim's working directory.
-- Add "*/*/.git" to also find repos two levels down.
local PATTERNS = { "*/.git" }

local function find_repos()
  local cwd = vim.fn.getcwd()
  local repos = {}
  -- The working directory itself may also be a repo
  if vim.uv.fs_stat(cwd .. "/.git") then
    table.insert(repos, cwd)
  end
  for _, pattern in ipairs(PATTERNS) do
    for _, dotgit in ipairs(vim.fn.globpath(cwd, pattern, false, true)) do
      table.insert(repos, vim.fn.fnamemodify(dotgit, ":h"))
    end
  end
  table.sort(repos)
  return repos
end

local function repo_name(path)
  local rel = vim.fn.fnamemodify(path, ":.")
  return (rel == "" or rel == ".") and vim.fn.fnamemodify(path, ":t") or rel
end

-- Let the user pick one repo, then call cb(repo_path)
local function pick_repo(cb)
  local repos = find_repos()
  if #repos == 0 then
    vim.notify("No git repos found under " .. vim.fn.getcwd(), vim.log.levels.WARN)
    return
  end
  vim.ui.select(repos, { prompt = "Git repo", format_item = repo_name }, function(choice)
    if choice then
      cb(choice)
    end
  end)
end

local function git(repo, args)
  local cmd = vim.list_extend({ "git", "-C", repo }, args)
  local r = vim.system(cmd, { text = true }):wait()
  local out = r.code == 0 and r.stdout or r.stderr or ""
  return vim.split(out, "\n", { trimempty = true }), r.code
end

-- Show lines in a read-only scratch tab; press q to close it
local function show_scratch(lines, ft)
  vim.cmd("tabnew")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = ft
  vim.keymap.set("n", "q", "<cmd>tabclose<cr>", { buffer = buf, desc = "Close" })
end

-- Branch, ahead/behind and changed files for every repo
local function summary_all()
  local repos = find_repos()
  local lines = {}
  for _, repo in ipairs(repos) do
    local out, code = git(repo, { "status", "--short", "--branch" })
    table.insert(lines, "▶ " .. repo_name(repo))
    if code ~= 0 then
      table.insert(lines, "  error: " .. (out[1] or "unknown"))
    else
      for _, l in ipairs(out) do
        table.insert(lines, "  " .. l)
      end
      if #out <= 1 then
        table.insert(lines, "  (clean)")
      end
    end
    table.insert(lines, "")
  end
  if #repos == 0 then
    lines = { "No git repos found under " .. vim.fn.getcwd() }
  end
  show_scratch(lines, "git")
end

-- Full diff (staged + unstaged) of every repo that has changes
local function diff_all()
  local lines = {}
  for _, repo in ipairs(find_repos()) do
    local out, code = git(repo, { "diff", "HEAD" })
    if code == 0 and #out > 0 then
      table.insert(lines, "######## " .. repo_name(repo) .. " ########")
      vim.list_extend(lines, out)
      table.insert(lines, "")
    end
  end
  if #lines == 0 then
    lines = { "No changes in any repo." }
  end
  show_scratch(lines, "git")
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      -- Pick one repo
      { "<leader>gms", function() pick_repo(function(r) Snacks.picker.git_status({ cwd = r }) end) end, desc = "Status (pick repo)" },
      { "<leader>gmd", function() pick_repo(function(r) Snacks.picker.git_diff({ cwd = r }) end) end, desc = "Diff hunks (pick repo)" },
      { "<leader>gml", function() pick_repo(function(r) Snacks.picker.git_log({ cwd = r }) end) end, desc = "Log (pick repo)" },
      { "<leader>gmg", function() pick_repo(function(r) Snacks.lazygit({ cwd = r }) end) end, desc = "Lazygit (pick repo)" },
      -- Repo of the current buffer, no picking needed
      { "<leader>gmb", function() Snacks.picker.git_status({ cwd = LazyVim.root.git() }) end, desc = "Status (buffer's repo)" },
      -- All repos at once
      { "<leader>gmS", summary_all, desc = "Summary (all repos)" },
      { "<leader>gmD", diff_all, desc = "Diff (all repos)" },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = { spec = { { "<leader>gm", group = "multi-repo" } } },
  },
}
