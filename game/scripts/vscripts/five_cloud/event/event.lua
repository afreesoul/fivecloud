-- 监听游戏事件
if FiveCloudEvent == nil then
    FiveCloudEvent = class({})
end

-- 监听单位生成
function FiveCloudEvent:OnNPCSpawned(event)
    -- print('FiveCloudEvent:OnNPCSpawned')
end

-- 生成英雄
function FiveCloudEvent:OnHeroInGame(hero)
    -- print("FiveCloudEvent:OnHeroInGame")
end

-- 监听单位死亡
function FiveCloudEvent:OnEntityKilled(event)
    local killed = EntIndexToHScript(event.entindex_killed) -- 被杀
    local attacker = EntIndexToHScript(event.entindex_attacker) -- 凶手

    if killed:IsHero() and not killed:IsClone() then
        if FiveCloudCustomEvent.HeroSituRespawnMode then
            killed:SetRespawnPosition(killed:GetAbsOrigin())
        end
    end
end
