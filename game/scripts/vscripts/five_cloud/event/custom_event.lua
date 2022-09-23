-- 自定义事件
if FiveCloudCustomEvent == nil then
    FiveCloudCustomEvent = class({})
end

function FiveCloudCustomEvent:init()
    FiveCloudCustomEvent.HeroSituRespawnMode = false
    FiveCloudCustomEvent.heroListKV = LoadKeyValues('scripts/npc/npc_heroes.txt')
    FiveCloudCustomEvent.unitListKV = LoadKeyValues('scripts/npc/npc_units.txt')
    FiveCloudCustomEvent.abilityListKV = LoadKeyValues('scripts/npc/npc_abilities.txt')
    FiveCloudCustomEvent.heroListByName = {}
    FiveCloudCustomEvent.unitListByName = {}
end

--------------------------------------------------------------------------------
-- 英雄部分
--------------------------------------------------------------------------------

-- 重置所有选中的英雄单位
function FiveCloudCustomEvent:ResetHero(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if ent:IsHero() and ent:IsAlive() and not ent:IsClone() then
            FiveCloudCustomEvent:DoResetHero(ent)
        end
    end
end

-- 重置英雄技能
function FiveCloudCustomEvent:DoResetHero(hero)
    for i = 0, FiveCloudConfig.heroMaxAbilityNum do
        local ability = hero:GetAbilityByIndex(i)
        if ability ~= nil and ability:GetLevel() > 0 and not ability:IsHidden() then
            ability:SetLevel(0)
            if ability:GetName() == "earth_spirit_stone_caller" or ability:GetName() == "treant_natures_guise" or
                ability:GetName() == "techies_minefield_sign" or ability:GetName() == "monkey_king_mischief" then
                ability:SetLevel(1)
            end
        end
    end

    local modifiers = hero:FindAllModifiers()

    for i = 1, #modifiers do
        modifiers[i]:Destroy()
    end

    hero:SetAbilityPoints(1)

    PlayerResource:ReplaceHeroWith(hero:GetPlayerID(), PlayerResource:GetSelectedHeroName(hero:GetPlayerID()),
        PlayerResource:GetGold(hero:GetPlayerID()), 0)
end

-- 升一级
function FiveCloudCustomEvent:LevelUp(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if ent ~= nil and ent:IsHero() then
            ent:HeroLevelUp(true)
        end
    end
end

-- 升到满级
function FiveCloudCustomEvent:MaxLevel(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if ent ~= nil then
            HeroMaxLevel(ent)
        end
    end
end

-- 设置金钱
function FiveCloudCustomEvent:SetGold(e)
    PlayerResource:SetGold(e.playerId, e.v, false)
    PlayerResource:SetGold(e.playerId, 0, true)
end

-- 清空物品
function FiveCloudCustomEvent:ClearInventory(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if ent ~= nil then
            for i = 0, FiveCloudConfig.heroMaxInventoryNum - 1 do
                local item = ent:GetItemInSlot(i)
                if item ~= nil then
                    ent:RemoveItem(item)
                end
            end
        end
    end
end

-- 复活英雄
function FiveCloudCustomEvent:RespawnHero(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if ent:IsHero() and not ent:IsClone() then
            if ent:IsAlive() then
                FiveCloudSDK:message("不能复活未死亡的英雄", e.playerId, "error")
            else
                ent:RespawnHero(false, false)
            end
        else
            FiveCloudSDK:message("只能复活英雄单位", e.playerId, "error")
        end
    end
end

-- 添加英雄
function FiveCloudCustomEvent:AddHero(e)
    local player = PlayerResource:GetPlayer(e.playerId)
    local heroName = "npc_dota_hero_" .. DOTAGameManager:GetHeroNameByID(e.heroId)
    local team = PlayerResource:GetTeam(e.playerId)
    local hero = PlayerResource:GetPlayer(e.playerId):GetAssignedHero()
    local teamid = team

    if e.isFriend == 0 then
        if team == DOTA_TEAM_GOODGUYS then
            teamid = DOTA_TEAM_BADGUYS
        end
        if team == DOTA_TEAM_BADGUYS then
            teamid = DOTA_TEAM_GOODGUYS
        end
    end

    DebugCreateUnit(player, heroName, teamid, false, function(unit)
        unit:SetControllableByPlayer(e.playerId, false)
    end)
end

-- 更换英雄
function FiveCloudCustomEvent:ReplaceHero(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if ent:IsHero() and not ent:IsClone() then
            local hero = PlayerResource:ReplaceHeroWith(ent:GetPlayerID(),
                "npc_dota_hero_" .. DOTAGameManager:GetHeroNameByID(e.heroId), PlayerResource:GetGold(e.playerId), 0)
        end
    end
end

-- 获取技能点
function FiveCloudCustomEvent:GetAbilityPoint(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if ent ~= nil and ent:IsHero() then
            local points = ent:GetAbilityPoints()
            ent:SetAbilityPoints(points + 1)
        end
    end
end

-- 移除技能点
function FiveCloudCustomEvent:RemoveAbilityPoint(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if ent ~= nil and ent:IsHero() then
            local points = ent:GetAbilityPoints()
            if points > 0 then
                ent:SetAbilityPoints(points - 1)
            else
                FiveCloudSDK:message("技能点不足", e.playerId, "error")
            end
        end
    end
end

-- 获取详细数据开启
function FiveCloudCustomEvent:GetHeroInfoStart(e)
    GameRules:GetGameModeEntity():SetContextThink("GetHeroInfo", function()
        return FiveCloudCustomEvent:GetHeroInfo(e, 0)
    end, 0)
    if e.first == 1 then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(e.playerId), "fiveCloud_updateServerStatus",
            {
                name = "fiveCloud_entInfo",
                data = true
            })
    end
end

-- 获取详细数据关闭
function FiveCloudCustomEvent:GetHeroInfoEnd(e)
    GameRules:GetGameModeEntity():SetContextThink("GetHeroInfo", function()
        return FiveCloudCustomEvent:GetHeroInfo(e, nil)
    end, 0)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(e.playerId), "fiveCloud_updateServerStatus", {
        name = "fiveCloud_entInfo",
        data = false
    })
end

-- 获取详细数据
function FiveCloudCustomEvent:GetHeroInfo(e, i)
    if e.ent ~= nil then
        local ent = EntIndexToHScript(e.ent)
        if ent ~= nil then
            local heroInfo = {}
            local GetAttackAnimationPoint = ent:GetAttackAnimationPoint()
            local GetCastPoint = ent:GetCastPoint(true)
            local GetProjectileSpeed = ent:GetProjectileSpeed()
            local GetCooldownReduction = ent:GetCooldownReduction()
            local GetIdealSpeed = ent:GetIdealSpeed()
            local GetAbsOrigin = ent:GetAbsOrigin()
            local GetAverageTrueAttackDamage = ent:GetAverageTrueAttackDamage(nil)
            local GetBaseDamageMin = ent:GetBaseDamageMin()
            local GetBaseDamageMax = ent:GetBaseDamageMax()
            local GetPhysicalArmorValue = ent:GetPhysicalArmorValue(false)
            local GetMagicalArmorValue = ent:GetMagicalArmorValue()

            heroInfo.GetAttackAnimationPoint = GetAttackAnimationPoint
            heroInfo.GetCastPoint = GetCastPoint
            heroInfo.GetProjectileSpeed = GetProjectileSpeed
            heroInfo.GetCooldownReduction = GetCooldownReduction
            heroInfo.GetIdealSpeed = GetIdealSpeed
            heroInfo.GetAbsOrigin = GetAbsOrigin
            heroInfo.GetAverageTrueAttackDamage = GetAverageTrueAttackDamage
            heroInfo.GetBaseDamageMin = GetBaseDamageMin
            heroInfo.GetBaseDamageMax = GetBaseDamageMax
            heroInfo.GetPhysicalArmorValue = GetPhysicalArmorValue
            heroInfo.GetMagicalArmorValue = GetMagicalArmorValue

            CustomNetTables:SetTableValue("fiveCloud_heroInfo", "entText", heroInfo)
        end
    end
    return i
end

function FiveCloudCustomEvent:GetHeroKVByHeroName(e)
    FiveCloudCustomEvent.heroListByName = {}
    for k, v in pairs(FiveCloudCustomEvent.heroListKV) do
        if type(v) == "table" then
            if k == e.unitName then
                for k1, v1 in pairs(v) do
                    FiveCloudCustomEvent.heroListByName[k1] = v1
                end
            end
        end
    end
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(e.playerId), "fiveCloud_toHeroKVByName", {
        data = FiveCloudCustomEvent.heroListByName,
        first = e.first
    })
end

function FiveCloudCustomEvent:GetUnitKVByUnitName(e)
    FiveCloudCustomEvent.unitListByName = {}
    for k, v in pairs(FiveCloudCustomEvent.unitListKV) do
        if type(v) == "table" then
            if k == e.unitName then
                for k1, v1 in pairs(v) do
                    FiveCloudCustomEvent.unitListByName[k1] = v1
                end
            end
        end
    end

    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(e.playerId), "fiveCloud_toHeroKVByName", {
        data = FiveCloudCustomEvent.unitListByName,
        first = e.first
    })
end

function FiveCloudCustomEvent:GetAblityKVByAblityName(e)
    local AblityKVByAblityName = {}
    for k, v in pairs(FiveCloudCustomEvent.abilityListKV) do
        if type(v) == "table" then
            if k == e.abilityName then
                for k1, v1 in pairs(v) do
                    AblityKVByAblityName[k1] = v1
                end
            end
        end
    end

    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(e.playerId), "fiveCloud_toAbilityKVByName", {
        abilityName = e.abilityName,
        data = AblityKVByAblityName,
        first = e.first
    })
end

-- 刷新英雄
function FiveCloudCustomEvent:RefreshHero(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if not ent:IsNull() then
            FiveCloudCustomEvent:RefreshUnit(ent)
            if ent:GetClassname() == "npc_dota_hero_meepo" and not ent:IsClone() then
                for k, clone in pairs(Entities:FindAllByClassname("npc_dota_hero_meepo")) do
                    if clone:IsClone() and clone:GetCloneSource() == ent then
                        FiveCloudCustomEvent:RefreshUnit(clone)
                    end
                end
            end
        end
    end
end

-- 刷新单位状态
function FiveCloudCustomEvent:RefreshUnit(hUnit)
    if hUnit:IsAlive() then
        hUnit:SetHealth(hUnit:GetMaxHealth())
        hUnit:SetMana(hUnit:GetMaxMana())
        FiveCloudCustomEvent:RefreshUnitCooldowns(hUnit)
    end
end

-- 刷新技能冷却
function FiveCloudCustomEvent:RefreshUnitCooldowns(hUnit)
    for i = 0, 20 do
        local item = hUnit:GetItemInSlot(i)
        if item ~= nil then

            item:EndCooldown()
        end
    end
    for i = 0, 31 do
        local hAbility = hUnit:GetAbilityByIndex(i)
        -- if hAbility and hAbility:GetLevel() > 0 and not hAbility:IsHidden() then
        if hAbility and hAbility:GetLevel() > 0 then
            hAbility:EndCooldown()
            hAbility:RefreshCharges()
        end
    end
end

-- 添加傀儡
function FiveCloudCustomEvent:AddDummyTarget(e)
    local hero = PlayerResource:GetPlayer(e.playerId):GetAssignedHero()
    local Dummy =
        CreateUnitByName("npc_dota_hero_target_dummy", hero:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)

    Dummy:SetControllableByPlayer(e.playerId, false)
end

-- 创建单位
function FiveCloudCustomEvent:CreateUnit(e)
    local player = PlayerResource:GetPlayer(e.playerId)
    local unit = e.unit
    local team = PlayerResource:GetTeam(e.playerId)
    local hero = PlayerResource:GetPlayer(e.playerId):GetAssignedHero()
    local teamid = team

    if e.isFriend == 0 then
        if team == DOTA_TEAM_GOODGUYS then
            teamid = DOTA_TEAM_BADGUYS
        end
        if team == DOTA_TEAM_BADGUYS then
            teamid = DOTA_TEAM_GOODGUYS
        end
    end

    local unit = CreateUnitByName(unit, hero:GetAbsOrigin(), true, nil, nil, teamid)

    unit:SetControllableByPlayer(e.playerId, false)
end

-- 自残
function FiveCloudCustomEvent:SelfMutilation(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if ent ~= nil then
            ent:SetHealth(1)
        end
    end
end

-- 移动至指定位置
function FiveCloudCustomEvent:MoveTo(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        local point = GetGroundPosition(Vector(e.pos.x, e.pos.y, e.pos.z), nil)
        FindClearSpaceForUnit(ent, point, false)
    end
end

-- 删除单位
function FiveCloudCustomEvent:RemoveUnit(e)
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if (ent ~= nil and ent:IsNull() == false and ent ~= PlayerResource:GetSelectedHeroEntity(0)) then
            if ent:IsHero() and not ent:IsClone() and ent:GetPlayerOwner() ~= nil and ent:GetPlayerOwnerID() ~= 0 then
                DisconnectClient(ent:GetPlayerID(), true)
            else
                ent:RemoveSelf()
            end
        else
            FiveCloudSDK:message("不能把自己给删了！", e.playerId, "error")
        end
    end
end

-- 无敌
function FiveCloudCustomEvent:Invulnerability(e)
    local hero = PlayerResource:GetPlayer(e.playerId):GetAssignedHero()
    for key, entIndex in pairs(e.selectedUnits) do
        local ent = EntIndexToHScript(entIndex)
        if ent ~= nil then
            if e.checked == 1 then
                ent:AddNewModifier(hero, nil, "lm_take_no_damage", nil)
            else
                ent:RemoveModifierByName("lm_take_no_damage")
            end
        end
    end
end

-- 双倍神符
function FiveCloudCustomEvent:SpawnRuneDoubleDamagePressed(e)
    local hero = PlayerResource:GetPlayer(e.playerId):GetAssignedHero()
    FiveCloudCustomEvent:SpawnRuneInFrontOfUnit(hero, DOTA_RUNE_DOUBLEDAMAGE)
end

-- 加速神符
function FiveCloudCustomEvent:SpawnRuneHastePressed(e)
    local hero = PlayerResource:GetPlayer(e.playerId):GetAssignedHero()
    FiveCloudCustomEvent:SpawnRuneInFrontOfUnit(hero, DOTA_RUNE_HASTE)
end

-- 幻象神符
function FiveCloudCustomEvent:SpawnRuneIllusionPressed(e)
    local hero = PlayerResource:GetPlayer(e.playerId):GetAssignedHero()
    FiveCloudCustomEvent:SpawnRuneInFrontOfUnit(hero, DOTA_RUNE_ILLUSION)
end

-- 隐身神符
function FiveCloudCustomEvent:SpawnRuneInvisibilityPressed(e)
    local hero = PlayerResource:GetPlayer(e.playerId):GetAssignedHero()
    FiveCloudCustomEvent:SpawnRuneInFrontOfUnit(hero, DOTA_RUNE_INVISIBILITY)
end

-- 恢复神符
function FiveCloudCustomEvent:SpawnRuneRegenerationPressed(e)
    local hero = PlayerResource:GetPlayer(e.playerId):GetAssignedHero()
    FiveCloudCustomEvent:SpawnRuneInFrontOfUnit(hero, DOTA_RUNE_REGENERATION)
end

-- 奥术神符
function FiveCloudCustomEvent:SpawnRuneArcanePressed(e)
    local hero = PlayerResource:GetPlayer(e.playerId):GetAssignedHero()
    FiveCloudCustomEvent:SpawnRuneInFrontOfUnit(hero, DOTA_RUNE_ARCANE)
end

-- 刷神符
function FiveCloudCustomEvent:SpawnRuneInFrontOfUnit(hUnit, runeType)
    if hUnit == nil then
        return
    end
    local fDistance = 200.0
    local fMinSeparation = 50.0
    local fRingOffset = fMinSeparation + 20.0
    local vDir = hUnit:GetForwardVector()
    local vInitialTarget = hUnit:GetAbsOrigin() + vDir * fDistance
    vInitialTarget.z = GetGroundHeight(vInitialTarget, nil)
    local vTarget = vInitialTarget
    local nRemainingAttempts = 100
    local fAngle = 2 * math.pi
    local fOffset = 0.0
    local bDone = false

    local vecRunes = Entities:FindAllByClassname("dota_item_rune")
    while (not bDone and nRemainingAttempts > 0) do
        bDone = true
        -- Too close to other runes?
        for i = 1, #vecRunes do
            if (vecRunes[i]:GetAbsOrigin() - vTarget):Length() < fMinSeparation then
                bDone = false
                break
            end
        end
        if not GridNav:CanFindPath(hUnit:GetAbsOrigin(), vTarget) then
            bDone = false
        end
        if not bDone then
            fAngle = fAngle + 2 * math.pi / 8
            if fAngle >= 2 * math.pi then
                fOffset = fOffset + fRingOffset
                fAngle = 0
            end
            vTarget = vInitialTarget + fOffset * Vector(math.cos(fAngle), math.sin(fAngle), 0.0)
            vTarget.z = GetGroundHeight(vTarget, nil)
        end
        nRemainingAttempts = nRemainingAttempts - 1
    end

    CreateRune(vTarget, runeType)
end

-- 设置摄像头位置
function FiveCloudCustomEvent:SetCameraDistanceDialog(e)
    local mode = GameRules:GetGameModeEntity()
    mode:SetCameraZRange(-1, e.v * 4)
end

-- 昼夜变换
function FiveCloudCustomEvent:DayNightCycle(e)
    if GameRules:IsDaytime() then
        GameRules:SetTimeOfDay(0.751)
    else
        GameRules:SetTimeOfDay(0.251)
    end
end

-- 暂停昼夜变换
function FiveCloudCustomEvent:PauseDayNightCycle(e)
    local mode = GameRules:GetGameModeEntity()
    if e.checked == 1 then
        mode:SetDaynightCycleDisabled(true)
    else
        mode:SetDaynightCycleDisabled(false)
    end
    CustomGameEventManager:Send_ServerToAllClients("fiveCloud_updateServerStatus", {
        name = "fiveCloud_pauseDayNightCycle",
        data = e.checked
    })
end

-- 简易购买模式
function FiveCloudCustomEvent:easyBuy(e)
    if GameRules:IsCheatMode() then
        SendToServerConsole("dota_easybuy " .. e.checked)
        CustomGameEventManager:Send_ServerToAllClients("fiveCloud_updateServerStatus", {
            name = "fiveCloud_easyBuy",
            data = e.checked
        })
    else
        FiveCloudSDK:message("未开启作弊模式，简易购买模式无法使用", e.playerId, "error")
    end
end

-- 无限技能
function FiveCloudCustomEvent:FreeSpells(e)
    if GameRules:IsCheatMode() then
        if e.checked == 1 then
            SendToServerConsole("dota_ability_debug 1")
            FiveCloudCustomEvent:RefreshHero(e)
        else
            SendToServerConsole("dota_ability_debug 0")
        end
        CustomGameEventManager:Send_ServerToAllClients("fiveCloud_updateServerStatus", {
            name = "fiveCloud_freeSpells",
            data = e.checked
        })
    else
        FiveCloudSDK:message("未开启作弊模式，该功能无法使用", e.playerId, "error")
    end
end

-- 快速复活
function FiveCloudCustomEvent:heroFastRespawn(e)
    local mode = GameRules:GetGameModeEntity()
    if e.checked == 1 then
        mode:SetFixedRespawnTime(3)
    else
        mode:SetFixedRespawnTime(-1)
    end
    CustomGameEventManager:Send_ServerToAllClients("fiveCloud_updateServerStatus", {
        name = "fiveCloud_heroFastRespawn",
        data = e.checked
    })
end

-- 原地复活
function FiveCloudCustomEvent:heroSituRespawn(e)
    if e.checked == 1 then
        FiveCloudCustomEvent.HeroSituRespawnMode = true
    else
        FiveCloudCustomEvent.HeroSituRespawnMode = false
    end
    CustomGameEventManager:Send_ServerToAllClients("fiveCloud_updateServerStatus", {
        name = "fiveCloud_heroSituRespawn",
        data = e.checked
    })
end

-- 禁用每秒获得金钱
function FiveCloudCustomEvent:PassiveGold(e)
    local mode = GameRules:GetGameModeEntity()
    if e.checked == 1 then
        GameRules:SetGoldPerTick(0)
    else
        GameRules:SetGoldPerTick(1)
    end
    CustomGameEventManager:Send_ServerToAllClients("fiveCloud_updateServerStatus", {
        name = "fiveCloud_passiveGold",
        data = e.checked
    })
end

-- 战争迷雾
function FiveCloudCustomEvent:NoFogOfWar(e)
    local mode = GameRules:GetGameModeEntity()
    if e.checked == 1 then
        mode:SetFogOfWarDisabled(true)
    else
        mode:SetFogOfWarDisabled(false)
    end
    CustomGameEventManager:Send_ServerToAllClients("fiveCloud_updateServerStatus", {
        name = "fiveCloud_noFogOfWar",
        data = e.checked
    })
end

-- 在控制台打印特效名
function FiveCloudCustomEvent:ParticleLogCreates(e)
    if e.checked == 1 then
        SendToServerConsole("cl_particle_log_creates 1")
    else
        SendToServerConsole("cl_particle_log_creates 0")
    end
end


-- 反馈
function FiveCloudCustomEvent:feedback(e)

    local url = '/dota2/feedback/edit'
    local playerid = e.playerId
    local data = {
        Content = e.feedbackcontent
    }
    local callback = (function(res)
        if res ~= nil then
            local v = res.message
            if res.code == 200 then
                FiveCloudSDK:message(v, e.playerId, "info")
            else
                if res.code == 40002 then
                    FiveCloudSDK:message("非服务器主机", e.playerId, "info")
                else
                    FiveCloudSDK:message(v, e.playerId, "info")
                end
            end
        end
    end)
    FiveCloudSDK:httpPostWithSign(url, playerid, data, callback)
end

-- 发送控制台命令
function FiveCloudCustomEvent:SendToServerConsole(e)
    if GameRules:IsCheatMode() then
        SendToServerConsole(e.command)
    else
        FiveCloudSDK:message("未开启作弊模式，该功能无法使用", e.playerId, "error")
    end
end


FiveCloudCustomEvent:init()
