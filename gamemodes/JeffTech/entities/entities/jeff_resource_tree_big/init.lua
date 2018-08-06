AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
include('../basefiles/resource.lua')

ENT.MaxResource = 5000
ENT.Resourcetogive = "wood"
ENT.YeildMul = 2
ENT.Tool = "woodaxe"
ENT.Models = {"models/props/de_inferno/tree_large.mdl"}