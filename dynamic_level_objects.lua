
function update_car(c)
    if (player.x<=c.x+16 and player.x>=c.x-8) and (player.y<=c.y+8 and player.y>=c.y-8) then
        sfx_boom()
        dead()
    end
    if c.spd != nil then
        if c.x*(c.spd > 0 and 1 or -1)>c.destination_x  then
            c.x=c.spawn_x
        end
            c.x += c.spd
    end

end

function draw_car(c)
    spr(c.spr, c.x, c.y)
    spr(c.spr+1, c.x+8, c.y)
end

car = {
    spawn_x = -32,
    destination_x = 140,
    x = -8,
    y = 80,
    spr = 32,
    draw = draw_car,
    update = update_car,
    day = true,
    spd = 15,
    width = 16,
    height = 7
}
current_objects = {
}