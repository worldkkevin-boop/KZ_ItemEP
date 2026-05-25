-- ================================================================
-- KZ_Compare.lua  —  Hub unificado KZ ItemEP
-- Abas: Comparar | Spec EP | Proc EP         /kzc /kzca /kzcb
-- ================================================================

local KZC_W    = 420
local KZC_PAD  = 8
local KZC_HALF = 192

local KZC_H_COMPARE = 360

-- ── nomes curtos por spec ────────────────────────────────────────
local KZC_SPEC_SHORT = {
    ["RogueCombatSwords"]    = "CS",   ["RogueCombatDaggers"]   = "CD",
    ["WarriorFury-EP"]       = "Fury", ["WarriorThreat-EP"]     = "Prot",
    ["WarriorMitigation-EP"] = "Mitig",["WarriorArms-EP"]       = "Arms",
    ["DruidFeralDPS-EP"]     = "Feral",["DruidTank-EP"]         = "Bear",
    ["DruidThreat-EP"]       = "BearT",["DruidResto-EP"]        = "Resto",
    ["HunterDPS-EP"]         = "Hunt", ["HunterSurvival"]       = "Surv",
    ["MageDPS"]              = "Mage", ["WarlockSMRuin"]        = "SMR",
    ["WarlockDestruction"]   = "Destro",["ShamanHEP"]           = "Heal",
    ["ShamanMelee"]          = "Melee",["PaladinRetDPS"]        = "Ret",
    ["PaladinHEP"]           = "Holy", ["PaladinProtEH"]        = "Prot",
    ["PriestHoly"]           = "Holy", ["PriestHolyLong"]       = "HolyL",
    ["PriestShadow"]         = "Shad",
}

-- ── nomes de display por spec ────────────────────────────────────
local KZC_SPEC_DISPLAY = {
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

-- ── cores por qualidade ──────────────────────────────────────────
local KZC_QCOLOR = {
    [0]="ff9d9d9d",[1]="ffffffff",[2]="ff1eff00",
    [3]="ff0070dd",[4]="ffa335ee",[5]="ffff8000",
}

-- ================================================================
-- Frame principal
-- ================================================================
local KZCFrame = CreateFrame("Frame", "KZCompareFrame", UIParent)
KZCFrame:SetWidth(KZC_W)
KZCFrame:SetHeight(KZC_H_COMPARE)
KZCFrame:SetFrameStrata("DIALOG")
KZCFrame:SetMovable(true)
KZCFrame:EnableMouse(true)
KZCFrame:RegisterForDrag("LeftButton")
KZCFrame:SetScript("OnDragStart", function() this:StartMoving() end)
KZCFrame:SetScript("OnDragStop",  function() this:StopMovingOrSizing() end)
KZCFrame:SetBackdrop({
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile=true, tileSize=16, edgeSize=12,
    insets={left=3,right=3,top=3,bottom=3}
})
KZCFrame:SetBackdropColor(0.05, 0.05, 0.05, 1.0)
KZCFrame:SetBackdropBorderColor(0.8, 0.6, 0.0, 1)
KZCFrame:SetPoint("CENTER", UIParent, "CENTER", 250, 0)
KZCFrame:Hide()

local KZCBg = KZCFrame:CreateTexture(nil, "BACKGROUND")
KZCBg:SetAllPoints(KZCFrame)
KZCBg:SetTexture(0.06, 0.05, 0.04, 1.0)

local KZCTitleFS = KZCFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
KZCTitleFS:SetPoint("TOP", KZCFrame, "TOP", 0, -8)
KZCTitleFS:SetText("|cffFFD700KZ|r ItemEP")

local KZCCloseBtn = CreateFrame("Button", nil, KZCFrame, "UIPanelCloseButton")
KZCCloseBtn:SetPoint("TOPRIGHT", KZCFrame, "TOPRIGHT", 0, 0)
KZCCloseBtn:SetScript("OnClick", function() KZCFrame:Hide() end)

local KZCSepTop = KZCFrame:CreateTexture(nil, "ARTWORK")
KZCSepTop:SetHeight(1)
KZCSepTop:SetPoint("TOPLEFT",  KZCFrame, "TOPLEFT",  6, -22)
KZCSepTop:SetPoint("TOPRIGHT", KZCFrame, "TOPRIGHT", -6, -22)
KZCSepTop:SetTexture(0.8, 0.6, 0.0, 0.6)

-- rodapé da aba Comparar (escondido nas outras abas)
local KZCSepBot = KZCFrame:CreateTexture(nil, "ARTWORK")
KZCSepBot:SetHeight(1)
KZCSepBot:SetPoint("BOTTOMLEFT",  KZCFrame, "BOTTOMLEFT",  6, 32)
KZCSepBot:SetPoint("BOTTOMRIGHT", KZCFrame, "BOTTOMRIGHT", -6, 32)
KZCSepBot:SetTexture(0.4, 0.4, 0.4, 0.6)

local KZCDiffFS = KZCFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
KZCDiffFS:SetPoint("BOTTOM", KZCFrame, "BOTTOM", 0, 10)
KZCDiffFS:SetWidth(KZC_W - 20)
KZCDiffFS:SetJustifyH("CENTER")
KZCDiffFS:SetText("|cffa0a0a0Capture dois itens para comparar|r")

-- ================================================================
-- Sistema de abas
-- ================================================================
local KZC_ACTIVE_TAB = "compare"
local KZCTabBtns     = {}
local KZCPaneCompare, KZCPaneSpec, KZCPaneProcs
local KZCUpdateDiff, KZCSpecRefresh, KZCProcsRefresh

local KZC_TAB_DEFS = {
    {key="compare", label="Comparar"},
    {key="spec",    label="Spec EP"},
    {key="procs",   label="Proc EP"},
}
local TAB_BTN_W = math.floor((KZC_W - KZC_PAD*2 - 4) / 3)

local function KZCRefreshTabBtns()
    for _, tb in ipairs(KZCTabBtns) do
        if tb.key == KZC_ACTIVE_TAB then
            tb.bg:SetTexture(0.28, 0.20, 0.02, 0.95)
            tb.fs:SetText("|cffFFD700" .. tb.label .. "|r")
        else
            tb.bg:SetTexture(0.10, 0.10, 0.10, 0.80)
            tb.fs:SetText("|cff777777" .. tb.label .. "|r")
        end
    end
end

local function KZCSetTab(tab)
    KZC_ACTIVE_TAB = tab
    if KZCPaneCompare then KZCPaneCompare:Hide() end
    if KZCPaneSpec    then KZCPaneSpec:Hide()    end
    if KZCPaneProcs   then KZCPaneProcs:Hide()   end
    KZCSepBot:Hide()
    KZCDiffFS:Hide()

    if tab == "compare" then
        KZCFrame:SetHeight(KZC_H_COMPARE)
        KZCSepBot:Show()
        KZCDiffFS:Show()
        if KZCPaneCompare then KZCPaneCompare:Show() end
        if KZCUpdateDiff  then KZCUpdateDiff() end
    elseif tab == "spec" then
        if KZCSpecRefresh then KZCSpecRefresh() end
        if KZCPaneSpec then KZCPaneSpec:Show() end
    elseif tab == "procs" then
        if KZCProcsRefresh then KZCProcsRefresh() end
        if KZCPaneProcs then KZCPaneProcs:Show() end
    end
    KZCRefreshTabBtns()
end

for i, tabDef in ipairs(KZC_TAB_DEFS) do
    local btn = CreateFrame("Button", nil, KZCFrame)
    btn:SetWidth(TAB_BTN_W) btn:SetHeight(20)
    btn:SetPoint("TOPLEFT", KZCFrame, "TOPLEFT", KZC_PAD + (i-1)*(TAB_BTN_W+2), -24)
    local bg = btn:CreateTexture(nil,"BACKGROUND"); bg:SetAllPoints()
    bg:SetTexture(0.10,0.10,0.10,0.80)
    local hl = btn:CreateTexture(nil,"HIGHLIGHT"); hl:SetAllPoints()
    hl:SetTexture(1,1,1,0.08)
    local fs = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); fs:SetAllPoints()
    fs:SetText("|cff777777" .. tabDef.label .. "|r")
    local key = tabDef.key
    btn:SetScript("OnClick", function() KZCSetTab(key) end)
    KZCTabBtns[i] = {key=key, label=tabDef.label, bg=bg, fs=fs}
end
-- aba Comparar ativa por padrão
KZCTabBtns[1].bg:SetTexture(0.28, 0.20, 0.02, 0.95)
KZCTabBtns[1].fs:SetText("|cffFFD700Comparar|r")

local KZCTabSep = KZCFrame:CreateTexture(nil, "ARTWORK")
KZCTabSep:SetHeight(1)
KZCTabSep:SetPoint("TOPLEFT",  KZCFrame, "TOPLEFT",  6, -46)
KZCTabSep:SetPoint("TOPRIGHT", KZCFrame, "TOPRIGHT", -6, -46)
KZCTabSep:SetTexture(0.4, 0.4, 0.4, 0.5)

-- ================================================================
-- Panes (sub-frames por aba)
-- ================================================================
KZCPaneCompare = CreateFrame("Frame", nil, KZCFrame)
KZCPaneCompare:SetPoint("TOPLEFT",     KZCFrame, "TOPLEFT",    0, -48)
KZCPaneCompare:SetPoint("BOTTOMRIGHT", KZCFrame, "BOTTOMRIGHT", 0, 34)
KZCPaneCompare:Show()

KZCPaneSpec = CreateFrame("Frame", nil, KZCFrame)
KZCPaneSpec:SetPoint("TOPLEFT",     KZCFrame, "TOPLEFT",    0, -48)
KZCPaneSpec:SetPoint("BOTTOMRIGHT", KZCFrame, "BOTTOMRIGHT", 0, 6)
KZCPaneSpec:Hide()

KZCPaneProcs = CreateFrame("Frame", nil, KZCFrame)
KZCPaneProcs:SetPoint("TOPLEFT",     KZCFrame, "TOPLEFT",    0, -48)
KZCPaneProcs:SetPoint("BOTTOMRIGHT", KZCFrame, "BOTTOMRIGHT", 0, 6)
KZCPaneProcs:Hide()

-- ================================================================
-- Aba COMPARAR
-- ================================================================
local KZCSpecFS = KZCPaneCompare:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
KZCSpecFS:SetPoint("TOPLEFT", KZCPaneCompare, "TOPLEFT", KZC_PAD, -6)
KZCSpecFS:SetText("|cffa0a0a0Spec: (nenhuma)|r")

local KZCSepMid = KZCPaneCompare:CreateTexture(nil, "ARTWORK")
KZCSepMid:SetHeight(1)
KZCSepMid:SetPoint("TOPLEFT",  KZCPaneCompare, "TOPLEFT",  6, -20)
KZCSepMid:SetPoint("TOPRIGHT", KZCPaneCompare, "TOPRIGHT", -6, -20)
KZCSepMid:SetTexture(0.3, 0.3, 0.3, 0.5)

local KZCDivV = KZCPaneCompare:CreateTexture(nil, "ARTWORK")
KZCDivV:SetWidth(1)
KZCDivV:SetPoint("TOPLEFT",    KZCPaneCompare, "TOPLEFT",    KZC_PAD + KZC_HALF + 3, -21)
KZCDivV:SetPoint("BOTTOMLEFT", KZCPaneCompare, "BOTTOMLEFT", KZC_PAD + KZC_HALF + 3,   0)
KZCDivV:SetTexture(0.4, 0.4, 0.4, 0.5)

-- ── dados dos dois slots ─────────────────────────────────────────
local KZCData = {
    [1] = {link=nil,name=nil,ep=nil,ep_oh=nil,quality=1,texture=nil,ep_specs={},selectedSpec=nil},
    [2] = {link=nil,name=nil,ep=nil,ep_oh=nil,quality=1,texture=nil,ep_specs={},selectedSpec=nil},
}
local KZCSlotUI = {}

local function KZCUpdateSpecLabel(slot)
    local ui = KZCSlotUI[slot]
    if not ui then return end
    local sp = KZCData[slot].selectedSpec
    if sp then
        ui.specLabel:SetText("|cffFFD700" .. (KZC_SPEC_SHORT[sp] or sp:sub(1,5)) .. "|r")
    else
        ui.specLabel:SetText("|cffa0a0a0(spec)|r")
    end
end

local KZCLoadSlot  -- forward declaration

local function KZCCycleSlotSpec(slot, dir)
    local d     = KZCData[slot]
    local specs = (VRB_LABELS and VRB_LABELS[UnitClass("player")]) or {}
    if table.getn(specs) == 0 then return end
    if not d.selectedSpec then
        d.selectedSpec = specs[1]
    else
        local cur = 1
        for i, sp in ipairs(specs) do if sp == d.selectedSpec then cur=i break end end
        cur = cur + dir
        if cur < 1 then cur = table.getn(specs) end
        if cur > table.getn(specs) then cur = 1 end
        d.selectedSpec = specs[cur]
    end
    KZCUpdateSpecLabel(slot)
    if d.link then KZCLoadSlot(slot) end
end

local function KZCBuildPanel(slot)
    local xOff = (slot == 1) and KZC_PAD or (KZC_PAD + KZC_HALF + 7)
    local label = (slot == 1) and "A" or "B"

    local captBtn = CreateFrame("Button", nil, KZCPaneCompare)
    captBtn:SetWidth(KZC_HALF) captBtn:SetHeight(20)
    captBtn:SetPoint("TOPLEFT", KZCPaneCompare, "TOPLEFT", xOff, -24)
    local cBg = captBtn:CreateTexture(nil,"BACKGROUND"); cBg:SetAllPoints(); cBg:SetTexture(0.15,0.15,0.05,0.9)
    local cHL = captBtn:CreateTexture(nil,"HIGHLIGHT");  cHL:SetAllPoints(); cHL:SetTexture(0.5,0.5,0.1,0.3)
    local cTx = captBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); cTx:SetAllPoints()
    cTx:SetText("|cffFFD700+ Capturar " .. label .. "|r")

    local specPrev = CreateFrame("Button", nil, KZCPaneCompare)
    specPrev:SetWidth(18) specPrev:SetHeight(16)
    specPrev:SetPoint("TOPLEFT", KZCPaneCompare, "TOPLEFT", xOff, -46)
    local spPBg = specPrev:CreateTexture(nil,"BACKGROUND"); spPBg:SetAllPoints(); spPBg:SetTexture(0.2,0.2,0.2,0.8)
    local spPHl = specPrev:CreateTexture(nil,"HIGHLIGHT");  spPHl:SetAllPoints(); spPHl:SetTexture(1,1,1,0.2)
    local spPTx = specPrev:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); spPTx:SetAllPoints(); spPTx:SetText("<")

    local specLabel = KZCPaneCompare:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    specLabel:SetPoint("TOPLEFT", KZCPaneCompare, "TOPLEFT", xOff+20, -48)
    specLabel:SetWidth(KZC_HALF-40) specLabel:SetJustifyH("CENTER")
    specLabel:SetText("|cffa0a0a0(spec)|r")

    local specNext = CreateFrame("Button", nil, KZCPaneCompare)
    specNext:SetWidth(18) specNext:SetHeight(16)
    specNext:SetPoint("TOPLEFT", KZCPaneCompare, "TOPLEFT", xOff+KZC_HALF-20, -46)
    local spNBg = specNext:CreateTexture(nil,"BACKGROUND"); spNBg:SetAllPoints(); spNBg:SetTexture(0.2,0.2,0.2,0.8)
    local spNHl = specNext:CreateTexture(nil,"HIGHLIGHT");  spNHl:SetAllPoints(); spNHl:SetTexture(1,1,1,0.2)
    local spNTx = specNext:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); spNTx:SetAllPoints(); spNTx:SetText(">")

    local iconFrame = CreateFrame("Frame", nil, KZCPaneCompare)
    iconFrame:SetWidth(32) iconFrame:SetHeight(32)
    iconFrame:SetPoint("TOPLEFT", KZCPaneCompare, "TOPLEFT", xOff, -64)
    local iconBorder = iconFrame:CreateTexture(nil,"BACKGROUND"); iconBorder:SetAllPoints(); iconBorder:SetTexture(0.3,0.3,0.3,0.8)
    local iconTex = iconFrame:CreateTexture(nil,"ARTWORK")
    iconTex:SetPoint("TOPLEFT",     iconFrame, "TOPLEFT",     1, -1)
    iconTex:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", -1,  1)
    iconTex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

    local nameFS = KZCPaneCompare:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    nameFS:SetPoint("TOPLEFT", KZCPaneCompare, "TOPLEFT", xOff+36, -66)
    nameFS:SetWidth(KZC_HALF-38) nameFS:SetJustifyH("LEFT")
    nameFS:SetText("|cffa0a0a0(vazio)|r")

    local epSpecFS = {}
    for i = 1, 4 do
        local fs = KZCPaneCompare:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        fs:SetPoint("TOPLEFT", KZCPaneCompare, "TOPLEFT", xOff, -100-(i-1)*13)
        fs:SetWidth(KZC_HALF) fs:SetJustifyH("LEFT") fs:SetText("")
        epSpecFS[i] = fs
    end

    local statsFS = KZCPaneCompare:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    statsFS:SetPoint("TOPLEFT", KZCPaneCompare, "TOPLEFT", xOff, -156)
    statsFS:SetWidth(KZC_HALF) statsFS:SetJustifyH("LEFT") statsFS:SetText("")

    KZCSlotUI[slot] = {
        captBtn=captBtn, specPrev=specPrev, specNext=specNext, specLabel=specLabel,
        iconTex=iconTex, nameFS=nameFS, epSpecFS=epSpecFS, statsFS=statsFS,
    }
end

KZCBuildPanel(1)
KZCBuildPanel(2)

-- ── atualiza comparação ───────────────────────────────────────────
KZCUpdateDiff = function()
    local sA = KZCData[1].selectedSpec
    local sB = KZCData[2].selectedSpec
    KZCSpecFS:SetText(
        "|cffa0a0a0A:|r |cffFFD700" .. (sA and (KZC_SPEC_SHORT[sA] or sA:sub(1,5)) or "?") .. "|r" ..
        "   |cffa0a0a0B:|r |cffFFD700" .. (sB and (KZC_SPEC_SHORT[sB] or sB:sub(1,5)) or "?") .. "|r"
    )
    local ep1, ep2 = KZCData[1].ep, KZCData[2].ep
    local oh1, oh2 = KZCData[1].ep_oh, KZCData[2].ep_oh
    if not (ep1 and ep2 and ep1 > 0 and ep2 > 0) then
        if ep1 and ep1 > 0 then KZCDiffFS:SetText("|cffa0a0a0Capture o item B para comparar|r")
        elseif ep2 and ep2 > 0 then KZCDiffFS:SetText("|cffa0a0a0Capture o item A para comparar|r")
        else KZCDiffFS:SetText("|cffa0a0a0Capture dois itens para comparar|r") end
        return
    end
    local function cmpLine(pre, v1, v2)
        local d = v1 - v2
        if     d >  0.5 then return pre .. "|cff00ff00A +" .. string.format("%.2f", d)  .. " EP|r"
        elseif d < -0.5 then return pre .. "|cffff6666B +" .. string.format("%.2f", -d) .. " EP|r"
        else                  return pre .. "|cffffff00= iguais|r" end
    end
    local txt = cmpLine("|cffa0a0a0MH:|r ", ep1, ep2)
    if oh1 and oh2 then txt = txt .. "\n" .. cmpLine("|cffa0a0a0OH:|r ", oh1, oh2) end
    KZCDiffFS:SetText(txt)
end

-- ── tooltip oculto para scan ──────────────────────────────────────
local KZCScanTip
local function KZCEnsureTip()
    if not KZCScanTip then
        KZCScanTip = CreateFrame("GameTooltip","KZCScanTooltip",UIParent,"GameTooltipTemplate")
        KZCScanTip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end
end

local function KZCReadWeaponSlot()
    for i = 1, KZCScanTip:NumLines() do
        local lo = getglobal("KZCScanTooltipTextLeft"  .. i)
        local ro = getglobal("KZCScanTooltipTextRight" .. i)
        local lt = (lo and lo:GetText()) or ""
        local rt = (ro and ro:GetText()) or ""
        if string.find(lt, "^Off Hand")  then return "INVTYPE_WEAPONOFFHAND" end
        if string.find(lt, "^Main Hand") then return "INVTYPE_WEAPONMAINHAND" end
        if string.find(lt, "^Two%-Hand") or string.find(lt, "^Two Hand") then return "INVTYPE_2HWEAPON" end
        if string.find(lt, "^One%-Hand") or string.find(lt, "^Held In Off") then return "INVTYPE_WEAPON" end
        if lt=="Ranged" or lt=="Gun" or lt=="Bow" or lt=="Crossbow" or lt=="Wand" then return "INVTYPE_RANGED" end
        if rt=="Gun" or rt=="Bow" or rt=="Crossbow" or rt=="Wand" or rt=="Thrown" then return "INVTYPE_RANGED" end
    end
    return nil
end

local function KZCReadWeaponDPSSpeed()
    for i = 1, KZCScanTip:NumLines() do
        local lo = getglobal("KZCScanTooltipTextLeft"  .. i)
        local ro = getglobal("KZCScanTooltipTextRight" .. i)
        local lt = (lo and lo:GetText()) or ""
        local rt = (ro and ro:GetText()) or ""
        local mn, mx = string.match(lt, "(%d+) %- (%d+)")
        if mn then
            local spd = string.match(rt, "Speed ([%d%.]+)") or string.match(lt, "Speed ([%d%.]+)")
            if spd then
                spd = tonumber(spd)
                return (tonumber(mn)+tonumber(mx))/2/spd, spd
            end
        end
    end
    return nil, nil
end

local function KZCBareLink(link)
    if not link then return nil end
    local _, _, hl = string.find(link, "|H([^|]+)|h")
    return hl or link
end

-- ── colorização de stats ──────────────────────────────────────────
local function KZCColorLine(line)
    if string.find(line, "^Binds") then return "|cff888888" .. line .. "|r" end
    if string.find(line, "^%(") and string.find(line, "per second") then return "|cff999999" .. line .. "|r" end
    if string.find(line, "%d+ %- %d+") and string.find(line, "Damage") then return "|cffffffff" .. line .. "|r" end
    if string.find(line, "^Equip:") then return "|cffFFD700" .. line .. "|r" end
    if string.find(line, "^Use:")   then return "|cff88ddff" .. line .. "|r" end
    if string.find(line, "^Chance on hit:") or string.find(line, "^On equip:") then return "|cffff9933" .. line .. "|r" end
    if string.find(line, "^%+") or string.find(line, "^Weapon Damage") then return "|cff33ff66" .. line .. "|r" end
    return "|cffcccccc" .. line .. "|r"
end

local KZC_SKIP = {"Durability","Sell","Buy","Requires","Quest","Soulbound","Unique"}
local function KZCStatLines(tipName, numLines)
    local result, count = "", 0
    for i = 2, numLines do
        local lo = getglobal(tipName.."TextLeft" ..i)
        local ro = getglobal(tipName.."TextRight"..i)
        local lt = (lo and lo:GetText()) or ""
        local rt = (ro and ro:GetText()) or ""
        if lt ~= "" then
            local skip = false
            for _, pat in ipairs(KZC_SKIP) do if string.find(lt, pat) then skip=true break end end
            if not skip then
                local line = lt
                if rt ~= "" then line = line .. "  " .. rt end
                if result ~= "" then result = result .. "\n" end
                result = result .. KZCColorLine(line)
                count = count + 1
                if count >= 8 then break end
            end
        end
    end
    return result
end

-- ── carrega e exibe um slot ───────────────────────────────────────
KZCLoadSlot = function(slot)
    local d  = KZCData[slot]
    local ui = KZCSlotUI[slot]
    if not d.link then return end

    local bareLink = KZCBareLink(d.link)
    KZCEnsureTip()
    KZCScanTip:ClearLines()
    local scanOk = pcall(function() KZCScanTip:SetHyperlink(bareLink) end)
    local statsText = ""
    if scanOk then statsText = KZCStatLines("KZCScanTooltip", KZCScanTip:NumLines()) end

    local iName, iQuality, iTexture
    local function tryInfo(arg)
        local n, _, _, _, _, _, _, q, _, t = GetItemInfo(arg)
        if n then iName=n; iQuality=q; iTexture=t end
    end
    tryInfo(d.link)
    if not iName then tryInfo(bareLink) end
    if iName then d.name=iName; d.quality=iQuality or 1; d.texture=iTexture end

    local slotType = scanOk and KZCReadWeaponSlot() or nil
    local isOneHand = slotType == "INVTYPE_WEAPON" or slotType == "INVTYPE_WEAPONMAINHAND" or slotType == "INVTYPE_WEAPONOFFHAND"
    local wDPS, wSpd = nil, nil
    if isOneHand and scanOk then wDPS, wSpd = KZCReadWeaponDPSSpeed() end

    local className = UnitClass("player")
    local specs = (VRB_LABELS and VRB_LABELS[className]) or {}
    local nm = d.name

    if not d.selectedSpec then
        d.selectedSpec = VRB_ACTIVE_SPEC or (specs[1] and specs[1]) or nil
    end
    KZCUpdateSpecLabel(slot)

    d.ep_specs = {}
    d.ep    = 0
    d.ep_oh = nil

    for i, spec in ipairs(specs) do
        if VRB_WEIGHTS and VRB_WEIGHTS[spec] then
            local ep_mh = VRBScanItemEP(d.link, spec) or 0
            local pEP = 0
            if nm then
                if VRB_PROC_DB and VRB_PROC_DB[nm] then
                    local pv = VRB_PROC_DB[nm]
                    if type(pv) == "number" then pEP = pv
                    elseif type(pv) == "table" and pv[spec] then pEP = pv[spec] end
                elseif VRB_CUSTOM_ITEMS and VRB_CUSTOM_ITEMS[nm] and VRB_CUSTOM_ITEMS[nm][spec] then
                    pEP = VRB_CUSTOM_ITEMS[nm][spec]
                end
            end
            ep_mh = ep_mh + pEP
            local ep_oh = nil
            if isOneHand and wDPS and wSpd then
                local w   = VRB_WEIGHTS[spec]
                local mhC = wDPS*(w["MHDPS"] or 0) + wSpd*(w["MHSPEED"] or 0)
                local ohC = wDPS*(w["OHDPS"] or 0) + wSpd*(w["OHSPEED"] or 0)
                ep_oh = ep_mh - mhC + ohC
            end
            d.ep_specs[i] = {spec=spec, ep_mh=ep_mh, ep_oh=ep_oh, proc=pEP}
            if spec == d.selectedSpec then
                d.ep    = ep_mh
                d.ep_oh = ep_oh
            end
        end
    end
    if d.ep == 0 and d.selectedSpec and VRB_WEIGHTS and VRB_WEIGHTS[d.selectedSpec] then
        d.ep = VRBScanItemEP(d.link, d.selectedSpec) or 0
    end

    local qc = KZC_QCOLOR[d.quality] or "ffffffff"
    ui.nameFS:SetText("|c" .. qc .. (d.name or "?") .. "|r")
    if d.texture then ui.iconTex:SetTexture(d.texture) end

    for i = 1, 4 do
        local row = ui.epSpecFS[i]
        if not row then break end
        local sd = d.ep_specs[i]
        if sd and sd.ep_mh and sd.ep_mh > 0 then
            local short = KZC_SPEC_SHORT[sd.spec] or sd.spec:sub(1,5)
            local isSel = (sd.spec == d.selectedSpec)
            local cLbl  = isSel and "ffFFD700" or "ff999999"
            local cMH   = isSel and "ffFFD700" or "ffbbbbbb"
            local txt = "|c"..cLbl..short..":|r |c"..cMH..string.format("%.1f",sd.ep_mh).." MH|r"
            if sd.ep_oh then
                local cOH = isSel and "ff88ccff" or "ff7799bb"
                txt = txt .. "  |c"..cOH..string.format("%.1f",sd.ep_oh).." OH|r"
            end
            if sd.proc > 0 then txt = txt .. " |cffa0a0a0+"..string.format("%.1f",sd.proc).."p|r" end
            row:SetText(txt)
        else
            row:SetText("")
        end
    end

    ui.statsFS:SetText(statsText)
    KZCUpdateDiff()
end

-- ================================================================
-- Aba SPEC EP
-- ================================================================
local KZCSpecClassFS = KZCPaneSpec:CreateFontString(nil,"OVERLAY","GameFontNormal")
KZCSpecClassFS:SetPoint("TOP", KZCPaneSpec, "TOP", 0, -10)
KZCSpecClassFS:SetText("|cffa0a0a0Carregando...|r")

local KZCSpecSepLine = KZCPaneSpec:CreateTexture(nil,"ARTWORK")
KZCSpecSepLine:SetHeight(1)
KZCSpecSepLine:SetPoint("TOPLEFT",  KZCPaneSpec, "TOPLEFT",  6, -26)
KZCSpecSepLine:SetPoint("TOPRIGHT", KZCPaneSpec, "TOPRIGHT", -6, -26)
KZCSpecSepLine:SetTexture(0.4, 0.4, 0.4, 0.6)

local KZCSpecBtns = {}
local KZCSpecDynSeps = {}

KZCSpecRefresh = function()
    for _, b in ipairs(KZCSpecBtns)   do b:Hide() end
    for _, s in ipairs(KZCSpecDynSeps) do s:Hide() end
    KZCSpecBtns    = {}
    KZCSpecDynSeps = {}

    local className, classFileName = UnitClass("player")
    if not className then KZCFrame:SetHeight(130) return end

    local color = RAID_CLASS_COLORS[classFileName] or {r=1,g=0.82,b=0}
    local ch = string.format("ff%02x%02x%02x", color.r*255, color.g*255, color.b*255)
    KZCSpecClassFS:SetText("|c"..ch..className.."|r  |cffa0a0a0Spec EP|r")

    local specs  = VRBGetValidRatings()
    local n      = table.getn(specs)
    local ITEM_H = 22
    local yBase  = -30

    local function makeSpecBtn(idx, lbl, specKey)
        local btn = CreateFrame("Button", nil, KZCPaneSpec)
        btn:SetWidth(KZC_W - KZC_PAD*2 - 16) btn:SetHeight(ITEM_H)
        btn:SetPoint("TOPLEFT", KZCPaneSpec, "TOPLEFT", KZC_PAD, yBase - (idx-1)*ITEM_H)
        local isAll = (specKey == nil)
        local selBg = btn:CreateTexture(nil,"BACKGROUND"); selBg:SetAllPoints()
        selBg:SetTexture(color.r, color.g, color.b, 0.25); selBg:Hide()
        local hl = btn:CreateTexture(nil,"HIGHLIGHT"); hl:SetAllPoints()
        hl:SetTexture(color.r, color.g, color.b, 0.15)
        local fs = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
        fs:SetPoint("LEFT", btn, "LEFT", 6, 0) fs:SetJustifyH("LEFT")
        local function refresh()
            local sel = isAll and (VRB_ACTIVE_SPEC == nil) or (not isAll and VRB_ACTIVE_SPEC == specKey)
            if sel then fs:SetText("|cffFFFFFF► "..lbl.."|r"); selBg:Show()
            else        fs:SetText("|cffa0a0a0  "..lbl.."|r"); selBg:Hide() end
        end
        btn.refresh = refresh
        btn:SetScript("OnClick", function()
            VRB_ACTIVE_SPEC = specKey
            if VRB_SETTINGS then VRB_SETTINGS.activeSpec = specKey end
            for _, b in ipairs(KZCSpecBtns) do if b.refresh then b.refresh() end end
            DEFAULT_CHAT_FRAME:AddMessage(
                "|cffFFD700[KZ ItemEP]|r Spec: "..(specKey and lbl or "Todas"), 1,1,1)
        end)
        refresh()
        table.insert(KZCSpecBtns, btn)
    end

    for i, specKey in ipairs(specs) do
        local disp = KZC_SPEC_DISPLAY[specKey] or string.gsub(specKey, className, "")
        makeSpecBtn(i, disp, specKey)
    end

    -- separador + "Todos"
    local sepY = yBase - n*ITEM_H - 2
    local sep = KZCPaneSpec:CreateTexture(nil,"ARTWORK"); sep:SetHeight(1)
    sep:SetPoint("TOPLEFT",  KZCPaneSpec, "TOPLEFT",  6, sepY)
    sep:SetPoint("TOPRIGHT", KZCPaneSpec, "TOPRIGHT", -6, sepY)
    sep:SetTexture(0.3,0.3,0.3,0.8)
    table.insert(KZCSpecDynSeps, sep)

    -- "Todos" ocupa a próxima linha após o separador (usa índice n+2 → gap de 1 linha para sep)
    local todosBtn = CreateFrame("Button", nil, KZCPaneSpec)
    todosBtn:SetWidth(KZC_W - KZC_PAD*2 - 16) todosBtn:SetHeight(ITEM_H)
    todosBtn:SetPoint("TOPLEFT", KZCPaneSpec, "TOPLEFT", KZC_PAD, yBase - (n+1)*ITEM_H - 6)
    local tAll  = (VRB_ACTIVE_SPEC == nil)
    local tSelBg = todosBtn:CreateTexture(nil,"BACKGROUND"); tSelBg:SetAllPoints()
    tSelBg:SetTexture(color.r,color.g,color.b,0.25)
    if tAll then tSelBg:Show() else tSelBg:Hide() end
    local tHl = todosBtn:CreateTexture(nil,"HIGHLIGHT"); tHl:SetAllPoints(); tHl:SetTexture(color.r,color.g,color.b,0.15)
    local tFs = todosBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    tFs:SetPoint("LEFT",todosBtn,"LEFT",6,0); tFs:SetJustifyH("LEFT")
    tFs:SetText(tAll and "|cffFFFFFF► Mostrar Todos|r" or "|cffa0a0a0  Mostrar Todos|r")
    todosBtn.refresh = function()
        local sel = (VRB_ACTIVE_SPEC == nil)
        if sel then tFs:SetText("|cffFFFFFF► Mostrar Todos|r"); tSelBg:Show()
        else        tFs:SetText("|cffa0a0a0  Mostrar Todos|r"); tSelBg:Hide() end
    end
    todosBtn:SetScript("OnClick", function()
        VRB_ACTIVE_SPEC = nil
        if VRB_SETTINGS then VRB_SETTINGS.activeSpec = nil end
        for _, b in ipairs(KZCSpecBtns) do if b.refresh then b.refresh() end end
        todosBtn.refresh()
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[KZ ItemEP]|r Spec: Todas", 1,1,1)
    end)
    table.insert(KZCSpecBtns, todosBtn)

    -- altura do frame: tabs(48) + header(30) + specs + sep + todos + padding
    local contentH = 30 + (n+2)*ITEM_H + 14
    KZCFrame:SetHeight(48 + contentH + 6)
end

-- ================================================================
-- Aba PROC EP
-- ================================================================
local VRPF_W      = KZC_W - KZC_PAD*2
local VRPF_BASE_H = 156

local VRBPFCurrentItem = nil
local VRBPFCurrentEP   = 0

-- "Capturar item do tooltip"
local VRBPFUseBtn = CreateFrame("Button", nil, KZCPaneProcs)
VRBPFUseBtn:SetWidth(VRPF_W) VRBPFUseBtn:SetHeight(20)
VRBPFUseBtn:SetPoint("TOPLEFT", KZCPaneProcs, "TOPLEFT", KZC_PAD, -8)
local VRBPFUseBG = VRBPFUseBtn:CreateTexture(nil,"BACKGROUND"); VRBPFUseBG:SetAllPoints(); VRBPFUseBG:SetTexture(0.15,0.15,0.05,0.9)
local VRBPFUseHL = VRBPFUseBtn:CreateTexture(nil,"HIGHLIGHT");  VRBPFUseHL:SetAllPoints(); VRBPFUseHL:SetTexture(0.5,0.5,0.1,0.3)
local VRBPFUseTx = VRBPFUseBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); VRBPFUseTx:SetAllPoints()
VRBPFUseTx:SetText("|cffFFD700+ Capturar item do tooltip atual|r")

-- label do item capturado
local VRBPFItemFS = KZCPaneProcs:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
VRBPFItemFS:SetPoint("TOPLEFT", KZCPaneProcs, "TOPLEFT", KZC_PAD, -36)
VRBPFItemFS:SetWidth(VRPF_W) VRBPFItemFS:SetJustifyH("LEFT")
VRBPFItemFS:SetText("|cffa0a0a0Item: (nenhum capturado)|r")

-- "Proc EP: X"
local VRBPFEPLabel = KZCPaneProcs:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
VRBPFEPLabel:SetPoint("TOPLEFT", KZCPaneProcs, "TOPLEFT", KZC_PAD, -54)
VRBPFEPLabel:SetText("Proc EP: |cffFFD7000|r")

-- EditBox
local VRBPFEditBox = CreateFrame("EditBox", "VRBPFEditBox", KZCPaneProcs, "InputBoxTemplate")
VRBPFEditBox:SetWidth(60) VRBPFEditBox:SetHeight(20)
VRBPFEditBox:SetPoint("TOPLEFT", KZCPaneProcs, "TOPLEFT", KZC_PAD, -70)
VRBPFEditBox:SetAutoFocus(false) VRBPFEditBox:SetMaxLetters(6) VRBPFEditBox:SetText("0")
VRBPFEditBox:SetScript("OnTextChanged", function()
    local v = tonumber(VRBPFEditBox:GetText()) or 0
    if v < 0 then v = 0 end
    VRBPFCurrentEP = v
    VRBPFEPLabel:SetText("Proc EP: |cffFFD700" .. VRBPFCurrentEP .. "|r")
end)
VRBPFEditBox:SetScript("OnEscapePressed", function() VRBPFEditBox:ClearFocus() end)
VRBPFEditBox:SetScript("OnEnterPressed",  function() VRBPFEditBox:ClearFocus() end)

local function VRBPFEPUpdate()
    VRBPFCurrentEP = tonumber(VRBPFEditBox:GetText()) or 0
    VRBPFEPLabel:SetText("Proc EP: |cffFFD700" .. VRBPFCurrentEP .. "|r")
end
VRBPFEPUpdate()

-- botões +/-
local VRBPFLastStepBtn = nil
local epDeltas = {-10,-5,5,10,50}
local epLabels = {"-10","-5","+5","+10","+50"}
for bi = 1, 5 do
    local btn = CreateFrame("Button", nil, KZCPaneProcs)
    btn:SetWidth(30) btn:SetHeight(18)
    if VRBPFLastStepBtn then btn:SetPoint("LEFT", VRBPFLastStepBtn, "RIGHT", 2, 0)
    else btn:SetPoint("LEFT", VRBPFEditBox, "RIGHT", 4, 0) end
    local bgtex = btn:CreateTexture(nil,"BACKGROUND"); bgtex:SetAllPoints()
    if epDeltas[bi] > 0 then bgtex:SetTexture(0.05,0.35,0.05,0.9) else bgtex:SetTexture(0.35,0.05,0.05,0.9) end
    local hltex = btn:CreateTexture(nil,"HIGHLIGHT"); hltex:SetAllPoints(); hltex:SetTexture(1,1,1,0.15)
    local fs = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); fs:SetAllPoints(); fs:SetText(epLabels[bi])
    local delta = epDeltas[bi]
    btn:SetScript("OnClick", function()
        local cur = (tonumber(VRBPFEditBox:GetText()) or 0) + delta
        if cur < 0 then cur = 0 end
        VRBPFEditBox:SetText(tostring(cur))
        VRBPFCurrentEP = cur
        VRBPFEPLabel:SetText("Proc EP: |cffFFD700" .. cur .. "|r")
    end)
    VRBPFLastStepBtn = btn
end

-- botão Salvar
local VRBPFAddBtn = CreateFrame("Button", nil, KZCPaneProcs)
VRBPFAddBtn:SetWidth(50) VRBPFAddBtn:SetHeight(18)
VRBPFAddBtn:SetPoint("LEFT", VRBPFLastStepBtn, "RIGHT", 4, 0)
local VRBPFAddBG = VRBPFAddBtn:CreateTexture(nil,"BACKGROUND"); VRBPFAddBG:SetAllPoints(); VRBPFAddBG:SetTexture(0.0,0.5,0.0,0.9)
local VRBPFAddHL = VRBPFAddBtn:CreateTexture(nil,"HIGHLIGHT");  VRBPFAddHL:SetAllPoints(); VRBPFAddHL:SetTexture(0.1,0.7,0.1,0.3)
local VRBPFAddTx = VRBPFAddBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); VRBPFAddTx:SetAllPoints(); VRBPFAddTx:SetText("|cff00ff00Salvar|r")

-- separador + label lista
local VRBPFSep2 = KZCPaneProcs:CreateTexture(nil,"ARTWORK"); VRBPFSep2:SetHeight(1)
VRBPFSep2:SetPoint("TOPLEFT",  KZCPaneProcs, "TOPLEFT",  6, -96)
VRBPFSep2:SetPoint("TOPRIGHT", KZCPaneProcs, "TOPRIGHT", -6, -96)
VRBPFSep2:SetTexture(0.4,0.4,0.4,0.6)

local VRBPFListLbl = KZCPaneProcs:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
VRBPFListLbl:SetPoint("TOPLEFT", KZCPaneProcs, "TOPLEFT", KZC_PAD, -104)
VRBPFListLbl:SetText("|cffa0a0a0Configurados:|r")

-- pool de linhas
local VRPF_MAX_ROWS = 25
local VRBPFRowPool  = {}
for i = 1, VRPF_MAX_ROWS do
    local rf = CreateFrame("Button", nil, KZCPaneProcs)
    rf:SetWidth(VRPF_W) rf:SetHeight(18)
    rf:Hide()
    local rbg = rf:CreateTexture(nil,"BACKGROUND"); rbg:SetAllPoints()
    if math.mod(i,2)==0 then rbg:SetTexture(0.08,0.08,0.08,0.7) else rbg:SetTexture(0.14,0.14,0.14,0.7) end
    local rhlt = rf:CreateTexture(nil,"HIGHLIGHT"); rhlt:SetAllPoints(); rhlt:SetTexture(0.4,0.7,1.0,0.15)
    local nameFS = rf:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    nameFS:SetPoint("LEFT",rf,"LEFT",4,0); nameFS:SetWidth(220); nameFS:SetJustifyH("LEFT")
    local epFS = rf:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    epFS:SetPoint("RIGHT",rf,"RIGHT",-22,0); epFS:SetWidth(60); epFS:SetJustifyH("RIGHT")
    local delBtn = CreateFrame("Button",nil,rf); delBtn:SetWidth(18); delBtn:SetHeight(18)
    delBtn:SetPoint("RIGHT",rf,"RIGHT",0,0)
    local delHL = delBtn:CreateTexture(nil,"HIGHLIGHT"); delHL:SetAllPoints(); delHL:SetTexture(0.8,0.1,0.1,0.4)
    local delTx = delBtn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall"); delTx:SetAllPoints(); delTx:SetText("|cffff5555X|r")
    VRBPFRowPool[i] = {frame=rf, nameFS=nameFS, epFS=epFS, delBtn=delBtn}
end

KZCProcsRefresh = function()
    if VRBPFCurrentItem then
        VRBPFItemFS:SetText("|cffd0d0d0Item:|r |cffFFFFFF" .. VRBPFCurrentItem .. "|r")
    else
        VRBPFItemFS:SetText("|cffa0a0a0Item: (nenhum capturado)|r")
    end
    for i = 1, VRPF_MAX_ROWS do VRBPFRowPool[i].frame:Hide() end

    if not VRB_PROC_DB then
        KZCFrame:SetHeight(48 + VRPF_BASE_H + 6)
        return
    end

    local entries = {}
    for itemName, epVal in pairs(VRB_PROC_DB) do
        local ep = epVal
        if type(epVal) == "table" then
            local mx = 0
            for _, v in pairs(epVal) do if v > mx then mx=v end end
            ep = mx; VRB_PROC_DB[itemName] = mx
        end
        if type(ep) == "number" and ep > 0 then
            table.insert(entries, {item=itemName, ep=ep})
        end
    end
    table.sort(entries, function(a,b) return a.item < b.item end)

    local count = 0
    for i, entry in ipairs(entries) do
        if i > VRPF_MAX_ROWS then break end
        local row = VRBPFRowPool[i]
        row.frame:SetPoint("TOPLEFT", KZCPaneProcs, "TOPLEFT", KZC_PAD, -(VRPF_BASE_H + (i-1)*18))
        row.nameFS:SetText("|cffFFFFFF" .. entry.item .. "|r")
        row.epFS:SetText("|cffFFD700+" .. entry.ep .. "|r")
        local ci, cep = entry.item, entry.ep
        row.delBtn:SetScript("OnClick", function()
            VRB_PROC_DB[ci] = nil
            KZCProcsRefresh()
        end)
        row.frame:SetScript("OnClick", function()
            VRBPFCurrentItem = ci
            VRBPFEditBox:SetText(tostring(cep))
            VRBPFCurrentEP = cep
            VRBPFEPLabel:SetText("Proc EP: |cffFFD700" .. cep .. "|r")
            KZCProcsRefresh()
        end)
        row.frame:Show()
        count = count + 1
    end

    local extraH = count > 0 and (count*18 + 8) or 20
    KZCFrame:SetHeight(48 + VRPF_BASE_H + extraH + 6)
end

VRBPFUseBtn:SetScript("OnClick", function()
    local name = VRB_LAST_ITEM_NAME
    if not name or name == "" then
        local lbl = getglobal("GameTooltipTextLeft1")
        name = lbl and lbl:GetText()
    end
    if name and name ~= "" then
        VRBPFCurrentItem = name
        KZCProcsRefresh()
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[KZ ItemEP]|r Passe o mouse em um item primeiro.", 1,0.8,0)
    end
end)

local function VRBPFDoAdd()
    if not VRBPFCurrentItem then
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[KZ ItemEP]|r Capture um item primeiro.", 1,0.5,0)
        return
    end
    if VRBPFCurrentEP <= 0 then
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[KZ ItemEP]|r Ajuste o EP primeiro.", 1,0.5,0)
        return
    end
    if not VRB_PROC_DB then VRB_PROC_DB = {} end
    VRB_PROC_DB[VRBPFCurrentItem] = VRBPFCurrentEP
    DEFAULT_CHAT_FRAME:AddMessage(
        "|cffFFD700[KZ ItemEP]|r Proc salvo: |cffFFFFFF"..VRBPFCurrentItem.."|r  +"..VRBPFCurrentEP.." EP", 1,1,0.5)
    VRBPFCurrentEP = 0
    VRBPFEPUpdate()
    KZCProcsRefresh()
end
VRBPFAddBtn:SetScript("OnClick", VRBPFDoAdd)

-- ================================================================
-- Link pinado + hooks de tooltip
-- ================================================================
local KZC_PinnedLink = nil
local KZC_PinnedName = nil

local function KZCPinLink(link)
    if not link or link == "" then return end
    KZC_PinnedLink = link
    local nm = GetItemInfo(link)
    if nm then KZC_PinnedName = nm end
end

local _kzcOrigSetQuestItem = GameTooltip.SetQuestItem
GameTooltip.SetQuestItem = function(self, qtype, index)
    KZCPinLink(GetQuestItemLink and GetQuestItemLink(qtype, index))
    return _kzcOrigSetQuestItem(self, qtype, index)
end

local _kzcOrigSetQuestLogItem = GameTooltip.SetQuestLogItem
GameTooltip.SetQuestLogItem = function(self, qtype, index)
    KZCPinLink(GetQuestLogItemLink and GetQuestLogItemLink(qtype, index))
    return _kzcOrigSetQuestLogItem(self, qtype, index)
end

local _kzcOrigSetMerchantItem = GameTooltip.SetMerchantItem
GameTooltip.SetMerchantItem = function(self, index)
    KZCPinLink(GetMerchantItemLink and GetMerchantItemLink(index))
    return _kzcOrigSetMerchantItem(self, index)
end

local _kzcOrigSetLootItem = GameTooltip.SetLootItem
GameTooltip.SetLootItem = function(self, index)
    KZCPinLink(GetLootSlotLink and GetLootSlotLink(index))
    return _kzcOrigSetLootItem(self, index)
end

-- ================================================================
-- Handlers botões Capturar + < >
-- ================================================================
for slot = 1, 2 do
    local s = slot
    KZCSlotUI[s].captBtn:SetScript("OnClick", function()
        local link = KZC_PinnedLink
        if not link or link == "" then
            DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[KZ Compare]|r Passe o mouse em um item primeiro.", 1,0.8,0)
            return
        end
        KZCData[s].link = link
        KZCData[s].name = KZC_PinnedName
        KZCLoadSlot(s)
    end)
    KZCSlotUI[s].specPrev:SetScript("OnClick", function() KZCCycleSlotSpec(s,-1) end)
    KZCSlotUI[s].specNext:SetScript("OnClick", function() KZCCycleSlotSpec(s, 1) end)
end

-- ================================================================
-- Watcher: atualiza pin e diff ao mudar spec global
-- ================================================================
local KZC_LastSpec = nil
local KZCWatcher   = CreateFrame("Frame")
KZCWatcher:SetScript("OnUpdate", function()
    if VRB_CURRENT_ITEM_LINK and VRB_CURRENT_ITEM_LINK ~= "" then
        KZC_PinnedLink = VRB_CURRENT_ITEM_LINK
        KZC_PinnedName = VRB_LAST_ITEM_NAME
    end
    if not KZCFrame:IsShown() then return end
    if VRB_ACTIVE_SPEC == KZC_LastSpec then return end
    KZC_LastSpec = VRB_ACTIVE_SPEC
    KZCUpdateDiff()
end)

-- ================================================================
-- Slash commands
-- ================================================================
local function KZCCaptureSlot(slot)
    local link = KZC_PinnedLink
    if not link or link == "" then
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[KZ Compare]|r Passe o mouse em um item primeiro.", 1,0.8,0)
        return
    end
    if not KZCFrame:IsShown() then KZCSetTab("compare"); KZCFrame:Show() end
    KZCData[slot].link = link
    KZCData[slot].name = KZC_PinnedName
    KZCLoadSlot(slot)
    DEFAULT_CHAT_FRAME:AddMessage(
        "|cffFFD700[KZ Compare]|r Slot "..(slot==1 and "A" or "B")..": |cffFFFFFF"..(KZC_PinnedName or "?").."|r", 1,0.8,0)
end

SLASH_KZCOMPARE1 = "/kzcompare"
SLASH_KZCOMPARE2 = "/kzc"
SlashCmdList["KZCOMPARE"] = function()
    if KZCFrame:IsShown() then KZCFrame:Hide()
    else KZCSetTab("compare"); KZCUpdateDiff(); KZCFrame:Show() end
end

SLASH_KZCOMPAREA1 = "/kzca"
SlashCmdList["KZCOMPAREA"] = function() KZCCaptureSlot(1) end

SLASH_KZCOMPAREB1 = "/kzcb"
SlashCmdList["KZCOMPAREB"] = function() KZCCaptureSlot(2) end

-- funções públicas para VRBMenu.lua redirecionar para este frame
function KZCOpenTab(tab)
    if KZCFrame:IsShown() and KZC_ACTIVE_TAB == tab then
        KZCFrame:Hide()
    else
        KZCSetTab(tab)
        KZCFrame:Show()
    end
end
