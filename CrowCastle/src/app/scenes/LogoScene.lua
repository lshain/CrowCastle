
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local LogoScene = class("LogoScene", function()
    return display.newScene("LogoScene")
end)

function LogoScene:ctor()
	-- 显示游戏名称 =============================================================================
    cc.ui.UILabel.new({
            UILabelType = 2, text = "CROW CASTLE", size = 72})
        :align(display.CENTER, display.cx, display.cy * 1.5)
        :addTo(self)

    -- 显示版权信息 =============================================================================
    cc.ui.UILabel.new({
            UILabelType = 2, text = "Copyright (C) MWN", size = 48})
        :align(display.CENTER, display.cx, display.cy * 0.5)
        :addTo(self)

    -- 2 秒后自动跳转到菜单场景 =================================================================
  	scheduler.performWithDelayGlobal(function (dt)
        app:enterScene("MainScene", nil, nil, nil)
  	end, 2)
end

function LogoScene:onEnter()
end

function LogoScene:onExit()
end

return LogoScene
