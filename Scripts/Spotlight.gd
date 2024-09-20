extends PointLight2D

const GROWTH_RATE = 5.0  # How fast the light grows
const DECREASE_RATE = 1.0
const MAX_SCALE = 5.0  # Maximum scale size
const ORIGINAL_SCALE = 1.0  # Initial scale size
const RESET_TIME = 4.0  # Time in seconds to gradually reset to original scale

var is_scaling_down = false  # A flag to check if we are scaling down
var scaling_timer = 0.0  # Timer for scaling back down

func _ready():
	# Set the initial scale when the scene starts
	self.scale = Vector2(ORIGINAL_SCALE, ORIGINAL_SCALE)

func _process(delta):
	# Check if the space key is pressed
	if Input.is_action_pressed("ui_accept"):  # "ui_accept" is typically mapped to spacebar
		# Increase the scale of the PointLight2D
		self.scale += Vector2(GROWTH_RATE * delta, GROWTH_RATE * delta)

		# Limit the maximum scale
		if self.scale.x > MAX_SCALE:
			self.scale = Vector2(MAX_SCALE, MAX_SCALE)

	# When space is released, start the gradual scaling down
	if Input.is_action_just_released("ui_accept"):
		is_scaling_down = true  # Start scaling down
		scaling_timer = RESET_TIME  # Set the timer to 4 seconds

	# If we are scaling down, gradually reduce the scale over time
	if is_scaling_down:
		scaling_timer -= delta  # Decrease the timer

		# Gradually move the scale back to the original size over time
		self.scale = self.scale.move_toward(Vector2(ORIGINAL_SCALE, ORIGINAL_SCALE), DECREASE_RATE * delta)

		# Stop scaling down when the timer runs out
		if scaling_timer <= 0.0:
			self.scale = Vector2(ORIGINAL_SCALE, ORIGINAL_SCALE)  # Ensure final scale is exact
			is_scaling_down = false  # Stop the scaling down process
