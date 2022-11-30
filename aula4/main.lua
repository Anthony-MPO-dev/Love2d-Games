
ANGULAR_SPEED = 6
PLAYER_SPEED = 180
BULLET_SPEED = 500

function love.load()

    heigth = love.graphics.getHeight()
    width = love.graphics.getWidth()

    sprite = {}
    sprite.bg = love.graphics.newImage("sprites/tile_05.png")
    sprite.bullet = love.graphics.newImage("sprites/tile_187.png")
    sprite.player = love.graphics.newImage("sprites/soldier1_machine.png")
    sprite.zombie = love.graphics.newImage("sprites/zoimbie1_hold.png")

    player = {}
    player.x = width / 2
    player.y = heigth / 2
    player.direction = 0 -- girar para esquerda / direita
    player.vector = {}
    --player.rotation = -math.pi/2 --radianos
    player.rotation = 0 -- radianos

    bullets = {} -- guarda as balas disparadas pelo player

end

function love.update(dt)
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

    if love.keyboard.isDown('d') then
        player.direction = 1 -- gira sentido horario
    end
    if love.keyboard.isDown('a') then
        player.direction = -1 -- gira sentido anti-horário
    end

    player.rotation = player.rotation + player.direction * ANGULAR_SPEED * dt
    player.x = player.x + player.vector.x * PLAYER_SPEED * dt
    player.y = player.y + player.vector.y * PLAYER_SPEED * dt

    for i, b in ipairs(bullets) do
        b.x = b.x + b.vector.x * BULLET_SPEED * dt
        b.y = b.y + b.vector.y * BULLET_SPEED * dt
    end

end

function love.draw()
    draw_background()
    
    love.graphics.draw(sprite.player,
        player.x, player.y, -- posição do player na tela 
        player.rotation, -- rotação do player
        nil, nil, -- escala da imagem nos eixos x e y
        sprite.player:getWidth()/3.5, sprite.player:getHeight()/2 -- origem da imagem no eixo x e y
    ) 

    for i, b in ipairs(bullets) do
        love.graphics.draw(sprite.bullet, b.x, b.y, 
        0, nil, nil, 
        sprite.bullet:getWidth()/2,
        sprite.bullet:getHeight()/2)
    end

    
end

function draw_background()
    img_h = sprite.bg:getHeight()
    img_w = sprite.bg:getWidth()

    --Arredonda para cima. Ex: 4.1 -> 5
    cols  = math.ceil( width / img_w)
    rows  = math.ceil(heigth / img_h)

    for row = 0, rows-1 do       
        for col = 0, cols-1 do
            love.graphics.draw(sprite.bg, col * img_w, row * img_h)
        end
    end

end

function love.keypressed(key)
    if key == 'space' then
        local bullet = {}
        bullet.x = player.x
        bullet.y = player.y
        bullet.vector = {}
        bullet.vector.x = math.cos(player.rotation)
        bullet.vector.y = math.sin(player.rotation)
        table.insert(bullets, bullet) -- insere a bala na lista de balas
    end
end