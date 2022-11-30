WINDOW_WIDTH = love.graphics.getWidth()
WINDOW_HEIGHT = love.graphics.getHeight()

--dimensões virtuais
WIDTH = 640
HEIGHT = 360

--tile map 18x18

push = require 'lib/push'
wf = require 'lib/windfield' -- física

sti = require 'lib/sti'
Class = require 'lib/class'

require 'Player'
require 'Map' -- Nossa classe de tiles

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(WIDTH, HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)
    
    --gravidade eixo x, y, false->atualiza o mundo o tempo todo
    world = wf.newWorld(0,800,false)
    world:setQueryDebugDrawing(true) -- visualiza o campo de busca
    world:addCollisionClass('platform')

    ground = world:newRectangleCollider(10, 300, 600, 60)
    ground:setType('static')
    ground:setCollisionClass('platform')

    player = Player(world) -- inicialização (metodo init() em ação)
    map = Map(world)
end

function love.update(dt)
    world:update(dt)
    player:update(dt)

end

function love.draw()
    push:start()
        world:draw()  --desenha o mundo
        map:draw() -- desenha o mapa
        player:draw() --deenha o player
    push:finish()
end

function love.keypressed(key)
    if key == 'w' or key == 'space' or key == 'up' then
        player:jump()
    end    
end