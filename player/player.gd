extends KinematicBody2D

onready var interaction_cast_length = $interaction_cast.cast_to.y

var materials_left = {
	"material": 3,
	"material1": 3,
	"material2": 3,
}

var speed = 200  # speed in pixels/sec
var velocity = Vector2.ZERO
var direction = Vector2.ZERO

var interacting := false

func _ready():
	Game.player = self

func _physics_process(_delta):
	if not $crafting_hud/crafting_area.visible:
		get_movement_input()
	else:
		velocity = Vector2.ZERO
	direction = Vector2(sign(velocity.x), sign(velocity.y))
	
	get_crafting_input()
	
	if Input.is_action_just_pressed("interact"):
		interact()
	
	change_interaction_cast_direction(direction)
	
	update_animation()
	
	velocity = move_and_slide(velocity)

func change_interaction_cast_direction(direction_to_face: Vector2):
	match direction_to_face:
		Vector2(-1,0):
			$interaction_cast.cast_to = Vector2(-interaction_cast_length,0)
		Vector2(1, 0):
			$interaction_cast.cast_to = Vector2(interaction_cast_length,0)
		Vector2(0,-1):
			$interaction_cast.cast_to = Vector2(0,-interaction_cast_length)
		Vector2(0, 1):
			$interaction_cast.cast_to = Vector2(0,interaction_cast_length)
		_:
			return
	pass

func get_movement_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	# Make sure diagonal movement isn't faster
	velocity = velocity.normalized() * speed

func get_crafting_input():
	if Input.is_action_just_pressed("inventory_open") and not interacting:
		$crafting_hud/crafting_area.visible = not $crafting_hud/crafting_area.visible
	pass

# only updates facing rn
func update_animation():
	match direction:
		Vector2(-1,0):
			$Sprite.frame = 3
		Vector2(1, 0):
			$Sprite.frame = 2
		Vector2(0,-1):
			$Sprite.frame = 1
		Vector2(0, 1):
			$Sprite.frame = 0
		_:
			return
	pass

func interact():
	if $interaction_cast.is_colliding():
		if $interaction_cast.get_collider().is_in_group("terminal"):
			$crafting_hud/crafting_area.visible = not $crafting_hud/crafting_area.visible
			$interaction_cast.get_collider().toggle_visibility()
			interacting = not interacting
			if interacting:
				$Camera2D.position.y += 60
			else:
				$Camera2D.position.y -= 60

func use_material(material_type: String):
	materials_left[material_type] -= 1
