AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

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
		local spawnamount  = math.ceil((self:GetPos():Distance(tr.HitPos)/500)^2*self.SpawnCount)	-- linear scaling math.ceil(self:GetPos():Distance(tr.HitPos)/200*self.SpawnCount)
	
		self.spawned = true
	
		for i = 1, spawnamount do
			local trace = util.TraceLine( {
				start = self:GetPos(),
				endpos = self:GetPos() + Vector(math.random(-self.Radius,self.Radius), math.random(-self.Radius,self.Radius), -10000),
				filter = function ( ent ) if ( ent:GetClass() == "jeff_tree_small" || ent:GetClass() == "jeff_tree_big" ) then return true end end
			} )
			local allowspawn = true
			for _,p in pairs(self.SpawnLocations) do
				if p:Distance(trace.HitPos-Vector(0,0,20)) < 100 or trace.HitNormal.z < 0.25 then allowspawn = false end
			end
			if trace.HitWorld and allowspawn then
				print("hitworld")
				table.insert(self.SpawnLocations, trace.HitPos-Vector(0,0,20))
				table.insert(self.SpawnAngles, trace.HitNormal:Angle()+Angle(90,0,0))
			else
				spawnamount = spawnamount + 1
			end
		end
	
		for i,e in pairs(self.SpawnLocations) do
			local prop
			if math.random(1,10) <= 1 then
				--rarespawn
				prop = ents.Create("jeff_tree_big") -- models/props/de_inferno/tree_large.mdl
			else
				--normal spawn
				prop = ents.Create("jeff_tree_small")
			end
			table.insert(self.PropArray, prop)
			prop:SetPos(e)
			prop:SetAngles(self.SpawnAngles[i])
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
 