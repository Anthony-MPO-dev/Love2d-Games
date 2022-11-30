TSIZE = 96 -- tamanho do tile
PATH = "kenney_tinydungeon/Tiles/"
SCALE = 6
ENEMY_SPEED = 40
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    height = love.graphics.getHeight()
    width = love.graphics.getWidth()

    tilemap = {
            --20x11
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
            {1,0,1,3,1,3,0,0,0,0,0,1,1,3,0,1,3,0,0,1},
            {1,0,1,0,1,1,0,1,1,0,1,1,1,1,0,1,0,1,3,1},
            {1,0,1,0,1,1,0,1,1,0,1,0,0,0,0,0,0,1,1,1},
            {1,0,1,0,1,1,0,1,1,0,1,0,1,1,1,3,1,1,3,1},
            {1,0,0,0,1,0,0,1,1,0,0,0,0,0,1,1,3,1,0,1},
            {1,1,1,0,1,0,1,1,1,1,1,1,1,0,0,0,0,0,0,1},
            {1,3,1,0,0,0,0,3,1,1,3,0,0,0,1,1,0,1,1,1},
            {1,0,1,0,1,1,1,0,1,1,1,1,1,1,0,0,0,0,1,1},
            {1,0,0,0,0,0,0,0,0,0,0,3,1,3,0,1,1,3,1,1},
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}                      
            }

    sprite = {}
    sprite.wall = love.graphics.newImage(PATH.."tile_0014.png")
    sprite.floor = love.graphics.newImage(PATH.."tile_0024.png")
    sprite.player = love.graphics.newImage(PATH.."tile_0084.png")
    sprite.potion = love.graphics.newImage(PATH.."tile_0116.png")

    smallFont = love.graphics.newFont('Minecraft.ttf', 20) --BECKETT_.TTF
    bigFont = love.graphics.newFont('Minecraft.ttf', 50)

    player = {}
    player = {x=2, y=2, point=0} --posição inicial do player (linha, coluna)
    

end

function love.update(dt)

    
    
end

function love.draw()
    --desenha todos os retangulos ou tiles do mapa

    for i, row in ipairs(tilemap) do
        for j, col in ipairs(row) do
            if col == 1 then
                love.graphics.draw(sprite.wall, 
                (j-1)*TSIZE, (i-1)*TSIZE,0, -- coordenadas (x,y) dos retangulos
                SCALE, SCALE) -- tamanho do retangulo
            elseif col == 0 then
                love.graphics.draw(sprite.floor, 
                (j-1)*TSIZE, (i-1)*TSIZE,0, -- coordenadas (x,y) dos retangulos
                SCALE, SCALE) -- tamanho do retangulo
            elseif col == 3 then
                love.graphics.draw(sprite.floor, 
                (j-1)*TSIZE, (i-1)*TSIZE,0, -- coordenadas (x,y) dos retangulos
                SCALE, SCALE) -- tamanho do retangulo
                love.graphics.draw(sprite.potion, 
                (j-1)*TSIZE, (i-1)*TSIZE,0, -- coordenadas (x,y) dos retangulos
                SCALE, SCALE) -- tamanho do retangulo
            end
        end
    end

    love.graphics.draw(sprite.player, 
    (player.x-1)*TSIZE, (player.y-1)*TSIZE,0, -- coordenadas (x,y) dos retangulos
    SCALE, SCALE) -- tamanho do retangulo


    love.graphics.setFont(bigFont)
    love.graphics.printf("Pontos: ".. player.point, width/2-100, 0, width, 'left')
end

function love.keypressed(key)
    local x = player.x -- coluna onde se encontra o player
    local y = player.y -- linha onde se encontra o player

    if key == 'w' then
        y = y - 1
    end
    if key == 's' then
        y = y + 1
    end
    if key == 'a' then
        x = x - 1
    end
    if key == 'd' then
        x = x + 1
    end

    if tilemap[y][x] ~= 1 then -- não é parede
        player.x = x
        player.y = y
    end
    if tilemap[y][x] == 3 then
        tilemap[y][x] = 0
        player.point = player.point +1
    end
    
end