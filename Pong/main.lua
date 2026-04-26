push = require 'push'

class = require 'class'

paddle = require 'paddle'

ball = require 'ball'



WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200




function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    largeFont = love.graphics.newFont('font.otf', 32)
    smallFont = love.graphics.newFont('font.otf', 12)

    player1score = 0
    player2score = 0

    player1 = paddle(10, 30, 5, 20)
    player2 = paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    gameState = 'start'

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
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    player1:update(dt)
    player2:update(dt)

    if gameState == 'play' then
        ball:update(dt)
    end
end

-- function resetBall()
--     ballX = VIRTUAL_WIDTH / 2 - 2
--     ballY = VIRTUAL_HEIGHT / 2 - 2

--     ballDX = (math.random(2) == 1 and 1 or -1) * math.random(80, 120)
--     ballDY = math.random(-100, 100)
-- end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            ball:reset()


            ballDX = (math.random(2) == 1 and 1 or -1) * math.random(80, 120)
            ballDY = math.random(-50, 50) 

            -- resetBall()
        end
    end
end

function love.draw()
    push:start()

    love.graphics.setFont(smallFont)    
    love.graphics.clear(40/255, 45/255, 52/255, 1)


    if gameState == 'start' then
        love.graphics.printf("Press Enter to Start", 0, VIRTUAL_HEIGHT / 2 - 110, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.printf("Playing", 0, VIRTUAL_HEIGHT / 2 - 110, VIRTUAL_WIDTH, 'center')
    end
    -- love.graphics.printf("Hello Pingo", 0, VIRTUAL_HEIGHT / 2 - 110, VIRTUAL_WIDTH, 'center')


    love.graphics.print(tostring(player1score), VIRTUAL_WIDTH / 2 - 25, VIRTUAL_HEIGHT / 2 - 80)
    love.graphics.print(tostring(player2score), VIRTUAL_WIDTH / 2 + 25, VIRTUAL_HEIGHT / 2 - 80)

    -- padle 1
    player1:render()

    -- padle 2
    player2:render()

    -- ball
    ball:render()


    push:finish()
end
