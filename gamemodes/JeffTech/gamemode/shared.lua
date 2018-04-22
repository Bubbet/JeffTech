GM.Name = "Jeff Tech"
GM.Author = "Bubbet & Yoshi"
GM.Email = "uhh jeff"
GM.Website = "https://www.youtube.com/watch?v=AfIOBLr1NDU"

if SERVER then
	include("player_class/player_jefftech.lua")
	include("modules/inventory.lua")
end

-- DeriveGamemode("sandbox") -- Remove Later

function GM:Initialize()
	--CreateConVar("jeff_debug", "false")
end