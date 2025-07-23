SoundBoard_UI = {}

function SoundBoard_UI:CreateFrame()
    local frame = CreateFrame("Frame", "SoundBoardFrame", UIParent)
    frame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background" })
    frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:SetWidth(200)
    frame:SetHeight(20 + 30 * 6)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) this:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) this:StopMovingOrSizing() end)

    local allSounds = self:GetAllSounds()
    local y = -10

    for name, _ in pairs(allSounds) do
        local soundName = name
        local btn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        btn:SetText(soundName)
        btn:SetWidth(160)
        btn:SetHeight(24)
        btn:SetPoint("TOP", frame, "TOP", 0, y)
        btn:SetScript("OnClick", function()
            SoundBoard:SendSound(soundName)
            -- SoundBoard:Print("Envoi du son : " .. soundName)
        end)
        y = y - 30
    end

    self:AddMuteButton(frame)

    frame:Hide()

    SLASH_SOUNDBOARD1 = "/sb"
    SlashCmdList["SOUNDBOARD"] = function()
        if frame:IsShown() then
            frame:Hide()
        else
            frame:Show()
        end
    end
end

function SoundBoard_UI:AddMuteButton(parent)
    if self.muteButton then return end

    local btn = CreateFrame("Button", nil, parent)
    btn:SetWidth(24)
    btn:SetHeight(24)
    btn:SetPoint("TOPRIGHT", -4, -4)

    if SoundBoard.muted then
        btn:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up") -- une croix pour mute
    else
        btn:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up") -- une icône visible
    end

    btn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    btn.tooltip = "Activer/Désactiver le son"

    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
        GameTooltip:SetText(btn.tooltip, 1, 1, 1)
        GameTooltip:Show()
    end)

    btn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    btn:SetScript("OnClick", function()
        SoundBoard.muted = not SoundBoard.muted
        if SoundBoard.muted then
            SoundBoard:Print("🔇 Mode muet activé.")
            btn:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
        else
            SoundBoard:Print("🔊 Mode muet désactivé.")
             btn:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up") -- icône verte
        end
    end)

    self.muteButton = btn
end

function SoundBoard_UI:GetAllSounds()
    local sounds = {}
    for k, v in pairs(SoundBoard_Sounds or {}) do sounds[k] = v end
    for k, v in pairs(SoundBoard_Custom or {}) do sounds[k] = v end
    return sounds
end
