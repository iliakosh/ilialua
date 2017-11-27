-----------------------------------------------------------------------------------------
-- Scene 1
-----------------------------------------------------------------------------------------
local scene = require("composer").newScene()

----------------------------------------------------
-- Play
----------------------------------------------------

-- TODO:
-- + don't drag the ball
-- + decrease the platform's width
-- use left and right keys to move the platform ?
-- add physical bounds

-- add an impuls when the ball collide the platform depepended on collision coords
-- add bricks
-- destroy bricks after N collisions

local function onTouch(event)
	local obj  = event.target
	local phase = event.phase

	if "began" == phase then
		print(obj.name, "Began:", event.x, event.y)
		obj.inMove = true
		obj.dx = event.x - obj.x
		obj.dy = event.y - obj.y
		print("d:", obj.dx, obj.dy)
	elseif "moved" == phase then
		if obj.inMove then
			print(obj.name, ".")

			if obj.name == "Platform" then 	
				obj.x = event.x - obj.dx
			end
			
			if obj.name == "ball" then
				obj.y = event.y - obj.dy
			end
		else
			print(obj.name, "fuck off!")
		end
	elseif "ended" == phase then
		print(obj.name, "End")
		obj.inMove = false
	end
end

----------------------------------------------------
-- Create
----------------------------------------------------

function scene:create(event)
	local debug = false 

	-- start
	print("Hello world, I am here again!")
    self.W = display.contentWidth 
    self.H = display.contentHeight   
    print(self.W, self.H)
	
	-- background
    local background = display.newImageRect( "background.png", self.W, self.H )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
	
	-- Physics 
	physics.start()
	--physics.setContinuous(true)

	-- bounds
	depth  = 0
	top    =  display.newRect(display.contentCenterX, 0, self.W, 1)
	bottom =  display.newRect(display.contentCenterX, self.H+depth, self.W, 10)
	left   =  display.newRect(0,display.contentCenterY, 1, self.H)
	right  =  display.newRect(self.W, display.contentCenterY, 1, self.H)
	left:setFillColor(1,0,0)
	bottom:setFillColor(0,.5,0)
	top:setFillColor(1,0,0)
	right:setFillColor(1,0,0)
	physics.addBody(bottom,   "static" )
	physics.addBody(left,     "static", {friction=.5} )
	physics.addBody(right,    "static" )
	physics.addBody(top,      "static" )
	
	-- create platform
	local shellR         = 300 
    local platform = display.newImageRect("platform.png", 300, 70)
    platform.name  = "Platform"
    platform.x     = display.contentCenterX
    platform.y     = display.contentHeight-160
	platform:addEventListener("touch", onTouch) -- Listen touch event for platform 
    physics.addBody(platform, "dynamic", {bounce=.1})

	function calc_shape(w,h,d)
		local vertices = { -w/2,h/2, (-w/2)+d,-h/2, (w/2)-d,-h/2, w/2,h/2 }
		return 	vertices
	end 
	
	-- create platform's shell
	local shell_shape = calc_shape(platform.width, 50, platform.width*.30)
	local shell = display.newPolygon(0,0, shell_shape)
	shell.x     = platform.x
	shell.y     = platform.y-(platform.height+shell.height)/2
	shell.fill  = {type="image", filename="platform.png"}
	physics.addBody(shell, "dynamic", {shape=shell_shape, bounce=.5})
	local piston = physics.newJoint("piston", platform, shell,  platform.x, platform.y, 0, -1)
	piston.isLimitEnabled = true
	piston:setLimits(0, 30)

	-- create platform's wheels
	local wheel_radius = 50
    local wheel1 = display.newImageRect("wooden-wheel.png", wheel_radius*2, wheel_radius*2)
    local wheel2 = display.newImageRect("wooden-wheel.png", wheel_radius*2, wheel_radius*2)
	wheel1.y = platform.y + platform.height/2 - 10
	wheel2.y = platform.y + platform.height/2 - 10 
	wheel1.x = platform.x - platform.width/2 + wheel_radius/2 
	wheel2.x = platform.x + platform.width/2 - wheel_radius/2 
    physics.addBody(wheel1, "dynamic", {radius=wheel_radius, friction=.5})
    physics.addBody(wheel2, "dynamic", {radius=wheel_radius, friction=.5})
	physics.newJoint("pivot", platform, wheel1, wheel1.x, wheel1.y)
	physics.newJoint("pivot", platform, wheel2, wheel2.x, wheel2.y)

	-- create ball
	local ball = display.newImageRect("scull.png", 112, 112)
	ball.name  = "ball"
    ball.x     = display.contentCenterX
    ball.y     = display.contentCenterY
    physics.addBody(ball, "dynamic", {radius=50, bounce=.95 ,friction=.5})
	
	-- create cloud
	local cloud_shape = calc_shape(500, 150, 0)
	local cloud = display.newPolygon(0,0, cloud_shape)
	cloud.fill  = {type="image", filename="cloud1.png"}
	cloud.x     = display.contentCenterX
    cloud.y     = display.contentCenterY-450
	physics.addBody(cloud, "dynamic", {shape=cloud_shape, bounce=.95 ,friction=.5})
	local touch1 = physics.newJoint( "touch", cloud, cloud.x-100, cloud.y)
	local touch2 = physics.newJoint( "touch", cloud, cloud.x+100, cloud.y)
	local dr = 0.7
	local mf = 7
	touch1.dampingRatio = dr
	touch1.maxForce     = mf
	touch2.dampingRatio = dr
	touch2.maxForce     = mf
	

	-- controll
	local function onKeyEvent(event)
		if event.phase == "down" then
			if event.keyName == "enter" then
				if debug then
					physics.setDrawMode("normal")
					debug = false					
				else
					physics.setDrawMode("debug")
					debug = true		
				end
			end
			local f = 4
			if event.keyName == "left" then
				platform:applyLinearImpulse(-f,0,platform.x,platform.y)	
			end
			if event.keyName == "right" then
				platform:applyLinearImpulse(f,0,platform.x,platform.y)
			end
			if event.keyName == "up" then
				local f = 5
				shell:applyLinearImpulse(0,-f,0,0)
				platform:applyLinearImpulse(0,f,0,0)
			end
		end
		return false
	end

	Runtime:addEventListener("key", onKeyEvent)
end


scene:addEventListener("create", scene)


return scene

----------------------------------------------------
-- EOF
----------------------------------------------------