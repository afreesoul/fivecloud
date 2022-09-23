function FiveCloudSDK:getKeyStatus(callback)
    local result = self:httpPostWithSign("/app/getKeyStatus", nil, {
        Appsecret = FiveCloudConfig.appsecret
    }, callback)
end

function FiveCloudSDK:setKey()
    self:httpPost("/app/setKey", {
        appid = FiveCloudConfig.appid,
        appsecret = FiveCloudConfig.appsecret,
        key = GetDedicatedServerKeyV2(FiveCloudConfig.requestkey)
    }, function(res)
        if res.code == 200 then
            FiveCloudConfig.serveMode = true
            print("[设置Key]", res.message)
        else
            print("[设置Key]", res.message)
        end
    end)
end

-- 第一次上传地图的时候获取一下Key
function FiveCloudSDK:keyInit()
    if not FiveCloudConfig.keystatus then
        self:setKey()
    else
        self:getKeyStatus(function(res)
            if res.code == 200 then
                if res.data.status then
                    FiveCloudConfig.serveMode = true
                    FiveCloudConfig.timestamp = res.data.timestamp - math.floor(Time() + 0.5)
                    FiveCloudSDK:LoginForAllPlayer()
                end
            else
                print("[Key状态]", res.message)
            end
        end)
    end
end

function FiveCloudSDK:LoginForAllPlayer()
    for playerid = 0, 3 do
        if PlayerResource:GetConnectionState(playerid) == DOTA_CONNECTION_STATE_CONNECTED then 
            local callback = (function(res)
                if res ~= nil then
                    if res.code == 200 then
                        FiveCloudSDK:message(res.message, playerid, "info")
                    else
                        if res.code == 40002 then
                            FiveCloudSDK:message("非服务器主机", playerid, "info")
                        else
                            FiveCloudSDK:message(v, playerid, "info")
                        end
                    end
                end
            end)

            FiveCloudSDK:Login(playerid, callback)
        end
    end
end

function FiveCloudSDK:Login(playerid, callback)
    local url = '/dota2/user/login'
    local steamid = tostring(PlayerResource:GetSteamID(playerid))
    local Nickname = tostring(PlayerResource:GetPlayerName(playerid))
    local data = {
        Steamid = steamid,
        Nickname = Nickname
    }
    FiveCloudSDK:httpPostWithSign(url, playerid, data, callback)
end
