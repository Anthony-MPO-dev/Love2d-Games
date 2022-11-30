Map = Class {}

function Map:init(world)
    self.world = world
    self.gameMap = sti('maps/level1.lua')
end

function Map:update(dt)
    
end

function Map:draw()
    self.gameMap:drawLayer(self.gameMap.layers['Camada de Blocos 1'])
    self.gameMap:drawLayer(self.gameMap.layers['Camada de Blocos 2'])
end