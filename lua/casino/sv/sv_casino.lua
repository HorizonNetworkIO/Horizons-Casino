HZNCasino.CollectionPots = {}

util.AddNetworkString("HZNCasino.UpdateLock")
net.Receive("HZNCasino.UpdateLock", function(len, ply)
    if (!IsValid(ply)) then return end
    if (!ply:Alive()) then return end
    
    local locked = net.ReadBool()
    local potId = net.ReadInt(8)
    
    HZNCasino:UpdateLock(ply, locked, potId)
end)

util.AddNetworkString("HZNCasino.CollectPot")
net.Receive("HZNCasino.CollectPot", function(len, ply)
    if (!IsValid(ply)) then return end
    if (!ply:Alive()) then return end

    local potId = net.ReadInt(8)

    HZNCasino:CollectPot(ply, potId)
end)

function HZNCasino.AddCollectionPot(ent)
    HZNCasino.CollectionPots[#HZNCasino.CollectionPots + 1] = ent
    return #HZNCasino.CollectionPots
end

function HZNCasino.RemoveCollectionPot(ent)
    -- loop through collection pots and find this ent
    for i = 1, #HZNCasino.CollectionPots do
        if (HZNCasino.CollectionPots[i] == ent) then
            table.remove(HZNCasino.CollectionPots, i)
            return
        end
    end
end

function HZNCasino:CollectPot(ply, potId)
    local collectAmount = HZNCasino.CollectionPots[potId]:GetCurrentPot()

    if (collectAmount == 0) then
        DarkRP.notify(ply, 0, 4, "This pot is empty!")
        return
    end

    if (HZNCasino.CollectionPots[potId]:GetLocked()) then
        DarkRP.notify(ply, 0, 4, "This pot is locked!")
        return
    end

    -- distance check
    if (!HZNLib:InDistance(ply, HZNCasino.CollectionPots[potId], HZNLib.USE_DISTANCE)) then
        DarkRP.notify(ply, 0, 4, "You are too close to the collection pot!")
        return
    end

    HZNCasino.CollectionPots[potId]:SetCurrentPot(0)
    ply:addMoney(collectAmount)

    if (ply == HZNCasino.CollectionPots[potId]:CPPIGetOwner()) then
        DarkRP.notify(ply, 0, 4, "You've collected " .. DLL.FormatMoney(collectAmount) .. " from your casino pot!")
    else
        DarkRP.notify(ply, 0, 4, "You've collected " .. DLL.FormatMoney(collectAmount) .. " from a casino pot!")
    end
end

function HZNCasino:UpdateLock(ply, locked, potId)
    if (ply != HZNCasino.CollectionPots[potId]:CPPIGetOwner()) then
        DarkRP.notify(ply, 1, 4, "You are not the owner of this collection pot.")
        return
    end

    -- distance check
    if (!HZNLib:InDistance(ply, HZNCasino.CollectionPots[potId], HZNLib.USE_DISTANCE)) then
        DarkRP.notify(ply, 0, 4, "You are too close to the collection pot!")
        return
    end


    HZNCasino.CollectionPots[potId]:Lock(locked)
end

function HZNCasino.AddToPlayersPot(ply, caller)
    if (!ply:Alive()) then return end

    if (ply == caller) then return end

    -- loop through pots a
    for i = 1, #HZNCasino.CollectionPots do
        if (HZNCasino.CollectionPots[i]:CPPIGetOwner() == ply) then
            HZNCasino.CollectionPots[i]:RaisePot(HZNCasino.Config.PayoutPerMachine, caller)
            return
        end
    end
end