AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
include('../basefiles/resource.lua')

ENT.MaxResource = 5000
ENT.Resourcetogive = "stone"
ENT.YeildMul = 2
ENT.Tool = "pickaxe"
ENT.Models = {"models/props_wasteland/rockcliff_cluster02a.mdl","models/props_wasteland/rockcliff_cluster01b.mdl","models/props_wasteland/rockcliff_cluster02c.mdl"}