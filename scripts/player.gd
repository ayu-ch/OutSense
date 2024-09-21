extends CharacterBody2D

@onready var player = $"."
@onready var ray = $RayCast2D2
# Variables
var speed = 200
 # Speed of the character
@onready var animated_sprite = $"move ani"
# Preload sprite images for different directions # Replace with the path to your Sprite node


func _ready():
	pass
	# Set initial sprite
	#sprite.texture = down_sprite
	

		

func _process(_delta):
	# Reset velocity
	velocity = Vector2()

	# Get input for movement
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	
		
	# Normalize the velocity vector to maintain consistent speed
	velocity = velocity.normalized() * speed

	# Move the character
	move_and_slide()

	# Update the character's sprite based on direction
	update_character_sprite(velocity)


	
	
func update_character_sprite(v):
	if v.length() > 0:
		if abs(v.x) > abs(v.y): # Horizontal movement
			if v.x > 0:
				animated_sprite.play("move right") # Facing right
			else:
				animated_sprite.play("move left") # Facing left
		else: # Vertical movement
			if v.y > 0:
				animated_sprite.play("move down") # Facing down
			else:
				animated_sprite.play("move up") # Facing up
	else:
		animated_sprite.stop()
