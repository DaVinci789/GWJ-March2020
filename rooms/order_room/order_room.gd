extends "res://rooms/room_base.gd"

# opposite of direction
const supply_station_areas = {
    "south": [Vector2(5,2),Vector2(8,2),Vector2(11,2)],
    "north": [Vector2(4,13),Vector2(7,13),Vector2(10,13)],
    "west": [Vector2(13,5),Vector2(13,8),Vector2(13,11)],
    "east": [Vector2(2,4),Vector2(2,7),Vector2(2,10)],
}

const supply_station_scene = preload("res://supply_station/supply_station.tscn")

var counter := 0

func load_order_stations(where: String) -> void:
    var id = 0
    # set material supply stations
    for position in supply_station_areas[where]:
        var supply_station = supply_station_scene.instance()
        supply_station.position = map_to_world(position)
        supply_station.position += Vector2(8,8)

        if id != 0:
            supply_station.set_material_type("material" + str(id))
        else:
            supply_station.set_material_type("material")

        if id + 1 > 2:
            id = 0 
        else:
            id += 1

        add_child(supply_station)