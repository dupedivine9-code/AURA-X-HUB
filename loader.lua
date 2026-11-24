-- AURA X V8 standalone loader
-- Loads the separate Crimson Glass script; does not modify the original source.
local SOURCE_URL = "https://raw.githubusercontent.com/dupedivine9-code/AURA-X-HUB/main/AURA_X_Crimson_Glass_V8_No_White_Ending.lua"

local ok, source = pcall(function()
    return game:HttpGet(SOURCE_URL)
end)

if not ok or type(source) ~= "string" or #source < 1000 then
    warn("[AURA X] Failed to download the main script.")
    return
end

local compile, loadError = loadstring(source)
if not compile then
    warn("[AURA X] Compile error: " .. tostring(loadError))
    return
end

local ran, runError = pcall(compile)
if not ran then
    warn("[AURA X] Runtime error: " .. tostring(runError))
end
