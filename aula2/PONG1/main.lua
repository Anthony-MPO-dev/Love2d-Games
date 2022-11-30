function love.load()
    math.randomseed(os.time())
    heigth = love.graphics.getHeight()
    width = love.graphics.getWidth()

    racket1 = {} -- table
    racket1.w = 20
    racket1.h = 80
    racket1.x = 10
    racket1.y = heigth/2 - (racket1.h/2)

    racket2 = {} -- table
    racket2.w = 20
    racket2.h = 80
    racket2.x = width-30
    racket2.y = heigth/2 - (racket2.h/2)

    ball = {}
    ball.w = 20
    ball.h = 20
    ball.x = width/2
    ball.y = heigth/2 - (ball.h/2)
    ball.dx = -300 -- velocidade da bola no eixo x (pixels por segundo)
    ball.dy = 0

end

function love.update(dt)

    --if collides(ball, racket1) == true then
    --    ball.dx = -ball.dx -- para a bola
    --    ball.dy = math.random(-200, 200)
    --    love.graphics.setBackgroundColor(252/255,150/255,9/255)
    --end

    if collides(ball, racket2) == true then
        ball.dx = -ball.dx -- para a bola
        love.graphics.setBackgroundColor(244/255,66/255,19/255)
    end

    if ball.x + ball.w >= width then
        --Detecta borda direita
        ball.x = width - ball.w -1
        ball.dx = -ball.dx
        --love.graphics.setBackgroundColor(255/255,255/255,255/255)
    end

    if ball.x - ball.w <= 0 then
        --Detecta borda direita
        ball.x = ball.w -1
        ball.dx = -ball.dx
        --love.graphics.setBackgroundColor(255/255,255/255,255/255)
    end

     --dt faz a velocidade ser dependente do tempo
    ball.x = ball.x - ball.dx *dt
    ball.y = ball.y - ball.dy *dt
   
end

function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", racket1.x, racket1.y, racket1.w, racket1.h)

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", racket2.x, racket2.y, racket2.w, racket2.h)

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", ball.x, ball.y, ball.w, ball.h)

end

--Verifica se há colisão entre os dois objetos
function collides(ball, racket)
    -- Algoritmo AABB

    if ball.y > racket.y + racket.h or ball.y + ball.h < racket.y then
        --Bola a baixo ou acimda da raquete  
        return false
    end

    if ball.x > racket.x + racket.w or ball.x + ball.w < racket.x then
        --Bola à esquerda ou direita da raquete
        return false
    end
    return true
end