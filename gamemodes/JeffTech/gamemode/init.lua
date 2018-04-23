AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("gui/cl_inventory.lua")
AddCSLuaFile("gui/cl_scoreboard.lua")

include("shared.lua")

util.AddNetworkString("Inventory")

function GM:ShowTeam( ply )
	net.Start("Inventory")
	net.WriteTable(self:ReturnInv(ply)) -- strip the table of amount 0 before sending
	net.Send( ply )
end

DEFINE_BASECLASS( "gamemode_base" )

function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_jefftech" )
	
	BaseClass.PlayerSpawn( self, ply )
end

function GM:PlayerInitialSpawn( ply )

	BaseClass.PlayerInitialSpawn( self, ply )
	
end

concommand.Add( "jeff_difficulty", function( ply, cmd, args )
	return args[1]
end )