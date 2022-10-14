AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("HZNCasino.OpenMenu")

function ENT:Initialize()
    self:SetModel("models/inside/macpro.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    self:SetPotID(HZNCasino.AddCollectionPot(self))
end

function ENT:Use(activator, caller)
    local owner = self:CPPIGetOwner()

    if (self:GetLocked() && activator != owner) then
        DarkRP.notify("This pot is locked!", activator, 1, 4)
        return
    end

    net.Start("HZNCasino.OpenMenu")
        net.WriteEntity(self)
    net.Send(activator)
end

function ENT:OnRemove()
    HZNCasino.RemoveCollectionPot(self)
end

function ENT:RaisePot(amount, caller)
    local newAmount, newLimit = hook.Run("HZNCasino.RaisePot", self, amount, limit, caller)

    if (newAmount) then
        amount = newAmount
    end

    if (newLimit) then
        limit = newLimit
    end

    if (self:GetCurrentPot() == HZNCasino.Config.CasinoCollectorLimit) then
        return
    end

    self:SetCurrentPot(self:GetCurrentPot() + amount)

    if (self:GetCurrentPot() > HZNCasino.Config.CasinoCollectorLimit) then
        self:SetCurrentPot(HZNCasino.Config.CasinoCollectorLimit)
    end
end

function ENT:Lock(lock)
    self:SetLocked(lock)
end

hook.Add("canLockpick", "HZNCasino.CanLockpick", function(ply, ent)
    if ent:GetClass() == "casino_collector" then
        return true
    end
end)

hook.Add("lockpickTime", "HZNCasino.LockpickTime", function(ply, ent)
    if ent:GetClass() == "casino_collector" then
        return HZNCasino.Config.LockpickTime
    end
end)

hook.Add("onLockpickCompleted", "HZNCasino.OnLockpickCompleted", function(ply, success, ent)
    if (ent:GetClass() == "casino_collector" && success) then
        ent:Lock(!ent:GetLocked())
    end
end)