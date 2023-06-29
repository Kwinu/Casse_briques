-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

local pad = {}
pad.largeur = 80
pad.hauteur = 20
pad.x = 0
pad.y = 0

local balle = {}
balle.rayon = 10
balle.colle = false
balle.x = 0
balle.y = 0
balle.vx = 0
balle.vy = 0

local brick = {}
local niveau = {}

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

function Demarre()
    balle.colle = true
    local l, c
    niveau = {}
    for l = 1, 6 do
        niveau[l] = {}
        for c = 1, 15 do
            niveau[l][c] = 1
        end
    end
end

function love.load()
    largeur = love.graphics.getWidth()
    hauteur = love.graphics.getHeight()

    brick.hauteur = 25
    brick.largeur = largeur / 15

    pad.y = hauteur - (pad.hauteur / 2)

    Demarre()
end

function love.update(dt)
    pad.x = love.mouse.getX()

    if balle.colle == true then
        balle.x = pad.x
        balle.y = pad.y - pad.hauteur / 2 - balle.rayon
    else
        balle.x = balle.x + (balle.vx * dt)
        balle.y = balle.y + (balle.vy * dt)
    end

    -- collision briques
    local c = math.floor(balle.x / brick.largeur) + 1
    local l = math.floor(balle.y / brick.hauteur) + 1

    if l >= 1 and l <= #niveau and c >= 1 and c <= 15 then
        if niveau[l][c] == 1 then
            balle.vy = -balle.vy
            niveau[l][c] = 0
        end
    end

    -- collision sur les murs

    if balle.x > largeur then
        balle.vx = -balle.vx
        balle.x = largeur
    end

    if balle.x < 0 then
        balle.vx = -balle.vx
        balle.x = 0
    end

    if balle.y < 0 then
        balle.vy = -balle.vy
        balle.y = 0
    end

    if balle.y > hauteur then
        balle.colle = true
    end

    -- collision sur le pad

    local posCollisionPad = pad.y - (pad.hauteur / 2) - balle.rayon
    if balle.y > posCollisionPad then
        -- distance du pad
        local distPad = math.abs(pad.x - balle.x)
        if distPad < pad.largeur / 2 then
            balle.vy = -balle.vy
            balle.y = posCollisionPad
        end
    end
end

function love.draw()
    brick.x = 0
    brick.y = 0
    -- pour chaque ligne
    local l, c
    for l = 1, 6 do
        brick.x = 0
        -- pour chaque colonne
        for c = 1, 15 do
            if niveau[l][c] == 1 then
                --dessine

                love.graphics.rectangle("fill", brick.x + 1, brick.y + 1, brick.largeur - 2, brick.hauteur - 2)
            end
            brick.x = brick.x + brick.largeur
        end
        brick.y = brick.y + brick.hauteur
    end

    love.graphics.rectangle("fill", pad.x - (pad.largeur / 2), pad.y - (pad.hauteur / 2), pad.largeur, pad.hauteur)
    love.graphics.circle("fill", balle.x, balle.y, balle.rayon)
end

function love.keypressed(key)
end

function love.mousepressed(x, y, n)
    if balle.colle == true then
        balle.colle = false
        balle.vx = 200
        balle.vy = -200
    end
end
