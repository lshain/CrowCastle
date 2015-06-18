
require("config")
require("cocos.init")
require("framework.init")
require("app.layers.BackgroundLayer")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    
    -- 屏幕适配
    cc.Director:getInstance():setContentScaleFactor(640 / CONFIG_SCREEN_HEIGHT)
    
    -- 预加载图片资源
    display.addSpriteFrames("game.plist", "game.png")
    
    self:enterScene("LogoScene")
end

return MyApp
