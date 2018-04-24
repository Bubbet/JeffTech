GM.Name = "Jeff Tech"
GM.Author = "Bubbet & Yoshi"
GM.Email = "uhh jeff"
GM.Website = "https://www.youtube.com/watch?v=AfIOBLr1NDU"

include("player_class/player_jefftech.lua")

if SERVER then
	include("player_class/player_jefftech.lua")
	include("modules/inventory.lua")
	include("modules/nodehandling.lua")
end

-- DeriveGamemode("sandbox") -- Remove Later

function GM:Initialize()
	--CreateConVar("jeff_debug", "false")
end
