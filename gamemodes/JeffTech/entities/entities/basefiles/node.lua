local phys
 
function ENT:Initialize()

	self.SpawnCount = math.random(1,4)
	self.Radius = 5000
	self.SpawnLocations = {}
	self.SpawnAngles = {}
	self.PropArray = {}
	self.spawned = false
 
	self:SetModel( "models/props_interiors/BathTub01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 
    phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:DoSpawn()
	if !self.spawned then
		tr = util.TraceLine( {
				start = self:GetPos(),
				endpos = self:GetPos() + Vector(0, 0, -10000),
				filter = function ( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
			} )
		self.spawnamount  = math.ceil((self:GetPos():Distance(tr.HitPos)/500)^2*self.SpawnCount)	-- linear scaling math.ceil(self:GetPos():Distance(tr.HitPos)/200*self.SpawnCount)
	
		self.spawned = true
	
		for i = 1, self.spawnamount do
			local trace = util.TraceLine( {
				start = self:GetPos(),
				endpos = self:GetPos() + Vector(math.random(-self.Radius,self.Radius), math.random(-self.Radius,self.Radius), -10000),
				filter = function ( ent ) if ( ent:GetClass() == self.smallresource || ent:GetClass() == self.largeresource ) then return true end end
			} )
			local allowspawn = true
			for _,p in pairs(self.SpawnLocations) do
				if p:Distance(trace.HitPos-Vector(0,0,20)) < self.minimumspacing or trace.HitNormal.z < 0.25 then allowspawn = false end
			end
			if trace.HitWorld and allowspawn then
				--print("hitworld")
				table.insert(self.SpawnLocations, trace.HitPos-Vector(0,0,20))
				table.insert(self.SpawnAngles, trace.HitNormal:Angle()+Angle(90,0,0))
			else
				self.spawnamount = self.spawnamount + 1
			end
		end
	
		for i,e in pairs(self.SpawnLocations) do
			local prop
			if math.random(1,self.largerarity) <= 1 then
				--rarespawn
				prop = ents.Create(self.largeresource) -- models/props/de_inferno/tree_large.mdl
			else
				--normal spawn
				prop = ents.Create(self.smallresource)
			end
			table.insert(self.PropArray, prop)
			prop:SetPos(e)
			local Ang = self.SpawnAngles[i]
			Ang:RotateAroundAxis(Ang:Up(), math.random(-180,180))
			prop:SetAngles(Ang)
			prop:Spawn()
			prop:GetPhysicsObject():EnableMotion(false)
		end
	
	else
	
		for _,e in pairs(self.PropArray) do
			if !(e == nil) then 
				e:Remove()
			end
		end
		self.SpawnLocations = {}
		self.SpawnAngles = {}
		self.PropArray = {}
		self.spawned = false
		
	end
end

function ENT:Use()
	self:DoSpawn()
end
 
function ENT:Think()
end
 