print("[FiveCloudGame初始化]")

-- 报错追踪
if not GameRules:IsCheatMode() then
    if __debug_trace_back_original__ == nil then
        __debug_trace_back_original__ = debug.traceback
    end
    debug.traceback = function(thread, message, level)
        local trace
        if thread == nil and message == nil and level == nil then
            trace = __debug_trace_back_original__()
        else
            trace = __debug_trace_back_original__(thread, message, level)
        end
        if thread ~= nil then
            local e = tostring(thread)
            print('[错误]')

            FiveCloudSDK:httpPostWithSign("/dota2/log/edit", nil, {
                Content = e
            }, function(res)
                DeepPrintTable(res)
            end)
        end

        return trace
    end
end
