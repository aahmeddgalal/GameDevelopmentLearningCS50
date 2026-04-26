ball = class{}

function ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = (math.random(2) == 1 and 1 or -1) * math.random(80, 120)
    self.dy = math.random(-50, 50)
end

function ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = (math.random(2) == 1 and 1 or -1) * math.random(80, 120)
    self.dy = math.random(-50, 50)
end

function ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false

    elseif self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    else
        return true
    end

end

function ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

return ball