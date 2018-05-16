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
	
	if string.find(map,"gms_") then -- checking map for existing ents to replace with our counterpart
		local allents = ents.GetAll()
		
		for _,e in pairs(allents) do
			local model = e:GetModel()
			local ent = nil
			if string.find(e:GetClass(),"prop_") and cvars.Number("jeff_overwrite_map_resources") <= 1 then
				if string.find(model,"tree") then
					if string.find(model,"deciduous") then
						ent = ents.Create("jeff_tree_small")
					else
						ent = ents.Create("jeff_tree_big")
					end
				elseif string.find(model,"rock") then
					if string.find(model,"cluster") then
						ent = ents.Create("jeff_rock_big")
					else
						ent = ents.Create("jeff_rock_small")
					end				
				end
				if !(ent == nil) then 
					ent:SetPos(e:GetPos())
					ent:SetAngles(e:GetAngles())
					ent:Spawn()
					ent:SetModel(model)
					ent:GetPhysicsObject():EnableMotion(false)
				end
			end
			if string.find(e:GetClass(),"prop_") then e:Remove() end
		end
		if cvars.Number("jeff_overwrite_map_resources") == 0 then filecontents = nil end -- no
	end
	
	if filecontents == nil then 
		timer.Simple(10, function()
			print("[JeffTech] Warning: No node file for this map, make one by spawning nodes then running the jeff_savenodes command.")
		end)
		return nil
	end
	
	local nodes = string.Explode(";", filecontents)
	
	for _,e in pairs(nodes) do
		local nodeinfo = string.Explode(",", e)
		if !nodeinfo or !nodeinfo[2] then continue end
		local class = nodeinfo[1]
		local posraw = string.Explode(".", 	nodeinfo[2])
		local pos = Vector(posraw[1],posraw[2],posraw[3])
		
		--print(class)
		
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