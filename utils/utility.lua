-- Standard awesome library
-- Useful reusable functions
local tonumber = tonumber
local awful = require("awful")
local naughty = naughty
local timer = timer
local pairs = pairs
local type = type
local table = table
local io = io
local tostring = tostring

local utility = {}

function utility.run_once(prg, times)
   if not prg then
      do return nil end
   end
   times = times or 1

   local count_prog

   local f, err = io.popen('ps aux | grep "' .. prg .. '" | grep -v grep | wc -l')
   if f then
       local s = f:read("*all")
       f:close()
       count_prog = tonumber(s)
   else
       naughty.notify({ preset = naughty.config.presets.critical,
                        title = "Error: " .. err })
   end
   if times > count_prog then
      for l = count_prog, times-1 do
         awful.util.spawn_with_shell(prg)
      end
   end
end

function utility.repeat_every(func, seconds)
   func()
   local t = timer({ timeout = seconds })
   t:add_signal("timeout", func)
   t:start()
end

function utility.pop_spaces(s1,s2,maxsize)
   local sps = ""
   for i = 1, maxsize-string.len(s1)-string.len(s2) do
      sps = sps .. " "
   end
   return s1 .. sps .. s2
end

function utility.append_table(what, to_what, overwrite)
   for k, v in pairs(what) do
      if type(k) ~= "number" then
         if overwrite or not to_what[k] then
            to_what[k] = v
         end
      else
         table.insert(to_what, v)
      end
   end
end

function utility.slurp(file, mode)
   local mode = mode or "*all"
   local handler = io.open(file, 'r')
   local result = handler:read(mode)
   handler:close()
   return result
end

-- *** Internal calc function *** ---
function utility.calc(result)
   naughty.notify( { title = "Awesome calc",
                     text = "Result: " .. result,
                     timeout = 5})
end

-- *** Debug pring function *** ---
function utility.nprint(s)
   naughty.notify( { title = "Debug print",
                     text = tostring(s),
                     timeout = 5})
end

return utility
