-- 配置

FiveCloudConfig = {}

FiveCloudConfig.appid = ""  -- 后台生成
FiveCloudConfig.appsecret = "" -- 后台生成
FiveCloudConfig.requestkey = "fiveCloud" -- 随意字符串
FiveCloudConfig.baseurl = "https://api.holemystery.com/fivecloud" -- 服务器地址
FiveCloudConfig.keystatus = false   -- 未接入key时填false，接入完填写true

FiveCloudConfig.timestamp = 0 -- 初始化时从服务器获取时间戳
FiveCloudConfig.serveMode = false -- 初始化时通过服务器获取服务器状态

FiveCloudConfig.heroMaxAbilityNum = 36
FiveCloudConfig.heroMaxInventoryNum = 17
