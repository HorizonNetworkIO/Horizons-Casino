local casino = {}

local function openMenu()
    if (casino.menu) then
        casino.menu:Remove()
    end

    wimg.Register("delete", "https://i.imgur.com/OunTuKU.png")
    casino.closeMat = wimg.Create("delete")

    casino.menu = vgui.Create("DFrame")
    casino.menu:SetSize(HZNHud.SW(350), HZNHud.SH(215))
    casino.menu:Center()
    casino.menu:SetTitle("")
    casino.menu:SetDraggable(true)
    casino.menu:ShowCloseButton(false)
    casino.menu.Paint = function(self, w, h)
        HZNShadows.BeginShadow( "HZNCasino:CollectorMenu4" )
        local x, y = self:LocalToScreen( 0, 0 )
        draw.RoundedBoxEx(6, x, y, w, HZNHud.SH(40), Color(45, 45, 45), true, true, false, false)
        draw.SimpleText(casino.owner:Nick() .. "'s Casino Pot", "HZN:Bold@25", x + HZNHud.SW(15), y + HZNHud.SH(20), Color(231, 231, 231), TEXT_ALIGN_LEFT, 1)
        HZNShadows.EndShadow( "HZNCasino:CollectorMenu4", x, y, 1, 1, 1, 255, 0, 0, false )
    end


    casino.panel = vgui.Create("DPanel", casino.menu)
    casino.panel:SetSize(casino.menu:GetWide(), casino.menu:GetTall() - HZNHud.SH(40))
    casino.panel:SetPos(0, HZNHud.SH(40))
    casino.panel.Paint = function(self, w, h)
        HZNShadows.BeginShadow( "HZNCasino:CollectorMenu3" )
        local x, y = self:LocalToScreen( 0, 0 )
        draw.RoundedBoxEx(6, x, y, w, h, Color(35, 35, 35), false, false, true, true)

        draw.RoundedBox(0, x + HZNHud.SW(15), y + HZNHud.SH(10), w - HZNHud.SW(30), HZNHud.SH(40), Color(45, 45, 45))

        draw.SimpleText("Current Pot ", "HZN:Default@25", x + HZNHud.SW(25), y + HZNHud.SH(30), Color(231, 231, 231), TEXT_ALIGN_LEFT, 1)
        draw.SimpleText(DLL.FormatMoney(casino.currentPot), "HZN:Bold@25", x + w - HZNHud.SW(25), y + HZNHud.SH(30), Color(231, 231, 231), TEXT_ALIGN_RIGHT, 1)
        HZNShadows.EndShadow( "HZNCasino:CollectorMenu3", x, y, 1, 1, 1, 255, 0, 0, false )
    end

    casino.collectButton = vgui.Create("DButton", casino.menu)
    casino.collectButton:SetSize(HZNHud.SW(320), HZNHud.SH(40))
    casino.collectButton:SetPos(casino.menu:GetWide()/2-casino.collectButton:GetWide()/2, HZNHud.SH(105))
    casino.collectButton:SetText("")
    casino.collectButton.Paint = function(self, w, h)
        if (casino.locked) then 
            draw.RoundedBox(2, 0, 0, w, h, Color(82, 141, 27, 20))
            draw.SimpleText("POT IS LOCKED!", "HZN:Bold@25", w / 2, h / 2, Color(255, 255, 255), 1, 1)
        else
            local col = Color(68, 119, 21, 190)
            if (self:IsHovered()) then
                col = Color(68, 119, 21, 100)
            end
            draw.RoundedBox(2, 0, 0, w, h, col)
            draw.SimpleText("Collect", "HZN:Bold@25", w / 2, h / 2, Color(255, 255, 255), 1, 1)
        end
    end
    casino.collectButton.DoClick = function()
        if (!casino.locked) then
            net.Start("HZNCasino.CollectPot")
                net.WriteInt(casino.collectionPotId, 8)
            net.SendToServer()
            casino.menu:Close()
        end
    end

    casino.lockButton = vgui.Create("DButton", casino.menu)
    casino.lockButton:SetSize(HZNHud.SW(320), HZNHud.SH(40))
    casino.lockButton:SetPos(casino.menu:GetWide()/2-casino.lockButton:GetWide()/2, HZNHud.SH(160))
    casino.lockButton:SetText("")
    casino.lockButton.Paint = function(self, w, h)
        local col = Color(180, 33, 33, 190)
        if (self:IsHovered()) then
            col = Color(180, 33, 33, 100)
        end
        draw.RoundedBox(2, 0, 0, w, h, col)
        draw.SimpleText(casino.locked and "Unlock" or "Lock", "HZN:Bold@25", w / 2, h / 2, Color(255, 255, 255), 1, 1)
    end
    casino.lockButton.DoClick = function()
        net.Start("HZNCasino.UpdateLock")
            net.WriteBool(!casino.locked)
            net.WriteInt(casino.collectionPotId, 8)
        net.SendToServer()
        casino.menu:Close()
    end

    casino.closeButton = vgui.Create("DButton", casino.menu)
    casino.closeButton:SetSize(HZNHud.SW(22), HZNHud.SH(22))
    casino.closeButton:SetPos(casino.menu:GetWide()-HZNHud.SW(32), HZNHud.SH(9))
    casino.closeButton:SetText("")
    casino.closeButton.Paint = function(self, w, h)
        local col = color_white
        if (self:IsHovered()) then
            col = Color(255, 255, 255, 75)
        end
        casino.closeMat(0, 0, w, h, col)
    end
    casino.closeButton.DoClick = function()
        casino.menu:Close()
    end

    casino.menu:MakePopup()
end

net.Receive("HZNCasino.OpenMenu", function()
    local casinoEntity = net.ReadEntity()
    casino.owner = casinoEntity:CPPIGetOwner()
    casino.collectionPotId = casinoEntity:GetPotID()
    casino.locked = casinoEntity:GetLocked()
    casino.currentPot = casinoEntity:GetCurrentPot()
     
    -- distance check, fuck you 
    if (LocalPlayer():GetPos():Distance(casinoEntity:GetPos()) > 100) then
        print("[HZN] You are too far away from the casino.")
        return
    end

    openMenu()
end)