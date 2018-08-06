AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

util.AddNetworkString("JeffTech_DroppedItemsSpawn")
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
	if self.Items == nil then self:Remove(); return end
	GAMEMODE:GiveItem(ply, self.Items, self.Amounts)
	self:Remove()
end

function ENT:Colorize(count2)
	local max = cvars.Number("jeff_cratemax")
	
	local count = 0
	local count2 = count2 or 0
	
	for i,e in pairs(self.Amounts) do
		count = count + e
	end
	
	local col = 255*(count+count2)/max
	
	if (count+count2)<=max then 
		self:SetColor(Color(col,255-col,0,255))
		self.Count = count+count2.."/"..max
		//print(self.Count)
		
		timer.Simple(0.1, function()
			net.Start("JeffTech_DroppedItemsSpawn")
				net.WriteEntity(self)
				net.WriteString(self.Count)
			net.Broadcast()
		end)
	end

	return (count+count2)>max
end

function ENT:StartTouch(ent)
	
	local count2 = 100000
	
	if ent.Items ~= nil then
		count2 = 0
		for i,e in pairs(ent.Amounts) do
			count2 = count2 + e
		end
	end
	
	if ent:GetCreationID()>self:GetCreationID() or not IsValid(ent) or ent.Items == nil or self:Colorize(count2) then return end
	
	for i,e in pairs(ent.Items) do
		local exists = 0
		for i2,e2 in pairs(self.Items) do
			if e == e2 then exists = i2 end
		end
		if exists>0 then
			self.Amounts[exists] = self.Amounts[exists] + ent.Amounts[i]
		else
			table.insert(self.Items,1,e)
			table.insert(self.Amounts,1,ent.Amounts[i])
		end
	end
	ent:Remove()
	self:Colorize()
end

-- add 3d rendering for text on box