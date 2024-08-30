--Milk Journey

function _init()
    day = true
end

function _update()

end

function _draw()
    if day then
        cls(15)
    else
        cls(0)
    end
    draw_player()
    player_input()

    -- draw tiles in map
    map(0, 0, 0, 0, 6, 2)
end
