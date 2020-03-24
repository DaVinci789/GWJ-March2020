extends Node2D

enum Directions {
    NORTH,
    SOUTH,
    EAST,
    WEST,
}

# 12 * 16 == 192
const ROOM_WIDTH = 192
const ROOM_HEIGHT = 192

const order_room_scene = preload("res://rooms/order_room/order_room.tscn")

const room_scenes = {
    "order_room": preload("res://rooms/order_room/order_room.tscn")
}

func _ready():
    randomize()
    add_child(order_room_scene.instance())

    var next_room: TileMap = room_scenes[room_scenes.keys()[randi() % room_scenes.keys().size()]].instance()
    match Directions.values()[randi() % Directions.values().size()]:
        Directions.NORTH:
            next_room.position = Vector2(0,-1) * ROOM_HEIGHT
        Directions.SOUTH:
            next_room.position = Vector2(0,1) * ROOM_HEIGHT
        Directions.EAST:
            next_room.position = Vector2(1,0) * ROOM_WIDTH
        Directions.WEST:
            next_room.position = Vector2(-1,0) * ROOM_WIDTH
        _:
            print("Uh oh...")
    add_child(next_room)
    move_child($player, self.get_children().size())
