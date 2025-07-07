local Class = require "src.lib.class"

Paddle = Class {}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.dy = 0
    self.width = width
    self.height = height
end

function Paddle:update(dt)
    local y = self.y + self.dy * dt

    if y < 0 then
        y = 0
    elseif y > VIRTUAL_HEIGHT - self.height then
        y = VIRTUAL_HEIGHT - self.height
    end

    self.y = y
end

function Paddle:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end