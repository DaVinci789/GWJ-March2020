extends TextureRect

signal selected(object)
signal dropped(object)

var drag_position = null

func _on_material_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
			emit_signal("selected", self)
		else:
			drag_position = null
			emit_signal("dropped", self)
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
	pass # Replace with function body.
