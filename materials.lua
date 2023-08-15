
local util = require('util')
local rgb = function (r,g,b,a)
    return 
    {
        util.math.regrad3(1,255,r),
        util.math.regrad3(1,255,g),
        util.math.regrad3(1,255,b),
        util.math.regrad3(1,255,a or 255),
    }
end

local material = {}
material.air =
{
    color = rgb(0, 0, 0, 0),
    density = 0
}
material.sand =
{
    color = rgb(187, 184, 125),
    density = 1.6
}
material.stone =
{
    color = rgb(114, 114, 114),
    density = 2.6
}
material.dirt =
{
    color = rgb(71, 54, 23),
    density = 1.6
}
return material