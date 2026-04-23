local group = vim.api.nvim_create_augroup("autosave_on_change", { clear = true })
local timers = {}

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

  vim.api.nvim_buf_call(buf, function()
    pcall(vim.cmd, "silent! update")
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

  timer:start(
    150,
    0,
    vim.schedule_wrap(function()
      save_buf(buf)
    end)
  )
end

vim.api.nvim_create_autocmd({
  "InsertLeave",
  "TextChanged",
  "TextChangedI",
  "TextChangedP",
}, {
  group = group,
  callback = function(args)
    queue_save(args.buf)
  end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = group,
  callback = function(args)
    cleanup_timer(args.buf)
  end,
})
