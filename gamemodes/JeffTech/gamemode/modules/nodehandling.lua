function GM:SaveNodes(overwrite)
	local map = game.GetMap()
	local allents = ents.GetAll()
	local nodeents = {}
	for _,e in pairs(allents) do -- populating nodeents array
		if string.find(e:GetClass(),"jeff_node_") then table.insert(nodeents, e) end
	end
	
	if !file.Exists("JeffTech/nodedata/*", "DATA") then
		file.CreateDir("JeffTech/nodedata/")
	end
	
	if file.Exists("JeffTech/nodedata/"..map..".txt", "DATA") and (overwrite == "true") then
		file.Delete("JeffTech/nodedata/"..map..".txt")
	end
	
	for _,e in pairs(nodeents) do
		local pos = e:GetPos()
		local contents = e:GetClass()..","..math.Round(pos.x).."."..math.Round(pos.y).."."..math.Round(pos.z)..";"

		file.Append("JeffTech/nodedata/"..map..".txt", contents)
	end
end

function GM:LoadNodes()
	local map = game.GetMap()
	local filecontents = file.Read("JeffTech/nodedata/"..map..".txt", "DATA")

	if filecontents == nil then
		filecontents = file.Read("gamemodes/JeffTech/data/nodedata/"..map..".txt", "THIRDPARTY")
	end
	
	local nodes = string.Explode(";", filecontents)
	
	for _,e in pairs(nodes) do
		local nodeinfo = string.Explode(",", e)
		local class = nodeinfo[1]
		local posraw = string.Explode(".", nodeinfo[2])
		local pos = Vector(posraw[1],posraw[2],posraw[3])
		
		print(class)
		
		local node = ents.Create(class)
		node:SetPos(pos)
		node:Spawn()
		node:GetPhysicsObject():EnableMotion(false)
		node:DoSpawn()
		timer.Simple(1,function()
			node:Remove()
		end)
	end
end

concommand.Add("jeff_savenodes", function(ply, cmd, args) GAMEMODE:SaveNodes(args[1]); print(args[1]) end)