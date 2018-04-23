AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
function ENT:Initialize()
 
	self.Active = true
	self.MaxResource = 1000
	self.ResourceCount = self.MaxResource
	self:SetModel( "models/props/de_inferno/tree_small.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	
end

function ENT:GiveResource( damagetable )
	
	local ply = damagetable[2]
	local damage = damagetable[1]
	local tool = damagetable[3]
	local class = ""
	if IsValid(tool) then class = tool:GetClass() end
	local difficulty = cvars.Number("jeff_difficulty")
	
	if ply and self.Active then
		if string.find(class, "woodaxe") then
			self.ResourceCount = self.ResourceCount - damage*difficulty
			GAMEMODE:GiveItem( ply, {"wood"}, {damage*difficulty}, false )
		else
			GAMEMODE:GiveItem( ply, {"wood"}, {2*difficulty}, false )
		end
	end
	
	if self.ResourceCount <= 0 then
		self.Active = false
		self:SetColor(Color(0,0,0,50))
		timer.Simple(self.MaxResource/10,function()
			self.ResourceCount = self.MaxResource
			self.Active = true
			self:SetColor(Color(255,255,255,255))
		end)
	end
	
end

function ENT:Think()
	if !(self.infoTable == nil) then
		
		self:GiveResource(self.infoTable)
		self.infoTable = nil
	end
end