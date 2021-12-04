BreakingBoxParticle = {}
BreakingBoxParticle.__index = BreakingBoxParticle

function BreakingBoxParticle:create(location, size, velocity, type)
    local bb_particle = {}
    setmetatable(bb_particle, BreakingBoxParticle)

    bb_particle.location = location
    bb_particle.size = size
    bb_particle.type = type
    bb_particle.acceleration = Vector:create(0, 0.1)
    bb_particle.velocity = velocity
    bb_particle.lifespan = 100
    bb_particle.decay = math.random(3, 8) / 10
    bb_particle.active = false

    return bb_particle
end

function BreakingBoxParticle:update()
    if (self.active) then
        self.velocity:add(self.acceleration)
        self.location:add(self.velocity)
        -- self.acceleration:mul(0)
        self.lifespan = self.lifespan - self.decay
    end
end

function BreakingBoxParticle:applyForce(force)
    self.acceleration:add(force)
end

function BreakingBoxParticle:isDead()
    return self.lifespan < 0
end

function BreakingBoxParticle:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(1, 1, 1, self.lifespan / 100)
    if (self.type == "h") then
        love.graphics.line(
            self.location.x - self.size / 2,
            self.location.y,
            self.location.x + self.size / 2,
            self.location.y
        )
    elseif (self.type == "v") then
        love.graphics.line(
            self.location.x,
            self.location.y - self.size / 2,
            self.location.x,
            self.location.y + self.size / 2
        )
    end
    love.graphics.setColor(r, g, b, a)
end


BreakingBox = {}
BreakingBox.__index = BreakingBox

function BreakingBox:create(loc, cls, size)
    local breakingbox = {}
    setmetatable(breakingbox, BreakingBox)

    -- Опциональные параметры
    breakingbox.cls = cls or BreakingBoxParticle
    breakingbox.location = loc
    breakingbox.size = size or 10
    breakingbox.particleLimit = lmt or 10

    -- Стандартные параметры
    breakingbox.particles = {}
    breakingbox.active = false
    local vec_y = Vector:create(0, breakingbox.size / 2)
    local vec_x = Vector:create(breakingbox.size / 2, 0)

    breakingbox.particles[0] =
        breakingbox.cls:create(
        breakingbox.location:copy() - vec_y,
        size,
        Vector:create(math.random(-100, 100) / 100, math.random(-400, 0) / 100),
        "h"
    )
    breakingbox.particles[1] =
        breakingbox.cls:create(
        breakingbox.location:copy() + vec_x,
        size,
        Vector:create(math.random(0, 200) / 100, math.random(-100, 100) / 100),
        "v"
    )
    breakingbox.particles[2] =
        breakingbox.cls:create(
        breakingbox.location:copy() + vec_y,
        size,
        Vector:create(math.random(-100, 100) / 100, math.random(0, 50) / 100),
        "h"
    )
    breakingbox.particles[3] =
        breakingbox.cls:create(
        breakingbox.location:copy() - vec_x,
        size,
        Vector:create(math.random(-200, 0) / 100, math.random(-100, 100) / 100),
        "v"
    )
    
    return breakingbox
end

function BreakingBox:draw()
    -- Отрисовка частиц
    for k, v in pairs(self.particles) do
        v:draw()
    end
end

function BreakingBox:update()
    -- Обработка частиц
    for k, v in pairs(self.particles) do
        -- Обновление частиц
        v:update()
    end
end

function BreakingBox:checkClick(x, y)
    if
        (x > self.location.x - (self.size / 2) and x < self.location.x + (self.size / 2) and
            y > self.location.y - (self.size / 2) and
            y < self.location.y + (self.size / 2))
     then
        for k, v in pairs(self.particles) do
            v.active = true
        end
    end
end
