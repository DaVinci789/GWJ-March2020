extends KinematicBody2D

var speed = 200  # speed in pixels/sec
var velocity = Vector2.ZERO
var direction = Vector2.ZERO

func get_input():
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

func _physics_process(delta):
	get_input()
	direction = Vector2(sign(velocity.x), sign(velocity.y))
	
	update_animation()
	
	velocity = move_and_slide(velocity)