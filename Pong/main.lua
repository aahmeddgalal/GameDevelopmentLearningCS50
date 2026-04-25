WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


push = require 'push'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    largeFont = love.graphics.newFont('font.otf', 32)
    smallFont = love.graphics.newFont('font.otf', 12)

    player1score = 0
    player2score = 0

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        vsync = true,
        fullscreen = false
    })

push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    upscale = 'normal'
})

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
    love.graphics.rectangle('fill', 10, 10, 5, 20)

    -- padle 2
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- ball
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)


    push:finish()
end
