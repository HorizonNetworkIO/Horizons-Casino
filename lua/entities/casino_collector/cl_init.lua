include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:DrawTranslucent()
    local angle = EyeAngles()

	-- Only use the Yaw component of the angle
	angle = Angle( 0, angle.y, 0 )

	-- Apply some animation to the angle
	angle.y = angle.y + math.sin( CurTime() ) * 10
    angle.z = angle.z + math.sin( CurTime() ) * 10

	-- Correct the angle so it points at the camera
	-- This is usually done by trial and error using Up(), Right() and Forward() axes
	angle:RotateAroundAxis( angle:Up(), -90 )
	angle:RotateAroundAxis( angle:Forward(), 90 )

    local center = self:OBBCenter()
    local pos = LocalToWorld(center, angle, self:GetPos(), self:GetAngles())

    cam.Start3D2D(pos + Vector(0, 0, 40), angle, 0.1)
        draw.SimpleText("Casino Pot", "HZN:Bold@80", 0, 0, HZNHud:GetColor(3), 1, 1)
        
        if (self:GetLocked()) then
            draw.SimpleText("Locked", "HZN:Bold@70", 0, 50, Color(233, 61, 61), 1, 1)
        end
    cam.End3D2D()
end
