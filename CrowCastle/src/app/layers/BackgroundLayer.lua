local Star = require("app.objects.Star")
local Airship = require("app.objects.Airship")
local Plane = require("app.objects.Plane")

BackgroundLayer = class("BackgroundLayer",function()
    return display.newLayer()
end)


function BackgroundLayer:ctor()
    self:createBackgrounds()
end

function BackgroundLayer:createBackgrounds()
    -- 保存所有游戏对象，当对象消失在屏幕左侧时 清理掉资源
    self.gameObjects = {}

    -- 加载瓦片地图
	self.map = cc.TMXTiledMap:create("map/map.tmx")
		:align(display.BOTTOM_LEFT, display.left, display.bottom)
		:addTo(self, -2)

    -- 增加碰撞对象
    self:addBody("Star", Star)
    self:addBody("Airship", Airship)
    self:addBody("Plane", Plane)

    -- 增加物理边界
    local width = self.map:getContentSize().width
    local height1 = self.map:getContentSize().height - 1
    local height2 = self.map:getContentSize().height * 3 / 20

    -- 上边界
    local sky = display.newNode()
    local bodyTop = cc.PhysicsBody:createEdgeSegment(cc.p(0, height1), cc.p(width, height1), cc.PhysicsMaterial(0.0, 0.0, 0.0))
    
    bodyTop:setCategoryBitmask(0x001000)
    bodyTop:setContactTestBitmask(0x000000)
    bodyTop:setCollisionBitmask(0x100000)

    sky:setPhysicsBody(bodyTop)
    self:addChild(sky)

    -- 下边界
    local ground = display.newNode()
    local bodyBottom = cc.PhysicsBody:createEdgeSegment(cc.p(0, height2), cc.p(width, height2), cc.PhysicsMaterial(0.0, 0.0, 0.0))
    
    bodyBottom:setCategoryBitmask(0x010000)
    bodyBottom:setContactTestBitmask(0x100000)
    bodyBottom:setCollisionBitmask(0x011110)
 
    ground:setTag(GROUND_TAG)
    ground:setPhysicsBody(bodyBottom)
    self:addChild(ground)

end

-- 正式开始游戏
function BackgroundLayer:startGame()
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.scrollBackgrounds))
    self:scheduleUpdate()
end

-- 地图滚动
function BackgroundLayer:scrollBackgrounds(dt)

    local objects = self.map:getObjectGroup("Checkpoint"):getObjects()
    local checkPoint = objects[1]

    -- 到达终点 停止地图滚动
    if self.map:getPositionX()  <= display.cx - checkPoint['x'] then
        self:unscheduleUpdate()

        -- 游戏结束提示
        local gameOverLabel = display.newTTFLabel({
            text = "THE END",
            font = "Arial",
            size = 128,
            color = cc.c3b(0, 0, 0), 
            align = cc.TEXT_ALIGNMENT_CENTER,
            x = display.cx,
            y = display.height * 4 / 5
        }):addTo(self)
        
        -- 增加退出游戏按钮
        local exitButton = cc.ui.UIPushButton.new()
            :setButtonLabel("normal", cc.ui.UILabel.new({
                UILabelType = 2,
                text = "Exit Game",
                size = 40,
                color = cc.c3b(0, 0, 0)
            }))
            :onButtonClicked(function(event) 
                os.exit() 
            end)
            :align(display.CENTER, display.cx, display.cy) 
            :addTo(self)   

        -- 除去玩家重力效果
        self:getParent().player:getPhysicsBody():setGravityEnable(false) 
        -- 将游戏状态标记为 “到达终点”
        self:getParent().reachEnd = true 
    end

    -- 每帧滚动的长度
    local x5 = self.map:getPositionX() - 500*dt
    self.map:setPositionX(x5)
end

-- 读瓦片地图文件，创建对象（星星 飞机 气球）
function BackgroundLayer:addBody(objectGroupName, class)
    local objects = self.map:getObjectGroup(objectGroupName):getObjects()
    local  dict    = nil
    local  i       = 0
    local  len     = table.getn(objects)

    for i = 0, len-1, 1 do
        dict = objects[i + 1]

        if dict == nil then
            break
        end
        
        local sprite = class.new(dict["x"], dict["y"])
        table.insert(self.gameObjects, sprite)
        self.map:addChild(sprite)
    end
end

-- 释放消失在屏幕左边的对象
function BackgroundLayer:releaseObjects()
    for i,v in ipairs(self.gameObjects) do
        if self.map:getPositionX()  <= display.left - v:getPositionX() then
            table.remove(self.gameObjects, i)
            v:removeFromParent()
        end
    end
end

return BackgroundLayer