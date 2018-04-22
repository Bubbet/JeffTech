local rowsize = 32

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

ITEM_ROW = {
	Init = function(self)
	
		local w = ScrW()/5/2-rowsize/2
		local h = rowsize
		
		self.Line = self:Add("DPanel")
		self.Line:SetSize(self:GetWide()+16,2)
		self.Line:Dock(BOTTOM)
		self.Line:DockMargin(0,0,4,0)
		function self.Line:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
		end
		
		
		self.Icon = self:Add("DImage")
		self.Icon:Dock(LEFT)
		self.Icon:SetSize(rowsize,rowsize)
		self.Icon:SetContentAlignment(5)
		self.Icon:DockMargin(1,0,0,0)
		
		self.ItemPanel = self:Add("Panel")
		self.ItemPanel:SetSize(w,h)
		self.ItemPanel:Dock(LEFT)
		
		self.AmountPanel = self:Add("Panel")
		self.AmountPanel:SetSize(w,h)
		self.AmountPanel:Dock(LEFT)
		
		self.Item = self.ItemPanel:Add("DLabel")
		self.Item:Dock(FILL)
		self.Item:SetFont("Inv_Contents")
		self.Item:SetContentAlignment(4)
		self.Item:SetTextColor(Color(255,255,255))
		--self.Item:DockMargin(0,1,self:GetWide()/2+rowsize/2,1)
		self.Item:SizeToContents()

		self.Amount = self.AmountPanel:Add("DLabel")
		self.Amount:Dock(FILL)
		self.Amount:SetFont("Inv_Contents")
		--self.Amount:SetContentAlignment(4)
		self.Amount:SetTextColor(Color(255,255,255))
		--self.Amount:DockMargin(0,1,0,1)
		self.Amount:SizeToContents()
		
		self:Dock(TOP)
		self:SetHeight(rowsize)
		self:DockMargin(0,2,0,2)
		
	end,
	Update = function(self, item, amount)
		self.Item:SetText(item)
		self.Amount:SetText(amount)
	end,
	Paint = function(self, w, h)
		surface.SetDrawColor(255,255,255) -- why the fuck arent you working!
		surface.DrawLine(0,h,w,h)
	end,
	Think = function(self)
		if self.Amount:GetText() == "0" then
			self:Remove()
		end
	end
}

ITEM_ROW = vgui.RegisterTable(ITEM_ROW, "DPanel")

INVENTORY = {
	Init = function(self)
		local w = ScrW()/5
		local h = ScrH()
		
		self.Base = self:Add("Panel")
		self.Base:Dock(FILL)
		self.Base:SetSize(w,h)
		
		self.ItemListContainer = self.Base:Add("DPanel")
		self.ItemListContainer:Dock(TOP)
		self.ItemListContainer:SetSize(w,h*3/4)
		function self.ItemListContainer:Paint() end
		
		self.ButtonContainer = self.Base:Add("DPanel")
		self.ButtonContainer:Dock(BOTTOM)
		self.ButtonContainer:SetSize(w,h/4)
		function self.ButtonContainer:Paint() end
		
		self.ItemList = self.ItemListContainer:Add("DScrollPanel")
		self.ItemList:Dock(FILL)
		--self.ItemList:DockMargin(0,0,0,h/4)
		local scrollBar = self.ItemList:GetVBar()
		function scrollBar:Paint(w,h)
			surface.SetDrawColor(50,50,50,255)
			draw.RoundedBox(0,0,0,w,h,Color(50,50,50,100))
		end
		function scrollBar.btnGrip:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(100,100,100,150))
		end
		function scrollBar.btnUp:Paint(w,h)
			--draw.RoundedBox(0,0,0,w,h,Color(50,50,50,255))
		end
		function scrollBar.btnDown:Paint(w,h)
			--draw.RoundedBox(0,0,0,w,h,Color(50,50,50,255))
		end
		
		self.Line = self.ButtonContainer:Add("DPanel")
		self.Line:SetSize(self:GetWide()+16,2)
		self.Line:Dock(TOP)
		self.Line:DockMargin(0,0,4,0)
		function self.Line:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
		end
		
		self.Items = {}
		
	end,
	PreformLayout = function(self)
		self:SetSize(ScrW()/5, ScrH())
		self:SetPos(ScrW()/5*4,0)
	end,
	Paint = function(self, w, h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
		surface.DrawLine(0,0,0,h)
	end,
	ActionSignal = function(self, action,  signal)
		if action == "InvRefresh" then			
			for i,e in pairs(self.PlyInv) do
				if IsValid(self.Items[i]) then 
					self.Items[i]:Update(e["Item"],e["Amount"]) 
					continue
				end
			
				self.Items[i] = vgui.CreateFromTable(ITEM_ROW, self.Items[i])
				self.Items[i]:Update(e["Item"],e["Amount"])
			
				self.ItemList:AddItem(self.Items[i])
			end
		end	
	end
}

INVENTORY = vgui.RegisterTable(INVENTORY, "EditablePanel")

net.Receive("Inventory", function()
	if( !Inventory ) then
		Inventory = vgui.CreateFromTable(INVENTORY)
		Inventory:SetVisible(false)
		Inventory:PreformLayout()
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