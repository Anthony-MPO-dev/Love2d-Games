PATH = 'kenney_tinydungeon/Tiles/'
TSIZE = 16 -- tamanho do tile
WINDOW_WIDTH = 840
WINDOW_HEIGHT = 600
-- Dimensões virtuais
WIDTH = 280
HEIGHT = 200


push = require 'push'
function love.load()
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('Minecraft.ttf', 20) --BECKETT_.TTF
    bigFont = love.graphics.newFont('Minecraft.ttf', 50)

    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(WIDTH, HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)
    tilemap = {
        {1,1,1,1,1,1,1,1,1,1,1,1,0,0},
        {1,0,0,0,0,0,0,0,0,0,0,1,0,0},
        {1,0,1,1,1,0,1,1,1,1,0,1,0,0},
        {1,0,1,0,0,0,0,0,0,5,0,1,0,0},
        {1,0,1,1,1,0,0,0,0,0,0,0,0,0},
        {1,0,0,4,0,0,1,0,0,0,0,0,0,0},
        {1,0,0,0,0,0,1,1,1,0,0,0,0,0},
        {1,0,0,0,0,0,0,6,0,0,0,0,0,0},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1}
            }
    sprite = {}
    sprite.wall = love.graphics.newImage(PATH .."tile_0014.png")
    sprite.floor = love.graphics.newImage(PATH .."tile_0049.png")
    sprite.player = love.graphics.newImage(PATH .."tile_0097.png")
    sprite.enemy = love.graphics.newImage(PATH .."tile_0121.png")
    sprite.axel = love.graphics.newImage(PATH .."tile_0118.png")
    sprite.mana_potion = love.graphics.newImage(PATH .."tile_0116.png")
    sprite.life_potion = love.graphics.newImage(PATH .."tile_0115.png")
    player = {x = 3, y = 2}
    while true do
        X = SORTEIO_X()
        Y = SORTEIO_Y()
        if (tilemap[Y][X] ~= 1) then 
            player.x = X
            player.y = Y
            break
        end
    end

    enemy = {x = 0, y = 0, passos = 0}

    while true do
        X = SORTEIO_X()
        Y = SORTEIO_Y()
        if ((tilemap[Y][X] ~= 1) and X ~= player.x and Y ~= player.y ) then 
            enemy.x = X
            enemy.y = Y
            break
        end
    end
    
    inventario = {0,0,0,0}

    time_limit = 0.2 -- segundos
    timer = time_limit
    
    game_over = false

end

function love.update(dt)
        timer = timer - dt

        if timer <= 0 and game_over == false then
            timer = time_limit -- reset do timer   
            move_enemy(enemy, math.random(-1, 1))
                
        end
end

function love.draw()
    push:start()

    for a=1,3 do --imprime os itens do inventario
        if(inventario[a] == 6) then
            love.graphics.draw(sprite.axel, 
            a * TSIZE, 0 * TSIZE) 
        end
        if(inventario[a] == 5) then
            love.graphics.draw(sprite.life_potion, 
            a * TSIZE, 0 * TSIZE) 
        end
        if(inventario[a] == 4) then
            love.graphics.draw(sprite.mana_potion, 
            a * TSIZE, 0 * TSIZE) 
        end
    end
    
    for i, row in ipairs(tilemap) do
        for j, col in ipairs(row) do
            if col == 1 then
                love.graphics.draw(sprite.wall, 
                        j * TSIZE, i * TSIZE)
            elseif col == 0 or col == 5 or col == 4 or col == 6 then
                love.graphics.draw(sprite.floor, 
                        j * TSIZE, i * TSIZE) 
            end
            if col == 6 then
                love.graphics.draw(sprite.axel, 
                j * TSIZE, i * TSIZE)
            elseif col == 5 then
                love.graphics.draw(sprite.life_potion, 
                j * TSIZE, i * TSIZE)
            elseif col == 4 then
                love.graphics.draw(sprite.mana_potion, 
                j * TSIZE, i * TSIZE)
            end
        end
    end

    love.graphics.draw(sprite.player, 
            player.x * TSIZE, player.y * TSIZE) 

    love.graphics.draw(sprite.enemy, 
        enemy.x * TSIZE, enemy.y * TSIZE) 

    game_over = colides(player, enemy)

    if game_over == true then
        love.graphics.setColor(255, 0, 0)
        love.graphics.setFont(bigFont)
        love.graphics.printf("GAME OVER", 0, 40, WINDOW_WIDTH/3, 'center')
    end
    push:finish()
end

function love.keypressed(key)
    local x = player.x -- coluna onde se encontra o player
    local y = player.y -- linha onde se encontra o player
    if(game_over == false)then
        if key == 'w' then
            y = y - 1
        end
        if key == 'a' then
            x = x - 1
        end
        if key == 's' then
            y = y + 1
        end
        if key == 'd' then
            x = x + 1
        end
        if tilemap[y][x] ~= 1 then 
            --não é parede
            player.x = x
            player.y = y
        end
        if tilemap[y][x] >= 2 then 
            if inventario[4] < 4 then
                inventario[4] = inventario[4]+1;
                inventario[inventario[4]] = tilemap[y][x] 
            end
            tilemap[y][x] = 0
        end
    end
end

function move_enemy(enemy, direction)
    if tilemap[enemy.y][enemy.x+direction] ~= 1 then 
        enemy.x = enemy.x + direction;
    elseif enemy.x > 13 or enemy.x < 2 then
        while true do
            X = SORTEIO_X()
            Y = SORTEIO_Y()
            if ((tilemap[Y][X] ~= 1) and X ~= player.x and Y ~= player.y ) then 
                enemy.x = X
                enemy.y = Y
                break
            end
        end
        return false
    elseif tilemap[enemy.y][enemy.x-direction] ~= 1 then 
        enemy.x = enemy.x - direction;
    else
        return false
    end

end


function SORTEIO_X()
    N = math.random(1,12)
    return N
end

function SORTEIO_Y()
    N = math.random(1,7)
    return N
end

function colides(player, enemy)
    if(player.x == enemy.x and player.y == enemy.y)then
        return true
    else
        return false
    end
end


