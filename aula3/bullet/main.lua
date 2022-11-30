function love.load()
    --o tipo da bala que pode ser reutilizada
    bullet = love.graphics.newImage("bala.png")
    speed = 200 -- 20 pixels por segundo
    x = 0
    y = 150
    x2 = 0
    y2 = 250
    w = love.graphics.getWidth()
    h = love.graphics.getHeight()

    xscale = 0.5
    x2scale = 1

end

--atualizada 60 vezes por segundo
function love.update(dt)
    x = x + speed * dt
    x2 = x2 + speed * dt
    if x >= w then
        x = w
        --deformar a bala (achatamento)
        if xscale > 0.2 then
            xscale = xscale - 1.5*dt
        end
    end
    if x2 >= w then
        x2 = w
        --deformar a bala (achatamento)
        if x2scale > 0.4 then
            x2scale = x2scale - 2*dt
        end

        --reseta as bala
        if x2scale < 0.4 then
            x2 = 0
            x2scale = 1
        end
        if xscale < 0.4 then
            x = 0
            xscale = 0.5
        end
    end

   
end

function love.draw()
    love.graphics.setBackgroundColor(0/255, 138/255, 197/255)

    --sol
    love.graphics.setColor(243/255, 197/255, 48/255)
    love.graphics.circle("fill",600,120,100);
   

    -- x, y atualiza a posição do objeto
    --bullet
    love.graphics.draw(bullet, x, y, 0, xscale*-1, 0.5)

    --tree
    love.graphics.setColor(83/255, 120/255, 27/255)
    love.graphics.rectangle("fill", 60, 180, 170, 150)
    love.graphics.setColor(83/255, 35/255, 27/255)
    love.graphics.rectangle("fill", 120, 300, 45, 150)
   

    --bullet
    love.graphics.draw(bullet, x2, y2, 0, x2scale*-1, 1)

    --grama
    love.graphics.setColor(63/255 , 192/255, 21/255) 
    love.graphics.rectangle("fill", 0, 450, 800, 300)

    --solo
    love.graphics.setColor(222/255 , 192/255, 93/255) 
    love.graphics.rectangle("fill", 0, 480, 800, 200)

     


    


end
