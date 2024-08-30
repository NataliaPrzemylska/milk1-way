--Milk Journey

function _init()
    day = true
    journey_days = 0
    debug = false
end

function _update()
    for obj in all(current_objects) do
        if obj.spd != nil then
            obj.x += obj.spd
        end
    end
end

function _draw()
    if day then
        cls(15)
    else
        cls(0)
    end
    draw_player()
    player_input()

    -- draw a screen of tiles in map
    map(0, 0, 0, 0, 16, 16)

    for obj in all(current_objects) do
        if obj.day == day then
            obj.draw(obj)
        end
    end
end
