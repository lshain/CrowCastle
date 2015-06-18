
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local Player = require("app.objects.Player")

local GameScene = class("GameScene", function()
    return display.newPhysicsScene("GameScene")
end)

function GameScene:ctor()
    -- 记录是否到达游戏终点
    self.reachEnd = false

    -- 创建物理世界
    self.world = self:getPhysicsWorld()
    self.world:setGravity(cc.p(0, -98))
    --self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)

    -- 添加背景
    self.backgroundLayer = BackgroundLayer.new()
        :addTo(self)

    -- 添加玩家乌鸦
    self.player = Player.new()
        :pos(display.cx - 170, display.top - 220)
        :addTo(self)
    self.player:flying()

    -- 玩家乌鸦飞翔到屏幕中央后，正式开始游戏
    self:playerFlyToScene()

    -- 每 10 秒执行一次清理
    local function onInterval(dt)
        self.backgroundLayer:releaseObjects()
    end
    local handle = scheduler.scheduleGlobal(onInterval, 10)


end

-- 玩家乌鸦飞到屏幕中央
function GameScene:playerFlyToScene()

    local function startGame()
        self.player:createProgress()
        self.player:getPhysicsBody():setGravityEnable(true)  
        self.backgroundLayer:startGame()

        self:addCollision()
        self.backgroundLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            return self:onTouch(event.name, event.x, event.y)
        end)
        self.backgroundLayer:setTouchEnabled(true)
    end

    local sequence = transition.sequence({
        cc.MoveTo:create(2, cc.p(display.cx, display.height * 3 / 4)),
        cc.CallFunc:create(startGame)
    })
    self.player:runAction(sequence)
end

-- 触摸
function GameScene:onTouch(event, x, y)
    if event == "began" then
        if self.player.blood > 0  then
            if self.reachEnd then
                --do nothing
            else
                self.player:getPhysicsBody():setVelocity(cc.p(0, 98))
            end
        end
        return true
    end
end

-- 增加碰撞
function GameScene:addCollision()

    -- 判断碰撞的对象是 星星、飞机、气球、或地面 做出相应的处理
    local function contactLogic(node)
        -- 碰撞类型：星星
        if node:getTag() == STAR_TAG then
            if self.player.blood > 0 and self.player.blood < 100 then

                self.player.blood = self.player.blood + 5
                self.player:setProPercentage(self.player.blood)
            end

            -- 释放星星对象
            for i,v in ipairs(self.backgroundLayer.gameObjects) do
                if v == node then
                    table.remove(self.backgroundLayer.gameObjects, i)
                end
            end
            node:removeFromParent()
        -- 碰撞类型：地面
        elseif node:getTag() == GROUND_TAG then
            if self.reachEnd then
                -- do nothing
            else
                self.player.blood = self.player.blood - 50
                self.player:setProPercentage(self.player.blood)

                -- 玩家死亡掉到地上，不再反弹
                if self.player.blood <= 0 then
                    self.player:getPhysicsBody():setGravityEnable(false)  
                end
            end
        -- 碰撞类型：飞机
        elseif node:getTag() == PLANE_TAG then
            self.player.blood = self.player.blood - 40
            self.player:setProPercentage(self.player.blood)
        -- 碰撞类型：气球
        elseif node:getTag() == AIRSHIP_TAG then
            self.player.blood = self.player.blood - 30
            self.player:setProPercentage(self.player.blood)
        end

        -- 判断玩家是否死亡
        if self.player.blood <= 0 then 
            -- 停止地图滚动
            self.backgroundLayer:unscheduleUpdate()
            -- 停止飞翔动画
            transition.stopTarget(self.player)
            -- 停止所有事件
            --cc.Director:getInstance():getEventDispatcher():removeAllEventListeners()

            -- 游戏结束提示
            local gameOverLabel = display.newTTFLabel({
                text = "GAME OVER",
                font = "Arial",
                size = 128,
                color = cc.c3b(0, 0, 0), 
                align = cc.TEXT_ALIGNMENT_CENTER,
                x = display.cx,
                y = display.height * 4 / 5
            }):addTo(self)
            -- 退出游戏按钮
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
        end
    end

    -- 碰撞开始
    local function onContactBegin(contact)
        local a = contact:getShapeA():getBody():getNode()
        local b = contact:getShapeB():getBody():getNode()

        contactLogic(a)
        contactLogic(b)

        return true
    end

    -- 碰撞分离
    local function onContactSeperate(contact)
        -- 碰撞结束，玩家飞回到屏幕中心点
        local moveAct = cc.MoveTo:create(1, cc.p(display.cx, self.player:getPositionY() ))
        self.player:runAction(moveAct)
    end

    -- 碰撞事件监听
    local contactListener = cc.EventListenerPhysicsContact:create()
    contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    contactListener:registerScriptHandler(onContactSeperate, cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(contactListener, 1)
end

return GameScene
