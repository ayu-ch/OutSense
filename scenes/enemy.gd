extends CharacterBody2D

const SPEED = 60
const RANDOM_SPEED = 160
var motion=Vector2.ZERO
var player= null
var CAN_ATTACK=true
var is_in_attack_area=false

@onready var attack_radius: Area2D = $attack_radius
@onready var enemy: CharacterBody2D = $"."
@onready var Player: CharacterBody2D = $"../Player"
@onready var attack_timer: Timer = $AttackTimer
@onready var cooldown: Timer = $Cooldown
@onready var random_movement_timer: Timer = $RandomMovement

var random_inward_outward = 0.0
var random_tangential_speed = 0.0

var randomnum

enum {
	SURROUND,
	RANDOM,
	HIT,
	RETREAT
}

var state = RANDOM

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	player=Player
	random_movement_timer.start()
  

func _physics_process(delta):
	match state:
		SURROUND:
			move(get_circle_position(randomnum), delta)
			print(SURROUND)
		RANDOM:
			print("RANDOM")
			move_random(player.global_position, delta)
			#vector_to_target = vector_to_target.rotated(randf_range(-amount,amount))

		HIT:
			#retreat(player.global_position,delta,1)
			#await get_tree().create_timer(2).timeout
			#retreat(player.global_position,delta,-1)
			#await get_tree().create_timer(2).timeout
			print("HIT") 
			state=RANDOM
			
			
		RETREAT:
			retreat(player.global_position,delta,-1)
			#await get_tree().create_timer(1).timeout
			#state=RANDOM
			print("RETREAT")

func move_random(target, delta):
	var player_direction = (target - global_position).normalized()
	var inward_outward_movement = player_direction * random_inward_outward * delta
	var side_direction = Vector2(-player_direction.y, player_direction.x)
	var tangential_movement = side_direction * random_tangential_speed * delta
	velocity = (inward_outward_movement + tangential_movement) * RANDOM_SPEED * 25 
	print("Velocity:", velocity)
	move_and_slide()



	
func retreat(target,delta, sign):
	var direction = sign * (target - global_position).normalized() 
	var desired_velocity =  direction * SPEED
	var steering = desired_velocity
	velocity = steering
	move_and_slide()

func move(target, delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	print(velocity)
	move_and_slide()

func set_state(new_state):
	state = new_state

func get_circle_position(random):
	if player:
		var kill_circle_centre = player.global_position
		var radius = 180
		
		var angle = random * PI * 2;
		var x = kill_circle_centre.x + cos(angle) * radius;
		var y = kill_circle_centre.y + sin(angle) * radius;

		return Vector2(x, y)


func _on_AttackTimer_timeout():
	print("Timed out")

	


func _on_random_movement_timeout() -> void:
	random_inward_outward = randf_range(-0.25, 0.5) 
	random_tangential_speed = randf_range(-1.5, 1.5)
	print("New random movement generated: inward/outward:", random_inward_outward, "tangential:", random_tangential_speed)


func _on_cooldown_timeout() -> void:
	CAN_ATTACK=true
	if is_in_attack_area:
		state=HIT
	
