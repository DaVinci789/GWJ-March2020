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

# [{position: Vector2, tilemap: TileMap}]
var rooms := []

func _ready():
	generate_rooms()

	# move player node on top
	move_child($player, self.get_children().size())
	var starting_room_map: TileMap = rooms[0].tilemap
	$player.position = Vector2(starting_room_map.room_width / 2, starting_room_map.room_height / 2) * TILE_SIZE

func generate_rooms():
	randomize()
	add_child(order_room_scene.instance())

	var room_positions = []

	var current_direction := Vector2.ZERO
	room_positions.append(current_direction)

	# chooses random exit for each room
	for i in ROOM_AMOUNT:
		var next_room := current_direction
		var exit = Directions.values()[randi() % Directions.values().size()]
		match exit:
			Directions.NORTH:
				next_room += Vector2(0,-1)
			Directions.SOUTH:
				next_room += Vector2(0,1)
			Directions.EAST:
				next_room += Vector2(1,0)
			Directions.WEST:
				next_room += Vector2(-1,0)
		room_positions.append(next_room)
		current_direction = next_room
	
	for room_position in room_positions:
		# different for starting room
		if room_position == Vector2(0,0):
			var current_room: TileMap = order_room_scene.instance()
			current_room.position = Vector2(0,0)
			add_child(current_room)
			#rooms[room_position] = current_room
			rooms.append({"position": room_position, "tilemap": current_room})
			continue
		# get random room from room_scenes
		var current_room: TileMap = room_scenes[room_scenes.keys()[randi() % room_scenes.keys().size()]].instance()
		# scales from local unit vector coords to global coords
		current_room.position = room_position * (current_room.room_width * TILE_SIZE) 

		rooms.append({"position": room_position, "tilemap": current_room})
		add_child(current_room)
	
	# connect the exits of the first room and the room right after it
	## find the direction relative to the first room
	for i in ROOM_AMOUNT:
		if i + 1 >= rooms.size():
			break
		var starting_room = rooms[i]
		var second_room   = rooms[i + 1]
		match second_room.position - starting_room.position:
			Vector2.UP:
				starting_room.tilemap.exits.append("north")
				second_room.tilemap.exits.append("south")
			Vector2.DOWN:
				starting_room.tilemap.exits.append("south")
				second_room.tilemap.exits.append("north")
			Vector2.LEFT:
				starting_room.tilemap.exits.append("west")
				second_room.tilemap.exits.append("east")
			Vector2.RIGHT:
				starting_room.tilemap.exits.append("east")
				second_room.tilemap.exits.append("west")

	for room in rooms:
		var room_tilemap: TileMap = room.get("tilemap")
		room_tilemap.set_walls(room_tilemap.exits)

func get_opposing_exit(exit: String) -> String:
	match exit:
		"north":
			return "south"
		"south":
			return "north"
		"east":
			return "west"
		"west":
			return "east"
		_:
			return "None"
