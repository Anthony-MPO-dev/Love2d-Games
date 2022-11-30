wf = require 'lib/windfield'
math.randomseed(os.time())

function love.load()
    
    world = wf.newWorld(0, 300, false)
    side = 64
    radius = 31
    speed = 200
    sprite = love.graphics.newImage('interface.png')

    world:setQueryDebugDrawing(true)

    for i=1, 10 do

        x = math.random(1, 600)
        y = math.random(1, 500)

        box = world:newRectangleCollider(x, y, side, side)
        box:setRestitution(0.8)
    end

    ground = world:newRectangleCollider(0,500,800,100)
    ground:setType('static')
    ground = world:newRectangleCollider(200,300,300,30)
    ground:setType('static')


    x = math.random(1, 600)
    y = math.random(1, 500)
    player = world:newRectangleCollider(x, y, side, side)
    player:setFixedRotation(true)
    player:setRestitution(0)

end


function love.update(dt)
   
    px = player:getX() -- posição no eixo x do player 

    if love.keyboard.isDown('a') then
            px = px - speed * dt
    elseif love.keyboard.isDown('d') then
        px = px + speed * dt

    end

    player:setX(px)
    world:update(dt)

end

function love.keypressed(key)
    if key == 'w' then
        player:applyLinearImpulse(0,-2200)

    end

    if key == 'q' then
        colliders = world:queryCircleArea(player:getX(), player:getY(), 200)
        
        for i, collider in ipairs(colliders) do
            if collider ~= player and player:getX() <= collider:getX() then
                collider: applyLinearImpulse(3000,0)
            elseif collider ~= player then
                collider: applyLinearImpulse(-3000,0)
            end
        end
    end
end

function love.draw()
    love.graphics.clear(0,151/255, 226/255)
    world:draw()

    love.graphics.draw(sprite, player:getX()-side/2, player:getY()-side/2)

end