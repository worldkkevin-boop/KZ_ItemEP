scoredItemTypes = {
  INVTYPE_2HWEAPON, INVTYPE_CHEST, INVTYPE_CLOAK,
  INVTYPE_FEET, INVTYPE_FINGER, INVTYPE_HAND, INVTYPE_HEAD, INVTYPE_HOLDABLE,
  INVTYPE_LEGS, INVTYPE_NECK, INVTYPE_RANGED, INVTYPE_RELIC, INVTYPE_ROBE, INVTYPE_SHIELD,
  INVTYPE_SHOULDER, INVTYPE_TRINKET, INVTYPE_WAIST, INVTYPE_WEAPON,
  INVTYPE_WEAPONMAINHAND, INVTYPE_WEAPONOFFHAND, INVTYPE_WRIST,
  "Schusswaffe", "Zauberstab", "Armbrust", "Gun", "Wand", "Crossbow"
}

VRB_STAT_LABELS = {
    ["STR"]="Str",["AGI"]="Agi",["STA"]="Sta",["INT"]="Int",["SPI"]="Spi",
    ["CRIT"]="Crit%",["TOHIT"]="Hit%",["ATTACKPOWER"]="AP",["DODGE"]="Dodge",
    ["PARRY"]="Parry",["DEFENSE"]="Def",["ARMOR"]="Armor",["BLOCK"]="Block",
    ["HEAL"]="Heal",["DMG"]="Dmg",["SHADOWDMG"]="ShdwDmg",["SPELLCRIT"]="SpCrit%",
    ["SPELLTOHIT"]="SpHit",["MANAREG"]="MP5",["HEALTHREG"]="HP5",
    ["FERALATTACKPOWER"]="FeralAP",["ARMORPEN"]="ArPen",["HASTE"]="Haste",
    ["HEALTH"]="Health",["MANA"]="Mana",["BONUS"]="Proc",
    ["RANGEDATTACKPOWER"]="RAP",["RANGEDCRIT"]="RngCrit%",
    ["MHDPS"]="MH DPS",["MHSPEED"]="MH Spd",
    ["OHDPS"]="OH DPS",["OHSPEED"]="OH Spd",
    ["RANGEDDPS"]="Rng DPS",["RANGEDSPEED"]="Rng Spd",
}

VRB_EQUIP_SLOTS = {
    ["INVTYPE_HEAD"]={1},["INVTYPE_NECK"]={2},["INVTYPE_SHOULDER"]={3},
    ["INVTYPE_CLOAK"]={15},["INVTYPE_CHEST"]={5},["INVTYPE_ROBE"]={5},
    ["INVTYPE_WRIST"]={9},["INVTYPE_HAND"]={10},["INVTYPE_WAIST"]={6},
    ["INVTYPE_LEGS"]={7},["INVTYPE_FEET"]={8},["INVTYPE_FINGER"]={11,12},
    ["INVTYPE_TRINKET"]={13,14},["INVTYPE_WEAPON"]={16,17},
    ["INVTYPE_WEAPONMAINHAND"]={16},["INVTYPE_WEAPONOFFHAND"]={17},
    ["INVTYPE_HOLDABLE"]={17},["INVTYPE_SHIELD"]={17},
    ["INVTYPE_2HWEAPON"]={16},["INVTYPE_RANGED"]={18},["INVTYPE_RELIC"]={18},
}

VRB_ACTIVE_SPEC = nil
VRB_CURRENT_ITEM_LINK = nil
VRBEquippedEPCache = {}  -- Cache EP do item equipado (preenchido pelo ShoppingTooltip1)

VRB_SPEC_ALIASES = {
    ["swords"]="RogueCombatSwords",["sword"]="RogueCombatSwords",["espada"]="RogueCombatSwords",
    ["daggers"]="RogueCombatDaggers",["dagger"]="RogueCombatDaggers",["adaga"]="RogueCombatDaggers",
    ["fury"]="WarriorFury-EP",["furia"]="WarriorFury-EP",
    ["arms"]="WarriorArms-EP",["2h"]="WarriorArms-EP",["bracos"]="WarriorArms-EP",
    ["prot"]="WarriorThreat-EP",
    ["hunter"]="HunterDPS-EP",["mm"]="HunterDPS-EP",["marksman"]="HunterDPS-EP",
    ["survival"]="HunterDPS-EP",["cacador"]="HunterDPS-EP",
    ["resto"]="DruidResto-EP",["feral"]="DruidFeralDPS-EP",
    ["shadow"]="PriestShadow",["holy"]="PriestHoly",
    ["bm"]="HunterDPS-EP",["mm"]="HunterDPS-EP",["survival"]="HunterSurvival",["suv"]="HunterSurvival",
    ["mage"]="MageDPS",["mago"]="MageDPS",["fire"]="MageDPS",["frost"]="MageDPS",
    ["destro"]="WarlockDestruction",["destruction"]="WarlockDestruction",
    ["smruin"]="WarlockSMRuin",["sm"]="WarlockSMRuin",["lock"]="WarlockSMRuin",
}

function istable(t) return type(t) == "table" end
function VRBRound(num, places)
  local mult = 10^(places or 0)
  return math.floor(num * mult + 0.5) / mult
end
function VRBCheckItemType(slot)
  for id, scoredSlot in pairs(scoredItemTypes) do
    if slot == scoredSlot then return true end
  end
end
function VRBGetValidRatings()
  local class = UnitClass("player")
  return VRB_LABELS[class] or {}
end
function VRBGetFilteredRatings()
  local all = VRBGetValidRatings()
  if not VRB_ACTIVE_SPEC then return all end
  local filtered = {}
  for _, r in ipairs(all) do
    if r == VRB_ACTIVE_SPEC then table.insert(filtered, r) end
  end
  if table.getn(filtered) == 0 then return all end
  return filtered
end
function VRBCalculateRating(weightTable, bonuses)
  local baseScore = 0
  local weightTypes = VRB_WEIGHTS[weightTable]
  local currentBonus = 0
  for t, w in pairs(weightTypes) do
    if BonusScanner.bonuses[t] then currentBonus = BonusScanner.bonuses[t] end
    if bonuses[t] then
      if istable(w) then
        if tonumber(currentBonus) < tonumber(w[1]) then baseScore = baseScore + (bonuses[t] * w[2])
        else baseScore = baseScore + (bonuses[t] * w[3]) end
      else baseScore = baseScore + (bonuses[t] * w) end
    end
  end
  return VRBRound(baseScore, 2)
end
function VRBCalculateRatingDetailed(weightTable, bonuses)
  local baseScore = 0
  local breakdown = {}
  local weightTypes = VRB_WEIGHTS[weightTable]
  local currentBonus = 0
  for t, w in pairs(weightTypes) do
    if BonusScanner.bonuses[t] then currentBonus = BonusScanner.bonuses[t] end
    if bonuses[t] then
      local contribution = 0
      if istable(w) then
        if tonumber(currentBonus) < tonumber(w[1]) then contribution = bonuses[t] * w[2]
        else contribution = bonuses[t] * w[3] end
      else contribution = bonuses[t] * w end
      if contribution ~= 0 then
        breakdown[t] = { ep = VRBRound(contribution, 1), raw = bonuses[t] }
        baseScore = baseScore + contribution
      end
    end
  end
  return VRBRound(baseScore, 2), breakdown
end

-- Grade SS/S/A/B/C/D/F com teto por slot
function VRBGetGrade(score, weightTable, equipLoc)
  local maxScore
  -- Teto por slot tem prioridade em todos os slots (calibrado pelo BiS do site)
  if equipLoc and VRB_MAX_SCORES_SLOT and VRB_MAX_SCORES_SLOT[equipLoc] then
    maxScore = VRB_MAX_SCORES_SLOT[equipLoc]
  end
  if not maxScore then
    local levelMax = VRBGetLevelMax and VRBGetLevelMax(weightTable)
    if levelMax then
      maxScore = levelMax
    else
      maxScore = (VRB_MAX_SCORES and VRB_MAX_SCORES[weightTable]) or 125
    end
  end
  local pct = score / maxScore
  if pct >= 0.95 then return "SS" end
  if pct >= 0.85 then return "S"  end
  if pct >= 0.70 then return "A"  end
  if pct >= 0.50 then return "B"  end
  if pct >= 0.30 then return "C"  end
  if pct >= 0.15 then return "D"  end
  return "F"
end
function VRBGetGradeTotal(score, weightTable)
  local maxScore = (VRB_MAX_SCORES_TOTAL and VRB_MAX_SCORES_TOTAL[weightTable]) or 750
  local pct = score / maxScore
  if pct >= 0.95 then return "SS" end
  if pct >= 0.85 then return "S"  end
  if pct >= 0.70 then return "A"  end
  if pct >= 0.50 then return "B"  end
  if pct >= 0.30 then return "C"  end
  if pct >= 0.15 then return "D"  end
  return "F"
end
function VRBGradeColor(grade)
  if grade == "SS" then return 1.0, 0.50, 0.0 end
  if grade == "S"  then return 0.0, 1.0, 0.0  end
  if grade == "A"  then return 0.27,0.87, 0.0 end
  if grade == "B"  then return 1.0, 0.85, 0.0 end
  if grade == "C"  then return 1.0, 0.55, 0.0 end
  if grade == "D"  then return 1.0, 0.30, 0.0 end
  return 1.0, 0.15, 0.15
end
function VRBGradeDisplay(grade)
  local r, g, b = VRBGradeColor(grade)
  local hex = string.format("ff%02x%02x%02x", r*255, g*255, b*255)
  if grade == "SS" then return "|cffFF8C00[SS]|r |cffFFD700BiS|r" end
  return "|c" .. hex .. "[" .. grade .. "]|r"
end
function VRBBuildBreakdownString(breakdown, maxStats)
  maxStats = maxStats or 4
  local parts = {}
  for stat, data in pairs(breakdown) do
    table.insert(parts, { stat = stat, ep = data.ep, raw = data.raw })
  end
  table.sort(parts, function(a, b) return a.ep > b.ep end)
  local count = table.getn(parts)
  if count > maxStats then count = maxStats end
  local chunks = {}
  for i = 1, count do
    local p = parts[i]
    local label = (VRB_STAT_LABELS and VRB_STAT_LABELS[p.stat]) or p.stat
    if p.stat == "BONUS" then table.insert(chunks, label .. ":" .. p.ep)
    else table.insert(chunks, label .. "(" .. p.raw .. "):" .. p.ep) end
  end
  local result = ""
  local numLines = 0
  local i = 1
  while i <= table.getn(chunks) do
    if result ~= "" then result = result .. "\n" end
    if i + 1 <= table.getn(chunks) then
      result = result .. chunks[i] .. "  " .. chunks[i+1]
      i = i + 2
    else
      result = result .. chunks[i]
      i = i + 1
    end
    numLines = numLines + 1
  end
  return result, numLines
end

-- Detecta tipo de slot pelo texto do tooltip (evita depender do cache de GetItemInfo)
local function VRBGuessWeaponSlot(numLines, tooltipName)
    for i = 1, numLines do
        local leftObj  = getglobal(tooltipName .. "TextLeft"  .. i)
        local rightObj = getglobal(tooltipName .. "TextRight" .. i)
        local txt  = leftObj  and leftObj:GetText()  or ""
        local rtxt = rightObj and rightObj:GetText() or ""
        -- Slot type no LEFT (exato ou prefixo para casos como "One-Hand Sword" junto)
        if string.find(txt, "^Off Hand")  then return "INVTYPE_WEAPONOFFHAND" end
        if string.find(txt, "^Main Hand") then return "INVTYPE_WEAPONMAINHAND" end
        if string.find(txt, "^Two%-Hand") or string.find(txt, "^Two Hand") then return "INVTYPE_2HWEAPON" end
        if txt == "Ranged" or txt == "Thrown" or string.find(txt, "^Ranged") then return "INVTYPE_RANGED" end
        if string.find(txt, "^One%-Hand") or string.find(txt, "^Held In Off") then return "INVTYPE_WEAPON" end
        -- Tipo de arma no LEFT (alguns servidores mostram tipo antes do slot)
        if txt == "Gun" or txt == "Bow" or txt == "Crossbow" or txt == "Wand" then
            return "INVTYPE_RANGED"
        end
        -- Fallback: tipo de arma no RIGHT (para tooltips com layout diferente)
        if rtxt == "Bow" or rtxt == "Gun" or rtxt == "Crossbow" or rtxt == "Wand" or rtxt == "Thrown" then
            return "INVTYPE_RANGED"
        end
        if rtxt == "Polearm" or rtxt == "Staff" or string.find(rtxt, "^Two%-Handed") then
            return "INVTYPE_2HWEAPON"
        end
        if rtxt == "Sword" or rtxt == "Mace" or rtxt == "Axe" or rtxt == "Dagger" or rtxt == "Fist Weapon" then
            return "INVTYPE_WEAPON"
        end
    end
end

-- Injeta MHDPS/MHSPEED (ou OH/Ranged) nos bonuses.
-- Em vanilla WoW a linha de arma separa: Left="71 - 132 Damage" | Right="Speed 2.70"
local function VRBInjectWeaponStats(bonuses, numLines, tooltipName, equipLoc)
    for i = 1, numLines do
        local leftObj  = getglobal(tooltipName .. "TextLeft"  .. i)
        local rightObj = getglobal(tooltipName .. "TextRight" .. i)
        local leftTxt  = (leftObj  and leftObj:GetText())  or ""
        local rightTxt = (rightObj and rightObj:GetText()) or ""

        local ls, le, mn, mx = string.find(leftTxt, "(%d+) %- (%d+)")
        if mn and string.find(leftTxt, "Damage") then
            local rs, re, spd = string.find(rightTxt, "Speed ([%d%.]+)")
            if not spd then rs, re, spd = string.find(leftTxt, "Speed ([%d%.]+)") end
            if spd then
                spd = tonumber(spd)
                if spd and spd > 0 then
                    local dps = VRBRound((tonumber(mn) + tonumber(mx)) / 2 / spd, 1)
                    if equipLoc == "INVTYPE_RANGED" or equipLoc == "INVTYPE_RANGEDRIGHT"
                       or equipLoc == "INVTYPE_THROWN" or equipLoc == "INVTYPE_RELIC" then
                        bonuses["RANGEDDPS"]   = dps
                        bonuses["RANGEDSPEED"] = spd
                    elseif equipLoc == "INVTYPE_WEAPONOFFHAND" or equipLoc == "INVTYPE_HOLDABLE" then
                        bonuses["OHDPS"]   = dps
                        bonuses["OHSPEED"] = spd
                    else
                        bonuses["MHDPS"]   = dps
                        bonuses["MHSPEED"] = spd
                    end
                    return
                end
            end
        end
    end
end

-- Extrai "item:ID:e:s:u" do link colorido completo para usar em SetHyperlink
local function VRBBareLink(link)
    if not link then return nil end
    local _, _, hl = string.find(link, "|H([^|]+)|h")
    return hl or link
end

-- Scan item EP via tooltip oculto
function VRBScanItemEP(link, weightTable)
  if not link then return nil end
  if not VRBScanTooltip then
    VRBScanTooltip = CreateFrame("GameTooltip", "VRBScanTooltip", UIParent, "GameTooltipTemplate")
    VRBScanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
  end
  local savedTemp = BonusScanner.temp
  BonusScanner.temp = { sets = {}, set = "", bonuses = {}, slot = "", details = {} }
  VRBScanTooltip:ClearLines()
  local ok = pcall(function() VRBScanTooltip:SetHyperlink(VRBBareLink(link)) end)
  if ok then
    local numLines = VRBScanTooltip:NumLines()
    for i = 2, numLines do
      local lineObj = getglobal("VRBScanTooltipTextLeft" .. i)
      if lineObj and lineObj:GetText() then BonusScanner:ScanLine(lineObj:GetText()) end
    end
    local _, _, _, _, _, _, _, scanEquipLoc = GetItemInfo(link)
    -- Prioriza leitura do tooltip (mais confiável): posição 8 do GetItemInfo pode retornar
    -- stackCount (número) em vez de equipLoc dependendo do build do servidor.
    local scanSlot = VRBGuessWeaponSlot(numLines, "VRBScanTooltip")
                     or (type(scanEquipLoc) == "string" and scanEquipLoc ~= "" and scanEquipLoc)
    if scanSlot then
      VRBInjectWeaponStats(BonusScanner.temp.bonuses, numLines, "VRBScanTooltip", scanSlot)
    end
  end
  local ep = VRBCalculateRating(weightTable, BonusScanner.temp.bonuses)
  BonusScanner.temp = savedTemp
  return ep
end

-- Retorna BonusScanner.bonuses aumentado com DPS/Speed dos slots MH(16) e OH(17)
local function VRBBuildAugmentedBonuses()
    local b = {}
    for k,v in pairs(BonusScanner.bonuses) do b[k] = v end
    if not VRBScanTooltip then
        VRBScanTooltip = CreateFrame("GameTooltip", "VRBScanTooltip", UIParent, "GameTooltipTemplate")
        VRBScanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end
    local weaponSlots = { {16, "INVTYPE_WEAPONMAINHAND"}, {17, "INVTYPE_WEAPONOFFHAND"}, {18, "INVTYPE_RANGED"} }
    for _, pair in ipairs(weaponSlots) do
        local slotId, slotType = pair[1], pair[2]
        local link = GetInventoryItemLink("player", slotId)
        if link then
            VRBScanTooltip:ClearLines()
            local ok = pcall(function() VRBScanTooltip:SetHyperlink(VRBBareLink(link)) end)
            local n = VRBScanTooltip:NumLines()
            VRBInjectWeaponStats(b, n, "VRBScanTooltip", slotType)
        end
    end
    return b
end

function VRBGetEquippedEP(weightTable)
  local link = VRB_CURRENT_ITEM_LINK

  -- Fallback: se link nao foi capturado pelo hook, busca na bag pelo nome do tooltip
  if not link then
    local lbl1 = getglobal("GameTooltipTextLeft1")
    local itemName = lbl1 and lbl1:GetText()
    if itemName then
      for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
          local bagLink = GetContainerItemLink(bag, slot)
          if bagLink and string.find(bagLink, itemName, 1, true) then
            link = bagLink
            VRB_CURRENT_ITEM_LINK = link
            break
          end
        end
        if link then break end
      end
    end
  end

  if not link then return nil end
  local name, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
  if not equipLoc or equipLoc == "" then return nil end
  local slots = VRB_EQUIP_SLOTS[equipLoc]
  if not slots then return nil end
  local bestEP = nil
  for _, slotId in ipairs(slots) do
    local equippedLink = GetInventoryItemLink("player", slotId)
    if equippedLink then
      local ep = VRBScanItemEP(equippedLink, weightTable)
      if ep and (bestEP == nil or ep < bestEP) then bestEP = ep end
    end
  end
  return bestEP
end

-- Hooks para capturar link do item
local _origSetBagItem = GameTooltip.SetBagItem
GameTooltip.SetBagItem = function(this, bag, slot)
  VRB_CURRENT_ITEM_LINK = GetContainerItemLink(bag, slot)
  return _origSetBagItem(this, bag, slot)
end
local _origSetInventoryItem = GameTooltip.SetInventoryItem
GameTooltip.SetInventoryItem = function(this, unit, slot)
  VRB_CURRENT_ITEM_LINK = GetInventoryItemLink(unit, slot)
  return _origSetInventoryItem(this, unit, slot)
end
local _origSetHyperlink = GameTooltip.SetHyperlink
GameTooltip.SetHyperlink = function(this, link)
  VRB_CURRENT_ITEM_LINK = link
  return _origSetHyperlink(this, link)
end
-- Vanilla 1.12: HookScript nao existe, usar SetScript com chain manual
local _origTooltipHide = GameTooltip:GetScript("OnHide")
GameTooltip:SetScript("OnHide", function()
    VRB_CURRENT_ITEM_LINK = nil
VRBEquippedEPCache = {}  -- Cache EP do item equipado (preenchido pelo ShoppingTooltip1)
    if _origTooltipHide then _origTooltipHide() end
end)

-- -------------------------------------------------------
-- VRBEPFrame: frame separado ao lado do tooltip
-- Resolve problema de tooltips longos (Bonescythe set etc.)
-- -------------------------------------------------------
local VRB_FRAME_W = 280

local VRBEPFrame = CreateFrame("Frame", "VRBEPFrame", UIParent)
VRBEPFrame:SetWidth(VRB_FRAME_W)
VRBEPFrame:SetFrameStrata("TOOLTIP")
VRBEPFrame:SetFrameLevel(200)
VRBEPFrame:SetBackdrop({
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 14,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
VRBEPFrame:SetBackdropColor(0.0, 0.0, 0.0, 1.0)
VRBEPFrame:SetBackdropBorderColor(0.8, 0.65, 0.0, 1.0)

-- Fundo solido extra (elimina transparencia do tooltip bg)
local VRBEPBg = VRBEPFrame:CreateTexture(nil, "BACKGROUND")
VRBEPBg:SetAllPoints(VRBEPFrame)
VRBEPBg:SetTexture(0.08, 0.07, 0.04, 1.0)
VRBEPFrame:SetScript("OnShow", function()
    this:SetFrameStrata("TOOLTIP")
    this:SetFrameLevel(200)
end)
VRBEPFrame:Hide()

-- Linha separadora abaixo do titulo
local VRBEPSep = VRBEPFrame:CreateTexture(nil, "ARTWORK")
VRBEPSep:SetHeight(1)
VRBEPSep:SetPoint("TOPLEFT",  VRBEPFrame, "TOPLEFT",  6, -16)
VRBEPSep:SetPoint("TOPRIGHT", VRBEPFrame, "TOPRIGHT", -6, -16)
VRBEPSep:SetTexture(0.8, 0.65, 0.0, 0.5)

local VRBEPTitle = VRBEPFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
VRBEPTitle:SetPoint("TOPLEFT", VRBEPFrame, "TOPLEFT", 8, -5)
VRBEPTitle:SetText("|cffFFD700KZ|r |cffa0a0a0ItemEP|r")

local VRBEPText = VRBEPFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
VRBEPText:SetPoint("TOPLEFT", VRBEPFrame, "TOPLEFT", 8, -20)
VRBEPText:SetJustifyH("LEFT")
VRBEPText:SetWidth(VRB_FRAME_W - 16)

local function VRBPositionEPFrame()
    VRBEPFrame:ClearAllPoints()
    local tipRight  = GameTooltip:GetRight()  or 0
    local tipLeft   = GameTooltip:GetLeft()   or 0
    local tipBottom = GameTooltip:GetBottom() or 0
    local screenW   = GetScreenWidth()
    local screenH   = GetScreenHeight()
    local frameW    = VRBEPFrame:GetWidth()   or 240
    local frameH    = VRBEPFrame:GetHeight()  or 100

    -- 1. Tenta direita do tooltip (espaco suficiente?)
    if (tipRight + frameW + 8) <= screenW then
        VRBEPFrame:SetPoint("TOPLEFT", GameTooltip, "TOPRIGHT", 4, 0)
        return
    end

    -- 2. Tenta abaixo do tooltip (espaco suficiente?)
    if (tipBottom - frameH - 8) >= 0 then
        local x = tipLeft
        if x + frameW > screenW then x = screenW - frameW - 4 end
        if x < 0 then x = 4 end
        VRBEPFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, tipBottom - 4)
        return
    end

    -- 3. Fallback: canto superior direito da tela (sempre visivel)
    VRBEPFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -4, -180)
end

-- -------------------------------------------------------
-- Tooltip trigger (filho do GameTooltip)
-- -------------------------------------------------------
VRBItemScoreTooltip = CreateFrame("Frame", "VRBItemScoreTooltip", GameTooltip)
VRBItemScoreTooltip:SetScript("OnShow", function(self)
    -- Fix z-order Bagshui
    GameTooltip:SetFrameStrata("TOOLTIP")
    GameTooltip:SetFrameLevel(500)

    local lines = GameTooltip:NumLines()
    BonusScanner.temp.sets = {}
    BonusScanner.temp.set = ""
    BonusScanner.temp.bonuses = {}
    BonusScanner.temp.slot = ""

    if not getglobal("GameTooltipTextLeft1") then VRBEPFrame:Hide() return end

    for i = 2, lines do
      local tmpText = getglobal("GameTooltipTextLeft" .. i)
      if tmpText and tmpText:GetText() then BonusScanner:ScanLine(tmpText:GetText()) end
    end

    local bonuses = BonusScanner.temp.bonuses
    if not bonuses then VRBEPFrame:Hide() return end

    -- equipLoc via GetItemInfo (posição 8 pode ser stackCount neste servidor — só usa se string)
    local currentEquipLoc = nil
    if VRB_CURRENT_ITEM_LINK then
        local _, _, _, _, _, _, _, loc = GetItemInfo(VRB_CURRENT_ITEM_LINK)
        if type(loc) == "string" and loc ~= "" then currentEquipLoc = loc end
    end
    -- Prioriza leitura do tooltip para armas ranged/offhand serem detectadas corretamente
    local weaponSlot = VRBGuessWeaponSlot(lines, "GameTooltip")
                       or currentEquipLoc
    -- Refina INVTYPE_WEAPON → MH ou OH verificando qual slot o item esta equipado
    if weaponSlot == "INVTYPE_WEAPON" and VRB_CURRENT_ITEM_LINK then
        local ohLink = GetInventoryItemLink("player", 17)
        local mhLink = GetInventoryItemLink("player", 16)
        if ohLink and ohLink == VRB_CURRENT_ITEM_LINK then
            weaponSlot = "INVTYPE_WEAPONOFFHAND"
        elseif mhLink and mhLink == VRB_CURRENT_ITEM_LINK then
            weaponSlot = "INVTYPE_WEAPONMAINHAND"
        end
    end
    if weaponSlot then
        VRBInjectWeaponStats(bonuses, lines, "GameTooltip", weaponSlot)
    end

    local ratings = VRBGetFilteredRatings()
    local className, classFileName = UnitClass("player")
    local color = RAID_CLASS_COLORS[classFileName]
    local colorHex = string.format("ff%02x%02x%02x", color.r*255, color.g*255, color.b*255)

    local itemName = nil
    local lbl1 = getglobal("GameTooltipTextLeft1")
    if lbl1 then itemName = lbl1:GetText() end
    if itemName and itemName ~= "" then VRB_LAST_ITEM_NAME = itemName end

    -- gradeEquipLoc: prefere slot detectado (inclui fallback de texto) para armas
    local gradeEquipLoc = weaponSlot or currentEquipLoc


    -- Salva dados para rebuild quando cache do equipado chegar
    VRBHoveredEPData = {
        ratings = ratings,
        bonuses = {},
        className = className,
        colorHex = colorHex,
        itemName = itemName,
        equipLoc = gradeEquipLoc,
    }
    -- Copia bonuses
    for k,v in pairs(bonuses) do VRBHoveredEPData.bonuses[k] = v end

    local frameLines = ""
    local hasScore = false
    local lineCount = 0

    for _, r in ipairs(ratings) do
      local vrbscore, breakdown = VRBCalculateRatingDetailed(r, bonuses)

      -- VRB_PROC_DB (usuario) tem prioridade sobre VRB_CUSTOM_ITEMS (hardcoded)
      -- VRB_PROC_DB pode ser flat {item=ep} ou legado {item={spec=ep}}
      local procEP = 0
      if itemName then
          if VRB_PROC_DB and VRB_PROC_DB[itemName] then
              local pv = VRB_PROC_DB[itemName]
              if type(pv) == "number" then
                  procEP = pv
              elseif type(pv) == "table" and pv[r] then
                  procEP = pv[r]
              end
          elseif VRB_CUSTOM_ITEMS and VRB_CUSTOM_ITEMS[itemName] and VRB_CUSTOM_ITEMS[itemName][r] then
              procEP = VRB_CUSTOM_ITEMS[itemName][r]
          end
      end
      if procEP > 0 then
          vrbscore = vrbscore + procEP
          breakdown["BONUS"] = { ep = procEP, raw = procEP }
      end

      if vrbscore > 0 then
        local normalizedLabel = string.gsub(r, className, "")
        local grade = VRBGetGrade(vrbscore, r, gradeEquipLoc)

        if hasScore then
          frameLines = frameLines .. "|cffa0a0a0" .. string.rep("-", 26) .. "|r\n"
          lineCount = lineCount + 1
        end

        -- Linha: Spec   EP [Grade] +/-diff
        -- Usa cache do ShoppingTooltip1 (pfUI Shift) se disponivel
        local equippedEP = VRBEquippedEPCache[r] or VRBGetEquippedEP(r)
        local compStr = ""
        if equippedEP and equippedEP > 0 then
          local diff = vrbscore - equippedEP
          if diff > 0.5 then
            compStr = " |cff00ee44" .. string.format("%+.1f", diff) .. " EP|r"
          elseif diff < -0.5 then
            compStr = " |cffff4444" .. string.format("%.1f", diff) .. " EP|r"
          else
            compStr = " |cffa0a0a0= igual|r"
          end
        end

        frameLines = frameLines ..
          "|c" .. colorHex .. normalizedLabel .. ":|r " ..
          "|cffFFD700" .. vrbscore .. " EP|r  " ..
          VRBGradeDisplay(grade) .. compStr .. "\n"
        lineCount = lineCount + 1

        local breakdownStr, breakdownLines = VRBBuildBreakdownString(breakdown, 4)
        if breakdownStr ~= "" then
          frameLines = frameLines .. "|cffa0a0a0" .. breakdownStr .. "|r\n"
          lineCount = lineCount + (breakdownLines or 1)
        end

        hasScore = true
      end
    end

    if hasScore then
        VRBEPText:SetText(frameLines)
        VRBEPFrame:SetHeight(lineCount * 14 + 30)
        VRBPositionEPFrame()
        VRBEPFrame:Show()
    else
        VRBEPFrame:Hide()
    end
end)

VRBItemScoreTooltip:SetScript("OnHide", function()
    VRBEPFrame:Hide()
    VRBEquippedEPCache = {}  -- Limpa cache ao esconder tooltip
end)

-- -------------------------------------------------------
-- EquipCompare Integration
-- Mostra EP do item EQUIPADO no ComparisonTooltip1
-- -------------------------------------------------------
local VRBCompareEPFrame = CreateFrame("Frame", "VRBCompareEPFrame", UIParent)
VRBCompareEPFrame:SetWidth(VRB_FRAME_W)
VRBCompareEPFrame:SetFrameStrata("TOOLTIP")
VRBCompareEPFrame:SetFrameLevel(200)
VRBCompareEPFrame:SetBackdrop({
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 14,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
VRBCompareEPFrame:SetBackdropColor(0.0, 0.0, 0.0, 1.0)
VRBCompareEPFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1.0)

local VRBCompareBg = VRBCompareEPFrame:CreateTexture(nil, "BACKGROUND")
VRBCompareBg:SetAllPoints(VRBCompareEPFrame)
VRBCompareBg:SetTexture(0.04, 0.04, 0.06, 1.0)
VRBCompareEPFrame:SetScript("OnShow", function()
    this:SetFrameStrata("TOOLTIP")
    this:SetFrameLevel(200)
end)
VRBCompareEPFrame:Hide()

local VRBCompareSep = VRBCompareEPFrame:CreateTexture(nil, "ARTWORK")
VRBCompareSep:SetHeight(1)
VRBCompareSep:SetPoint("TOPLEFT",  VRBCompareEPFrame, "TOPLEFT",  6, -16)
VRBCompareSep:SetPoint("TOPRIGHT", VRBCompareEPFrame, "TOPRIGHT", -6, -16)
VRBCompareSep:SetTexture(0.5, 0.5, 0.5, 0.4)

local VRBCompareTitleFS = VRBCompareEPFrame:CreateFontString("VRBCompareEPFrameTitle", "OVERLAY", "GameFontNormalSmall")
VRBCompareTitleFS:SetPoint("TOPLEFT", VRBCompareEPFrame, "TOPLEFT", 8, -5)
VRBCompareTitleFS:SetText("|cffa0a0a0[ Equipado ]|r")

local VRBCompareEPText = VRBCompareEPFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
VRBCompareEPText:SetPoint("TOPLEFT", VRBCompareEPFrame, "TOPLEFT", 8, -20)
VRBCompareEPText:SetJustifyH("LEFT")
VRBCompareEPText:SetWidth(VRB_FRAME_W - 16)

local function VRBScanComparisonTooltip(tooltipFrame, frameName)
    if not tooltipFrame or not tooltipFrame:IsShown() then return end

    local savedTemp = BonusScanner.temp
    BonusScanner.temp = { sets = {}, set = "", bonuses = {}, slot = "", details = {} }

    local numLines = tooltipFrame:NumLines()
    for i = 2, numLines do
        local line = getglobal(frameName .. "TextLeft" .. i)
        if line and line:GetText() then
            BonusScanner:ScanLine(line:GetText())
        end
    end

    -- Injeta DPS/Speed do item equipado (mesmo mecanismo do tooltip principal)
    local cmpWeaponSlot = VRBGuessWeaponSlot(numLines, frameName)
    if cmpWeaponSlot then
        VRBInjectWeaponStats(BonusScanner.temp.bonuses, numLines, frameName, cmpWeaponSlot)
    end

    local ratings = VRBGetFilteredRatings()
    local className, classFileName = UnitClass("player")
    local color = RAID_CLASS_COLORS[classFileName]
    local colorHex = string.format("ff%02x%02x%02x", color.r*255, color.g*255, color.b*255)

    local frameLines = ""
    local hasScore = false
    local lineCount = 0

    for _, r in ipairs(ratings) do
        local score = VRBCalculateRating(r, BonusScanner.temp.bonuses)
        VRBEquippedEPCache[r] = score
        VRBNeedsRebuild = true
        if score > 0 then
            local normalizedLabel = string.gsub(r, className, "")
            local grade = VRBGetGrade(score, r, cmpWeaponSlot)

            if hasScore then
                frameLines = frameLines .. "|cffa0a0a0" .. string.rep("-", 26) .. "|r\n"
                lineCount = lineCount + 1
            end

            -- Compara com o item novo (VRBHoveredEPData)
            local specLabel = ""
            if VRBHoveredEPData then
                local newEP = VRBCalculateRating(r, VRBHoveredEPData.bonuses)
                if newEP > 0 then
                    local diff = score - newEP
                    if diff > 0.5 then
                        specLabel = "  |cff00ee44MELHOR|r"
                    elseif diff < -0.5 then
                        specLabel = "  |cffff4444PIOR|r"
                    else
                        specLabel = "  |cffa0a0a0IGUAL|r"
                    end
                end
            end

            frameLines = frameLines ..
                "|c" .. colorHex .. normalizedLabel .. ":|r " ..
                "|cffFFD700" .. score .. " EP|r  " ..
                VRBGradeDisplay(grade) .. specLabel .. "\n"
            lineCount = lineCount + 1
            hasScore = true
        end
    end

    BonusScanner.temp = savedTemp

    if hasScore then
        -- Indicador geral: melhor ou pior que o equipado?
        local VRBTotalNew = 0
        local VRBTotalEquip = 0
        local VRBCompCount = 0
        for _, r in ipairs(VRBGetFilteredRatings()) do
            local eqEP = VRBEquippedEPCache[r]
            local newEP = VRBHoveredEPData and VRBCalculateRating(r, VRBHoveredEPData.bonuses) or 0
            if eqEP and eqEP > 0 and newEP > 0 then
                VRBTotalNew = VRBTotalNew + newEP
                VRBTotalEquip = VRBTotalEquip + eqEP
                VRBCompCount = VRBCompCount + 1
            end
        end
        if VRBCompCount > 0 then
            local totalDiff = VRBTotalNew - VRBTotalEquip
            if totalDiff > 0.5 then
                VRBCompareTitleFS:SetText("|cffa0a0a0[ Equipado ]|r  |cffff4444PIOR|r")
            elseif totalDiff < -0.5 then
                VRBCompareTitleFS:SetText("|cffa0a0a0[ Equipado ]|r  |cff00ee44MELHOR|r")
            else
                VRBCompareTitleFS:SetText("|cffa0a0a0[ Equipado ]  = IGUAL|r")
            end
        else
            VRBCompareTitleFS:SetText("|cffa0a0a0[ Equipado ]|r")
        end
        VRBCompareEPText:SetText(frameLines)
        VRBCompareEPFrame:SetHeight(lineCount * 14 + 30)
        VRBCompareEPFrame:ClearAllPoints()

        -- Posiciona abaixo do tooltip de comparacao (nao conflita com pfUI)
        local tipBottom = tooltipFrame:GetBottom() or 0
        local tipLeft   = tooltipFrame:GetLeft() or 0
        local tipRight  = tooltipFrame:GetRight() or 0
        local screenW   = GetScreenWidth()
        local frameW    = VRBCompareEPFrame:GetWidth() or 210
        local x = tipLeft
        if x + frameW > screenW then x = screenW - frameW - 4 end
        if x < 0 then x = 4 end
        if tipBottom > 80 then
            VRBCompareEPFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, tipBottom - 4)
        else
            VRBCompareEPFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -220, -180)
        end
        VRBCompareEPFrame:Show()
        -- Rebuild VRBEPFrame com cores de comparacao
        if VRBNeedsRebuild and VRBHoveredEPData then
            VRBNeedsRebuild = false
            local d = VRBHoveredEPData
            local newLines = ""
            local lineCount2 = 0
            local firstSpec = true

            for i = 1, table.getn(d.ratings) do
                local spec = d.ratings[i]
                local specScore, breakdown = VRBCalculateRatingDetailed(spec, d.bonuses)

                -- Proc EP no rebuild (VRB_PROC_DB prioridade sobre VRB_CUSTOM_ITEMS)
                local rebuildProcEP = 0
                if d.itemName then
                    if VRB_PROC_DB and VRB_PROC_DB[d.itemName] then
                        local pv = VRB_PROC_DB[d.itemName]
                        if type(pv) == "number" then
                            rebuildProcEP = pv
                        elseif type(pv) == "table" and pv[spec] then
                            rebuildProcEP = pv[spec]
                        end
                    elseif VRB_CUSTOM_ITEMS and VRB_CUSTOM_ITEMS[d.itemName] and VRB_CUSTOM_ITEMS[d.itemName][spec] then
                        rebuildProcEP = VRB_CUSTOM_ITEMS[d.itemName][spec]
                    end
                end
                if rebuildProcEP > 0 then
                    specScore = specScore + rebuildProcEP
                    breakdown["BONUS"] = { ep = rebuildProcEP, raw = rebuildProcEP }
                end

                if specScore > 0 then
                    local label = string.gsub(spec, d.className, "")
                    local grade = VRBGetGrade(specScore, spec, d.equipLoc)

                    if not firstSpec then
                        newLines = newLines .. "|cffa0a0a0" .. string.rep("-", 26) .. "|r\n"
                        lineCount2 = lineCount2 + 1
                    end
                    firstSpec = false

                    -- Comparacao com item equipado
                    local compStr = ""
                    local eqEP = VRBEquippedEPCache[spec]
                    if eqEP and eqEP > 0 then
                        local diff = specScore - eqEP
                        if diff > 0.5 then
                            compStr = "  |cff00ee44+" .. VRBRound(diff, 1) .. " EP|r"
                        elseif diff < -0.5 then
                            compStr = "  |cffff4444" .. VRBRound(diff, 1) .. " EP|r"
                        else
                            compStr = "  |cffa0a0a0= igual|r"
                        end
                    end

                    newLines = newLines ..
                        "|c" .. d.colorHex .. label .. ":|r " ..
                        "|cffFFD700" .. specScore .. " EP|r  " ..
                        VRBGradeDisplay(grade) .. compStr .. "\n"
                    lineCount2 = lineCount2 + 1

                    local bkStr, bkLines = VRBBuildBreakdownString(breakdown, 4)
                    if bkStr ~= "" then
                        newLines = newLines .. "|cffa0a0a0" .. bkStr .. "|r\n"
                        lineCount2 = lineCount2 + (bkLines or 1)
                    end
                end
            end

            if newLines ~= "" then
                VRBEPText:SetText(newLines)
                VRBEPFrame:SetHeight(lineCount2 * 14 + 30)
                VRBEPFrame:Show()
            end
        end
    else
        VRBCompareEPFrame:Hide()
    end
end

-- Hook no ComparisonTooltip1 apos todos os addons carregarem
local VRBECHookFrame = CreateFrame("Frame")
VRBECHookFrame:RegisterEvent("VARIABLES_LOADED")
VRBECHookFrame:SetScript("OnEvent", function()
    -- Aguarda um ciclo para garantir que EquipCompare carregou
    this.timer = 0
    this:SetScript("OnUpdate", function()
        this.timer = this.timer + arg1
        if this.timer < 0.5 then return end
        this:SetScript("OnUpdate", nil)
        this:UnregisterAllEvents()

        -- pfUI usa ShoppingTooltip1/2 (frames padrao do WoW)
        -- Tambem suporta ComparisonTooltip1 do EquipCompare como fallback
        local function HookComparisonTooltip(ttFrame, frameName)
            if not ttFrame then return end
            local trigger = CreateFrame("Frame", nil, ttFrame)
            trigger:SetScript("OnShow", function()
                VRBScanComparisonTooltip(ttFrame, frameName)
            end)
            trigger:SetScript("OnHide", function()
                VRBCompareEPFrame:Hide()
            end)
        end

        HookComparisonTooltip(ShoppingTooltip1, "ShoppingTooltip1")
        HookComparisonTooltip(ShoppingTooltip2, "ShoppingTooltip2")
        HookComparisonTooltip(ComparisonTooltip1, "ComparisonTooltip1")
    end)
end)


-- -------------------------------------------------------
-- Frame de Total EP
-- -------------------------------------------------------
local VRBTotalFrame = CreateFrame("Frame", "VRBTotalFrame", UIParent)
VRBTotalFrame:SetWidth(230)
VRBTotalFrame:SetHeight(100)
VRBTotalFrame:SetPoint("CENTER", UIParent, "CENTER", 300, 0)
VRBTotalFrame:SetMovable(true)
VRBTotalFrame:EnableMouse(true)
VRBTotalFrame:RegisterForDrag("LeftButton")
VRBTotalFrame:SetScript("OnDragStart", function() this:StartMoving() end)
VRBTotalFrame:SetScript("OnDragStop",  function() this:StopMovingOrSizing() end)
VRBTotalFrame:SetBackdrop({
    bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
    tile=true, tileSize=16, edgeSize=12,
    insets={left=3,right=3,top=3,bottom=3}
})
VRBTotalFrame:SetBackdropColor(0,0,0,0.75)
VRBTotalFrame:SetBackdropBorderColor(0.4,0.4,0.4,0.8)
VRBTotalFrame:Hide()

local VRBTotalTitle = VRBTotalFrame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
VRBTotalTitle:SetPoint("TOPLEFT",VRBTotalFrame,"TOPLEFT",6,-5)
VRBTotalTitle:SetJustifyH("LEFT")
local VRBTotalText = VRBTotalFrame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
VRBTotalText:SetPoint("TOPLEFT",VRBTotalFrame,"TOPLEFT",6,-18)
VRBTotalText:SetJustifyH("LEFT")
local VRBOverallText = VRBTotalFrame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
VRBOverallText:SetPoint("BOTTOMLEFT",VRBTotalFrame,"BOTTOMLEFT",6,5)
VRBOverallText:SetJustifyH("LEFT")

local VRBController = CreateFrame("Frame","VRBController",UIParent)
VRBController:SetScript("OnUpdate", function()
    local charOpen = CharacterFrame and CharacterFrame:IsShown()
    if charOpen then
        if not VRBTotalFrame:IsShown() then VRBTotalFrame:Show() end
    else
        if VRBTotalFrame:IsShown() then VRBTotalFrame:Hide() end
        return
    end
    if not this.timer then this.timer = 0 end
    this.timer = this.timer + arg1
    if this.timer < 1.0 then return end
    this.timer = 0
    local ratings = VRBGetValidRatings()
    if not (ratings and BonusScanner and BonusScanner.bonuses) then return end
    local className, classFileName = UnitClass("player")
    local color = RAID_CLASS_COLORS[classFileName] or {r=1,g=1,b=0}
    local colorHex = string.format("ff%02x%02x%02x",color.r*255,color.g*255,color.b*255)
    VRBTotalTitle:SetText("|c"..colorHex.."Total EP Equipado|r  |cffa0a0a0(arraste)|r")
    local augBonuses = VRBBuildAugmentedBonuses()
    local lines = ""
    local hasScore = false
    local bestScore = 0
    local bestSpec = nil
    for _, r in ipairs(ratings) do
        local score = VRBCalculateRating(r, augBonuses)
        if score > 0 then
            local label = string.gsub(r, className, "")
            local grade = VRBGetGradeTotal(score, r)
            lines = lines .. "|cffd0d0d0" .. label .. ":|r " .. score .. " EP  " .. VRBGradeDisplay(grade) .. "\n"
            hasScore = true
            if score > bestScore then bestScore = score; bestSpec = r end
        end
    end
    if hasScore then
        VRBTotalText:SetText(lines)
        local overallGrade = VRBGetGradeTotal(bestScore, bestSpec)
        VRBOverallText:SetText("|cffa0a0a0Gear:|r  " .. VRBGradeDisplay(overallGrade))
    else
        VRBTotalTitle:SetText("") VRBTotalText:SetText("") VRBOverallText:SetText("")
    end
end)

-- Slash command
SLASH_VRBSCORE1 = "/vrb"
SLASH_VRBSCORE2 = "/vrbscore"
SlashCmdList["VRBSCORE"] = function(msg)
    if not msg then msg = "" end
    local cmd = string.gsub(string.lower(msg), "^%s*(.-)%s*$", "%1")
    if cmd == "" or cmd == "all" or cmd == "todos" then
        VRB_ACTIVE_SPEC = nil
        if VRB_SETTINGS then VRB_SETTINGS.activeSpec = nil end
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[KZ ItemEP]|r Tooltip: todas as specs.", 1,1,1)
    elseif VRB_SPEC_ALIASES[cmd] then
        VRB_ACTIVE_SPEC = VRB_SPEC_ALIASES[cmd]
        if VRB_SETTINGS then VRB_SETTINGS.activeSpec = VRB_ACTIVE_SPEC end
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[KZ ItemEP]|r Filtrado: " .. VRB_ACTIVE_SPEC, 1,1,1)
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[KZ ItemEP]|r Uso: /vrb swords|daggers|sub|fury|arms|prot|hunter|all", 1,1,0)
    end
end

local VRBLoader = CreateFrame("Frame")
VRBLoader:RegisterEvent("VARIABLES_LOADED")
VRBLoader:SetScript("OnEvent", function()
    if not VRB_SETTINGS then VRB_SETTINGS = { activeSpec = nil } end
    if not VRB_PROC_DB then VRB_PROC_DB = {} end
    if VRB_SETTINGS.activeSpec then
        VRB_ACTIVE_SPEC = VRB_SETTINGS.activeSpec
        DEFAULT_CHAT_FRAME:AddMessage("|cffFFD700[KZ ItemEP]|r Filtrado: "..VRB_ACTIVE_SPEC.." (use /vrb all)", 1,1,0)
    end
end)