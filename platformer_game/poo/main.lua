Class = require 'class'
        require 'Fighter'


-- Instancia a classe Fighter (cria um objeto)
-- Fighter("Nome", "Largura", "Altura", cor)
blanka = Fighter("Blanka", 80, 80, {0, 0.6, 0.0})
honda = Fighter("Honda", 160, 80, {0.2, 0.4, 0.4})


function love.draw()
   blanka:draw(20, 30)
   honda:draw(160, 30)
end
        
-- width = love.graphics.getWidth()
-- height = love.graphics.getHeight()

-- fighter = {} -- Lista
-- fighter.name = "Blanka"
-- --    fighter.sayHello = function (msg)
-- --        love.graphics.print("Oi, Meu nome é ".. msg)
-- --    end

-- function fighter:sayHello()
--     love.graphics.print("Meu nome é ".. self.name)
-- end

-- function fighter:scream()
--     love.graphics.print("ARRRRRRRRGH!")
-- end

-- function fighter.kick()
--     --códig da função
--     love.graphics.print("Um chute!")
-- end

-- function love.draw()
--     --fighter.kick()
--     --fighter.sayHello(fighter.name)
--     fighter:sayHello()
--     --fighter:scream()
-- end