extends ColorRect

# Node references
@onready var value = $Value

# Update UI
func update_ammo_pickup_ui(ammo_pickup):
	value.text = str(ammo_pickup)
