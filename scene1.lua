-----------------------------------------------------------------------------------------
-- Scene 1
-----------------------------------------------------------------------------------------
local scene = require("composer").newScene()

----------------------------------------------------
-- Create
----------------------------------------------------

function scene:create(event)
    print("Hello world, I am here!")
    self.W = display.contentWidth 
    self.H = display.contentHeight   
    self.scale = 70
    self.g = display.newGroup()
    self.view:insert(self.g)
    self.g.x = self.W/2
    self.g.y = self.H/2
    self:test1()
end

function scene:plot(x, y, w, c)
    w = w or 3
    c = c or {1,0,0}
    local circe = display.newCircle(self.g, self.scale*x, -self.scale*y, w)
    circe:setFillColor(unpack(c))
end

function scene:coords()
    local rx = self.W/2 * .9
    local lx = display.newLine(self.g, -rx, 0, rx , 0)
    lx.strokeWidth = 3
    lx.stroke = {0,0.7,0}

    local ry = self.H/2 * .9
    local ly = display.newLine(self.g, 0, -ry, 0, ry)
    ly.strokeWidth = 3
    ly.stroke = {0.,0.7,0}
end

function scene:test1()
    local n = 10
    self:coords()
    for x= -n,n,.001 do
        y1 = 1/math.tanh(x)
        y2 = x
        self:plot(x, 0*y1 + 1*y2, 2, {0,0,1}) 
        self:plot(x, 1*y1 + 0*y2, 2, {0.5}) 
        self:plot(x, 1*y1 + 1*y2, 4) 
    end
end

scene:addEventListener("create", scene)

return scene

----------------------------------------------------
-- EOF
----------------------------------------------------