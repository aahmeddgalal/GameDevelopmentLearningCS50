WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200


push = require 'push'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    largeFont = love.graphics.newFont('font.otf', 32)
    smallFont = love.graphics.newFont('font.otf', 12)

    player1score = 0
    player2score = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        vsync = true,
        fullscreen = false
    })

push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    upscale = 'normal'
})

end 

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()

    love.graphics.setFont(largeFont)    
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    -- love.graphics.printf("Hello Pingo", 0, VIRTUAL_HEIGHT / 2 - 110, VIRTUAL_WIDTH, 'center')


    love.graphics.print(tostring(player1score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 - 110)
    love.graphics.print(tostring(player2score), VIRTUAL_WIDTH / 2 + 50, VIRTUAL_HEIGHT / 2 - 110)

    -- padle 1
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    -- padle 2
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- ball
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)


    push:finish()
end
