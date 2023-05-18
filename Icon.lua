
local iconVisible = true

-- Creation of the minimap icon
local myButton = CreateFrame("Button", "MyAddonIcon", Minimap)
myButton:SetSize(32, 32)
myButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)
myButton:SetFrameLevel(Minimap:GetFrameLevel() + 1)
myButton:SetMovable(true)
myButton:RegisterForDrag("LeftButton")

-- Create a circular texture
local myIcon = myButton:CreateTexture(nil, "OVERLAY")
myIcon:SetTexture("Interface\\AddOns\\MythicPlusLootTable\\Circle_Icon_Hourglass.tga")
myIcon:SetPoint("CENTER", myButton, "CENTER")
myIcon:SetSize(24, 24)

-- Set the circular texture as the button's icon
myButton:SetNormalTexture(myIcon)


local function ToggleIcon()
    print("Toggling")
    if iconVisible then
        myButton:Hide()
        iconVisible = false
    else
        myButton:Show()
        iconVisible = true
    end
end

-- Sets up the OnClick script handler that ether toggles table or hides icon
myButton:SetScript("OnClick", function(self, button, down)
    if button == "LeftButton" then
        -- Do something when the left mouse button is clicked
        ToggleLootTable()
    elseif button == "RightButton" then
        -- Do something when the right mouse button is clicked
        -- ToggleIcon()
        print("right click")
    end
end)

-- Allows the icon to be dragged along the minimap
myButton:SetScript("OnDragStart", function(self, button)
    self:StartMoving()

end)
myButton:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()

    local posX, posY = self:GetCenter()
    local mapPosX, mapPosY = Minimap:GetCenter()
    local scale = Minimap:GetEffectiveScale()
    local radius = (Minimap:GetWidth()/2) + 6
    local deltaX, deltaY = posX - mapPosX, posY - mapPosY
    local distance = math.sqrt(deltaX^2 + deltaY^2)
    if distance < radius then -- only reposition the button if it's within the minimap circle
        local angle = math.atan2(deltaY, deltaX)
        self:ClearAllPoints()
        self:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle)*radius, math.sin(angle)*radius)
    end
end)

-- Set up the tooltip text
myButton.tooltipTitle = "Mythic Plus Loot Table"
myButton.tooltipText1 = "Left Click: Toggle Table Window"
myButton.tooltipText2 = "Right Click: Hide Minimap Icon"

-- Sets up the OnEnter and OnLeave script handlers that shows the tooltip
myButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
    GameTooltip:AddLine(self.tooltipTitle, 1, 1, 1)
    GameTooltip:AddLine(self.tooltipText1)
    GameTooltip:AddLine(self.tooltipText2)
    GameTooltip:Show()
end)
myButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)
