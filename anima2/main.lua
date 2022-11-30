width = love.graphics.getWidth()
height = love.graphics.getHeight()
BALL_SPEED = 15

function love.load()
    love.window.setMode(width, height)
    image = love.graphics.newImage('ken.png')
    img_width = image:getWidth()
    img_height = image:getHeight()
    -- a folha tem 10 linhas e 7 sprites por linha 
    sprite_width = img_width / 7
    sprite_heigth = img_height / 10
    -- A Marcação para o recorte
    sprites = {}
    sprites.idle = get_sprites_by_row(2,4)
    sprites.hadouken = get_sprites_by_row(1,4)
    sprites.hadouken_ball = get_sprites_by_row(5,2)

    ball = {x = (img_width/7)-5, curFrame = 1, show = false}
    
    


    player = {curFrame = 1, state = 'idle'}
    
                             
end

function love.update(dt)
        player.curFrame = player.curFrame + 7*dt
        if player.state == 'hadouken' then
            if math.floor(player.curFrame) == 4 then
                ball.show = true
            end
            --Se último frame do hadouken, muda p/ estado ocioso
            if math.floor(player.curFrame) >= 5 then
                player.state = 'idle'
            end
        end
        if player.curFrame >= 5 then
            player.curFrame = 1
        end
        if ball.show then
            ball.x = ball.x + BALL_SPEED * dt
            ball.curFrame = ball.curFrame + 8*dt
            if ball.curFrame >= 3 then
                ball.curFrame = 1
            end
            --ball hadouken chega ao fim da tela
            if ball.x > width then
                ball.show = false
                ball.x = (img_width/7)-5
                ball.curFrame = 1
            end
        end
end

function love.draw()
    local idx = math.floor(player.curFrame)
    if player.state == 'idle' then
        love.graphics.draw(image, sprites.idle[idx], 30, 30)
    elseif player.state == 'hadouken' then
        love.graphics.draw(image, sprites.hadouken[idx], 30, 30)
    end
    if ball.show then
        local idx = math.floor(ball.curFrame)
        love.graphics.draw(image, sprites.hadouken_ball[idx], ball.x ,25)
    end
end

function get_sprites_by_row(row, numSprites)
    local sprites= {}
    for i=0,numSprites-1 do
        sprite = love.graphics.newQuad(
                            i* sprite_width, 
                            (row-1)*sprite_heigth,
                            sprite_width, sprite_heigth,
                            img_width, img_height
                            )
        table.insert(sprites, sprite)
    end
    return sprites
end

function love.keypressed(key)
    if key == 'h' then
        player.state = 'hadouken'
        player.curFrame = 1
    end
end