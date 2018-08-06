include('shared.lua')

function ENT:Draw()
	self:DrawModel()
    --AddWorldTip( self:EntIndex(), "Wood Node", 0.5, self:GetPos(), self  ) -- A sandbox function be sure to remove it.
	self:DrawText()
end

surface.CreateFont("HUDNumber5",{
	font = "Helvetica",
	size = 40,
	weight = 800
})

function ENT:DrawText()
	local Pos = self:GetPos()
    local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	surface.SetFont("HUDNumber5")
	self.Count = self.Count or "Broken"
	local TextWidth = surface.GetTextSize("Contains:")
    local TextWidth2 = surface.GetTextSize(self.Count)
	local TextWidth3 = surface.GetTextSize("Items")
	cam.Start3D2D(Pos + Ang:Up() * 17, Ang, 0.15)
		draw.WordBox(2, -TextWidth * 0.5 + 5, -150, "Contains:", "HUDNumber5", Color(00, 0, 0, 100), Color(255, 255, 255, 255))
        draw.WordBox(2, -TextWidth2 * 0.5 + 0, -100, self.Count, "HUDNumber5", Color(0, 0, 0, 100), Color(255, 255, 255, 255))
		draw.WordBox(2, -TextWidth3 * 0.5 + 0, -50, "Items", "HUDNumber5", Color(0, 0, 0, 100), Color(255, 255, 255, 255))
    cam.End3D2D()
end

net.Receive("JeffTech_DroppedItemsSpawn", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end
	ent.Count = net.ReadString()
	ent:DrawText()
end)
