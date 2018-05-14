function ENT:Initialize()
 
	self.Active = true
	self.ResourceCount = self.MaxResource
	self:SetModel( self.Models[math.random(1,table.Count(self.Models))] )
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
		if string.find(class, self.Tool) then
			self.ResourceCount = self.ResourceCount - damage*difficulty
			GAMEMODE:GiveItem( ply, {self.Resourcetogive}, {damage*difficulty*self.YeildMul}, false )
		else
			GAMEMODE:GiveItem( ply, {self.Resourcetogive}, {2*difficulty*self.YeildMul}, false )
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