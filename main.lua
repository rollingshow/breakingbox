require "vector"
require "particle"

function love.load()
    math.randomseed(os.time())

    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    systems = {}

    for i = 1, 20 do
        systems[i] = BreakingBox:create(Vector:create(math.random(0, width), math.random(0, height)), BreakingBoxParticle, math.random(10, 200))
    end
end

function love.update( dt )
    for k, v in pairs(systems) do
        v:update()
    end
end

function love.draw()
    for k, v in pairs(systems) do
        v:draw()
    end
end

function love.mousepressed( x, y, button )
    for k, v in pairs(systems) do
        v:checkClick(x, y)
    end
end

