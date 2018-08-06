GM.Name = "Jeff Tech"
GM.Author = "Bubbet & Yoshi"
GM.Email = "uhh jeff"
GM.Website = "https://www.youtube.com/watch?v=AfIOBLr1NDU"

include("player_class/player_jefftech.lua")

DeriveGamemode("sandbox") -- Remove Later

for i,e in pairs(file.Find( "gamemodes/JeffTech/content/materials/jefftech/icons/*.*", "THIRDPARTY" )) do
	resource.AddFile("materials/jefftech/icons/" .. e)
	resource.AddFile(e)
end

function GM:Initialize()
	--CreateConVar("jeff_debug", "false")
end
