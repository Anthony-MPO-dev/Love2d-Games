      
WINDOW_WIDTH = love.graphics.getWidth()
WINDOW_HEIGHT = love.graphics.getHeight()

--dimensões virtuais
WIDTH = 512
HEIGHT = 288

push =  require 'push'
        require 'Map'

world = Map()

function love.load()
        math.randomseed(os.time())	
        love.graphics.setDefaultFilter('nearest', 'nearest')
        push:setupScreen(WIDTH, HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)
end

function love.update(dt)
        world:update(dt)
end

function love.draw()
        push:start()
        love.graphics.translate(math.ceil(world.camX), math.ceil(world.camY))
        love.graphics.clear(104/255, 19/255, 238/255)
        world:draw()
        push:finish()
end

