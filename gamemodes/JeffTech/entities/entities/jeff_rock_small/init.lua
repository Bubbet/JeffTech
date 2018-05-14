AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
include('../basefiles/resource.lua')

ENT.MaxResource = 1000
ENT.Resourcetogive = "stone"
ENT.YeildMul = 1
ENT.Tool = "pickaxe"
ENT.Models = {"models/props_wasteland/rockcliff05b.mdl"}