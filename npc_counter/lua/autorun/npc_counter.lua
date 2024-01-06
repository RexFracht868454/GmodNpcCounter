local npcCount = 0

local function CountNPCs()
    npcCount = 0

    for _, ent in pairs(ents.GetAll()) do
        if IsValid(ent) and ent:IsNPC() then
            npcCount = npcCount + 1
        end
    end
end

hook.Add("OnEntityCreated", "UpdateNPCCount", function(ent)
    if IsValid(ent) and ent:IsNPC() then
        CountNPCs()

        net.Start("UpdateNPCCount")
        net.WriteInt(npcCount, 32)
        net.Broadcast()
    end
end)

hook.Add("Think", "UpdateNPCCountThink", function()
    CountNPCs()
end)

local function DrawNPCCountHUD()
    local text = "NPCs: " .. npcCount
    local font = "DermaLarge"
    surface.SetFont(font)

    local textWidth, textHeight = surface.GetTextSize(text)
    local x = ScrW() - textWidth - 20
    local y = ScrH() - textHeight - 20

    draw.RoundedBox(8, x - 5, y - 5, textWidth + 10, textHeight + 10, Color(0, 0, 0, 150))
    draw.SimpleText(text, font, x, y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawOutlinedRect(x - 5, y - 5, textWidth + 10, textHeight + 10)
end

hook.Add("HUDPaint", "DrawNPCCountHUD", DrawNPCCountHUD)

util.AddNetworkString("UpdateNPCCount")
net.Receive("UpdateNPCCount", function(len, ply)
    npcCount = net.ReadInt(32)
end)

CountNPCs()
