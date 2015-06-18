
local Airship = class("Airship", function()
    return display.newSprite("#airship.png")
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Airship:ctor(x, y)
    -- 物理效果
    local airshipBody = cc.PhysicsBody:createCircle(self:getContentSize().width / 2, MATERIAL_DEFAULT)
    airshipBody:setRotationEnable(false)

    airshipBody:setCategoryBitmask(0x000100)
    airshipBody:setContactTestBitmask(0x100000)
    airshipBody:setCollisionBitmask(0x010110)

    self:setPhysicsBody(airshipBody)
    self:getPhysicsBody():setGravityEnable(false)  
    self:setTag(AIRSHIP_TAG)
    
    -- 设置位置
    self:pos(x, y)

    -- 上下前进运动
    local move1 = cc.MoveBy:create(3, cc.p(0,  self:getContentSize().height ))
    local move2 = cc.MoveBy:create(3, cc.p(0, -self:getContentSize().height ))
    local SequenceAction = cc.Sequence:create( move1, move2 )
    transition.execute(self, cc.RepeatForever:create( SequenceAction ))
end

return Airship