-- -------------------------------------------------------
-- VRBMenu.lua — Dados de spec + botão do minimapa
-- UI unificada está em KZ_Compare.lua (KZCOpenTab)
-- -------------------------------------------------------

VRB_SPEC_DISPLAY = {
    ["RogueCombatSwords"]    = "Combat Swords",
    ["RogueCombatDaggers"]   = "Combat Daggers",
    ["MageDPS"]              = "Mage DPS",
    ["HunterDPS-EP"]         = "MM / BM",
    ["HunterSurvival"]       = "Survival (Melee)",
    ["WarlockSMRuin"]        = "SM/Ruin",
    ["WarlockDestruction"]   = "Destruction",
    ["WarriorFury-EP"]       = "Fury",
    ["WarriorArms-EP"]       = "Arms",
    ["WarriorThreat-EP"]     = "Protection (Threat)",
    ["WarriorMitigation-EP"] = "Protection (Mitigation)",
    ["DruidFeralDPS-EP"]     = "Feral DPS",
    ["DruidTank-EP"]         = "Feral Tank",
    ["DruidThreat-EP"]       = "Bear Tank",
    ["DruidResto-EP"]        = "Restoration",
    ["PaladinProtEH"]        = "Protection",
    ["PaladinRetDPS"]        = "Retribution",
    ["PaladinHEP"]           = "Holy",
    ["PriestHoly"]           = "Holy",
    ["PriestHolyLong"]       = "Holy (Longa Duracao)",
    ["PriestShadow"]         = "Shadow",
    ["ShamanHEP"]            = "Restoration",
    ["ShamanMelee"]          = "Enhancement",
}

-- Stubs de compatibilidade (redireciona para KZCOpenTab)
function VRBMenuOpen()   if KZCOpenTab then KZCOpenTab("spec")  end end
function VRBMenuToggle() if KZCOpenTab then KZCOpenTab("spec")  end end
function VRBProcToggle() if KZCOpenTab then KZCOpenTab("procs") end end

-- -------------------------------------------------------
-- Botão no minimapa
-- -------------------------------------------------------
local VRBMapBtn = CreateFrame("Button", "VRBMapBtn", Minimap)
VRBMapBtn:SetWidth(20) VRBMapBtn:SetHeight(20)
VRBMapBtn:SetFrameStrata("MEDIUM")
VRBMapBtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 28, -4)

local VRBMapIcon = VRBMapBtn:CreateTexture(nil, "ARTWORK")
VRBMapIcon:SetAllPoints()
VRBMapIcon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01")

local VRBMapHl = VRBMapBtn:CreateTexture(nil, "HIGHLIGHT")
VRBMapHl:SetAllPoints()
VRBMapHl:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

VRBMapBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
VRBMapBtn:SetScript("OnClick", function()
    if not KZCOpenTab then return end
    if arg1 == "RightButton" then
        KZCOpenTab("procs")
    else
        KZCOpenTab("compare")
    end
end)
VRBMapBtn:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    GameTooltip:AddLine("|cffFFD700KZ ItemEP|r")
    GameTooltip:AddLine("Clique esquerdo: Comparar itens", 0.8,0.8,0.8)
    GameTooltip:AddLine("Clique direito: Gerenciar Procs",  0.8,0.8,0.8)
    GameTooltip:AddLine(" ", 1,1,1)
    GameTooltip:AddLine("|cffa0a0a0Macros para capturar itens:|r")
    GameTooltip:AddLine("|cffFFD700/kzca|r  — Captura item A (passe o mouse no item antes)", 0.8,0.8,0.8)
    GameTooltip:AddLine("|cffFFD700/kzcb|r  — Captura item B (passe o mouse no item antes)", 0.8,0.8,0.8)
    GameTooltip:AddLine("|cffFFD700/kzc|r   — Abre/fecha o comparador", 0.8,0.8,0.8)
    GameTooltip:Show()
end)
VRBMapBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
