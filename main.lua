-- so require zemame od drugite fajlovi

local players = require("player")

local player = players.player
local enemy = players.enemy

local ball = require("ball")
local AI = require("ai")
local Sounds = require("sounds")


--------------------------------------------------
-- SETTINGS
--------------------------------------------------

local screenWidth = 800
local screenHeight = 600

local winningScore = 10

local gameState = "menu"
local gameMode = "ai"


--------------------------------------------------
-- SOUNDS
--------------------------------------------------

local paddleSound
local wallSound
local scoreSound


local normalFont
local scoreFont

--------------------------------------------------
-- LOAD
--------------------------------------------------

function love.load()


    love.window.setTitle("Pong")  

    icon = love.image.newImageData("table-tennis.png")

    love.window.setIcon(icon)



    love.window.setMode(
        screenWidth,
        screenHeight
    )

    math.randomseed(os.time())



    normalFont = love.graphics.newFont(24)
    scoreFont = love.graphics.newFont(45)

    love.graphics.setFont(normalFont)


    paddleSound =
        Sounds.createSound(
            600,
            0.08,
            0.4
        )

    wallSound =
        Sounds.createSound(
            300,
            0.08,
            0.3
        )

    scoreSound =
        Sounds.createSound(
            150,
            0.25,
            0.5
        )
end


--------------------------------------------------
-- COLLISION
--------------------------------------------------

function checkCollision(a, b)

    return a.x < b.x + b.width
       and a.x + a.size > b.x
       and a.y < b.y + b.height
       and a.y + a.size > b.y
end


--------------------------------------------------
-- RESET BALL
--------------------------------------------------

function resetBall(direction)

    ball.x =
        screenWidth / 2 - ball.size / 2

    ball.y =
        screenHeight / 2 - ball.size / 2

    ball.dx =
        350 * direction

    ball.dy =
        math.random(-200, 200)


    if math.abs(ball.dy) < 80 then

        ball.dy = 80
    end
end


--------------------------------------------------
-- RESET GAME
--------------------------------------------------

function resetGame()

    player.score = 0
    enemy.score = 0


    player.y =
        screenHeight / 2 -
        player.height / 2


    enemy.y =
        screenHeight / 2 -
        enemy.height / 2


    resetBall(1)

    gameState = "playing"
end


--------------------------------------------------
-- KEY PRESSED
--------------------------------------------------

function love.keypressed(key)

    --------------------------------------------------
    -- ESC = MENU
    --------------------------------------------------

    if key == "escape" then

        gameState = "menu"

        return
    end


    --------------------------------------------------
    -- MENU
    --------------------------------------------------

    if gameState == "menu" then

        if key == "1" then

            gameMode = "ai"
            gameState = "start"

        elseif key == "2" then

            gameMode = "two_player"
            gameState = "start"
        end


    --------------------------------------------------
    -- START
    --------------------------------------------------

    elseif gameState == "start" then

        if key == "return" then

            resetGame()
        end


    --------------------------------------------------
    -- GAME OVER
    --------------------------------------------------

    elseif gameState == "gameover" then

        if key == "return" then

            gameState = "menu"
        end
    end
end


--------------------------------------------------
-- UPDATE
--------------------------------------------------

function love.update(dt)

    if gameState ~= "playing" then

        return
    end


    --------------------------------------------------
    -- PLAYER
    --------------------------------------------------

    if love.keyboard.isDown("w") then

        player.y =
            player.y -
            player.speed * dt
    end


    if love.keyboard.isDown("s") then

        player.y =
            player.y +
            player.speed * dt
    end


    --------------------------------------------------
    -- PLAYER BOUNDARIES
    --------------------------------------------------

    if player.y < 0 then

        player.y = 0
    end


    if player.y + player.height > screenHeight then

        player.y =
            screenHeight - player.height
    end


    --------------------------------------------------
    -- ENEMY / AI
    --------------------------------------------------

    if gameMode == "ai" then

        AI.update(
            enemy,
            ball,
            dt
        )

    else

        if love.keyboard.isDown("up") then

            enemy.y =
                enemy.y -
                enemy.speed * dt
        end


        if love.keyboard.isDown("down") then

            enemy.y =
                enemy.y +
                enemy.speed * dt
        end
    end


    --------------------------------------------------
    -- ENEMY BOUNDARIES
    --------------------------------------------------

    if enemy.y < 0 then

        enemy.y = 0
    end


    if enemy.y + enemy.height > screenHeight then

        enemy.y =
            screenHeight - enemy.height
    end


    --------------------------------------------------
    -- BALL MOVEMENT
    --------------------------------------------------

    ball.x =
        ball.x +
        ball.dx * dt

    ball.y =
        ball.y +
        ball.dy * dt


    --------------------------------------------------
    -- TOP WALL
    --------------------------------------------------

    if ball.y <= 0 then

        ball.y = 0

        ball.dy =
            -ball.dy

        wallSound:stop()
        wallSound:play()
    end


    --------------------------------------------------
    -- BOTTOM WALL
    --------------------------------------------------

    if ball.y + ball.size >= screenHeight then

        ball.y =
            screenHeight - ball.size

        ball.dy =
            -ball.dy

        wallSound:stop()
        wallSound:play()
    end


    --------------------------------------------------
    -- PLAYER COLLISION
    --------------------------------------------------

    if checkCollision(ball, player)
       and ball.dx < 0 then

        ball.x =
            player.x + player.width

        ball.dx =
            -ball.dx


        local paddleCenter =
            player.y +
            player.height / 2

        local ballCenter =
            ball.y +
            ball.size / 2

        local difference =
            ballCenter -
            paddleCenter

        ball.dy =
            difference * 5


        paddleSound:stop()
        paddleSound:play()
    end


    --------------------------------------------------
    -- ENEMY COLLISION
    --------------------------------------------------

    if checkCollision(ball, enemy)
       and ball.dx > 0 then

        ball.x =
            enemy.x -
            ball.size

        ball.dx =
            -ball.dx


        local paddleCenter =
            enemy.y +
            enemy.height / 2

        local ballCenter =
            ball.y +
            ball.size / 2

        local difference =
            ballCenter -
            paddleCenter

        ball.dy =
            difference * 5


        paddleSound:stop()
        paddleSound:play()
    end


    --------------------------------------------------
    -- PLAYER LOSES
    --------------------------------------------------

    if ball.x + ball.size < 0 then

        enemy.score =
            enemy.score + 1

        scoreSound:stop()
        scoreSound:play()


        if enemy.score >= winningScore then

            gameState = "gameover"

        else

            resetBall(1)
        end
    end


    --------------------------------------------------
    -- ENEMY LOSES
    --------------------------------------------------

    if ball.x > screenWidth then

        player.score =
            player.score + 1

        scoreSound:stop()
        scoreSound:play()


        if player.score >= winningScore then

            gameState = "gameover"

        else

            resetBall(-1)
        end
    end
end


--------------------------------------------------
-- DRAW
--------------------------------------------------

function love.draw()

    love.graphics.setColor(
        1,
        1,
        1
    )


    --------------------------------------------------
    -- MENU
    --------------------------------------------------

    if gameState == "menu" then

        love.graphics.printf(
            "PONG",
            0,
            130,
            screenWidth,
            "center"
        )

        love.graphics.printf(
            "First to 10 wins!",
            0,
            180,
            screenWidth,
            "center"
        )

        love.graphics.printf(
            "1 - Player vs AI",
            0,
            270,
            screenWidth,
            "center"
        )

        love.graphics.printf(
            "2 - Two Players",
            0,
            320,
            screenWidth,
            "center"
        )

        love.graphics.printf(
            "Choose a game mode",
            0,
            400,
            screenWidth,
            "center"
        )


    

        return
    end


    --------------------------------------------------
    -- START SCREEN
    --------------------------------------------------

    if gameState == "start" then

        love.graphics.printf(
            "PONG",
            0,
            160,
            screenWidth,
            "center"
        )


        if gameMode == "ai" then

            love.graphics.printf(
                "PLAYER VS AI",
                0,
                250,
                screenWidth,
                "center"
            )

            love.graphics.printf(
                "W / S - Move",
                0,
                300,
                screenWidth,
                "center"
            )

        else

            love.graphics.printf(
                "TWO PLAYERS",
                0,
                250,
                screenWidth,
                "center"
            )

            love.graphics.printf(
                "W / S       UP / DOWN",
                0,
                300,
                screenWidth,
                "center"
            )
        end


        love.graphics.printf(
            "Press ENTER to start",
            0,
            380,
            screenWidth,
            "center"
        )


        love.graphics.printf(
            "ESC - Main Menu",
            0,
            570,
            screenWidth,
            "center"
        )

        return
    end


    --------------------------------------------------
    -- GAME OVER
    --------------------------------------------------

    if gameState == "gameover" then

        local message


        if player.score >= winningScore then

            message =
                "PLAYER 1 WINS!"

        else

            if gameMode == "ai" then

                message =
                    "AI WINS!"

            else

                message =
                    "PLAYER 2 WINS!"
            end
        end


        love.graphics.printf(
            message,
            0,
            180,
            screenWidth,
            "center"
        )


        love.graphics.printf(
            player.score ..
            " - " ..
            enemy.score,
            0,
            250,
            screenWidth,
            "center"
        )


        love.graphics.printf(
            "Press ENTER for menu",
            0,
            330,
            screenWidth,
            "center"
        )

        return
    end


    --------------------------------------------------
    -- CENTER LINE
    --------------------------------------------------

    for y = 0, screenHeight - 50, 30 do

        love.graphics.rectangle(
            "fill",
            screenWidth / 2 - 2,
            y,
            4,
            15
        )
    end


    --------------------------------------------------
    -- PLAYER
    --------------------------------------------------

    love.graphics.rectangle(
        "fill",
        player.x,
        player.y,
        player.width,
        player.height
    )


    --------------------------------------------------
    -- ENEMY
    --------------------------------------------------

    love.graphics.rectangle(
        "fill",
        enemy.x,
        enemy.y,
        enemy.width,
        enemy.height
    )


    --------------------------------------------------
    -- BALL
    --------------------------------------------------

    love.graphics.rectangle(
        "fill",
        ball.x,
        ball.y,
        ball.size,
        ball.size
    )


    --------------------------------------------------
    -- SCORE
    --------------------------------------------------
        love.graphics.setFont(scoreFont)

        love.graphics.print(
            player.score,
            screenWidth / 2 - 80,
            40
        )

        love.graphics.print(
            enemy.score,
            screenWidth / 2 + 50,
            40
        )

        love.graphics.setFont(normalFont)

    --------------------------------------------------
    -- MENU HINT
    --------------------------------------------------

    love.graphics.printf(
        "ESC - Main Menu",
        0,
        570,
        screenWidth,
        "center"
    )
end