local formatting
_G.printTable = function(tbl, indent)
  if not indent then indent = 1 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      if #v > 0 then
        print(formatting .. "{")
        printTable(v, indent + 1)
        print(formatting.rep("  ", indent) .. "}")
      else
        print(formatting .. "{}")
      end
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))
    elseif type(v) == "string" then
      print(formatting .. '"' .. v .. '"')
    elseif type(v) == "number" then
      print(formatting .. v)
    else
      print(formatting .. ("<%s>"):format(type(v)))
    end
  end
end
