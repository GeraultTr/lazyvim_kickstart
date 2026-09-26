local group = vim.api.nvim_create_augroup("autosave_on_change", { clear = true })
local timers = {}
local DELAY = 1000 -- ms

local function can_save(buf)
  return vim.api.nvim_buf_is_valid(buf)
    and vim.bo[buf].buftype == ""
    and vim.bo[buf].modifiable
    and not vim.bo[buf].readonly
    and vim.api.nvim_buf_get_name(buf) ~= ""
end

local function cleanup_timer(buf)
  local timer = timers[buf]
  if timer then
    timer:stop()
    timer:close()
    timers[buf] = nil
  end
end

local function save_buf(buf)
  if not can_save(buf) or not vim.bo[buf].modified then
    return
  end
  -- Never write mid-insert (e.g. if the timer fires after re-entering insert)
  if vim.api.nvim_get_mode().mode:match("^[iR]") then
    return
  end

  vim.api.nvim_buf_call(buf, function()
    -- Temporarily disable LazyVim's format-on-save for this write
    local prev = vim.b[buf].autoformat
    vim.b[buf].autoformat = false
    pcall(vim.cmd, "silent! update")
    vim.b[buf].autoformat = prev
  end)
end

local function queue_save(buf)
  if not can_save(buf) then
    return
  end

  local timer = timers[buf]
  if not timer then
    timer = vim.uv.new_timer()
    timers[buf] = timer
  else
    timer:stop()
  end

  timer:start(DELAY, 0, vim.schedule_wrap(function()
    save_buf(buf)
  end))
end

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = group,
  callback = function(args)
    queue_save(args.buf)
  end,
})

-- Cancel a pending save as soon as you start typing again
vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = function(args)
    if timers[args.buf] then
      timers[args.buf]:stop()
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = group,
  callback = function(args)
    cleanup_timer(args.buf)
  end,
})
