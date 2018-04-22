AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("gui/cl_inventory.lua")
AddCSLuaFile("gui/cl_scoreboard.lua")

include("shared.lua")
include("player_class/player_jefftech.lua")

util.AddNetworkString("Inventory")

function GM:ShowTeam( ply )
	net.Start("Inventory")
	net.WriteTable(self:ReturnInv(ply))
	net.Send( ply )
end

function GM:PlayerSpawn( ply )
	print(player_manager.SetPlayerClass( ply, "player_jefftech" ))
end