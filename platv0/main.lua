window_width = 854
window_height = 480
--Dimensões virtuais
width = 480
height = 270

push = require 'push'
require 'map' -- Importa map.lua

mundo = map()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(width, height, window_width, window_height)
end

function love.update(dt)
    mundo:update(dt)
end

function love.draw()
    
    push:start()
    love.graphics.translate(math.ceil(mundo.camX), math.ceil(mundo.camY))
    love.graphics.clear(0,151/255, 226/255)
    mundo:draw()
    push:finish()

end
