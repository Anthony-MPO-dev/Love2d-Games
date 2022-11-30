function love.load()
    bullet = love.graphics.newImage("bala.png")
    x = 0
    y = 100
    x2 = 0
    y2 = 400
end

function love.update(dt)
    x = x + 4
    x2 = x2 + 2
end

function love.draw()
    love.graphics.setBackgroundColor(0/255, 138/255, 197/255)
    love.graphics.draw(bullet, x, y, 0, -0.5, 0.5)
    love.graphics.draw(bullet, x2, y2, 0, -1, 1)
end
