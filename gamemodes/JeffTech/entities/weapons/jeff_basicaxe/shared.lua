AddCSLuaFile ()

SWEP.Author = "jeff"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Basic Axe"
SWEP.Instructions = [[Used to gather wood]]

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.ViewModeFlip = false
SWEP.UseHands = true
SWEP.WorldModel = "models/props_forest/axe.mdl"
SWEP.SetHoldType = "melee"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

SWEP.ShouldDropOnDie = false

local SwingSound = Sound("weapons/crowbar/crowbar_swing_miss1.wav")
local HitSound = Sound("weapons/crossbow/hitbod1.wav")

function SWEP:Initialize()
	self:SetWeaponHoldType("melee")
end

function SWEP:PrimaryAttack()

	if(CLIENT) then return end
	
	local ply = self:GetOwner()
	
	ply:LagCompensation(true)
	
	local shootpos = ply:GetShootPos()
	local endshootpos = shootpos + ply:GetAimVector() * 70
	local tmin = Vector(1,1,1) * -10
	local tmax = Vector(1,1,1) * 10
	
	local tr = util.TraceHull( {
		start = shootpos,
		endpos = endshootpos,
		filter = ply,
		mask = MASK_SHOT_HULL,
		mins = tmin,
		maxs = tmax} )
		
	if(not IsValid(tr.Entity)) then
		tr = util.TraceLine({
			start = shootpos,
			endpos = endshootpos,
			filter = ply,
			mask = MASK_SHOT_HULL})
	end

	local ent = tr.Entity
		
	if(IsValid( ent) && (ent:IsPlayer() || ent:IsNPC() )) then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)
		
		ply:EmitSound(HitSound)
		ent:SetHealth(ent:Health() -10)
		if(ent:health() < 1) then
			ent:kill()
		end
	
	elseif( !IsValid(ent)) then
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)
		
		ply:EmitSound(SwingSound)
	end
	
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 0.1)
	
	ply:LagCompensation(false)
end

function SWEP:CanSecondaryAttack()
	return false
end