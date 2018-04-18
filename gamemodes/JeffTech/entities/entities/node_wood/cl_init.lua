include('shared.lua')

function ENT:Draw()
	self:DrawModel()
    AddWorldTip( self:EntIndex(), "Wood Node", 0.5, self:GetPos(), self  )
end