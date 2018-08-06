AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
include('../basefiles/node.lua')

ENT.smallresource = "jeff_resource_tree_small"
ENT.largeresource = "jeff_resource_tree_big"
ENT.largerarity = 10
ENT.minimumspacing = 100