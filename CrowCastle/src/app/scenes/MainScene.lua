
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    -- 加载动画缓存 =============================================================================
    self:addAnimationCache()

	-- 添加背景图片 =============================================================================
    display.newSprite("main.png")
        :pos(display.cx, display.cy)
        :addTo(self)

    -- 添加游戏标题 =============================================================================
	local titleLabel = display.newTTFLabel({
	    text = "CROW CASTLE",
	    font = "Arial",
	    size = 96,
	    color = cc.c3b(0, 0, 0), 
	    align = cc.TEXT_ALIGNMENT_CENTER,
	    x = display.cx,
	    y = display.height * 7 / 8
	}):addTo(self)

	local move1 = cc.MoveBy:create(0.5, cc.p(0, 20))
    local move2 = cc.MoveBy:create(0.5, cc.p(0, -20))
    local SequenceAction = cc.Sequence:create( move1, move2 )
    transition.execute(titleLabel, cc.RepeatForever:create( SequenceAction ))

    -- 开始游戏按钮 =============================================================================
    local startButton = cc.ui.UIPushButton.new()
        :setButtonLabel("normal", cc.ui.UILabel.new({
            UILabelType = 2,
            text = "Start Game",
            size = 40,
            color = cc.c3b(0, 0, 0)
        }))
        :setButtonLabel("pressed", cc.ui.UILabel.new({
            UILabelType = 2,
            text = "Start Game",
            size = 50,
            color = cc.c3b(0, 0, 0)
        }))
        :onButtonClicked(function(event) 
            app:enterScene("GameScene", nil, nil, 3)
        end)
        :align(display.CENTER, display.cx, display.height * 3 / 4) 
        :addTo(self)   

    -- 添加乌鸦动画 =============================================================================
    local crow = display.newSprite("#bird1.png")
        :pos(display.cx - 170, display.height * 3 / 4)
    	:addTo(self)

    transition.playAnimationForever(crow, display.getAnimationCache("flying"))
    

end

function MainScene:onEnter()
end

function MainScene:onExit()
end

function MainScene:addAnimationCache()
    
    -- 添加乌鸦飞翔动画缓存
    local frames = display.newFrames( "bird" .. "%d.png", 1, 9)
    local animation = display.newAnimation(frames, 0.5 / 9)
    animation:setDelayPerUnit(0.1)
    display.setAnimationCache("flying", animation)
end

return MainScene
