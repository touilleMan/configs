local wibox = require("wibox")


--[[ Possibles acpi outputs:
Battery 0: Charging, 99%, 00:03:41 until charged
Battery 0: Charging, 99%, charging at zero rate - will never fully charge.
Battery 0: Unknown, 99%
Battery 0: Discharging, 99%, 02:21:23 remaining
Battery 0: Discharging, 99%, discharging at zero rate - will never fully discharge.
Battery 0: Full, 100%
]]--


function update_battery(widget)
    fh = assert(io.popen("acpi", "r"))
    status = fh:read("*l")
    fh:close()

    charge_level = string.match(status, "[0-9]+%%")
    if not charge_level then
        charge_level = '?%'
    end
    -- add padding
    charge_level = string.rep(' ', 4 - string.len(charge_level)) .. charge_level

    remaining = string.match(status, "[0-9][0-9]:[0-9][0-9]:[0-9][0-9]")
    if remaining then
        -- discare seconds
        remaining = string.sub(remaining, 0, -4)
    else
        -- replace remainingtime by padding
        remaining = "     "
    end

    is_charging = string.match(status, "Charging")
    if is_charging then
        charge_state = "▲"
    else
        charge_state = "▼"
    end

    widget:set_text(" |" .. charge_level .. charge_state .. remaining .. " | ")
end    


function create_battery_widget()
    battery_widget = wibox.widget.textbox()
    battery_widget:set_text(" | Battery | ")
    battery_widget_timer = timer({ timeout = 10 })
    battery_widget_timer:connect_signal("timeout", function()
        update_battery(battery_widget)
    end)
    battery_widget_timer:start()
    update_battery(battery_widget)
    return battery_widget
end
