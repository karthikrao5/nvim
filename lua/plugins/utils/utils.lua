
local utils = {}
local function spread(template)
  local result = {}
  for key, value in pairs(template) do
    result[key] = value
  end

  return function(table)
    for key, value in pairs(table) do
      result[key] = value
    end
    return result
  end
end


function utils.nmap(mode, keys, func, opts)
  vim.keymap.set(mode, keys, func, opts)
end


return utils
