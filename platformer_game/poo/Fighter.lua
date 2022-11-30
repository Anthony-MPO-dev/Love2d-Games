Fighter = Class {}

function Fighter:init(name, width, height, color)
    -- Construtor
    self.name = name
    self.w = width
    self.h = height
    self.color = color
end

function Fighter:sayHello()
    love.graphics.print("Oi, Meu nome é ".. self.name)
end

function Fighter:draw(x, y)
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', x, y, self.w, self.h)
end

