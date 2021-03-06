local select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, GetGlyphSocketInfo, tonumber, strfind, hooksecurefunc =
    select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, GetGlyphSocketInfo, tonumber, strfind, hooksecurefunc

local types = {
    spell = "SpellID",
    item  = "ItemID",
    glyph = "GlyphID",
    unit  = "NPC ID"
}

local function addLine(tooltip, id, type)
    tooltip:AddDoubleLine(type .. ":", "|cffffffff" .. id)
    tooltip:Show()
end

-- Spells
hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
    local id = select(11, UnitBuff(...))
    if id then addLine(self, id, types.spell) end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
    local id = select(11, UnitDebuff(...))
    if id then addLine(self, id, types.spell) end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
    local id = select(11, UnitAura(...))
    if id then addLine(self, id, types.spell) end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
    local id = select(3, self:GetSpell())
    if id then addLine(self, id, types.spell) end
end)

-- Units
local f = CreateFrame("frame")
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
f:SetScript("OnEvent", function()
    if GameTooltip:IsVisible() and not UnitIsPlayer("mouseover") and not C_PetBattles.IsInBattle() then
        local id = tonumber(UnitGUID("mouseover"):sub(6, 10), 16)
        if id ~= 0 then
            addLine(GameTooltip, id, types.unit);
        end
    end
end)

-- Items
hooksecurefunc("SetItemRef", function(link, ...)
    local id = tonumber(link:match("spell:(%d+)"))
    if id then addLine(ItemRefTooltip, id, types.item) end
end)

local function attachItemTooltip(self)
    local link = select(2, self:GetItem())
    if link then
        local id = select(3, strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+).*"))
        if id then addLine(self, id, types.item) end
    end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)

-- Glyphs
hooksecurefunc(GameTooltip, "SetGlyph", function(self, ...)
    local id = select(4, GetGlyphSocketInfo(...))
    if id then addLine(self, id, types.glyph) end
end)

hooksecurefunc(GameTooltip, "SetGlyphByID", function(self, id)
    if id then addLine(self, id, types.glyph) end
end)
