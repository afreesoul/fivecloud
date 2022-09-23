// 发送自定义事件
function FiveCloudFireCustomGameEvent(eventName, data) {
    let playerId = Players.GetLocalPlayer()
    let selectedUnits = Players.GetSelectedEntities(playerId)
    data.playerId = playerId
    data.selectedUnits = selectedUnits
    GameEvents.SendCustomGameEventToServer(eventName, data)
}

// 发送自定义ToggleButton事件,eventName需要事件名称和按钮的ID一致
function FiveCloudFireToggleEvent(eventName) {
    let data = {
        checked: $('#' + eventName).checked
    }
    FiveCloudFireCustomGameEvent(eventName, data);
}

// 显示Dota的tooltip
function FiveCloudShowDOTATooltip(panel, text) {
    $.DispatchEvent("DOTAShowTextTooltip", panel, text)
}

// 隐藏Dota的tooltip
function FiveCloudHideDOTATooltip() {
    $.DispatchEvent("DOTAHideTextTooltip")
    $.DispatchEvent("DOTAHideTitleTextTooltip")
}

// 关闭某个类型的窗口
function FiveCloudHideAllPanel(t) {
    for (let key in GameUI[t]) {
        GameUI[t][key].AddClass('minimized')
    }
}

// 开启某个窗口
function FiveCloudOpenPanel(t,v) {
    for (let key in GameUI[t]) {
        if (key == v){
            GameUI[t][key].RemoveClass('minimized')
        } else {
            GameUI[t][key].AddClass('minimized')
        }
    }
}

// 关闭某个窗口
function FiveCloudHidePanel(t,v) {
    GameUI[t][v].AddClass('minimized')
}