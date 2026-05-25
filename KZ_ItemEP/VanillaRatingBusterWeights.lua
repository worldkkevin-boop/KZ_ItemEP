VRB_LABELS = {
    ["Druid"]   = { "DruidFeralDPS-EP", "DruidTank-EP", "DruidThreat-EP", "DruidResto-EP" },
    ["Shaman"]  = { "ShamanHEP", "ShamanMelee" },
    ["Warrior"] = { "WarriorThreat-EP", "WarriorMitigation-EP", "WarriorFury-EP", "WarriorArms-EP" },
    ["Paladin"] = { "PaladinProtEH", "PaladinRetDPS", "PaladinHEP" },
    ["Priest"]  = { "PriestHoly", "PriestHolyLong", "PriestShadow" },
    ["Rogue"]   = { "RogueCombatSwords", "RogueCombatDaggers" },
    ["Hunter"]  = { "HunterDPS-EP", "HunterSurvival" },
    ["Mage"]    = { "MageDPS" },
    ["Warlock"] = { "WarlockSMRuin", "WarlockDestruction" },
}

-- Teto por ITEM INDIVIDUAL
VRB_MAX_SCORES = {
    -- Rogue (calibrado pelo Bonescythe Pauldrons T3 = 116 EP)
    ["RogueCombatSwords"]    = 125,
    ["RogueCombatDaggers"]   = 130,
    -- Warrior
    ["WarriorFury-EP"]       = 170,
    ["WarriorThreat-EP"]     = 160,
    ["WarriorMitigation-EP"] = 200,
    ["WarriorArms-EP"]       = 180,
    -- Hunter
    ["HunterDPS-EP"]        = 190,
    ["HunterSurvival"]      = 150,
    -- Druid
    ["DruidFeralDPS-EP"]     = 220,
    ["DruidTank-EP"]         = 280,
    ["DruidThreat-EP"]       = 200,
    ["DruidResto-EP"]        = 150,
    -- Paladin
    ["PaladinRetDPS"]        = 90,
    ["PaladinHEP"]           = 150,
    ["PaladinProtEH"]        = 380,
    -- Priest
    ["PriestHoly"]           = 170,
    ["PriestHolyLong"]       = 160,
    ["PriestShadow"]         = 110,
    -- Mage
    ["MageDPS"]             = 140,
    -- Warlock
    ["WarlockSMRuin"]          = 130,
    ["WarlockDestruction"]    = 130,
    -- Shaman
    ["ShamanHEP"]            = 110,
    ["ShamanMelee"]          = 90,
}

-- Teto para GEAR TOTAL EQUIPADO
-- Recalibrado com pesos corretos do site (AP=0.5 ref para AP=0.5 specs, AP=1 para specs dobradas)
-- Formula: soma do EP BiS de todos os slots / 0.95
-- Rogue CS calculado: MH 532.81 + OH 250.59 + gear 15 slots ~972 = ~1756 total
VRB_MAX_SCORES_TOTAL = {
    -- Rogue (escala AP=0.5)
    ["RogueCombatSwords"]    = 1850,  -- era 750. MH Hungering Cold 532 + OH Gressil 250 + gear 972
    ["RogueCombatDaggers"]   = 1600,  -- era 780. Armas CD tem menos EP (sem sword_skill, daggers menores)
    -- Warrior (escala AP=1, x2 — Crit=43, MHDPS=10.70 corrigidos)
    ["WarriorFury-EP"]       = 3100,  -- era 850. TF MH~630 + OH~214 + gear~2250
    ["WarriorThreat-EP"]     = 1000,  -- era 800. Spec customizada, estimativa conservadora
    ["WarriorMitigation-EP"] = 1500,  -- era 1000. STA/Armor focado
    ["WarriorArms-EP"]       = 3200,  -- era 900. 2H BiS ~980 EP (MHDPS=14.73) + gear~2200
    -- Hunter (escala AP=1, RANGEDDPS=31.29 corrigido)
    ["HunterDPS-EP"]         = 3800,  -- era 950. Arco BiS sozinho ~1881 EP (56DPS x31.29 + spd x40.48)
    ["HunterSurvival"]       = 2300,  -- era 700. Melee + OH corrigidos (MHDPS=10, OHDPS=8)
    -- Druid (escala AP=1 para Feral/Tank/Threat)
    ["DruidFeralDPS-EP"]     = 1920,  -- era 1100. Cat nao usa weapon DPS, apenas stats (AGI/STR/Crit)
    ["DruidTank-EP"]         = 2000,  -- era 1400. Bear com armor/STA/Crit alto
    ["DruidThreat-EP"]       = 1200,  -- era 1000
    ["DruidResto-EP"]        = 800,   -- era 750
    -- Paladin
    ["PaladinRetDPS"]        = 1000,  -- era 450. Escala AP=0.5 corrigida (STR=1.1, CRIT=14.81)
    ["PaladinHEP"]           = 800,   -- era 750
    ["PaladinProtEH"]        = 2000,  -- era 1900
    -- Priest
    ["PriestHoly"]           = 1400,  -- era 1400 (ok)
    ["PriestHolyLong"]       = 1300,  -- era 1200
    ["PriestShadow"]         = 1000,  -- era 700. Casters subestimados
    ["PriestShadowFarm"]     = 1000,  -- era 900
    -- Mage
    ["MageDPS"]              = 1200,  -- era 700. BiS T3 Frostfire ~1100+ EP
    -- Warlock
    ["WarlockSMRuin"]        = 1000,  -- era 650
    ["WarlockDestruction"]   = 1000,  -- era 650
    -- Shaman
    ["ShamanHEP"]            = 600,   -- era 550
    ["ShamanMelee"]          = 900,   -- era 450. Escala AP=0.5 corrigida (MH BiS ~230 + gear ~600)
}

VRB_CUSTOM_ITEMS = {
    -- =============================================================
    -- LENDARIOS / PROCS
    -- EP = bonus do proc ADICIONADO ao EP calculado automaticamente
    -- Referencia: AP=0.5 (igual ao site EP calculator)
    -- =============================================================
    ["Thunderfury, Blessed Blade of the Windseeker"] = {
        ["RogueCombatSwords"]  = 65,   -- proc nature AoE + slow
        ["RogueCombatDaggers"] = 52,
        ["WarriorFury-EP"]     = 145,
        ["WarriorThreat-EP"]   = 140,
    },
    ["Ironfoe"] = {
        ["RogueCombatSwords"]  = 50,   -- proc extra attack (2 PPM)
        ["WarriorFury-EP"]     = 120,
    },
    ["Vis'kag the Bloodletter"] = {
        ["RogueCombatSwords"]  = 40,   -- proc bloodlust chance
        ["RogueCombatDaggers"] = 30,
    },
    ["Flurry Axe"] = {
        ["RogueCombatSwords"]  = 33,   -- proc extra attack (alto PPM)
        ["WarriorFury-EP"]     = 75,
    },
    ["Hand of Edward the Odd"] = {
        ["RogueCombatDaggers"] = 20,   -- proc random spell cast
    },
    ["Eskhandar's Right Claw"] = {
        ["RogueCombatSwords"]  = 38,   -- proc bleed (6 PPM)
    },

    -- =============================================================
    -- WEAPON SKILL
    -- Weapon_1_Skill = 15 EP/ponto (site, AP=0.5) para CS e CD
    -- Hungering Cold: +6 sword skill = 6*15 = 90 EP (CS Rogue)
    -- Edgemaster: +7 sword/dagger/mace skill = 7*15 = 105 EP cada spec
    -- Aged Core:  +5 dagger skill = 5*15 = 75 EP (so para CD)
    -- =============================================================
    ["The Hungering Cold"] = {
        ["RogueCombatSwords"]  = 90,   -- +6 sword skill (6 * 15)
    },
    ["Edgemaster's Handguards"] = {
        ["RogueCombatSwords"]  = 105,  -- +7 sword skill (7 * 15)
        ["RogueCombatDaggers"] = 105,  -- +7 dagger skill (7 * 15)
        ["WarriorFury-EP"]     = 280,  -- +7 sword skill (7 * 20_site * 2_escala = 280)
        ["WarriorThreat-EP"]   = 50,   -- spec custom, estimativa
        ["WarriorArms-EP"]     = 280,  -- +7 sword skill (7 * 20_site * 2_escala = 280)
    },
    ["Aged Core Leather Gloves"] = {
        ["RogueCombatDaggers"] = 75,   -- +5 dagger skill (5 * 15)
    },

    -- =============================================================
    -- ROGUE: SET DARKMANTLE (T0.5, 4pc = +35 energia on hit ~4 PPM)
    -- Bonus total ~60 EP / 4 pecas = ~15 EP por peca
    -- =============================================================
    ["Darkmantle Cap"]       = { ["RogueCombatSwords"] = 15, ["RogueCombatDaggers"] = 15 },
    ["Darkmantle Tunic"]     = { ["RogueCombatSwords"] = 15, ["RogueCombatDaggers"] = 15 },
    ["Darkmantle Gloves"]    = { ["RogueCombatSwords"] = 15, ["RogueCombatDaggers"] = 15 },
    ["Darkmantle Pants"]     = { ["RogueCombatSwords"] = 15, ["RogueCombatDaggers"] = 15 },
    ["Darkmantle Spaulders"] = { ["RogueCombatSwords"] = 15, ["RogueCombatDaggers"] = 15 },
    ["Darkmantle Belt"]      = { ["RogueCombatSwords"] = 15, ["RogueCombatDaggers"] = 15 },
    ["Darkmantle Boots"]     = { ["RogueCombatSwords"] = 15, ["RogueCombatDaggers"] = 15 },
    ["Darkmantle Bracers"]   = { ["RogueCombatSwords"] = 15, ["RogueCombatDaggers"] = 15 },

    -- =============================================================
    -- TRINKETS (multiplas classes)
    -- =============================================================
    -- AQ40 trinkets: proc EP derivado do site (field80 = total EP, sem stats base)
    ["Badge of the Swarmguard"] = {
        ["RogueCombatSwords"]  = 32,   -- proc: -200 armor por hit, ate 5 stacks (-1000)
        ["RogueCombatDaggers"] = 32,
        ["WarriorFury-EP"]     = 32,
        ["WarriorArms-EP"]     = 32,
    },
    ["Jom Gabbar"] = {
        ["RogueCombatSwords"]  = 20,   -- proc: +6 AP por hit, ate 10 stacks
        ["RogueCombatDaggers"] = 20,
        ["WarriorFury-EP"]     = 20,
        ["WarriorArms-EP"]     = 20,
    },
    ["Hand of Justice"] = {
        ["RogueCombatSwords"]  = 38,   -- proc extra attack (1.5 PPM)
        ["RogueCombatDaggers"] = 38,
        ["WarriorFury-EP"]     = 75,
        ["WarriorArms-EP"]     = 45,
    },
    -- Blackhand's Breadth: +2% melee crit = 2 * CRIT_weight (BonusScanner nao parseia)
    ["Blackhand's Breadth"] = {
        ["RogueCombatSwords"]  = 28,   -- 2 * 13.895 = 27.8 EP (BonusScanner nao parseia crit de equip text)
        ["RogueCombatDaggers"] = 28,   -- 2 * 14.013 = 28.0 EP
        ["WarriorFury-EP"]     = 75,
        ["WarriorArms-EP"]     = 66,
        ["HunterDPS-EP"]       = 64,
    },
    -- Royal Seal of Eldre'Thalas: +2% hit (BonusScanner parseia) + silence proc (sem valor PVE) = sem entrada

    -- =============================================================
    -- ROGUE: ESPADAS
    -- =============================================================
    ["Krol Blade"]                 = { ["RogueCombatSwords"] = 52,  ["RogueCombatDaggers"] = 5 },
    ["Cruel Barb"]                 = { ["RogueCombatSwords"] = 20,  ["RogueCombatDaggers"] = 5 },
    ["Thrash Blade"]               = { ["RogueCombatSwords"] = 33,  ["RogueCombatDaggers"] = 0 },
    ["Trash Blade"]                = { ["RogueCombatSwords"] = 33,  ["RogueCombatDaggers"] = 0 },
    ["Dal'Rend's Sacred Charge"]   = { ["RogueCombatSwords"] = 28,  ["RogueCombatDaggers"] = 5 },
    ["Dal'Rend's Tribal Guardian"] = { ["RogueCombatSwords"] = 25,  ["RogueCombatDaggers"] = 5 },
    ["Barb of the Sand Reaver"]    = { ["RogueCombatSwords"] = 43,  ["RogueCombatDaggers"] = 5 },
    ["Maelstrom's Wrath"]          = { ["RogueCombatSwords"] = 0,   ["RogueCombatDaggers"] = 25 },
    ["Nightblade"]                 = { ["RogueCombatSwords"] = 25,  ["RogueCombatDaggers"] = 5 },

    -- =============================================================
    -- ROGUE: ADAGAS
    -- =============================================================
    ["Perdition's Blade"]          = { ["RogueCombatDaggers"] = 55,  ["RogueCombatSwords"] = 5 },
    ["Core Hound Tooth"]           = { ["RogueCombatDaggers"] = 60,  ["RogueCombatSwords"] = 10 },
    ["Fang of the Crystal Spider"] = { ["RogueCombatDaggers"] = 30,  ["RogueCombatSwords"] = 5 },
    ["Tooth of Eranikus"]          = { ["RogueCombatDaggers"] = 20 },
    ["Distracting Dagger"]         = { ["RogueCombatDaggers"] = 15 },
    ["Barman Shanker"]             = { ["RogueCombatDaggers"] = 25 },
    ["Spine of the Chromaggus"]    = { ["RogueCombatDaggers"] = 35,  ["RogueCombatSwords"] = 5 },
    ["Gutgore Ripper"]             = { ["RogueCombatDaggers"] = 30,  ["RogueCombatSwords"] = 5 },
    ["Heartseeker"]                = { ["RogueCombatDaggers"] = 20 },
    ["The Lobotomizer"]            = { ["RogueCombatDaggers"] = 15 },

    -- =============================================================
    -- PRIEST: ARMAS ESPECIAIS COM PROC
    -- =============================================================
    ["Benediction"] = {
        ["PriestHoly"]     = 80,
        ["PriestHolyLong"] = 90,
    },
    ["Anathema"] = {
        ["PriestShadow"] = 65,
    },
    ["Staff of Dominance"] = {
        ["PriestShadow"] = 30,
    },
    ["Veil of Eclipse"] = {
        ["PriestShadow"]   = 40,
        ["PriestHoly"]     = 35,
        ["PriestHolyLong"] = 40,
    },

    -- =============================================================
    -- PRIEST: SET FROZEN SHADOWEAVE (Tailoring BiS Shadow)
    -- 3pc bonus: +23 Shadow Damage = ~8 EP por peca
    -- =============================================================
    ["Frozen Shadoweave Robe"]      = { ["PriestShadow"] = 8 },
    ["Frozen Shadoweave Shoulders"] = { ["PriestShadow"] = 8 },
    ["Frozen Shadoweave Boots"]     = { ["PriestShadow"] = 8 },

    -- =============================================================
    -- PRIEST: SET VESTMENTS OF THE DEVOUT (T0 Holy)
    -- 8pc bonus: +23 Healing = ~3 EP por peca
    -- =============================================================
    ["Devout Crown"]       = { ["PriestHoly"] = 3, ["PriestHolyLong"] = 3 },
    ["Devout Mantle"]      = { ["PriestHoly"] = 3, ["PriestHolyLong"] = 3 },
    ["Devout Robe"]        = { ["PriestHoly"] = 3, ["PriestHolyLong"] = 3 },
    ["Devout Gloves"]      = { ["PriestHoly"] = 3, ["PriestHolyLong"] = 3 },
    ["Devout Belt"]        = { ["PriestHoly"] = 3, ["PriestHolyLong"] = 3 },
    ["Devout Sandals"]     = { ["PriestHoly"] = 3, ["PriestHolyLong"] = 3 },
    ["Devout Bracers"]     = { ["PriestHoly"] = 3, ["PriestHolyLong"] = 3 },
    ["Devout Skirt"]       = { ["PriestHoly"] = 3, ["PriestHolyLong"] = 3 },

    -- =============================================================
    -- PRIEST: SET VESTMENTS OF PROPHECY (T1 Holy, MC)
    -- 8pc: +23 Healing e proc de mana
    -- =============================================================
    ["Circlet of Prophecy"]   = { ["PriestHoly"] = 5, ["PriestHolyLong"] = 6 },
    ["Mantle of Prophecy"]    = { ["PriestHoly"] = 5, ["PriestHolyLong"] = 6 },
    ["Robes of Prophecy"]     = { ["PriestHoly"] = 5, ["PriestHolyLong"] = 6 },
    ["Gloves of Prophecy"]    = { ["PriestHoly"] = 5, ["PriestHolyLong"] = 6 },
    ["Belt of Transcendence"] = { ["PriestHoly"] = 5, ["PriestHolyLong"] = 6 },
    ["Sandals of Prophecy"]   = { ["PriestHoly"] = 5, ["PriestHolyLong"] = 6 },
    ["Bracelets of Prophecy"] = { ["PriestHoly"] = 5, ["PriestHolyLong"] = 6 },
    ["Pants of Prophecy"]     = { ["PriestHoly"] = 5, ["PriestHolyLong"] = 6 },

    -- =============================================================
    -- HUNTER: SET DEVILSAUR (2pc = +2% Hit antes do cap = ~64 EP)
    -- Cada peca carrega metade do beneficio do bonus de conjunto
    -- =============================================================
    ["Devilsaur Gauntlets"] = { ["HunterDPS-EP"] = 32 },
    ["Devilsaur Leggings"]  = { ["HunterDPS-EP"] = 32 },
}

-- Teto de EP por slot de equipamento (calibrado pelo BiS de cada slot)
-- Permite que itens BiS de slots menores (neck, ring) recebam [S] ou [SS]
-- em vez de serem penalizados por ter menos stats que chest/head
-- Teto por slot = BiS_EP / 0.95  (BiS aparece como [SS])
-- Fonte: ranking Combat Swords Rogue + pesos atuais VRB_WEIGHTS (AGI incluida)
-- NOTA: valores antigos excluiam AGI (peso era 0). Recalibrado com AGI=0.9792.
VRB_MAX_SCORES_SLOT = {
    -- Armadura (Bonescythe T3 = set BiS CS Rogue Naxx, exceto onde indicado)
    ["INVTYPE_HEAD"]            = 91,    -- Bonescythe Helmet 86.21 (29*AGI+2*Crit+30*AP+1*Hit)
    ["INVTYPE_CHEST"]           = 117,   -- Bonescythe Breastplate 111.21 (29*AGI+2*Crit+80*AP+1*Hit)
    ["INVTYPE_ROBE"]            = 117,
    ["INVTYPE_LEGS"]            = 73,    -- Bonescythe Legplates 69.39 (25*AGI+1*Crit+32*AP+1*Hit)
    ["INVTYPE_SHOULDER"]        = 57,    -- Bonescythe Pauldrons 54.60 (15*AGI+1*Crit+22*AP+1*Hit)
    ["INVTYPE_HAND"]            = 111,   -- Edgemaster's Handguards 105 EP (7*15 sword skill)
    ["INVTYPE_FEET"]            = 83,    -- Bonescythe Sabatons 78.54 (18*AGI+1*Crit+64*AP+1*Hit)
    ["INVTYPE_WAIST"]           = 85,    -- Belt of Never-ending Agony 80.50 (20*AGI+1*Crit+64*AP+1*Hit)
    ["INVTYPE_WRIST"]           = 43,    -- Bonescythe Bracers 40.61 (14*AGI+1*Crit+26*AP)
    -- Acessorios
    ["INVTYPE_NECK"]            = 47,    -- Prestor's Talisman of Connivery 44.4
    ["INVTYPE_CLOAK"]           = 52,    -- Shroud of Dominion 49.67 (11*AGI+1*Crit+50*AP)
    ["INVTYPE_FINGER"]          = 58,    -- Band of Unnatural Forces 54.91 (1*Crit+52*AP+1*Hit)
    ["INVTYPE_TRINKET"]         = 118,   -- Vanquished Tentacle de C'Thun 111.56
    -- Armas 1H (CS Rogue: Hungering Cold + 6*sword_skill=90 = 532.81 EP)
    ["INVTYPE_WEAPON"]          = 561,   -- Hungering Cold 532.81 (DPS+spd+14*AGI+6*sword_skill)
    ["INVTYPE_WEAPONMAINHAND"]  = 561,
    ["INVTYPE_WEAPONOFFHAND"]   = 264,   -- Gressil 250.59 (73DPS*OHDPS+2.7spd+15*AGI+40*AP)
    ["INVTYPE_HOLDABLE"]        = 65,
    ["INVTYPE_SHIELD"]          = 100,
    ["INVTYPE_2HWEAPON"]        = 900,
    ["INVTYPE_RANGED"]          = 1980,  -- Hunter MM BiS: Ashjre'thul (56.38DPS,2.9spd)=1881EP (RANGEDDPS=31.29,RANGEDSPEED=40.48)
    ["INVTYPE_RELIC"]           = 50,
}

VRB_WEIGHTS = {

  -- Tool (120s, AP=0.5 ref): STR=1.1 (bencao de forca), MHSPEED negativo = arma RAPIDA e melhor (site)
  -- NOTA: escala AP=0.5 direto do site (era 1/7 da escala correta)
  ["PaladinRetDPS"] = {
    ["STR"]         = 1.1,
    ["AGI"]         = 0.7405745063,
    ["CRIT"]        = 14.81149013,
    ["TOHIT"]       = { 9, 4.907241173, 0 },
    ["ATTACKPOWER"] = 0.5,
    ["MHDPS"]       = 4.201077199,
    ["MHSPEED"]     = -3.123877917,  -- negativo: arma rapida e melhor para Ret (site)
  },

  ["PaladinHEP"] = {
    ["INT"]       = 1.00,
    ["MANAREG"]   = 1.91,
    ["HEAL"]      = 1.00,
    ["SPELLCRIT"] = 20.34,
    ["SPI"]       = 0.00
    -- sem pesos de arma (healer)
  },

  ["PaladinProtEH"] = {
    ["ARMOR"]   = 0.51416,
    ["STA"]     = 10.14596,
    ["AGI"]     = 1.02832,
    ["STR"]     = 0.05,
    ["DODGE"]   = 0,
    ["PARRY"]   = 0,
    ["DEFENSE"] = 0.08,
    ["BLOCK"]   = 0.04,
    ["MHDPS"]   = 4.0,
    ["MHSPEED"] = 2.0,
  },

  -- Tool (Heal=1 ref): INT muito valioso, SPI baixo para Druid, SpellCrit moderado
  ["DruidResto-EP"] = {
    ["HEAL"]      = 1.00,
    ["DMG"]       = 1.00,
    ["INT"]       = 1.106,
    ["SPI"]       = 0.121,
    ["MANAREG"]   = 1.608,
    ["SPELLCRIT"] = 6.05,
    ["MANA"]      = 0.067,
  },

  ["DruidHEP"] = {
    ["INT"]       = 0.60,
    ["MANAREG"]   = 4.00,
    ["HEAL"]      = 1.00,
    ["SPELLCRIT"] = 7.50,
    ["SPI"]       = 0.30
  },

  -- Tool (Cat, AP=0.5 ref x2): pesos de stats batem com site (STR=1.2x2=2.4, AGI=1.361x2=2.72, Crit=17.215x2=34.43)
  -- NOTA: Cat form nao usa weapon DPS (habilidades escalam com AP, nao com dano da arma) -> sem MHDPS/MHSPEED
  ["DruidFeralDPS-EP"] = {
    ["AGI"]              = 2.72,
    ["ATTACKPOWER"]      = 1,
    ["CRIT"]             = 34.43,
    ["FERALATTACKPOWER"] = 1,
    ["HASTE"]            = 13.6,
    ["STR"]              = 2.4,
    ["TOHIT"]            = { 9, 34.43, 0 },
  },

  -- Tool (Bear): STA=1.2 ref. Dodge e Defense atualizados, ARMOR bem mais valioso
  ["DruidTank-EP"] = {
    ["AGI"]              = 1.70,
    ["ARMOR"]            = 0.42,
    ["ATTACKPOWER"]      = 1,
    ["CRIT"]             = 25.8,
    ["DEFENSE"]          = 2.0,
    ["DODGE"]            = 16.67,
    ["FERALATTACKPOWER"] = 1,
    ["HEALTH"]           = 0.18,
    ["HEALTHREG"]        = 2.4,
    ["STA"]              = 2.4,
    ["STR"]              = 2.2,
    ["TOHIT"]            = 36.1,
    ["MHDPS"]            = 4.5,
    ["MHSPEED"]          = 2.0,
  },

  ["DruidThreat-EP"] = {
    ["AGI"]              = 1.57,
    ["ARMORPEN"]         = 0.5,
    ["ATTACKPOWER"]      = 1,
    ["CRIT"]             = 25.8,
    ["FERALATTACKPOWER"] = 1,
    ["HASTE"]            = 26.6,
    ["STR"]              = 2.2,
    ["TOHIT"]            = 36.1,
    ["MHDPS"]            = 4.5,
    ["MHSPEED"]          = 2.0,
  },
  -- ================================================================
  -- ================================================================
  -- MAGE DPS (Fire / Frost)
  -- Tool (120s): SpellPower=1 ref. SPI quase zero (usa Evocation)
  -- Crit mais valioso para Fire (Ignite), similar para Frost
  -- ================================================================
  ["MageDPS"] = {
    ["DMG"]        = 1.0,
    ["SPELLCRIT"]  = 9.24,
    ["SPELLTOHIT"] = { 16, 12.87, 0 },
    ["INT"]        = 0.93,
    ["SPI"]        = 0.09,
    ["MANAREG"]    = 1.242,
  },
  -- WARLOCK DESTRUCTION
  -- Tool (120s): SpellPower=1 ref. Life Tap = INT/SPI/MP5 valem pouco
  -- SpellCrit e SpellHit quase iguais em valor
  -- ================================================================
  -- SM/RUIN (30 Affliction / 21 Destro) - build mais comum em raid
  ["WarlockSMRuin"] = {
    ["DMG"]        = 1.0,
    ["SPELLCRIT"]  = 15.19,
    ["SPELLTOHIT"] = { 16, 15.65, 0 },
    ["INT"]        = 0.25,
    ["SPI"]        = 0,
    ["MANAREG"]    = 0,
  },

  -- Pure Destruction
  ["WarlockDestruction"] = {
    ["DMG"]        = 1.0,
    ["SPELLCRIT"]  = 15.17,
    ["SPELLTOHIT"] = { 16, 15.81, 0 },
    ["INT"]        = 0.25,
    ["SPI"]        = 0,
    ["MANAREG"]    = 0,
  },
  ["ShamanHEP"] = {
    ["INT"]       = 0.20,
    ["MANAREG"]   = 1.00,
    ["HEAL"]      = 0.14,
    ["SPELLCRIT"] = 0.00,
    ["SPI"]       = 0.00
  },

  -- Tool (Enhancement, AP=0.5 ref): pesos direto do site. Sem OH (Shaman nao pode dual-wield em 1.12)
  -- NOTA: era escala 1/7 incorreta. Corrigido para AP=0.5 igual ao site
  ["ShamanMelee"] = {
    ["STR"]         = 1.0,
    ["AGI"]         = 0.6425925,
    ["CRIT"]        = 12.85185,
    ["TOHIT"]       = { 9, 9.35185, 0 },
    ["ATTACKPOWER"] = 0.5,
    ["MHDPS"]       = 5.0,   -- site Enhancement DPS weight
    ["MHSPEED"]     = 4.0,   -- site Enhancement Weapon_Speed weight
  },

  -- ================================================================
  -- PRIEST
  -- ================================================================
  -- Tool (120s fight): Heal=1 referencia. INT muito mais valioso que SPI
  ["PriestHoly"] = {
    ["HEAL"]      = 1.0,
    ["SPELLCRIT"] = 8.0,
    ["INT"]       = 1.14,
    ["SPI"]       = 0.40,
    ["MANAREG"]   = 1.61,
  },

  -- HolyLong: lutas longas, SPI e MP5 ganham mais valor
  ["PriestHolyLong"] = {
    ["HEAL"]      = 1.0,
    ["SPELLCRIT"] = 8.0,
    ["INT"]       = 1.0,
    ["SPI"]       = 0.65,
    ["MANAREG"]   = 2.0,
  },

  -- Tool (120s): SpellPower=1 referencia. SpellHit muito valioso (miss=0 dano)
  ["PriestShadow"] = {
    ["DMG"]        = 1.0,
    ["SHADOWDMG"]  = 1.0,
    ["SPELLTOHIT"] = { 6, 20.32, 0 },
    ["INT"]        = 1.048,
    ["SPI"]        = 0.15,
    ["SPELLCRIT"]  = 2.56,
    ["MANAREG"]    = 1.608,
  },

  -- ================================================================
  -- WARRIOR
  -- ================================================================
  ["WarriorThreat-EP"] = {
    ["AGI"]         = 1.05,
    ["ARMOR"]       = 0.05,
    ["ATTACKPOWER"] = 1,
    ["BLOCK"]       = 0.04,
    ["CRIT"]        = 22,
    ["DEFENSE"]     = 0.22,
    ["DODGE"]       = 0,
    ["PARRY"]       = 7.47,
    ["STR"]         = 2,
    ["TOHIT"]       = { 14, 27, 0 },
    ["MHDPS"]       = 6.5,
    ["MHSPEED"]     = 2.5,
    ["OHDPS"]       = 3.5,
    ["OHSPEED"]     = -1.5,
  },

  -- Tool: STA=1 referencia. Block Chance = 0 (nao mitiga dano), Block Value sim
  ["WarriorMitigation-EP"] = {
    ["AGI"]       = 0.924,
    ["ARMOR"]     = 0.055,
    ["BLOCK"]     = 0,
    ["DEFENSE"]   = 2.606,
    ["DODGE"]     = 16.29,
    ["PARRY"]     = 16.29,
    ["STA"]       = 1,
    ["STR"]       = 0.02,
    ["HEALTH"]    = 0.1,
    ["HEALTHREG"] = 2.4,
    ["TOHIT"]     = { 9, 27, 0 },
    ["MHDPS"]     = 2.0,  -- arma menos critica pra mitigation tank
    ["MHSPEED"]   = 0.5,
  },

  -- Tool (AP=0.5 ref x2 = AP=1): stats ok do site (AGI=1.085x2=2.17, Crit=21.70x2=43.40)
  -- CORRECAO: armas corrigidas para site x2 (era 7.5/2.5 errados)
  ["WarriorFury-EP"] = {
    ["AGI"]         = 2.17,
    ["ATTACKPOWER"] = 1,
    ["CRIT"]        = 43.40,
    ["STR"]         = 2,
    ["TOHIT"]       = { 9, 35.19, 0 },
    ["MHDPS"]       = 10.695335952,  -- site 5.348 x2
    ["MHSPEED"]     = 7.967845788,   -- site 3.984 x2
    ["OHDPS"]       = 5.459513988,   -- site 2.730 x2
    ["OHSPEED"]     = -2.979937268,  -- site -1.490 x2
  },

  -- Tool (AP=0.5 ref x2 = AP=1): stats ok do site (AGI=1.075x2=2.15, Crit=21.50x2=43.0)
  -- CORRECAO: MHDPS corrigido para site x2 (era 7.5 errado). Arms usa 2H, sem OH
  ["WarriorArms-EP"] = {
    ["AGI"]         = 2.15,
    ["ATTACKPOWER"] = 1,
    ["CRIT"]        = 43.0,
    ["STR"]         = 2.0,
    ["TOHIT"]       = { 9, 37.49, 0 },
    ["MHDPS"]       = 14.73164693,  -- site 7.366 x2 (MS escala muito com damage range)
    ["MHSPEED"]     = 7.385206782,  -- site 3.693 x2
  },
  -- Survival: build MELEE do Hunter vanilla (Counterattack, Raptor Strike)
  -- Stats ok do site (STR=0.5x2=1, AGI=0.881x2=1.76, Crit=14.12x2=28.24)
  -- CORRECAO: armas corrigidas para site x2 (era ~metade dos valores corretos)
  ["HunterSurvival"] = {
    ["STR"]               = 1.0,
    ["AGI"]               = 1.76,
    ["ATTACKPOWER"]       = 1.0,
    ["CRIT"]              = 28.24,
    ["RANGEDCRIT"]        = 28.24,
    ["TOHIT"]             = { 9, 14.88, 0 },
    ["INT"]               = 0.1,
    ["MHDPS"]             = 10.0,   -- site 5.0 x2
    ["MHSPEED"]           = 8.0,    -- site 4.0 x2
    ["OHDPS"]             = 8.0,    -- site 4.0 x2
    ["OHSPEED"]           = -3.0,   -- site -1.5 x2
    ["RANGEDDPS"]         = 3.0,    -- custom: survival usa ranged minimamente
    ["RANGEDSPEED"]       = -1.0,
  },
  -- ================================================================
  -- HUNTER DPS (Marksman) -- Tool (AP=0.5 ref x2 = AP=1)
  -- AGI: 2 RAP + Crit + Dodge (3.35 = site 1.677 x2)
  -- CORRECAO: RANGEDDPS e RANGEDSPEED completamente errados antes
  -- Site: Range_DPS=15.646 x2=31.29, RWeapon_Speed=20.240 x2=40.48 (POSITIVO = arco lento e melhor!)
  -- Arco lento = menos clipping com Aimed Shot em 1.12 vanilla MM Hunter
  -- ================================================================
  ["HunterDPS-EP"] = {
    ["AGI"]               = 3.35,
    ["ATTACKPOWER"]       = 1.0,
    ["RANGEDATTACKPOWER"] = 1.0,
    ["CRIT"]              = 35.9,
    ["RANGEDCRIT"]        = 35.9,
    ["TOHIT"]             = { 9, 27.6, 0 },
    ["INT"]               = 0.1,
    ["RANGEDDPS"]         = 31.2926923,   -- site 15.646 x2
    ["RANGEDSPEED"]       = 40.48059582,  -- site 20.240 x2, POSITIVO = arco lento e melhor
    ["MHDPS"]             = 1.5,          -- melee contribui pouco
  },

  -- ================================================================
  -- ROGUE
  -- ================================================================
  -- Pesos retirados diretamente do EP Calculator do site (referencia AP=0.5)
  -- MHSPEED/OHSPEED corrigidos (fator x5.19 vs valores originais do site)
  -- MH: 2.70 * 24.593 = 66.4 EP (site) | OH: 2.70 * (-6.800) = -18.4 EP (site)
  ["RogueCombatSwords"] = {
    ["STR"]         = 0.5,
    ["AGI"]         = 0.9791585369,
    ["CRIT"]        = 13.89559757,
    ["TOHIT"]       = { 9, 15.01690588, 0 },
    ["ATTACKPOWER"] = 0.5,
    ["HASTE"]       = 8.263179685,
    ["MHDPS"]       = 5.780523465,
    ["MHSPEED"]     = 24.59259259,  -- corrigido: era 4.74478082
    ["OHDPS"]       = 3.0,
    ["OHSPEED"]     = -6.800376388, -- corrigido: era -1.310284044 (x5.19)
  },

  -- Pesos retirados diretamente do EP Calculator do site
  ["RogueCombatDaggers"] = {
    ["STR"]         = 0.5,
    ["AGI"]         = 0.9832122405,
    ["CRIT"]        = 14.01315497,
    ["TOHIT"]       = { 9, 13.43132031, 0 },
    ["ATTACKPOWER"] = 0.5,
    ["HASTE"]       = 7.344434577,
    ["MHDPS"]       = 5.279085258,
    ["MHSPEED"]     = 5.63277087,
    ["OHDPS"]       = 3.0,
    ["OHSPEED"]     = -1.999851983,
  },

}
-- ================================================================
-- RANK POR NIVEL: calibra o teto de EP baseado no level do jogador
-- Itens BiS do seu nivel atual = [SS], itens fracos = [F]
-- Conforme sobe de level, os mesmos itens vao perdendo valor
-- ================================================================
VRB_MAX_BY_LEVEL = {
    -- Cada entrada e o teto de EP para itens desse nivel de personagem
    -- Rogue Combat Swords
    ["RogueCombatSwords"] = {
        [20]=18,  [30]=35,  [40]=60,  [50]=90,  [60]=125
    },
    ["RogueCombatDaggers"] = {
        [20]=18,  [30]=36,  [40]=62,  [50]=95,  [60]=130
    },
    -- Warrior
    ["WarriorFury-EP"] = {
        [20]=25,  [30]=50,  [40]=85,  [50]=130, [60]=200
    },
    ["WarriorArms-EP"] = {
        [20]=25,  [30]=52,  [40]=88,  [50]=135, [60]=210
    },
    ["WarriorThreat-EP"] = {
        [20]=20,  [30]=40,  [40]=70,  [50]=110, [60]=160
    },
    ["WarriorMitigation-EP"] = {
        [20]=60,  [30]=120, [40]=200, [50]=300, [60]=500
    },
    -- Hunter
    ["HunterDPS-EP"] = {
        [20]=20,  [30]=40,  [40]=70,  [50]=110, [60]=190
    },
    -- Druid
    ["DruidFeralDPS-EP"] = {
        [20]=30,  [30]=60,  [40]=100, [50]=150, [60]=220
    },
    ["DruidTank-EP"] = {
        [20]=80,  [30]=150, [40]=250, [50]=400, [60]=600
    },
    ["DruidResto-EP"] = {
        [20]=20,  [30]=40,  [40]=65,  [50]=100, [60]=150
    },
    -- Priest
    ["PriestHoly"] = {
        [20]=20,  [30]=40,  [40]=65,  [50]=100, [60]=170
    },
    ["PriestShadow"] = {
        [20]=15,  [30]=30,  [40]=50,  [50]=80,  [60]=110
    },
    -- Mage
    ["MageDPS"] = {
        [20]=15,  [30]=30,  [40]=55,  [50]=85,  [60]=140
    },
    -- Warlock
    ["WarlockSMRuin"] = {
        [20]=15,  [30]=30,  [40]=55,  [50]=85,  [60]=130
    },
    ["WarlockDestruction"] = {
        [20]=15,  [30]=30,  [40]=55,  [50]=85,  [60]=130
    },
}

-- Retorna o teto de EP correto para o nivel atual do jogador
function VRBGetLevelMax(weightTable)
    local playerLevel = UnitLevel("player") or 60
    local levelData = VRB_MAX_BY_LEVEL and VRB_MAX_BY_LEVEL[weightTable]
    if not levelData then return nil end

    -- Pega o teto da faixa de nivel mais proxima (arredonda pra baixo em multiplos de 10)
    local bracket = math.floor(playerLevel / 10) * 10
    if bracket < 20 then bracket = 20 end
    if bracket > 60 then bracket = 60 end

    -- Interpola entre os dois brackets mais proximos
    local low  = levelData[bracket] or levelData[60]
    local high = levelData[bracket + 10] or low

    if bracket >= 60 then return low end

    -- Interpola linear dentro da faixa de nivel
    local progress = (playerLevel - bracket) / 10
    return math.floor(low + (high - low) * progress + 0.5)
end
