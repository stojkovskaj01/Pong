local AI = {}

function AI.update(enemy, ball, dt)

    local enemyCenter =
        enemy.y + enemy.height / 2

    local ballCenter =
        ball.y + ball.size / 2


    if enemyCenter < ballCenter - 10 then

        enemy.y =
            enemy.y + enemy.speed * dt

    elseif enemyCenter > ballCenter + 10 then

        enemy.y =
            enemy.y - enemy.speed * dt
    end


    if enemy.y < 0 then
        enemy.y = 0
    end

    if enemy.y + enemy.height > 600 then

        enemy.y = 600 - enemy.height
    end
end

return AI