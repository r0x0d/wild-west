extends ColorRect

# Node references
@onready var value = $Value

# Update UI
func update_health_pickup_ui(health_pickup):
	value.text = str(health_pickup)
