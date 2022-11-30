Class = require 'class'
map = Class{}

EMPTY = -1
BRICK_ID = 19
BUSH_ID = 49
CLOUD_ID = 61
CAM_SPEED = 100
ROCK_ID = 48
FLOWER_ID = 46
TREE010_ID =  24
TREE02_ID =  31
TREE03_ID =  38
WATER_ID = 41


function map:init()   

    math.randomseed(os.time())                                                              
    self.tileset = love.graphics.newImage("nature-paltformer-tileset-16x16.png")    
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 40
    self.mapHeight = 26
    self.tileMap = {}
    --     self.brick = love.graphics.newQuad(4*self.tileWidth, 2*self.tileHeight,
    --     self.tileWidth, self.tileHeight, 
    --     self.tileset:getWidth(), self.tileset:getHeight())
        
    self.tileQuad = self:creatQuads()   
    
    self.camX = 0
    self.camY = 0 
    
    for i=1, self.mapHeight * self.mapWidth do
        self.tileMap[i] = EMPTY
    end
    

   --  self:setTile(10,1,CLOUD_ID) -- UMA NUVEM NA COLUNA 10 LINHA 1
   -- self:setTile(11,1,CLOUD_ID)
   --  self:setTile(15,5,CLOUD_ID)
   -- self:setTile(40,3,CLOUD_ID)
   -- self:setTile(5,2,CLOUD_ID)

    self:genetateWorld()

   --      self.tileMap[3*40 + 18] = 61



end

function map:draw()
    local tile_id
    for i=1, self.mapHeight do      -- PARA CADA LINHA  
        for j=1, self.mapWidth do   -- PERCORRE TODAS AS COLUNAS 
            tile_id = self:getTile(j,i)
            if tile_id ~= EMPTY then
                love.graphics.draw(self.tileset, self.tileQuad[tile_id], 
                self.tileWidth * (j-1), self.tileHeight * (i-1))
            end
        end
    end
end 

function map:creatQuads() --   GENERICO 

    local tiles = {}
    local rows = self.tileset:getHeight() / self.tileHeight
    local cols = self.tileset:getWidth() / self.tileWidth

    for i = 1, rows do
        for j = 1, cols do
           tiles[(i-1) * cols + j] = love.graphics.newQuad(
                (j-1) * self.tileWidth,
                (i-1) * self.tileHeight,
                self.tileWidth, self.tileHeight, 
                self.tileset:getWidth(), self.tileset:getHeight()) 
        end
    end

    return tiles

end

function map:update(dt)

    if love.keyboard.isDown('right')then
        self.camX = math.max(self.camX - CAM_SPEED * dt, -(self.tileWidth * self.mapWidth - width))
    elseif love.keyboard.isDown('left')then
        self.camX = math.min(self.camX + CAM_SPEED * dt, 0)
    elseif love.keyboard.isDown('up')then
        self.camY = math.min(self.camY + CAM_SPEED * dt, 0)
    elseif love.keyboard.isDown('down')then
        self.camY = math.max(self.camY - CAM_SPEED * dt, -(self.tileHeight * self.mapHeight - height))
    end

end

function map:getTile(x,y)
    return self.tileMap[(y-1) * self.mapWidth + x]
end

function map:setTile(x,y, tileId)
    self.tileMap[(y-1) * self.mapWidth + x] = tileId
end

function map:genetateWorld() -- PROCEDURAL 
   
    for x=1, self.mapWidth do

       if math.random(1,10) == 1 then  -- NUVEM
            y = math.random(1,math.ceil(self.mapHeight/2) - 5) -- ALTURA DA NUVEM
            self:setTile(x, y, CLOUD_ID)
        
        end

        if math.random(1,15)  == 1 then
            self:setTile(x, self.mapHeight, WATER_ID)
            
        else
            for y=math.ceil(self.mapHeight/2) + 1, self.mapHeight do         -- CONSTRUIR PAVIMENTO
                self:setTile(x,y, BRICK_ID)
            end
        end

        y = math.ceil(self.mapHeight/2) -- ALTURA IMEDIATAMENTE ACIMA DO PAVIMENTO

        if self:getTile(x, y + 1) == BRICK_ID then
            --FLORES
             if math.random(1,26)  == 1 then                       
                self:setTile(x,y, FLOWER_ID)
        
            --PEDRA
            elseif math.random(1,20) == 1 then
                self:setTile(x,y, ROCK_ID)

            --ARBUSTO
            elseif math.random(1,10) == 1 then
                self:setTile(x,y, BUSH_ID)
            
            --ARVORE
            elseif math.random(1,10) == 1 then
                self:setTile(x,y, TREE3_ID)
                self:setTile(x,y-1, TREE2_ID)
                self:setTile(x,y-2, TREE1_ID)
            end
        end


    end
end