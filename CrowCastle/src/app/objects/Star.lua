
local Star = class("Star", function()
    return display.newSprite("#star.png")
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Star:ctor(x, y)
	-- 物理效果
    local starBody = cc.PhysicsBody:createCircle(self:getContentSize().width / 2, MATERIAL_DEFAULT)
    starBody:setDynamic(false)

    starBody:setCategoryBitmask(0x000001)
    starBody:setContactTestBitmask(0x100000)
    starBody:setCollisionBitmask(0x000001)

    self:setPhysicsBody(starBody)
    self:getPhysicsBody():setGravityEnable(false)  
    self:setTag(STAR_TAG)  

    -- 设置位置和缩放
    self:pos(x, y)
    self:setScale(0.5)
end

return Star