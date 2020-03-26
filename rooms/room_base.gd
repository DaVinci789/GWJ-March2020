extends TileMap

export (int) var room_width := 16
export (int) var room_height := 16

var wall_length := 12
var wall_height := 2

func _ready():
	set_walls(["north"])

func set_walls(exceptions: Array):
		#for each side, construct wall unless "north", "south", "east", or "west" is in exceptions
		var walls_to_create = ["north", "south", "east", "west"]
		for wall in walls_to_create:
				if wall in exceptions:
						walls_to_create.remove(walls_to_create.find(wall))
		for wall in walls_to_create:
				for length in wall_length:
						for height in wall_height:
								match wall:
										"north":
												# y-offset, x-offset
												set_cell(length + 2, height, 1)
										"south":
												set_cell(length + 2, height + room_height, 1)
										"east":
												# x-offset, y-offset
												set_cell(height, length + 2, 1)
										"west":
												set_cell(height + room_width - 2, length + 2, 1)
		update_bitmask_region(Vector2(0,0), map_to_world(Vector2(room_width, room_height)))