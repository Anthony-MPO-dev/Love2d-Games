
ANGULAR_SPEED = 6
PLAYER_SPEED = 180
BULLET_SPEED = 500
MONSTER_SPEED = 90

function love.load()
    math.randomseed(os.time())
    height = love.graphics.getHeight()
    width = love.graphics.getWidth()

    smallFont = love.graphics.newFont('Minecraft.ttf', 20) --BECKETT_.TTF
    bigFont = love.graphics.newFont('Minecraft.ttf', 50)

    sprite = {}
    sprite.bg = love.graphics.newImage("sprites/tile_06.png")
    sprite.bullet = love.graphics.newImage("sprites/tile_187.png")
    sprite.player = love.graphics.newImage("sprites/soldier1_machine.png")
    sprite.monster = love.graphics.newImage("sprites/zoimbie1_hold.png")

    player = {}
    player.x = width / 2
    player.y = height / 2
    player.points = 0

    player.direction = 0 -- girar para esquerda ou direita--
    --player.rotation = -math.pi/2
    player.rotation = 0
    player.vector = {}

    bullets = {} --guarda as balas disparadas

    monsters = {} --guarda monstros

    time_limit = 1 -- segundos
    timer = time_limit

    time_limit_g = 3 -- segundos
    timer_g = time_limit_g

    game_over = false
    giratorio = false

end

function love.update(dt)
    if game_over == false then
        timer = timer - dt
        if timer <= 0 then
            --esgotou o tempo
            create_monster()
            timer = time_limit -- reset do timer
            if time_limit > 0.2 then
                time_limit = time_limit * 0.96
            end
        end
        player.direction = 0
        player.vector.x = 0
        player.vector.y = 0
        if love.keyboard.isDown('w') then
            player.vector.y = math.sin(player.rotation)
            player.vector.x = math.cos(player.rotation)
            
        end
        if love.keyboard.isDown('s') then
            player.vector.y = -math.sin(player.rotation)
            player.vector.x = -math.cos(player.rotation)
        end
        --if love.keyboard.isDown('d') or giratorio == true then
        if giratorio == true then
            player.direction = 2 --girar sentido horario 
            player.rotation = player.rotation + player.direction * ANGULAR_SPEED * dt --faz com que a rotação seja ativada pela direção
        end
        --if love.keyboard.isDown('a') then
        --    player.direction = -1 --girar sentido anti-horario
        --end

        if giratorio == false then --caso não esteja em estado giratorio ele retorna para captar rotação pelo angulo vetorial
            player.rotation = -player_mouse_angle()
            player.x = player.x + player.vector.x * PLAYER_SPEED * dt
            player.y = player.y + player.vector.y *PLAYER_SPEED * dt
        end
        
        -- remover balas fora do viewpoint 
        for i=#bullets,1,-1 do
            local b = bullets[i]
            if b.x < 0 or b.x> width or b.y > height then 
                table.remove(bullets, i)
            end

            -- matar monstros (colisão com bullets)
            for j=#monsters,1,-1 do
                local m = monsters[j]
                if collides(b, m, 25) then
                    table.remove(monsters, j)
                    table.remove(bullets, i)
                    player.points = player.points + 1
                end
            end
        end

        for j=#monsters,1,-1 do
            local m = monsters[j]
            if collides(player, m, 25) then
                PLAYER_SPEED = 0
                BULLET_SPEED = 0
                MONSTER_SPEED = 0
                game_over = true;
            end
        end

        --for i=#bullets,

        --atualizar posição da bala
        for i, b in ipairs(bullets) do
            b.x = b.x + b.vector.x * BULLET_SPEED * dt
            b.y = b.y + b.vector.y * BULLET_SPEED * dt

        end

        -- atualizar posição do monstro
        for i, m in ipairs(monsters) do
            m.x = m.x + math.cos(m.rotation) * MONSTER_SPEED * dt
            m.y = m.y + math.sin(m.rotation) * MONSTER_SPEED * dt
            m.rotation = player_monster_angle(m)
        end

        if giratorio == true then
            timer_g = timer_g - dt
            if timer_g <= 0 then
                --esgotou o tempo
                giratorio = false
            end
            gira_atira()
            
        
        end
    end
end



function love.draw()
   
    draw_background()
    love.graphics.setFont(smallFont)
    love.graphics.print("Qtde de monsters: " .. #monsters)
    love.graphics.setFont(bigFont)
    love.graphics.printf("Pontos: ".. player.points, width/2-100, 0, width, 'left')

    if game_over == true then
        love.graphics.setColor(255, 0, 0)
        love.graphics.printf("GAME OVER", 0, 100, width, 'center')
    end

    love.graphics.draw(sprite.player, 
    player.x, player.y, -- posicao do player na tela 
    player.rotation, -- rotacao do player
    nil,nil, -- escala da imagem
    sprite.player:getWidth()/3,--origem do eixo y (centralizado)
    sprite.player:getHeight()/2 --origem do eixo x (centralizado)
    )

    --atira balas
    for i, b in ipairs(bullets) do
        love.graphics.draw(sprite.bullet, b.x, b.y, 0, nil, nil, 
        sprite.bullet:getWidth()/2, sprite.bullet:getHeight()/2)
    end

    -- desenha monstros 
    for i, m in ipairs(monsters) do
        love.graphics.draw(sprite.monster, m.x, m.y, m.rotation, nil, nil, 
        sprite.monster:getWidth()/3, sprite.monster:getHeight()/2)
    end

end

function draw_background()
    img_h = sprite.bg:getHeight()
    img_w = sprite.bg:getWidth()
    --aredonda para cima--
    cols = math.ceil(width / img_w)
    rows = math.ceil(height / img_h)
    for row = 0, rows -1 do
        for col=0, cols-1 do
            love.graphics.draw(sprite.bg, col* img_w, row * img_h)
        end
    end
end

--callback
function love.keypressed(key)
    if key == 'space' or key == 'c' or key == 'v' and game_over == false then
        local bullet = {}
        bullet.x = player.x
        bullet.y =  player.y
        bullet.vector = {}
        bullet.vector.x = math.cos(player.rotation)
        bullet.vector.y = math.sin(player.rotation)
        table.insert(bullets, bullet) -- insere a bala na lista de balas
    end

    if key == 'return' and game_over== false then
        create_monster()
    end

    if key == 't'  and game_over == false then
        giratorio = true
        timer_g = time_limit_g -- reset do timer
          
    end

end

function create_monster()
    local monster = {}
    side = math.random(1,4)
    
    if side == 1 then
        --lado esquerdo
        monster.x = -30
        monster.y =  math.random(0, height)
    elseif side == 2 then
        --cima
        monster.x = math.random(0, width)
        monster.y = -30
    elseif side == 3 then
        -- lado direito 
        monster.x = width + 10
        monster.y = math.random(0, height) 
    elseif side == 4 then
        --baixo
        monster.x = math.random(0, width)
        monster.y = height +10 
    end
    --monster.x = math.random(0, width+1)
    --monster.y = math.random(0,height+1)
    --monster.rotation = math.random(-2*math.pi, 2*math.pi)
    monster.rotation = player_monster_angle(monster) 
    table.insert(monsters, monster)
end

function collides(a, b, min_distance)
    -- distância euclidiana entre dois pontos 
    local h = math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)

    if h < min_distance then
        return true
    end
    return false
end

function player_monster_angle(monster)
    -- ângulo entre player e monstro é dado pela função invesa da tangente
    return math.atan2(player.y - monster.y, player.x - monster.x)
end

function player_mouse_angle()
    return math.atan2(love.mouse.getY() - player.y, player.x - love.mouse.getX())
  
end
function gira_atira()
    local bullet = {}
    bullet.x = player.x
    bullet.y =  player.y
    bullet.vector = {}
    bullet.vector.x = math.cos(player.rotation)
    bullet.vector.y = math.sin(player.rotation)
    table.insert(bullets, bullet) -- insere a bala na lista de balas

end