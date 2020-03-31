extends Node2D

enum Directions {
	NORTH,
	SOUTH,
	EAST,
	WEST,
}

# this is in addition to the starting room
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

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		generate_rooms()
		move_child($player, self.get_children().size())

func generate_rooms():
	# resets rooms for each time this function is called
	for node in get_children():
		if node.is_in_group("room"):
			node.free()
	# godot is being weird. won't free the order room node
	for node in get_children():
		if "order_room" in node.name:
			node.free()
	rooms = []

	randomize()

	var room_positions = []

	var current_direction := Vector2.ZERO
	room_positions.append(current_direction)

	# chooses random exit for each room
	for i in ROOM_AMOUNT:
		var next_room := current_direction
		next_room = generate_random_room_location(next_room, room_positions)
		room_positions.append(next_room)
		current_direction = next_room
	
	for room_position in room_positions:
		# different for starting room
		if room_position == Vector2(0,0):
			var current_room: TileMap = order_room_scene.instance()
			current_room.add_to_group("room")
			current_room.position = Vector2(0,0)
			add_child(current_room)
			rooms.append({"position": room_position, "tilemap": current_room})
			continue
		# get random room from room_scenes
		var current_room: TileMap = room_scenes[room_scenes.keys()[randi() % room_scenes.keys().size()]].instance()
		# scales from local unit vector coords to global coords
		current_room.position = room_position * (current_room.room_width * TILE_SIZE) 
		current_room.add_to_group("room")

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

# generates a valid room position
# that is, a room position that is not in previous_rooms
func generate_random_room_location(location: Vector2, previous_rooms: Array) -> Vector2:
	var exit = Directions.values()[randi() % Directions.values().size()]
	var next_room = location
	match exit:
		Directions.NORTH:
			next_room += Vector2(0,-1)
		Directions.SOUTH:
			next_room += Vector2(0,1)
		Directions.EAST:
			next_room += Vector2(1,0)
		Directions.WEST:
			next_room += Vector2(-1,0)
	if next_room in previous_rooms:
		return generate_random_room_location(location, previous_rooms)
	else:
		return next_room