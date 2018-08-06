AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
include('../basefiles/resource.lua')

ENT.MaxResource = 1000
ENT.Resourcetogive = "wood"
ENT.YeildMul = 1
ENT.Tool = "woodaxe"
ENT.Models = {"models/props_foliage/tree_springers_01a-lod.mdl","models/props_foliage/tree_springers_01a.mdl","models/props/de_inferno/tree_small.mdl"}