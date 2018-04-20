local PANEL = {}

function PANEL:Init()
	self:SetSize(ScrW() * 100/1920, ScrH() * 500/1080)
	self:Center()
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0,0,0,w,h,Color(100,100,100,100))
end

vgui.Register("Inventory", PANEL, "Panel")