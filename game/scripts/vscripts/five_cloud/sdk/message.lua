-- 暂时都先用系统的错误提示
-- 前端需要添加
-- GameEvents.Subscribe("CustomHUDError", CustomHUDError)
-- function CustomHUDError(data) {
--     GameUI.SendCustomHUDError(data.v, "")
-- }
function FiveCloudSDK:message(content, playerid, type)
    type = type or "success"
    if type == "success" then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "CustomHUDError", {
            v = content
        })
    end
    if type == "error" then
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "CustomHUDError", {
            v = content
        })
    end
    if type == "info" then
        if playerid == nil then
            CustomGameEventManager:Send_ServerToAllClients("CustomHUDInfo", {
                v = content
            })
        else
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "CustomHUDInfo", {
                v = content
            })
        end
        

    end
end