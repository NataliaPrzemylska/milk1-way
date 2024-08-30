current_objects = {

}

car = {
    x = 140
    y = 112
    spr = 33
    draw = draw_car,
    day = true,
    spd = 10,
    width = 16,
    height = 7
}

function draw_car(c)
    spr(c.spr, c.x, c.y)
    spr(c.spr+1, c.x+8, c.y)
end
