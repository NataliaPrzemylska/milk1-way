player = {
    x = 10,
    y = 10,
    sp = 0,
    width = 6,
    height = 7,
}

animation_speed = 0.5

function animate_player()
    if player.sp <= 3 then
        player.sp += animation_speed
    else
        player.sp = 0
    end
end

function draw_player()
    spr(255, player.x, player.y)
end
