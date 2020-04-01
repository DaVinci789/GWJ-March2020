extends "res://rooms/room_base.gd"

const terminal_tile  = 2
const terminal_scene = preload("res://terminal/terminal.tscn")

func _ready():
	load_terminals()

func load_terminals():
	for location in get_used_cells_by_id(terminal_tile):
		var terminal = terminal_scene.instance()
		add_child(terminal)
		terminal.position = map_to_world(location)
		terminal.position += terminal.tex_size / 3
		set_cellv(location, 0)
		update_bitmask_region(Vector2(0,0), map_to_world(Vector2(room_width, room_height)))
	pass