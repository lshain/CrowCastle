
local Plane = class("Plane", function()
    return display.newSprite("#plane.png")
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Plane:ctor(x, y)
    -- 物理效果
    local planeBody = cc.PhysicsBody:createBox(self:getContentSize(), MATERIAL_DEFAULT)
    planeBody:setRotationEnable(false)

    planeBody:setCategoryBitmask(0x000010)
    planeBody:setContactTestBitmask(0x100000)
    planeBody:setCollisionBitmask(0x010110)

    self:setPhysicsBody(planeBody)
    self:getPhysicsBody():setGravityEnable(false)  
    self:setTag(PLANE_TAG)

	-- 设置位置
    self:pos(x, y)

    -- 上下运动
    local move1 = cc.MoveBy:create(3, cc.p(-self:getContentSize().width,  self:getContentSize().height ))
    local move2 = cc.MoveBy:create(3, cc.p(-self:getContentSize().width, -self:getContentSize().height ))
    local SequenceAction = cc.Sequence:create( move1, move2 )
    transition.execute(self, cc.RepeatForever:create( SequenceAction ))
end

return Plane