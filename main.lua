local colors = require "colors"
local util = require "util"
local session = {}

local function _grain(_type,x,y,r,g,b,a)
	return {type = _type,x,y,r,g,b,a,status = 'falling'}
end

local function newgrain(grains,_type,x,y)
	local c = colors[_type]
	table.insert(grains,_grain(_type,x,y,util.array.unpack(c)))
end

local function _map(grains)
	local map = util.matrix.new(session.width,session.height,0)
	for i, v in ipairs(grains) do
		map[v[1]][v[2]] = v or 0
	end
	return map
end

function love.load()
	session.width = love.graphics.getWidth()
	session.height = love.graphics.getHeight()
	session.grain = {}
	for i = 1, 100000, 1 do
		newgrain(session.grain,'sand',util.random(1,session.width),util.random(1,session.height))
	end
	session.map = _map(session.grain)
end

local function gravit(map,obj,modx,mody)
	modx = modx or 0
	mody = mody or 0
	session.map[obj[1]+modx][obj[2]+mody] = session.map[obj[1]][obj[2]]
	session.map[obj[1]][obj[2]] = 0
	obj[1] = obj[1] +modx
	obj[2] = obj[2] +mody 
end

function love.update()
	--session.map = _map(session.grain)
	for i, grain in ipairs(session.grain) do
		if grain[2] < session.height then
			if session.map[grain[1]][grain[2]+1] == 0 then
				gravit(session.map,grain,0,1)
			elseif session.map[grain[1]+1] and session.map[grain[1]+1][grain[2]+1] == 0 then
				gravit(session.map,grain,1,1)
			elseif session.map[grain[1]-1] and session.map[grain[1]-1][grain[2]+1] == 0 then
				gravit(session.map,grain,-1,1)
			else
				grain.status = 'stable'
			end
		end
	end
end

function love.draw()
	--love.graphics.setColor(1, 1, 1)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 1, 1)
	love.graphics.points(session.grain)
end