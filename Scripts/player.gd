extends CharacterBody2D

@export var ghost_node: PackedScene
@export var silhouette_scene: PackedScene
var silhouette: Node
@onready var ghost_timer = $GhostTimer

const SPEED = 300.0
const DASH_SPEED = 1000.0  # Speed during the dash
const DASH_DURATION = 0.2  # Duration of the dash in seconds
const JUMP_VELOCITY = -400.0

var is_dashing = false
var dash_timer = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#func _ready():
	#silhouette = silhouette_scene.instantiate()
	#silhouette.position = position
	#get_tree().current_scene.add_child(silhouette)
	#silhouette.visible=false
	

func _physics_process(delta):
	# Get the input direction for horizontal and vertical movement.
	var horizontal_direction = Input.get_axis("ui_left", "ui_right")
	var vertical_direction = Input.get_axis("ui_up", "ui_down")

	# Check for dash input
	if Input.is_action_just_pressed("dash"):  # Assuming "F" is mapped to "ui_accept"
		start_dash()

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false 
			$Dash.emitting=false # End the dash
		else:
			# Maintain the dash speed in the current direction
			velocity = Vector2(DASH_SPEED * horizontal_direction, 0)

	else:
		#ghost_timer.stop()
		# Handle horizontal movement.
		if horizontal_direction:
			velocity.x = horizontal_direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		# Handle vertical movement.
		if vertical_direction:
			velocity.y = vertical_direction * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)

	# Move the character.
	move_and_slide()

	# Ghosting functionality
	# You might want to keep this part if it should execute under certain conditions.
	#if Input.is_action_just_pressed("ui_up"):
		#

#func add_ghost():
	#$Dash.emitting=true
	#var ghost = ghost_node.instantiate()
	#
	## Set the ghost's position and scale to match the current character's position and scale
	#ghost.position = position  # This assumes ghost is a type that supports position
	#ghost.scale = $Sprite2D.scale  # Match the sprite scale

	# Add the ghost to the current scene
	#get_tree().current_scene.add_child(ghost)

#func _on_ghost_timer_timeout():
	#$Dash.emitting=false
	#add_ghost()

func start_dash():
	is_dashing = true
	dash_timer = DASH_DURATION 
	ghost_timer.start()
	$Dash.emitting=true
