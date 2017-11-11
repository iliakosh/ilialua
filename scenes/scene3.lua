-----------------------------------------------------------------------------------------
-- Scene 3
-----------------------------------------------------------------------------------------
local scene = require("composer").newScene()

----------------------------------------------------
-- Create
----------------------------------------------------

local function onTouch( event )
	local t = event.target
	
	print(event.x, event.y)
	
	local phase = event.phase
	if "began" == phase then
		display.getCurrentStage():setFocus( t )
		t.isFocus = true
		t.x0 = event.x - t.x
		
	elseif t.isFocus then
		if "moved" == phase then
			t.x = event.x - t.x0
			if event.pressure then
				t:setStrokeColor( 1,  1, event.pressure )
			end
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t:setStrokeColor( 1,  1, 0 )
			t.isFocus = false
		end
	end

	return true
end

for i,item in ipairs( arguments ) do
    print(i, item.x)
	local button = display.newRoundedRect( item.x,  item.w, item.h, item.r )
	button:setFillColor( item.red, item.green, item.blue )
	button.strokeWidth = 6
	button:setStrokeColor( 1, 1, 0 )
	
	button:addEventListener( "touch", onTouch )
end

local function printTouch2( event )
	print( "event(" .. event.phase .. ") ("..event.x..",) ("..getFormattedPressure(event.pressure)..")" )
end

Runtime:addEventListener( "touch", printTouch2 )

return scene
