include("items.lua")

function GM:SyncInv( ply ) -- to be called at player spawn, and before and after every inventory update.
	if ply.inv == nil then--the player doesnt have a ply.inv then
		if sql.Query("SELECT * FROM 'Jeff_Inventory_"..ply:SteamID().."';") then --player has an inventory in the database then 
			--update ply.inv with database
			print("Updating ply.inv with db")
			--sets the ply.inv array from the sql database
			ply.inv = DEFAULT_INV
			local amounts = sql.Query("SELECT Amount FROM 'Jeff_Inventory_"..ply:SteamID().."';")[1]
			local i = 1
			for _,e in pairs(amounts) do
				ply.inv[i][2] = e
				i = i + 1
			end
			
		else
			--create new database
			print("Creating new db")
			--creates and populates the inital database for the player
			ply.inv = DEFAULT_INV -- add code to handle adding new items to the players inventory array by comparing their current array to the array found in default_inv adding the elements to the players array that are not found
			sql.Query("CREATE TABLE 'Jeff_Inventory_"..ply:SteamID().."'( Item TEXT, Amount INTEGER );")--creating the inital database for the inventory
			for _,e in pairs(ply.inv) do -- creating inital inventory
				local item = e[1]
				local amount = e[2]
				sql.Query("INSERT INTO 'Jeff_Inventory_"..ply:SteamID().."'( Item, Amount ) VALUES('"..item.."',"..amount..");")
			end
			
		end
	else
		--update database with ply.inv
		print("Updating db with ply.inv")
		-- updates the sql database with the contents of ply.inv
		for _,e in pairs(ply.inv) do -- updating the inventory
			local item = e[1]
			local amount = e[2]
			sql.Query("UPDATE 'Jeff_Inventory_"..ply:SteamID().."' SET Amount="..amount.." WHERE Item='"..item.."';")
		end
		
	end
end

-- make the player id be the table, and store the values item and amount in it per player

function GM:CreateDB( ply )
	if sql.Query("SELECT * FROM 'Jeff_Inventory_"..ply:SteamID().."';") then
		local dbindexcount = table.Count(sql.Query("SELECT Item FROM 'Jeff_Inventory_"..ply:SteamID().."';"))

		-- if sql.Query("SELECT * FROM '"..ply:SteamID().."';") then --player has an inventory in the database then 
			----update ply.inv with database
			-- print("Updating ply.inv with db")
			----sets the ply.inv array from the sql database
			-- ply.inv = DEFAULT_INV
			-- local amounts = sql.Query("SELECT Amount FROM '"..ply:SteamID().."';")[1]
			-- local i = 1
			-- for _,e in pairs(amounts) do
				-- ply.inv[i][2] = e
				-- i = i + 1
			-- end
			
		if dbindexcount < table.Count(DEFAULT_INV) then
			print("Updating db with new inventory indexs")
			local indexstoadd = table.Count(DEFAULT_INV) - dbindexcount - 1
			for i = dbindexcount, dbindexcount + indexstoadd do
				local item = DEFAULT_INV[i+1][1]
				local amount = DEFAULT_INV[i+1][2]
				sql.Query("INSERT INTO 'Jeff_Inventory_"..ply:SteamID().."'( Item, Amount ) VALUES('"..item.."',"..amount..");")
			end
		elseif dbindexcount > table.Count(DEFAULT_INV) then
			print(ply:Name().."'s Db was corrupt. Items will be lost.")
			sql.Query("DROP TABLE 'Jeff_Inventory_"..ply:SteamID().."';")
			self:CreateDB(ply)
		else
			print("Db already exists and is up to date")
		end
		
	else
		--create new database
		print("Creating new db")
		--creates and populates the inital database for the player
		sql.Query("CREATE TABLE 'Jeff_Inventory_"..ply:SteamID().."'( Item TEXT, Amount INTEGER );")--creating the inital database for the inventory
		for _,e in pairs(DEFAULT_INV) do -- creating inital inventory
			local item = e[1]
			local amount = e[2]
			sql.Query("INSERT INTO 'Jeff_Inventory_"..ply:SteamID().."'( Item, Amount ) VALUES('"..item.."',"..amount..");")
		end
	end

	--self:SyncInv(ply)
end

hook.Add("PlayerSpawn", "SyncInv", function( ply ) GAMEMODE:CreateDB( ply ) end )

-- remove all reference to ply.inv and replace it with giveitem being able to handle the database meaning: it retreaves how much of x item they have, checks if they can preform amount, then returns false if they cant else preforms the action, also add a optional boolean to the function being isdrop? meaning allownig the player to hit 0 and not return false

function GM:GiveItem( ply, items, amounts, drop )
	local allowed = true
	local i = 1
	local itemamount = {}
	for _,e in pairs(items) do
		for _,k in pairs (sql.Query("SELECT Amount FROM 'Jeff_Inventory_"..ply:SteamID().."' WHERE Item='"..e.."';")[1]) do itemamount[i] = k end -- really fucking weird gay garbage for some reason when setting itemamount[i] = sql.Query()[1][1] it returned a nil or table value i dont remember
		--print(itemamount[i])
		--print(amounts[i])
		if itemamount[i] + amounts[i] < 0 then
			allowed = false
			itemamount[i] = 0
		else
			itemamount[i] = itemamount[i] + amounts[i]
		end
		i = i + 1
	end

	if drop then
		--drop items very losely done fix later
		ent = ents.Create("dropped_items")
		ent.items = items
		ent.amounts = itemamount
		ent:SetPos(ply:GetShootPos() + ply:EyeAngles():Forward() * 10)
		ent:SetAngles(ply:EyeAngles())
		ent:Spawn()
		
	else
		--remove items from inventory
		if !allowed then
			return false
		end
	end
	
	local k = 1
	for _,e in pairs(items) do
		sql.Query("UPDATE 'Jeff_Inventory_"..ply:SteamID().."' SET Amount="..itemamount[k].." WHERE Item='"..e.."';")
		k = k + 1
	end
end

-- function GM:GiveItem( ply, item, amount ) -- Used for debugging, and maybe in the game code
	-- local itemindex
	-- local i = 1
	-- for _,e in pairs(ply.inv) do
		-- if e[1] == item then --returns string of item
			-- itemindex = i
		-- end
		-- i = i + 1
	-- end
	-- if ply.inv[itemindex][2] + amount > 0 then
		-- ply.inv[itemindex][2] = math.ceil(ply.inv[itemindex][2] + amount)
	-- else
		-- ply.inv[itemindex][2] = 0
	-- end
	-- self:SyncInv( ply )
-- end
-- items = string.Explode(" ", string.Explode("-", stringargs)[1])
-- items = stringargs:explode("-")[1]:explode(" ")
-- amounts = stringargs:explode("-")[2]:explode(" ")

concommand.Add("jeff_giveitem", function(ply, stringargs, args) GAMEMODE:GiveItem(ply, {args[1]}, {args[2]}, args[3]==1) end)

function GM:ReturnInv( ply )
	for _,e in pairs(sql.Query("SELECT * FROM 'Jeff_Inventory_"..ply:SteamID().."';")) do
		print("Player: " .. ply:Name() .. ", Item: " .. e["Item"] .. ", Amount: " .. e["Amount"])
	end
	return sql.Query("SELECT * FROM 'Jeff_Inventory_"..ply:SteamID().."';")
end

hook.Add("CustomHook", "ReturnInv", function(ply)
	return sql.Query("SELECT * FROM 'Jeff_Inventory_"..ply:SteamID().."';")
end)

concommand.Add("jeff_returninv", function(ply) GAMEMODE:ReturnInv(ply) end)

function Debug_Cleanup()
	--Entity(1).inv = nil
	sql.Query("DROP TABLE 'Jeff_Inventory_"..Entity(1):SteamID().."';")
end

concommand.Add("jeff_cleanup", Debug_Cleanup)