-----------------------------------------------------------------------------------------
-- Scene 1
-----------------------------------------------------------------------------------------
local scene = require("composer").newScene()

----------------------------------------------------
-- Play
----------------------------------------------------


local function onTouch( event )
	local t = event.target
    print(t.name)
    
	local phase = event.phase
	if "began" == phase then
		-- Make target the top-most object
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t )
		
		-- Spurious events can be sent to the target, e.g. the user presses 
		-- elsewhere on the screen and then moves the finger over the target.
		-- To prevent this, we add this flag. Only when it's true will "move"
		-- events be sent to the target.
		t.isFocus = true
		
		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
	elseif t.isFocus then
		if "moved" == phase then
			-- Make object move (we subtract t.x0,t.y0 so that moves are
			-- relative to initial grab point, rather than object "snapping").
			t.x = event.x - t.x0
			t.y = event.y - t.y0
			
			-- Gradually show the shape's stroke depending on how much pressure is applied.
			if ( event.pressure ) then
				t:setStrokeColor( 1, 1, 1, event.pressure )
			end
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t:setStrokeColor( 1, 1, 1, 0 )
			t.isFocus = false
		end
	end
end

----------------------------------------------------
-- Create
----------------------------------------------------

function scene:create(event)
    print("Hello world, I am here again!")
    local tapCount = 0
    self.W = display.contentWidth 
    self.H = display.contentHeight   
    print(self.W, self.H)
    
    local background = display.newImageRect( "background.png", self.W, self.H )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local platform = display.newImageRect( "platform.png", 450, 70 )
    platform.x = display.contentCenterX
    platform.y = display.contentHeight-30

    platform:addEventListener( "touch", onTouch )
    platform.name = "I am cool platform!"

    local balloon1 = display.newImageRect( "balloon.png", 112, 112 )
    balloon1.x = display.contentCenterX
    balloon1.y = display.contentCenterY
    balloon1.alpha = 50

    physics.start()
    physics.addBody(platform, "static", {bounce=.1})
    physics.addBody(balloon1, "dynamic", {radius=50, bounce=.5})
    
end

scene:addEventListener("create", scene)

return scene

----------------------------------------------------
-- EOF
----------------------------------------------------