(function () {
  FiveCloudContentInit()
})();

function FiveCloudContentInit() {
  $.Msg('[FiveCloudContent初始化]')

  // 配置
  GameUI.FiveCloudConfig = []
  GameUI.FiveCloudConfig.gameName = "shanhaijing"
  GameUI.FiveCloudConfig.mapName = "map1"
  GameUI.FiveCloudConfig.heroMaxAbilityNum = 36

  GameUI.FiveCloudPanel = []
  GameUI.FiveDialog = []
  GameUI.FiveCloudPickPanel = []
  GameUI.FiveCloudInfoPanel = []

  GameUI.CurrentAction = ""
  GameUI.MouseClickListen = false
  GameUI.MouseClickStatus = ''

  $("#fiveCloud_topMenu").BLoadLayout("file://{resources}/layout/custom_game/five_cloud/topmenu/index.xml", false, false)
  $("#fiveCloud_toolContainer").BLoadLayout("file://{resources}/layout/custom_game/five_cloud/tool/index.xml", false, false)
  $("#fiveCloud_heropick").BLoadLayout("file://{resources}/layout/custom_game/five_cloud/heropick/index.xml", false, false)
  $("#fiveCloud_unitpick").BLoadLayout("file://{resources}/layout/custom_game/five_cloud/unitpick/index.xml", false, false)
  $("#fiveCloud_entinfo").BLoadLayout("file://{resources}/layout/custom_game/five_cloud/entinfo/index.xml", false, false)
  $("#fiveCloud_entkv").BLoadLayout("file://{resources}/layout/custom_game/five_cloud/entkv/index.xml", false, false)

  GameUI.FiveCloudPanel.fiveCloud_toolContainer = $('#fiveCloud_toolContainer')
  GameUI.FiveCloudPickPanel.fiveCloud_heropick = $('#fiveCloud_heropick')
  GameUI.FiveCloudPickPanel.fiveCloud_unitpick = $('#fiveCloud_unitpick')
  GameUI.FiveCloudInfoPanel.fiveCloud_entinfo = $('#fiveCloud_entinfo')
  GameUI.FiveCloudInfoPanel.fiveCloud_entkv = $('#fiveCloud_entkv')

  GameUI.FiveDialog.SetGoldDialog = new FiveDialog({
    el: $("#fiveCloud_setGoldDialog"),
    title: '设置金钱',
    defaultValue: '0',
    content: '设置当前金钱。',
    ok: function () {
      let v = Number(GameUI.FiveDialog.SetGoldDialog.getinput())
      FiveCloudFireCustomGameEvent("fiveCloud_setGold", { v: v })
      GameUI.FiveDialog.SetGoldDialog.close()
    }
  })

  GameUI.FiveDialog.MoveToDialog = new FiveDialog({
    el: $("#fiveCloud_moveToDialog"),
    title: '移动至坐标',
    defaultValue: '0,0,128',
    content: '输入xyz坐标，以半角逗号分隔，高度可省略，目标坐标不可到达时，会移动到附近。',
    ok: function () {
      let v = GameUI.FiveDialog.MoveToDialog.getinput()
      if (v.indexOf(',') == -1) {
        GameUI.FiveDialog.MoveToDialog.setErrorInfo('输入的格式不正确')
        return false
      }
      let tempArr = v.split(',')
      var pos = {
        x: Number(tempArr[0]),
        y: Number(tempArr[1]),
        z: Number(tempArr[2])
      }
      FiveCloudFireCustomGameEvent("fiveCloud_moveTo", { pos })
      GameUI.FiveDialog.MoveToDialog.close()
    }
  })

  GameUI.FiveDialog.SetCameraDistanceDialog = new FiveDialog({
    el: $("#fiveCloud_setCameraDistanceDialog"),
    title: '调整视角高度',
    defaultValue: '1200',
    content: '调太高会卡，量力而行，建议不要超过2000。',
    ok: function () {
      let v = Number(GameUI.FiveDialog.SetCameraDistanceDialog.getinput())
      GameUI.SetCameraDistance(v)
      FiveCloudFireCustomGameEvent("fiveCloud_setCameraDistanceDialog", { v: v })
      GameUI.FiveDialog.SetCameraDistanceDialog.close()
    }
  })
  
  GameUI.FiveDialog.HostTimescaleDialog = new FiveDialog({
    el: $("#fiveCloud_hostTimescaleDialog"),
    title: '设置游戏速度',
    defaultValue: 1,
    content: '建议范围0~8，支持小数。',
    ok: function () {
      let v = GameUI.FiveDialog.HostTimescaleDialog.getinput()
      FiveCloudFireCustomGameEvent('fiveCloud_sendToServerConsole', { command: 'host_timescale ' + v })
      GameUI.FiveDialog.HostTimescaleDialog.close()
    }
  })

  GameUI.FiveDialog.ShowRangeDialog = new FiveDialog({
    el: $("#fiveCloud_showRangeDialog"),
    title: '显示作用范围',
    defaultValue: 0,
    content: '设置为0取消',
    ok: function () {
      let v = GameUI.FiveDialog.ShowRangeDialog.getinput()
      FiveCloudFireCustomGameEvent('fiveCloud_sendToServerConsole', { command: 'dota_range_display ' + v })
      GameUI.FiveDialog.ShowRangeDialog.close()
    }
  })
}

// 鼠标响应
GameUI.SetMouseCallback(function (eventName, arg) {
  if (GameUI.MouseClickListen) {
    switch (GameUI.MouseClickStatus) {
      case 'MoveToPoint':
        if (eventName == "pressed") {
          // Left-click is move to position
          if (arg === 0 && GameUI.GetClickBehaviors() === 0) {
            var coordinates = GameUI.GetScreenWorldPosition(GameUI.GetCursorPosition());
            if (coordinates != null) {
              var pos = {
                x: coordinates[0],
                y: coordinates[1],
                z: coordinates[2]
              }

              FiveCloudFireCustomGameEvent("fiveCloud_moveTo", { pos });
              GameUI.MouseClickListen = false
            }
          }
          // 右键
          if (arg === 1 && GameUI.GetClickBehaviors() === 0) {
            GameUI.MouseClickListen = false
          }
        }
        break
      default:
        if (eventName == "pressed") {
          // Left-click is move to position
          if (arg === 0 && GameUI.GetClickBehaviors() === 0) {
            FiveCloudHideAllPanel('FiveCloudPickPanel')
            GameUI.MouseClickListen = false
          }
          // 右键
          if (arg === 1 && GameUI.GetClickBehaviors() === 0) {

          }
        }
        break
    }
  }

  return false;
})