local Class = require "src.lib.class"
local Sounds = require "src.lib.sounds"

Ball = Class {}

function Ball:init(size)
    self.size = size
    self:reset()
end

function Ball:reset(direction)
    direction = direction or "right"
    self.x = VIRTUAL_WIDTH / 2 - self.size / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.size / 2
    self.dx = direction == "right" and 75 or -75
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

    if y <= 0 then
        Sounds.wallHit:play()
        y = 0
        self.dy = -self.dy
    elseif y >= VIRTUAL_HEIGHT - self.size then
        Sounds.wallHit:play()
        y = VIRTUAL_HEIGHT - self.size
        self.dy = -self.dy
    end

    self.x = x
    self.y = y
end

function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end
