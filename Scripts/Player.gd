extends CharacterBody2D

@export var speed = 50
@onready var animation_sprite = $AnimatedSprite2D

var is_attacking = false
var new_direction: Vector2 = Vector2(0, 1)
var animation

func _input(event):
	# Input event for our attacking
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		var animation = "attack_" + returned_direction(new_direction)
		animation_sprite.play(animation)

func _physics_process(delta):
	# Stores player input (left/right, up/down)
	var direction: Vector2

	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Normalize the input for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Sprinting
	if Input.is_action_pressed("ui_sprint"):
		speed = 100
	elif Input.is_action_just_released("ui_sprint"):
		speed = 50
	
	# Calculate movement
	var movement: Vector2 = speed * direction * delta

	if is_attacking == false:	
		# Move the player around and enforce collisions 
		move_and_collide(movement)
		# Play animation
		player_animations(direction)
	
	if !Input.is_anything_pressed():
		if is_attacking == false:
			animation = "idle_" + returned_direction(new_direction)

func player_animations(direction: Vector2):
	# If this is different from Vector2(0, 0), it means that we are moving in some direction
	if direction != Vector2.ZERO:
		new_direction = direction
		animation = "walk_" + returned_direction(new_direction)
		animation_sprite.play(animation)
		return
	
	# Otherwise, we are still. Not moving.
	animation = "idle_" + returned_direction(new_direction)
	animation_sprite.play(animation)

func returned_direction(direction: Vector2):
	# Normalize the direction vector
	var normalized_direction = direction.normalized()
	var default_return = "side"
	
	if normalized_direction.y > 0:
		return "down"
	elif normalized_direction.y < 0:
		return "up"
	elif normalized_direction.x > 0:
		# Flip the animation to the right side
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_direction.x < 0:
		# Flip the animation to the left side
		$AnimatedSprite2D.flip_h = true
		return "side"
	
	return default_return

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
