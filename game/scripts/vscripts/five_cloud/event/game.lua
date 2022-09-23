-- 游戏状态事件
if FiveCloudGameEvents == nil then
    FiveCloudGameEvents = class({})
end

-- 监听游戏状态改变

function FiveCloudGameEvents:OnGameRulesStateChange()
    local game_state = GameRules:State_Get()

    --------------------- 设置队伍阶段 ---------------------
    if game_state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        print("[游戏状态]: 设置队伍阶段")
        FiveCloudSDK:keyInit()
    end
end
