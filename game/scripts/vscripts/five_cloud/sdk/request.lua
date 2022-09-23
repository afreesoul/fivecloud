local md5 = require("five_cloud.utils.md5")

-- 有时候超时httpcode会获取到0，自动重发，最多3次
function FiveCloudSDK:request(methon, url, data, callback, retry)
    retry = retry or 0
    if string.sub(url, 1, 4) ~= "http" then
        url = FiveCloudConfig.baseurl .. url
    end
    print("[发送请求]", url)
    local req = CreateHTTPRequestScriptVM(methon, url)
    req:SetHTTPRequestHeaderValue('Content-Type', 'application/json;charset=uft-8')
    if methon == "POST" then
        req:SetHTTPRequestRawPostBody('application/json;charset=utf-8', json.encode(data))
    end
    req:SetHTTPRequestAbsoluteTimeoutMS(3000)
    req:Send(function(res)
        DeepPrintTable(res)
        if res.StatusCode == 0 and retry < 3 then
            GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("GetHeroInfo"), function()
                return self:request(methon, url, data, callback, retry + 1)
            end, 1)
        end
        if res.StatusCode == 200 then
            local data = json.decode(res.Body)
            if callback ~= nil then
                callback(data)
            end
        end
    end)
end

function FiveCloudSDK:httpGet(url, callback)
    self:request("GET", url, nil, callback)
end

function FiveCloudSDK:httpPost(url, data, callback)
    self:request("POST", url, data, callback)
end

-- 会自动上传dotaid
function FiveCloudSDK:httpPostWithSign(url, playerid, data, callback)
    local MakeData = self:makeData(playerid, data)
    local MakeSign = self:makeSign(MakeData)
    self:request("POST", url, MakeSign, callback)
end

function FiveCloudSDK:makeData(playerid, data)
    local timestamp = FiveCloudConfig.timestamp + math.floor(Time() + 0.5)
    local params = {
        Appid = FiveCloudConfig.appid,
        Noncestr = self:randomStr(16),
        Timestamp = timestamp
    }
    if playerid ~= nil then
        params["Dotaid"] = PlayerResource:GetSteamAccountID(playerid)
    else
        params["Dotaid"] = 0
    end

    for k, v in pairs(data) do
        params[k] = v
    end

    return params
end

function FiveCloudSDK:makeSign(data)
    local str = ""
    local keys = {}
    local signature = ""

    for k in pairs(data) do
        table.insert(keys, k)
    end

    table.sort(keys)

    for _, k in pairs(keys) do
        local v = data[k]
        if str == "" then
            str = str .. k .. "=" .. tostring(v)
        else
            str = str .. "&" .. k .. "=" .. tostring(v)
        end
    end

    --signature = md5.sumhexa(str .. "&key=" .. GetDedicatedServerKeyV2(FiveCloudConfig.requestkey))

    signature = md5.sumhexa(str .. "&key=" .. "test")

    data["signature"] = signature

    return data
end

