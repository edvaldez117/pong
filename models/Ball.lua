local Class = require "src.lib.class"

Ball = Class {}

function Ball:init(size)
    self.size = size
    self:reset()
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - self.size / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.size / 2
    self.dx = 75
    self.dy = math.random(-100, 100)
end

function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.size then
        return false
    end

    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.size then
        return false
    end

    return true
end

function Ball:update(dt)
    local x = self.x + self.dx * dt
    local y = self.y + self.dy * dt

    if x <= 0 then
        x = 0
        self.dx = -self.dx
    elseif x >= VIRTUAL_WIDTH - self.size then
        x = VIRTUAL_WIDTH - self.size
        self.dx = -self.dx
    end

    if y <= 0 then
        y = 0
        self.dy = -self.dy
    elseif y >= VIRTUAL_HEIGHT - self.size then
        y = VIRTUAL_HEIGHT - self.size
        self.dy = -self.dy
    end

    self.x = x
    self.y = y
end

function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end
