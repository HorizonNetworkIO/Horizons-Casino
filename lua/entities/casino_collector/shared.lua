ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Casino Collector"
ENT.Author = "Steel"
ENT.Spawnable = true 
ENT.Category = "HZN"

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "CurrentPot")
    self:NetworkVar("Bool", 1, "Locked")
    self:NetworkVar("Int", 1, "PotID")
end