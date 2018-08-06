include('items.lua')
include('inventory.lua')

util.AddNetworkString("CIcons")
util.AddNetworkString("CIconr")
util.AddNetworkString("CRequest")
util.AddNetworkString("CFin")
util.AddNetworkString("JeffItemDrop")

net.Receive("JeffItemDrop", function( len, ply )
	local inp = net.ReadTable()
	local item = inp[1]
	local amount = inp[2]
	GAMEMODE:GiveItem(ply, {item}, {-amount}, true)
	net.Start("CFin")
		net.WriteTable(GAMEMODE:ReturnInv(ply))
		net.WriteBool(succeeded)
	net.Send(ply)
end)
	
net.Receive("CIcons", function( len, ply )
	local inp = net.ReadTable()
	local recipe = {}
	recipe[9] = "none"
	for i,e in pairs(CRAFTING_RECIPES) do
		local cont = false
		for i2,e2 in pairs(inp) do
			if e[i2] == e2 then
				continue 
			end
			cont = true
		end
		--add check for inp[11] contains {"hands"}
		if cont then continue end
		recipe = e
	end
	net.Start("CIconr")
		net.WriteTable(recipe)
	net.Send(ply)
end)

net.Receive("CRequest", function( len, ply )
	local recipe = net.ReadTable()
	local bench = net.ReadTable()
	local amount = net.ReadInt(10)
	
	local items = {}
	local amounts = {}
	
	for i = 1,8 do -- populated items and amounts with 1x of mats
		local notadded = true
		for i2,e in pairs(items) do
			if e == recipe[i] then 
				if amounts[i2] == nil then break end
				amounts[i2] = amounts[i2]-1 or -1
				notadded = false
			end
		end
		if notadded then
			table.insert(items,recipe[i])
			table.insert(amounts,-1)
		end
	end
	
	table.insert(items,recipe[9])
	table.insert(amounts,recipe[10])
	
	if amount>1 then --Multiplies each array by amount
		for i,e in pairs(amounts) do
			amounts[i] = amounts[i]*amount
		end
	end
	
	local succeeded = GAMEMODE:GiveItem(ply, items, amounts)
	
	net.Start("CFin")
		net.WriteTable(GAMEMODE:ReturnInv(ply))
		net.WriteBool(succeeded)
	net.Send(ply)
end)