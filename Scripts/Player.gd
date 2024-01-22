extends CharacterBody2D

@export var speed = 50

# Node references
@onready var animation_sprite = $AnimatedSprite2D
@onready var health_bar = $UI/HealthBar
@onready var stamina_bar = $UI/StaminaBar
@onready var ammo_amount = $UI/AmmoAmount
@onready var health_amount = $UI/HealthAmount
@onready var stamina_amount = $UI/StaminaAmount

var is_attacking = false
var new_direction: Vector2 = Vector2(0, 1)
var animation

# UI Variables
var health = 100
var max_health = health
var regen_health = 1
var stamina = 100
var max_stamina = stamina
var regen_stamina = 5

# Custom signals
signal health_updated
signal stamina_updated
signal ammo_pickups_updated
signal health_pickups_updated
signal stamina_pickups_updated

# Pickups enumerator
enum Pickups { AMMO, STAMINA, HEALTH }
var ammo_pickup = 0
var health_pickup = 0
var stamina_pickup = 0

# We use the _ready() function whenever we need to set or initialize code that
# needs to run right after a node and its children are fully added to the
# scene. This function will only execute once before any _process() or
# _physics_process() functions.
func _ready():
	# This means each time there is a change in our health value, the player
	# script will emit the signal, and our healthbar will update its value.
	health_updated.connect(health_bar.update_health_ui)
	stamina_updated.connect(stamina_bar.update_stamina_ui)
	ammo_pickups_updated.connect(ammo_pickup.update_ammo_pickup_ui)
	health_pickups_updated.connect(health_pickup.update_health_pickup_ui)
	stamina_pickups_updated.connect(stamina_pickup.update_stamina_pickup_ui)

# Called every time a frame is drawn (60 times a second)
func _process(delta):
	# Calculate health & stamina, and if the updated_health is different from
	# the current health, update the value of the variable by "regenerating"
	# it.
	var updated_health = min(health + regen_health * delta, max_health)
	if updated_health != health:
		health = updated_health
		health_updated.emit(health, max_health)

	var updated_stamina = min(stamina + regen_stamina * delta, max_stamina)
	if updated_stamina != stamina:
		stamina = updated_stamina
		stamina_updated.emit(stamina, max_health)


func _input(event):
	# Input event for our attacking
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		animation = "attack_" + returned_direction(new_direction)
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
		if stamina >= 25:
			speed = 100
			stamina = stamina - 5
			stamina_updated.emit(stamina, max_stamina)
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

# Add the pickup item to the GUI-based inventory
func add_pickup(item):
	if item == Pickups.AMMO: 
		ammo_pickup = ammo_pickup + 3
		ammo_pickups_updated.emit(ammo_pickup)
	if item == Pickups.HEALTH:
		health_pickup = health_pickup + 1
		health_pickups_updated.emit(health_pickup)
	if item == Pickups.STAMINA:
		stamina_pickup = stamina_pickup + 1
		stamina_pickups_updated.emit(stamina_pickup)
		
	
