extends ColorRect

# Node reference variables
@onready var value = $Value

# Calculate remaining health and update UI
func update_health_ui(health, max_health):
	# 98 is the width value of our ColorRect node.
	value.size.x = 98 * health/max_health

