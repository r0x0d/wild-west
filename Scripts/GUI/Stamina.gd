extends ColorRect

# Node reference variables
@onready var value = $Value

# Calculate remaining stamina and update UI
func update_stamina_ui(stamina, max_stamina):
	# 98 is the width value of our ColorRect node.
	value.size.x = 98 * stamina/max_stamina

