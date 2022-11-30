Class = require 'class'

Map = Class {}

CAM_SPEED  = 100
EMPTY      = -1
BRICK_ID   = 19 --posição do brick no tilemap
DUST_ID    = 16
GRASS_ID   = 2
BUSH_ID    = 49
CLOUD_ID   = 54
ROCK_ID    = 48
FLOWER_ID  = 46
TREE_ROOT_ID = 24
TREE_TRUNK_ID  = 31
TREE_LEAF_ID  = 38
WATER_ID   = 41



function Map:init()
    math.randomseed(os.time())	
    self.tileset = love.graphics.newImage("nature2-paltformer-tileset-16x16.png") --importa tilemap
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth  = 40
    self.mapHeight = 26
    self.tileMap = {}

    self.tileQuads = self:createQuads()

    self.camX = 0
    self.camY = 0

    -- self.brick = love.graphics.newQuad(4*self.tileWidth, 
    --                 2*self.tileHeight,
                    -- self.tileWidth, self.tileHeight,
                    -- self.tileset:getWidth(),
                    -- self.tileset:getHeight())
    
 
    


    for i=1, self.mapHeight * self.mapWidth do
        self.tileMap[i] = EMPTY
    end

  

    self:generateWorld()

    -- self:setTile(10, 1, CLOUD_ID)
    -- self:setTile(11, 1, CLOUD_ID)
    -- self:setTile(12, 1, CLOUD_ID)
    -- self:setTile(13, 1, CLOUD_ID)
    -- self:setTile(14, 1, CLOUD_ID)

    -- self:setTile(32, 1, CLOUD_ID)
    -- self:setTile(33, 1, CLOUD_ID)
    -- self:setTile(34, 1, CLOUD_ID)
    -- self:setTile(35, 1, CLOUD_ID)

    -- self:setTile(20, 2, CLOUD_ID)
    -- self:setTile(21, 2, CLOUD_ID)
    -- self:setTile(22, 2, CLOUD_ID)

    -- self:setTile(30, 5, CLOUD_ID)
    -- self:setTile(31, 5, CLOUD_ID)
    -- self:setTile(32, 5, CLOUD_ID)

    -- self:setTile(8, 5, CLOUD_ID)
    -- self:setTile(9, 5, CLOUD_ID)
    -- self:setTile(10, 5, CLOUD_ID)
    -- self:setTile(11, 5, CLOUD_ID)
    -- self:setTile(12, 5, CLOUD_ID)
    -- self:setTile(13, 5, CLOUD_ID)

    

end

function Map:draw()
    local tile_id
    for i=1, self.mapHeight do -- para cada linha
        for j=1, self.mapWidth do -- percorre todas as colunas
            tile_id = self:getTile( j, i )
            if tile_id ~= EMPTY then
                love.graphics.draw(self.tileset, self.tileQuads[tile_id], 
                                   self.tileWidth*(j-1), self.tileHeight*(i-1))
            end
        end
    end 
end

function Map:createQuads()
    local tiles = {}
    local rows = self.tileset:getHeight() / self.tileHeight
    local cols = self.tileset:getWidth() / self.tileWidth
    
    for row = 1, rows do
        for col =1, cols do
            tiles [((row-1)*cols) + col] = love.graphics.newQuad(
                                            (col-1) * self.tileWidth, -- COLUNA
                                            (row-1) * self.tileHeight, -- LINHA
                                            self.tileWidth, self.tileHeight,
                                            self.tileset:getWidth(), self.tileset:getHeight())
        end
    end


    return tiles
end


function Map:update(dt)
    if love.keyboard.isDown('right') then
       self.camX = math.max(self.camX - CAM_SPEED * dt, -(self.mapWidth * self.tileWidth - WIDTH))
    elseif love.keyboard.isDown('left') then
        self.camX = math.min(self.camX + CAM_SPEED * dt, 0)
    elseif love.keyboard.isDown('up') then
        self.camY = math.min(self.camY + CAM_SPEED * dt, 0) 
    elseif love.keyboard.isDown('down') then
        self.camY = math.max(self.camY - CAM_SPEED * dt, 
        -(self.mapHeight * self.tileHeight - HEIGHT)) 
    end

end


function Map:getTile(x, y)
    return self.tileMap[((y-1) * self.mapWidth + x)]
end


function Map:setTile( x, y, tileId ) 
    self.tileMap[((y-1) * self.mapWidth + x)] = tileId
end



function Map:generateWorld() -- Geraçao procedural do mundo

    for x=1, self.mapWidth do

       if math.random(1,8) == 1 then  -- NUVEM
            y = math.random(1,math.ceil(self.mapHeight/2) - math.random(4,8))  -- define altura das nuvens aleatoriamente
            self:setTile(x, y, CLOUD_ID) -- Gera Nuvens
        
        end

        if math.random(1,8)  == 2 then -- Gera poços e Preenche o fundo com água)
            self:setTile(x, self.mapHeight, WATER_ID)
            
        else
            for y=math.ceil(self.mapHeight/2) + 1, self.mapHeight do -- Construir a plataforma
                self:setTile(x,y, BRICK_ID)
            end
        end

        y = math.ceil(self.mapHeight/2) -- Captura altura maxima da plataforma

        --se tiver chão coloque :
        if self:getTile(x, y + 1) == BRICK_ID then

            --bushes
            if math.random(1,5) == 1 then
                self:setTile(x,y, BUSH_ID)
        
            --flowers
            elseif math.random(1,8)  == 1 then                       
                self:setTile(x,y, FLOWER_ID)
        
            --rocks
            elseif math.random(1,15) == 1 then
                self:setTile(x,y, ROCK_ID)

            --trees
            elseif math.random(1,6) == 1 then
                self:setTile( x,y,   TREE_LEAF_ID )
                self:setTile( x,y-1, TREE_TRUNK_ID)
                self:setTile( x,y-2, TREE_ROOT_ID )
            end
        end

    end
end