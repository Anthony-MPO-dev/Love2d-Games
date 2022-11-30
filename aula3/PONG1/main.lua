function love.load()
    math.randomseed(os.time())
    heigth = love.graphics.getHeight()
    width = love.graphics.getWidth()

    racket1 = {} -- table
    racket1.w = 20
    racket1.h = 80
    racket1.score = 0
    racket1.x = 10
    racket1.dy = 0 -- valocidade da raquete
   
    racket1.y = heigth/2 - (racket1.h/2)

    racket2 = {} -- table
    racket2.w = 20
    racket2.h = 80
    racket2.score = 0
    racket2.x = width - 10 - racket2.w
    racket2.y = heigth/2 - (racket2.h/2)
    racket2.dy = 0 -- valocidade da raquete

    ball = {}
    ball.service_direction = 1 -- 1 (direita ) ou -1 (esquerda)
    ball.w = 20
    ball.h = 20
    ball.x = width/2
    ball.y = heigth/2 - (ball.h/2)
    ball.dx = 0 -- velocidade da bola no eixo x (pixels por segundo)
    ball.dy = 0

    smallFont = love.graphics.newFont('Affichage.ttf', 30)
    bigFont = love.graphics.newFont('Affichage.ttf', 80)

    sound = {}
    sound.hit_racket_dir = love.audio.newSource('dir.wav', 'static')
    sound.hit_racket_esq = love.audio.newSource('esq.wav', 'static')
    sound.hit_screen = love.audio.newSource('explosion.wav', 'static')
    sound.point = love.audio.newSource('point.wav', 'static')
    sound.start = love.audio.newSource('Start.wav', 'static')

    state = 'start'

end

function love.update(dt)

    if collides(ball, racket1) then
        ball.dx = -ball.dx *1.08 -- inverte a direção da bola
        --posiciona a bola na direção da raquete
        ball.x = racket1.x + racket1.w 
        --A velocidade da bola no eixo y é aleatória
       
        ball.dy = math.random(-300, 300)
        

        sound.hit_racket_esq:play() -- método play do objeto de audio
        --muda cor do background
        love.graphics.setBackgroundColor(252/255,150/255,9/255)
    end

    if collides(ball, racket2) == true then
        ball.dx = -ball.dx *1.08 -- inverte a direção da bola
        --posiciona a bola na direção da raquete
        ball.x = racket2.x - ball.w
        --A velocidade da bola no eixo y é aleatória
        
        ball.dy = math.random(-300, 300)
        
        sound.hit_racket_dir:play() -- método play do objeto de audio
        love.graphics.setBackgroundColor(244/255,66/255,19/255)
    end

    if ball.x + ball.w >= width then
        --Detecta borda direita
        --ball.x = width - ball.w -1
        --ball.dx = -ball.dx
        centralizes(ball,racket1, racket2)
        racket1.score = racket1.score + 1 
        ball.service_direction = 1
        if racket1.score == 3 then
            --fim de jogo
            state = 'start'
        else
            --vai para saque
            state = 'serve'
        end
        
        love.graphics.setBackgroundColor(0/255,0/255,0/255)
        sound.point:play()
    end

    if ball.x < 0 then
        --Detecta borda esquerda
        --ball.x = ball.w -1
        --ball.dx = -ball.dx
        centralizes(ball,racket1, racket2)
        racket2.score = racket2.score +1
        ball.service_direction = -1
        if racket2.score == 3 then
            --fim de jogo
            state = 'start'
        else
            --vai para saque
            state = 'serve'
        end
       
        love.graphics.setBackgroundColor(0/255,0/255,0/255)
        sound.point:play()
    end

    if ball.y <= 0 then
        --bola na borda superior
        ball.y = 0
        ball.dy = -ball.dy
        sound.hit_screen:play()
    end

    if ball.y + ball.h >= heigth then
        --bola na borda inferior
        ball.y = heigth - ball.h
        ball.dy = -ball.dy  
        sound.hit_screen:play()  
    end

    --Controla a raquete da esquerda
    if love.keyboard.isDown('w') then
        -- Usuário pressiona a tecla 'w'. A raquete sobre
        racket1.dy = -700
    elseif love.keyboard.isDown('s') then
        --Usuario pressiona a tecla 's'. A raquete desce 
        racket1.dy = 700
    else
        racket1.dy = 0  
    end

    --Controla a raquete da direita
    --if love.keyboard.isDown('up') then
        -- Usuário pressiona a tecla 'up'. A raquete sobre
    --    racket2.dy = -700
    --elseif love.keyboard.isDown('down') then
        --Usuario pressiona a tecla 'down'. A raquete desce 
    --    racket2.dy = 700
    --else
    --    racket2.dy = 0
    --end

    --IA que controla raquete da direita
    if racket2.y + racket2.h < ball.y then
        racket2.dy = 400
    elseif racket2.y > ball.y then
        racket2.dy = -400
    else
        racket2.dy = 0
    end

     --dt faz a velocidade ser dependente do tempo
    ball.x = ball.x - ball.dx *dt
    ball.y = ball.y - ball.dy *dt
    racket1.y = racket1.y + racket1.dy * dt;
    racket2.y = racket2.y + racket2.dy * dt;
    confinesracket(racket1)
    confinesracket(racket2)
   
end

function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(smallFont)
    if state == 'start' then
        love.graphics.printf('Pressione enter para jogar', 0, heigth/3, width, 'center')
    elseif state == 'serve' then
        love.graphics.printf('Pressione space para jogar', 0, heigth/3, width, 'center')
    end

    love.graphics.setFont(bigFont)
    love.graphics.printf(racket1.score, 200, heigth/3.3, width, 'left')
    love.graphics.setFont(bigFont)
    love.graphics.printf(racket2.score, 615, heigth/3.3, width, 'left')

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


--delimitar raquetes dentro do campo do jogo
function confinesracket(racket)
    if racket.y < 0 then
        racket.y = 0     
    end

    if racket.y + racket.h > heigth then
        racket.y = heigth - racket.h
    end


end

function centralizes(ball, racket1, racket2)
    --centraliza bola no centro da tela
    ball.x = width/2 - ball.w/2
    ball.y = heigth/2 - ball.h/2
    ball.dx = 0;
    ball.dy = 0

    racket1.x = 10
    racket1.y = heigth/2 - (racket2.h/2)
    racket2.x = width-30
    racket2.y = heigth/2 - (racket2.h/2)
end

--callback: invocado
function love.keypressed(key)
    if state == 'start' and key == 'return' then
        sound.start:play()
        ball.dx = -500
        state = 'play'
        racket1.score = 0
        racket2.score = 0
    end

    if state == 'serve' and key == 'space' then
        sound.start:play()
        ball.dx = ball.service_direction * 500
        ball.dy = math.random(-300, 300)
        state = 'play'
    end

end