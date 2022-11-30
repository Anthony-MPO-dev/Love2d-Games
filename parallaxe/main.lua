width = love.graphics.getWidth()
height = love.graphics.getHeight()

virtual_width = 3840
virtual_height = 2160

push = require 'push'

function love.load()
    
    push:setupScreen(virtual_width, virtual_height, width, height)
    
    love.window.setMode(width, height)
    bg = love.graphics.newImage('seaview_background.png')
    fg = love.graphics.newImage('seaview_foreground_empty.png')
    fgc = love.graphics.newImage('seaview_foreground.png')
    xbg = 0
    xfg = 0
    bg_speed = 10
    fg_speed = 300
end

function love.update(dt)
    xbg = (xbg - bg_speed* dt) % -virtual_width
    xfg = (xfg - fg_speed* dt) % -virtual_width
end

function love.draw()
    push:start()
    love.graphics.draw(bg, xbg, 0)
    love.graphics.draw(bg, virtual_width+xbg, 0)
    love.graphics.draw(fg, xfg, 0)
    love.graphics.draw(fg, virtual_width+xfg, 0)
    push:finish()
end