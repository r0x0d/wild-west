extends ColorRect

# Node references
@onready var value = $Value

# Update UI
func update_stamina_pickup_ui(stamina_pickup):
	value.text = str(stamina_pickup)
