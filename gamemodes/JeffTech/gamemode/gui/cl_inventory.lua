local rowsize = ScrH()/28.125

surface.CreateFont("Inv_Title",{
	font = "Helvetica",
	size = 32,
	weight = 200
})
surface.CreateFont("Inv_Contents",{
	font = "Helvetica",
	size = rowsize,
	weight = rowsize*8
})

local function SendCIcons()
	local out = {}
	for _,e in pairs(Inventory.CraftContainer.CIcon) do
		local item = e.Item
		if item == "none" then table.insert(out,"") else table.insert(out,item) end
	end
	net.Start("CIcons")
		net.WriteTable(out)
	net.SendToServer()
	return out
end

local function CraftRequest(recipe, amount)
	if recipe[9] == "none" then return end
	
	net.Start("CRequest")
		net.WriteTable(recipe)
		net.WriteInt(amount,10)
	net.SendToServer()
end

CRAFTINGICON = {
	Init = function(self)
		self.root = self:GetParent().root
		self.Item = "none"
		self:SetSize( self.root.wogi, self.root.hogi )
		self:Droppable('CIcon')
		self:Receiver('CIcon', function(self, droppedarray, isDropped)
			if isDropped then
				self.Item = droppedarray[1].Item
				self:SetImage("jefftech/icons/"..droppedarray[1].Item..".png")
				SendCIcons()
			end
		end, {})
		
		self.Label = self:Add("DLabel")
		self.Label:SetFont("Inv_Contents")
		self.Label:SetTextColor(self.root.textcolor)
		self.Label:SetText("")
		self.Label:Dock(FILL)
		self.Label:SetContentAlignment(5)
	end,
	Paint = function(self,w,h)
		self.Label:SetText("")
		local img = "jefftech/icons/noicon.png"
		if file.Exists("materials/jefftech/icons/"..self.Item..".png", "GAME") then img = "jefftech/icons/"..self.Item..".png" end
		self:SetImage(img)
		if img == "jefftech/icons/noicon.png" then self.Label:SetText(self.Item) end
		draw.RoundedBox(0,0,0,w,h,self.root.gridcolor)
		surface.SetDrawColor(self.root.linecolor)
		surface.DrawOutlinedRect(0,0,w,h)
		surface.DrawOutlinedRect(1,1,w-2,h-2)
	end,
	DoClick = function(self)
		if self:IsDragging() then
			return
		end
		self.Item = "none"
		self:SetImage("jefftech/icons/none.png")
		SendCIcons()
	end,
	DoRightClick = function(self)
		if self:IsDragging() then
			return
		end
		self.Item = "none"
		self:SetImage("jefftech/icons/none.png")
		SendCIcons()
	end,
	DragMouseRelease = function( self, mcode ) --needed to override the gay thing they were going to "todo"

		if ( IsValid( dragndrop.m_DropMenu ) ) then return end
	
		-- This wasn't the button we clicked with - so don't release drag
		if ( dragndrop.IsDragging() && dragndrop.m_MouseCode != mcode ) then
	
			return self:DragClick( mcode )
	
		end
	
		if ( !dragndrop.IsDragging() ) then
			dragndrop.Clear()
			return false
		end
	
		for k, v in pairs( dragndrop.m_Dragging ) do
	
			if ( !IsValid( v ) ) then continue end
			v:OnStopDragging()
	
		end
	
		dragndrop.Drop()
	
		-- Todo.. we should only do this if we enabled it!
		if ( gui.EnableScreenClicker ) then
			--gui.EnableScreenClicker( false )
		end
	
		self:MouseCapture( false )
		return true
	end
}

CRAFTINGICON = vgui.RegisterTable(CRAFTINGICON, "DImageButton")

CRAFTINGCONTAINER = {
	Init = function(self)
		self.root = self:GetParent()
		
		self:SetSize(self.root.wow,self.root.hobc)
		self:SetPos(self.root.w-self.root.wow*2,self.root.h-self.root.hobc)
		self:SetVisible(false)
		
		self.CIcon = {}
		
		self.CIcon[1] = vgui.CreateFromTable(CRAFTINGICON, self)
		--self.CIcon[1].Item = "wood"
		self.CIcon[1]:SetPos( self.root.wmogi*1 + self.root.wogi*0, self.root.hmogi*1 + self.root.hogi*0 )
		
		self.CIcon[2] = vgui.CreateFromTable(CRAFTINGICON, self)
		self.CIcon[2]:SetPos( self.root.wmogi*2 + self.root.wogi*1, self.root.hmogi*1 + self.root.hogi*0 )
		
		self.CIcon[3] = vgui.CreateFromTable(CRAFTINGICON, self)
		self.CIcon[3]:SetPos( self.root.wmogi*3 + self.root.wogi*2, self.root.hmogi*1 + self.root.hogi*0 )
		
		
		self.CIcon[4] = vgui.CreateFromTable(CRAFTINGICON, self)
		self.CIcon[4]:SetPos( self.root.wmogi*1 + self.root.wogi*0, self.root.hmogi*2 + self.root.hogi*1 )
		
		self.CIcon[5] = vgui.CreateFromTable(CRAFTINGICON, self)
		self.CIcon[5]:SetPos( self.root.wmogi*3 + self.root.wogi*2, self.root.hmogi*2 + self.root.hogi*1 )

		
		self.CIcon[6] = vgui.CreateFromTable(CRAFTINGICON, self)
		self.CIcon[6]:SetPos( self.root.wmogi*1 + self.root.wogi*0, self.root.hmogi*3 + self.root.hogi*2 )
		
		self.CIcon[7] = vgui.CreateFromTable(CRAFTINGICON, self)
		self.CIcon[7]:SetPos( self.root.wmogi*2 + self.root.wogi*1, self.root.hmogi*3 + self.root.hogi*2 )
		
		self.CIcon[8] = vgui.CreateFromTable(CRAFTINGICON, self)
		self.CIcon[8]:SetPos( self.root.wmogi*3 + self.root.wogi*2, self.root.hmogi*3 + self.root.hogi*2 )
		
		self.COutput = self:Add("DImageButton")		
		self.COutput:SetImage("jefftech/icons/none.png")
		self.COutput.root = self.root
		self.COutput:SetSize(self.root.wogi,self.root.hogi)
		self.COutput:SetPos( self.root.wmogi*2 + self.root.wogi*1, self.root.hmogi*2 + self.root.hogi*1 )
		function self.COutput:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,self.root.gridcolor)
			surface.SetDrawColor(self.root.linecolor)
			surface.DrawOutlinedRect(0,0,w,h)
			surface.DrawOutlinedRect(1,1,w-2,h-2)
		end
		function self.COutput:DragMouseRelease( mcode ) --needed to override the gay thing they were going to "todo"
			if ( IsValid( dragndrop.m_DropMenu ) ) then return end
			if ( !dragndrop.IsDragging() ) then
				dragndrop.Clear()
				return false
			end
			for k, v in pairs( dragndrop.m_Dragging ) do
				if ( !IsValid( v ) ) then continue end
				v:OnStopDragging()
			end
			dragndrop.Drop()
			return true
		end
		function self.COutput.DoClick()
			CraftRequest(self.COutput.recipe, 1)
		end
		function self.COutput.DoRightClick(self)
			self.Menu = self:Add("DMenu")
			self.Menu:AddOption("Craft 5x")
			self.Menu:AddOption("Craft 10x")
			self.Menu:AddSpacer()
			self.Menu:AddOption("Clear Grid")
			function self.Menu.OptionSelected(pnl, option)
				local text = option:GetText()
				if text == "Clear Grid" then
					for _,e in pairs(pnl:GetParent():GetParent().CIcon) do
						e.Item = "none"
						e:SetImage("jefftech/icons/none.png")
					end
					SendCIcons()
				end
				if text == "Craft 5x" then CraftRequest(pnl:GetParent():GetParent().COutput.recipe, 5) end
				if text == "Craft 10x" then CraftRequest(pnl:GetParent():GetParent().COutput.recipe, 10) end
			end
		end
		
		self.COutput:Droppable('CIcon')
		--[[self.COutput:Receiver('CIcon', function(self, droppedarray)
			
		end, {})]]
	end,
	Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,self.root.bgcolor)
		surface.SetDrawColor(self.root.linecolor)
		surface.DrawOutlinedRect(0,0,w,h)
		surface.DrawOutlinedRect(1,1,w-1,h-1)
	end
}

CRAFTINGCONTAINER = vgui.RegisterTable(CRAFTINGCONTAINER, "Panel")

ITEM_ROW = {
	ManInit = function(self)
	
		--self.root = self:GetParent():GetParent().root
		
		local w = self.root.wow
		local h = rowsize--(self.root.h-self.root.hobc)/16
		
		self:Droppable('CIcon')
		self:SetText("")
		self:SetSize(w,h)
		self:Dock(TOP)
		self:SetHeight(rowsize)
		self:DockMargin(0,2,0,2)
		
		self.Icon = self:Add("DImage")
		self.Icon:SetSize(h*(16/15),h)
		self.Icon:SetPos(2,0)
		
		self.ItemL = self:Add("DLabel")
		self.ItemL:SetFont("Inv_Contents")
		self.ItemL:SetTextColor(self.root.textcolor)
		self.ItemL:SetSize(w/2-h*16/15,h)
		self.ItemL:SetPos(h*16/15+4,0)
		
		self.AmountL = self:Add("DLabel")
		self.AmountL:SetFont("Inv_Contents")
		self.AmountL:SetTextColor(self.root.textcolor)
		self.AmountL:SetSize(w/2-h*16/15,h)
		self.AmountL:SetPos(h*16/15+w/2-h*16/15+4,0)
		
	end,
	Update = function(self, item, amount)
		self.Item = item
		self.Amount = tonumber(amount)
		self.ItemL:SetText(item)
		self.AmountL:SetText(amount)
		local img = "jefftech/icons/noicon.png"
		if file.Exists("materials/jefftech/icons/"..item..".png", "GAME") then img = "jefftech/icons/"..item..".png" end
		self.Icon:SetImage(img)
		if self.Amount == 0 then 
			self:Remove()
		end
	end,
	Paint = function(self, w, h)
		draw.RoundedBox(0,0,0,w,h,self.root.bgcolor)
		surface.SetDrawColor(self.root.linecolor)
		surface.DrawLine(0,h,w,h)
	end,
	DoRightClick = function(self)
		print("Dropping "..self.Item)
	end,
	DragMouseRelease = function( self, mcode ) --needed to override the gay thing they were going to "todo"

		if ( IsValid( dragndrop.m_DropMenu ) ) then return end
	
		-- This wasn't the button we clicked with - so don't release drag
		if ( dragndrop.IsDragging() && dragndrop.m_MouseCode != mcode ) then
	
			return self:DragClick( mcode )
	
		end
	
		if ( !dragndrop.IsDragging() ) then
			dragndrop.Clear()
			return false
		end
	
		for k, v in pairs( dragndrop.m_Dragging ) do
	
			if ( !IsValid( v ) ) then continue end
			v:OnStopDragging()
	
		end
	
		dragndrop.Drop()
		--self.ghost:Remove()
	
		-- Todo.. we should only do this if we enabled it!
		if ( gui.EnableScreenClicker ) then
			--gui.EnableScreenClicker( false )
		end
	
		self:MouseCapture( false )
		return true
	end--[[,
	DragMousePress = function( self, mcode )
		self.ghost = vgui.CreateFromTable(CRAFTINGICON, self.root.CraftContainer)
		self.ghost:SetParent(self.ghost)
		self.ghost.Item = self.Item
		self.ghost:SetPos(0,1000)
		
		if ( IsValid( dragndrop.m_DropMenu ) ) then return end
		if ( dragndrop.IsDragging() ) then dragndrop.StopDragging() return end
	
		if ( IsValid( self.m_pDragParent ) ) then
			return self.m_pDragParent:DragMousePress( mcode )
		end
	
		if ( !self.m_DragSlot ) then return end
	
		dragndrop.Clear()
		dragndrop.m_MouseCode = mcode
		dragndrop.m_DragWatch = self
		dragndrop.m_Dragging = {self, self.ghost}
		--ghost:Remove()
		dragndrop.m_MouseX = gui.MouseX()
		dragndrop.m_MouseY = gui.MouseY()
	end]]
}

ITEM_ROW = vgui.RegisterTable(ITEM_ROW, "DPanel")

INVENTORY = {
	Init = function(self)
		
		self.linecolor = Color(0,0,0,255)
		self.bgcolor = Color(0,0,0,200)
		self.gridcolor = Color(100,100,100,100)
		self.textcolor = Color(255,255,255,255)
		
		self.w = ScrW()
		self.h = ScrH()
		
		self.wow = self.w/5 --width of window
		self.wob = self.wow/3 --width of buttons
		
		self.hobc = self.h/3 --height of button container
		self.hob = self.hobc/3 --height of buttons
		
		self.rcg = 0.9 --ratio of crafting grid (% of crafting window occupied by grid)
		
		self.wogi = self.wow*self.rcg/3 --width of crafting icons DO NOT EDIT
		self.hogi = self.hobc*self.rcg/3 --height of crafting icons DO NOT EDIT
		self.wmogi = self.wow*(1-self.rcg)/4 --width margin between crafting icons DO NOT EDIT
		self.hmogi = self.hobc*(1-self.rcg)/4 --height margin between crafting icons DO NOT EDIT
		
		self:SetSize(self.w,self.h)
		self:SetPos(0,0)
		self:SetVisible(true)
		--self:MakePopup()
		
		self.CraftContainer = vgui.CreateFromTable(CRAFTINGCONTAINER, self)
		
		self.InvContainer = self:Add("Panel")
		self.InvContainer.root = self
		self.InvContainer:SetSize(self.wow,self.h)
		self.InvContainer:SetPos(self.w-self.wow,0)
		function self.InvContainer:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,self.root.bgcolor)
			surface.SetDrawColor(self.root.linecolor)
			surface.DrawLine(0,0,0,self.root.h)
			surface.DrawLine(1,0,1,self.root.h)
			surface.DrawLine(0,self.root.h-self.root.hobc,self.root.wow,self.root.h-self.root.hobc)
			surface.DrawLine(0,self.root.h-self.root.hobc+1,self.root.wow,self.root.h-self.root.hobc+1)
		end
		
		self.ItemList = self.InvContainer:Add("DScrollPanel")
		self.ItemList.root = self
		self.ItemList:SetSize(self.wow,self.h-self.hobc)
		local scrollBar = self.ItemList:GetVBar()
		local scrollBarroot = self
		function scrollBar:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,scrollBarroot.bgcolor)
		end
		function scrollBar.btnGrip:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,scrollBarroot.bgcolor)
		end
		function scrollBar.btnUp:Paint(w,h)
			--draw.RoundedBox(0,0,0,w,h,Color(50,50,50,255))
		end
		function scrollBar.btnDown:Paint(w,h)
			--draw.RoundedBox(0,0,0,w,h,Color(50,50,50,255))
		end
		scrollBar.btnUp:SetSize(0,0)
		scrollBar.btnDown:SetSize(0,0)
		
		self.Items = {}
		
		self.ButtonContainter = self.InvContainer:Add("Panel")
		self.ButtonContainter:SetSize(self.wow,self.hobc)
		self.ButtonContainter:SetPos(0,self.h-self.hobc)
		
		self.CraftingToggleButton = self.ButtonContainter:Add("DButton")
		self.CraftingToggleButton.root = self
		self.CraftingToggleButton:SetPos(0,0)
		self.CraftingToggleButton:SetSize(self.wob,self.hob)
		self.CraftingToggleButton:SetTextColor(self.textcolor)
		self.CraftingToggleButton:SetText("Show Crafting Grid")
		function self.CraftingToggleButton:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,100,200,100))
			surface.SetDrawColor(self.root.linecolor)
			surface.DrawOutlinedRect(0,0,w,h)
			surface.DrawOutlinedRect(1,1,w-2,h-2)
		end
		self.CraftingToggleButton.DoClick = function()
			if self.CraftContainer:IsVisible() then
				self.CraftContainer:SetVisible(false)
				self.CraftingToggleButton:SetText("Show Crafting Grid")
			else
				self.CraftContainer:SetVisible(true)
				self.CraftingToggleButton:SetText("Hide Crafting Grid")
			end
		end
	end,
	ActionSignal = function(self, action, signal)
		if action == "InvRefresh" then
			for i,e in pairs(self.PlyInv) do
				if IsValid(self.Items[i]) then 
					self.Items[i]:Update(e["Item"],e["Amount"]) 
					continue
				end
				
				if tonumber(e["Amount"]) ~= 0 then
					self.Items[i] = vgui.CreateFromTable(ITEM_ROW, self.Items[i])
					self.Items[i].root = self
					self.Items[i]:ManInit()
					self.Items[i]:Update(e["Item"],e["Amount"])
				
					self.ItemList:AddItem(self.Items[i])
				end
			end
		end	
	end
}

INVENTORY = vgui.RegisterTable(INVENTORY, "EditablePanel")

--local Inv = vgui.CreateFromTable(INVENTORY, Inv)
--timer.Simple(5,function() Inv:Remove(); Inv = nil; end)

--Inventory2:Remove(); Inventory2 = nil

net.Receive("Inventory", function()
	if( !Inventory ) then
		Inventory = vgui.CreateFromTable(INVENTORY)
		Inventory:SetVisible(false)
		--Inventory:PreformLayout()
	end
	if( Inventory:IsVisible() ) then
		Inventory:SetVisible(false)
		gui.EnableScreenClicker(false)
	else
		Inventory:SetVisible(true)
		gui.EnableScreenClicker(true)
		Inventory.PlyInv = net.ReadTable()
		Inventory:Command("InvRefresh")
	end
end)

net.Receive("CIconr", function()
	local inp = net.ReadTable()
	local item = inp[9]
	local img = "jefftech/icons/noicon.png"
	if file.Exists("materials/jefftech/icons/"..item..".png", "GAME") then img = "jefftech/icons/"..item..".png" end
	Inventory.CraftContainer.COutput:SetImage(img)
	Inventory.CraftContainer.COutput.recipe = inp
	Inventory.CraftContainer.COutput.Item = item
end)

net.Receive("CFin", function()
	Inventory.PlyInv = net.ReadTable()
	Inventory:Command("InvRefresh")
end)