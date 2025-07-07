require "configs"
require "fonts"
require "models.Paddle"
require "models.Ball"

push = require "src.lib.push"


local gameState
local player1Score
local player2Score

local player1
local player2

local ball

function love.load()
    -- Initialize game state
    gameState = "start"

    -- Initialize scores
    player1Score = 0
    player2Score = 0

    -- Initialize paddles
    player1 = Paddle(10, 30, PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(VIRTUAL_WIDTH - PADDLE_WIDTH - 10, VIRTUAL_HEIGHT - PADDLE_HEIGHT - 30, PADDLE_WIDTH, PADDLE_HEIGHT)

    -- Initialize the ball
    ball = Ball(BALL_SIZE)

    -- Setting up screen
    love.graphics.setDefaultFilter("nearest", "nearest")
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function love.resize(w, h)
    -- Resize the window and keep the scale
    push:resize(w, h)
end

function love.update(dt)
    if gameState == "play" then
        ball:update(dt)
    end

    -- Player 1 movement
    if love.keyboard.isDown("w") then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("s") then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0        
    end

    -- Player 2 movement
    if love.keyboard.isDown("up") then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("down") then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" or key == "kpenter" then
        if gameState == "start" then
            gameState = "play"
        elseif gameState == "play" then
            ball:reset()
            gameState = "start"
        end
    end
end

function love.draw()
    push:apply("start")

    -- Set the background color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- Display auxiliary text
    love.graphics.setFont(smallFont)
    love.graphics.printf("Pong!", 0, 20, VIRTUAL_WIDTH, "center")
    love.graphics.printf("Game state: " .. gameState, 0, 30, VIRTUAL_WIDTH, "center")

    -- Display the scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- Display the paddles
    player1:render()
    player2:render()
    
    -- Display the ball
    ball:render()

    -- Display FPS
    displayFPS()

    push:apply("end")
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), PADDLE_WIDTH + 20, 10)
end
