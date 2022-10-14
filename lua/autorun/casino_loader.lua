// Steel's Addon Loader
// Fuck off

local AddonSubFolder = "casino"
local AddonName = "HZNCasino"
local AddonColor = Color(86, 218, 163)

HZNCasino = {}

function HZNCasino:Log(str)
    MsgC(AddonColor, "[" .. AddonName .. "] ", Color(255, 255, 255), str .. "\n")
end

local function loadServerFile(str)
    if CLIENT then return end
    include(str)
    HZNCasino:Log("Loaded Server File " .. str)
end

local function loadClientFile(str)
    if SERVER then AddCSLuaFile(str) return end
    include(str)
    HZNCasino:Log("Loaded Client File " .. str)
end

local function loadSharedFile(str)
    if SERVER then AddCSLuaFile(str) end
    include(str)
    HZNCasino:Log("Loaded Shared File " .. str)
end

local function load()
    local sharedFiles = file.Find(AddonSubFolder .. "/sh/*.lua", "LUA")
    local clientFiles = file.Find(AddonSubFolder .. "/cl/*.lua", "LUA")
    local vguiFiles = file.Find(AddonSubFolder .. "/cl/vgui/*.lua", "LUA")
    local serverFiles = file.Find(AddonSubFolder .. "/sv/*.lua", "LUA")

    for _, file in pairs(clientFiles) do
        loadClientFile(AddonSubFolder .. "/cl/" .. file)
    end

    for _, file in pairs(serverFiles) do
        loadServerFile(AddonSubFolder .. "/sv/" .. file)
    end

    for _, file in pairs(sharedFiles) do
        loadSharedFile(AddonSubFolder .. "/sh/" .. file)
    end

    for _, file in pairs(vguiFiles) do
        loadClientFile(AddonSubFolder .. "/cl/vgui/" .. file)
    end

    HZNCasino:Log("Loaded " .. #clientFiles + #sharedFiles + #serverFiles + #vguiFiles .. " files")
end

load()