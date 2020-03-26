extends Node2D

enum Directions {
	NORTH,
	SOUTH,
	EAST,
	WEST,
}

# 12 * 16 == 192
const ROOM_AMOUNT = 4
const TILE_SIZE   = 16

const order_room_scene = preload("res://rooms/order_room/order_room.tscn")

const room_scenes = {
	"dining_room1": preload("res://rooms/dining_room1/dining_room1.tscn"),
	"dining_room2": preload("res://rooms/dining_room2/dining_room2.tscn"),
	"dining_room3": preload("res://rooms/dining_room3/dining_room3.tscn"),
}

var rooms := []

func _ready():
	generate_rooms()

func generate_rooms():
	randomize()
	add_child(order_room_scene.instance())

	var current_direction := Vector2.ZERO
	rooms.append(current_direction)

	for i in ROOM_AMOUNT:
		var next_room := current_direction
		match Directions.values()[randi() % Directions.values().size()]:
			Directions.NORTH:
				next_room += Vector2(0,-1)
			Directions.SOUTH:
				next_room += Vector2(0,1)
			Directions.EAST:
				next_room += Vector2(1,0)
			Directions.WEST:
				next_room += Vector2(-1,0)
			_:
				print("Uh oh...")
		rooms.append(next_room)
		current_direction = next_room
	
	for room_position in rooms:
		# different for starting room
		if room_position == Vector2(0,0):
			var current_room: TileMap = order_room_scene.instance()
			current_room.position = Vector2(0,0)
			add_child(current_room)
			continue
		# get random room from room_scenes
		var current_room: TileMap = room_scenes[room_scenes.keys()[randi() % room_scenes.keys().size()]].instance()
		# scales from local unit vector coords to global coords
		current_room.position = room_position * (current_room.room_width * TILE_SIZE) 
		add_child(current_room)

	# move player node on top
	move_child($player, self.get_children().size())
	pass
