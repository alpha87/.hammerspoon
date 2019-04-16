require "sspai.sspai"

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
    hs.notify.new({title="Hammerspoon", informativeText=hs.battery.percentage() .. "%"}):send()
end)
