local material = require "materials"
local util = require "util"
local session = {}

local function _grain(_material, _density, x, y, r, g, b, a)
	return { material = _material, density = _density, x, y, r, g, b, a }
end

local function newgrain(grains, _material, x, y)
	local c = material[_material]
	if session.map[x][y].material ~= 'air' then
		return
	end
	table.insert(grains, _grain(_material, c.density, x, y, util.array.unpack(c.color)))
	session.map[x][y] = grains[#grains]
end

local function _map(grains)
	local map = {}
	for x = 0, session.width, 1 do
		map[x] = {}
		for y = 0, session.height, 1 do
			map[x][y] = _grain('air', 0, x, y,0,0,0,0)
		end
	end
	for i, v in ipairs(grains) do
		map[v[1]][v[2]] = v
	end
	return map
end

function love.load()
	session.width = love.graphics.getWidth()
	session.height = love.graphics.getHeight()
	session.grain = {}
	session.gdirection = 1
	session.map = _map({})
	for i = 1, 10000, 1 do
		newgrain(session.grain, 'sand', util.random(1, session.width), util.random(1, session.height-100))
		newgrain(session.grain, 'stone', util.random(1, session.width), util.random(1, session.height))
		newgrain(session.grain, 'dirt', util.random(1, session.width), util.random(100, session.height))
	end
end

local function gravit(obj, modx, mody)
	session.map[modx][mody],session.map[obj[1]][obj[2]] = session.map[obj[1]][obj[2]],session.map[modx][mody]
	session.map[modx][mody][1],session.map[modx][mody][2],session.map[obj[1]][obj[2]][1],session.map[obj[1]][obj[2]][2] = session.map[obj[1]][obj[2]][1],session.map[obj[1]][obj[2]][2],session.map[modx][mody][1],session.map[modx][mody][2]
end

local gdirections =
{ --down, left, up, right
	{ { -1, 1 }, { 0, 1 }, { 1, 1 } },
	{ { -1, -1 }, { -1, 0 }, { -1, 1 } },
	{ { 1, -1 }, { 0, -1 }, { -1, -1 } },
	{ { 1, 1 }, { 1, 0 }, { 1, -1 } },
}

function love.keypressed(key)
	if key == 'down' then
		session.gdirection = 1
	elseif key == 'left' then
		session.gdirection = 2
	elseif key == 'up' then
		session.gdirection = 3
	elseif key == 'right' then
		session.gdirection = 4
	end
end

function love.update()
	--session.map = _map(session.grain)
	for i, grain in ipairs(session.grain) do
		local xm, ym = grain[1] + gdirections[session.gdirection][2][1], grain[2] + gdirections[session.gdirection][2][2]
		local xl, yl = grain[1] + gdirections[session.gdirection][1][1], grain[2] + gdirections[session.gdirection][1][2]
		local xr, yr = grain[1] + gdirections[session.gdirection][3][1], grain[2] + gdirections[session.gdirection][3][2]
		if grain[2] <= session.height then
			if session.map[xm] and session.map[xm][ym] and (session.map[xm][ym].density < session.map[grain[1]][grain[2]].density) then
				gravit(grain, xm, ym)
			elseif session.map[xl] and session.map[xl][yl] and (session.map[xl][yl].density < session.map[grain[1]][grain[2]].density) then
				gravit(grain, xl, yl)
			elseif session.map[xr] and session.map[xr][yr] and (session.map[xr][yr].density < session.map[grain[1]][grain[2]].density) then
				gravit(grain, xr, yr)
			end
		end
	end
end

function love.draw()
	love.graphics.print("Current FPS: " .. tostring(love.timer.getFPS()), 1, 1)
	love.graphics.points(session.grain)
end
