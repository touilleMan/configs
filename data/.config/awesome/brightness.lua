local awful = require("awful")
local wibox = require("wibox")


function get_brightness()
    fh = assert(io.popen("xrandr --current --verbose | grep Brightness", "r"))
    status = fh:read("*l")
    fh:close()

    return tonumber(string.match(status, "[0-9]\.[0-9]"))
end


function set_brightness(value)
	if value > 1.0 or value < 0.0 then
		return
	end
    awful.util.spawn("xrandr --output LVDS1 --brightness " .. tostring(value), false)
end


function up_brightness()
	current = get_brightness()
	set_brightness(current + 0.1)
end


function down_brightness()
	current = get_brightness()
	set_brightness(current - 0.1)
end
