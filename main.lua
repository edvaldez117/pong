require "configs"
require "fonts"
require "models.Paddle"
require "models.Ball"

push = require "src.lib.push"

local gameState
local player1Score
local player2Score
local servingPlayer
local winningPlayer

local player1
local player2

local ball

function love.load()
    -- Setting randomseed using os time
    math.randomseed(os.time())

    -- Initialize game state
    gameState = "start"

    -- Initialize scores
    player1Score = 0
    player2Score = 0

    -- Initialize serving and winning player
    servingPlayer = 1
    winningPlayer = 0

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
        -- Detecting collision with players
        if ball:collides(player1) then
            ball.x = player1.x + player1.width + 1
            ball.dx = -ball.dx * 1.05

            local paddleCenter = player1.y + player1.height / 2
            local ballCenter = ball.y + ball.size / 2
            if ballCenter < paddleCenter then
                ball.dy = -math.random(0, 200)
            elseif ballCenter > paddleCenter then
                ball.dy = math.random(0, 200)
            else
                ball.dy = 0
            end
        elseif ball:collides(player2) then
            ball.x = player2.x - ball.size - 1
            ball.dx = -ball.dx * 1.05

            local paddleCenter = player2.y + player2.height / 2
            local ballCenter = ball.y + ball.size / 2
            if ballCenter <= paddleCenter then
                ball.dy = -math.random(0, 150)
            elseif ballCenter > paddleCenter then
                ball.dy = math.random(0, 150)
            end
        end

        -- Detecting if a player scores a point
        if ball.x <= 0 then
            player2Score = player2Score + 1
            servingPlayer = 1
            ball:reset()
            if player2Score == WINNING_POINTS then
                winningPlayer = 2
                gameState = "win"
            else 
                gameState = "serve"
            end
        elseif ball.x + ball.size >= VIRTUAL_WIDTH then
            player1Score = player1Score + 1
            servingPlayer = 2
            ball:reset("left")
            if player1Score == WINNING_POINTS then
                winningPlayer = 1
                gameState = "win"
            else 
                gameState = "serve"
            end
        end

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
            gameState = "serve"
        elseif gameState == "serve" then
            gameState = "play"
        elseif gameState == "play" then
            player1Score = 0
            player2Score = 0
            servingPlayer = 1
            ball:reset()
            gameState = "start"
        elseif gameState == "win" then
            player1Score = 0
            player2Score = 0
            gameState = "serve"
        end
    end
end

function love.draw()
    push:apply("start")

    -- Set the background color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- Display auxiliary text
    love.graphics.setFont(smallFont)
    if gameState == "start" then
        love.graphics.printf("Pong!", 0, 20, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to start a game", 0, 30, VIRTUAL_WIDTH, "center")
    elseif gameState == "serve" then
        love.graphics.printf("Player " .. tostring(servingPlayer) .. " serves!", 0, 20, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to serve", 0, 30, VIRTUAL_WIDTH, "center")
    elseif gameState == "win" then
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " won!", 0, 20, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to start a new game", 0, 30, VIRTUAL_WIDTH, "center")
    end

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
