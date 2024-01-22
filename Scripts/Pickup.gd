@tool 
extends Area2D

# Node references
@onready var sprite = $Sprite2D

# Type of pickups to choose from
enum Pickups { AMMO, STAMINA, HEALTH }
@export var item: Pickups

# Texture assets/resources
var ammo_texture = preload("res://Assets/Icons/shard_01i.png")
var stamina_texture = preload("res://Assets/Icons/potion_02b.png")
var health_texture = preload("res://Assets/Icons/potion_02c.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Execute the code in the editor without running the game
	if not Engine.is_editor_hint():
		if item == Pickups.AMMO:
			# Change the texture that matches with the editor selection.
			sprite.set_texture(ammo_texture)
		elif item == Pickups.HEALTH:
			sprite.set_texture(health_texture)
		elif item == Pickups.STAMINA:
			sprite.set_texture(stamina_texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Execute the code in the editor without running the game
	if Engine.is_editor_hint():
		if item == Pickups.AMMO:
			# Change the texture that matches with the editor selection.
			sprite.set_texture(ammo_texture)
		elif item == Pickups.HEALTH:
			sprite.set_texture(health_texture)
		elif item == Pickups.STAMINA:
			sprite.set_texture(stamina_texture)

func _on_body_entered(body):
	if body.name == "Player":
		# Call the add_pickup function from the Player scene
		body.add_pickup(item)
		# Delete from scene tree
		get_tree().queue_delete(self)
