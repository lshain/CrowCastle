
local Player = class("Player", function()
    return display.newSprite("#bird1.png")
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Player:ctor()
    -- 物理效果
    local body = cc.PhysicsBody:createBox(self:getContentSize(), MATERIAL_DEFAULT)
    body:setRotationEnable(false)

    body:setCategoryBitmask(0x111111)
    body:setContactTestBitmask(0x010111)
    body:setCollisionBitmask(0x011110)

    self:setTag(PLAYER_TAG)
    self:setPhysicsBody(body)
    self:getPhysicsBody():setGravityEnable(false) 
end

-- 创建血条
function Player:createProgress()
    -- 设置血量
    self.blood = 100
    local progressbg = display.newSprite("#progress1.png")
    self.fill = display.newProgressTimer("#progress2.png", display.PROGRESS_TIMER_BAR)

    self.fill:setMidpoint(cc.p(0, 0.5))
    self.fill:setBarChangeRate(cc.p(1.0, 0))
    self.fill:setPosition(progressbg:getContentSize().width/2, progressbg:getContentSize().height/2)
    progressbg:addChild(self.fill)
    self.fill:setPercentage(self.blood)

    progressbg:setAnchorPoint(cc.p(0, 1))
    self:getParent():addChild(progressbg)
    progressbg:setPosition(cc.p(display.left, display.top))
end

-- 设置血条长度
function Player:setProPercentage(Percentage)
    self.fill:setPercentage(Percentage)
end

-- 播放乌鸦飞翔动画
function Player:flying()
    transition.playAnimationForever(self, display.getAnimationCache("flying"))
end


return Player