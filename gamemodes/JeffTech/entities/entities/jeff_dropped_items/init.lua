AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')


--something something serverside crap that handles all the fun
function ENT:Initialize()

	self:SetModel( "models/Items/item_item_crate.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 
    phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(ply, caller, usetype, value)
	GAMEMODE:GiveItem(ply, self.Items, self.Amounts)
	self:Remove()
end

-- add 3d rendering for text on box