
function love.load()
    scale = 0.4
    frames = {}
    for i = 1,10 do
        frame = love.graphics.newImage("freeknight/png/Run ("..i..").png")
        table.insert(frames, frame)
    end

    curFrame=1
end

function love.update(dt)
    curFrame = curFrame + 16*dt
    if curFrame > 10 then
        curFrame = 1
    end
end

function love.draw()
    idx = math.floor(curFrame)
    love.graphics.draw(frames[idx], 0, 0, 0, scale, scale)
    
end

function love.keypressed(key)

end