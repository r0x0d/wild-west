extends CharacterBody2D

@export var speed = 50

func _physics_process(delta):
	# Stores player input (left/right, up/down)
	var direction: Vector2

	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Normalize the input for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Calculate movement
	var movement: Vector2 = speed * direction * delta

	# Move the player around and enforce collisions 
	move_and_collide(movement)
