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

    love.window.setTitle('Pong')

    math.randomseed(os.time())

    largeFont = love.graphics.newFont('font.otf', 32)
    smallFont = love.graphics.newFont('font.otf', 8)

    sounds = {
        ['paddle'] = love.audio.newSource('sounds/paddle.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall'] = love.audio.newSource('sounds/wall.wav', 'static'),
        ['winning'] = love.audio.newSource('sounds/winning.wav', 'static')
    }


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
    upscale = true,
    fullscreen = false,
    resizable = true
})

end 


function love.resize(w, h)
    WINDOW_WIDTH = w
    WINDOW_HEIGHT = h
    push:resize(w, h)
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


        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.05
            ball.x = player1.x + 5

            sounds['paddle']:play()

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.05
            ball.x = player2.x - ball.width

            sounds['paddle']:play()

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
        sounds['wall']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall']:play()
        end

        if ball.x < 0 then 
            player2score = player2score + 1
            sounds['score']:play()
            ball:reset()

            if player2score == 10 then 
                winner = 'Player 2'
                gameState = 'done'
                sounds['winning']:play()
                -- player1score = 0
                -- player2score = 0
            else
                gameState = 'start'
            end
        
        elseif ball.x > VIRTUAL_WIDTH then 
            player1score = player1score + 1
            sounds['score']:play()
            ball:reset()
            
            if player1score == 10 then
                winner = 'Player 1'
                gameState = 'done'
                sounds['winning']:play()
                -- player1score = 0
                -- player2score = 0
            else
                gameState = 'start'
            end
        end
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
        elseif gameState == 'done' then
            player1score = 0
            player2score = 0
            gameState = 'start'
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


    if gameState == 'start' and player1score == 0 and player2score == 0 then
        love.graphics.printf("Welcome to Pong!", 0, VIRTUAL_HEIGHT / 2 - 110, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Start", 0, VIRTUAL_HEIGHT / 2 - 100, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'start' and (player1score > 0 or player2score > 0) then
        love.graphics.printf("Press Enter to Serve", 0, VIRTUAL_HEIGHT / 2 - 100, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.printf("Playing", 0, VIRTUAL_HEIGHT / 2 - 110, VIRTUAL_WIDTH, 'center')
    end

    if gameState == 'done' then
        love.graphics.clear(9/255, 121/255, 105/255, 1)
        love.graphics.printf(winner .. " wins!", 0, VIRTUAL_HEIGHT / 2 - 110, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Restart", 0, VIRTUAL_HEIGHT / 2 - 100, VIRTUAL_WIDTH, 'center')
    end
    -- love.graphics.printf("Hello Pingo", 0, VIRTUAL_HEIGHT / 2 - 110, VIRTUAL_WIDTH, 'center')


    love.graphics.setFont(largeFont)
    love.graphics.print(tostring(player1score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 - 80)
    love.graphics.print(tostring(player2score), VIRTUAL_WIDTH / 2 + 25, VIRTUAL_HEIGHT / 2 - 80)
    love.graphics.setFont(smallFont)

    -- padle 1
    player1:render()

    -- padle 2
    player2:render()

    -- ball
    ball:render()

    function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1) -- green color for FPS
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10) -- .. concatenation operator to combine string and number
    love.graphics.setColor(1, 1, 1, 1) -- to reset color to white
end
displayFPS()

    push:finish()
end


-- function displayFPS()
--     love.graphics.setFont(smallFont)
--     love.graphics.setColor(0, 1, 0, 1) -- green color for FPS
--     love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10) -- .. concatenation operator to combine string and number
--     love.graphics.setColor(1, 1, 1, 1) -- to reset color to white
-- end