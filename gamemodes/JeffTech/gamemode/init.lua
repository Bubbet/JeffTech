AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("gui/cl_inventory.lua")
AddCSLuaFile("gui/cl_scoreboard.lua")

include("shared.lua")
include("player_class/player_jefftech.lua")
include("modules/inventory.lua")
include("modules/nodehandling.lua")
include("modules/crafting.lua")

util.AddNetworkString("Inventory")

function GM:ShowTeam( ply )
	net.Start("Inventory")
	net.WriteTable(self:ReturnInv(ply)) -- strip the table of amount 0 before sending
	local max = cvars.Number("jeff_cratemax")
	net.WriteInt(max,14)
	net.Send( ply )
end

DEFINE_BASECLASS( "gamemode_base" )

function GM:PlayerSpawn( ply )
	player_manager.SetPlayerClass( ply, "player_jefftech" )
	
	BaseClass.PlayerSpawn( self, ply )
	
	ply:SetupHands() -- Create the hands and call GM:PlayerSetHandsModel
end

-- Choose the model for hands according to their player model.
function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

function GM:PlayerInitialSpawn( ply )

	BaseClass.PlayerInitialSpawn( self, ply )
	
end

function GM:InitPostEntity()
	self:LoadNodes()
end

concommand.Add( "jeff_difficulty", function( ply, cmd, args )
	return args[1]
end )

concommand.Add( "jeff_cratemax", function( ply, cmd, args )
	return args[1]
end )

concommand.Add( "jeff_overwrite_map_resources", function( ply, cmd, args )
	return args[1]
end )