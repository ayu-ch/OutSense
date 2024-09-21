extends CharacterBody2D


var HEALTH = 100
const SPEED = 150
const JUMP_VELOCITY = -300.0

@onready var healthbar: ColorRect = $ColorRect/healthbar

enum {
	SURROUND,
	RANDOM,
	HIT,
	RETREAT
}
var health_width

func _ready() -> void:
	health_width = healthbar.size.x

func _physics_process(delta: float) -> void:
	
	healthbar.size.x = (HEALTH / 100.0) * health_width
	var directionx := Input.get_axis("move_left", "move_right")
	var directiony := Input.get_axis("move_up", "move_down")
	if directionx:
		velocity.x = directionx * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if directiony:
		velocity.y = directiony * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	if velocity.x != 0:
		if velocity.x > 0:
			$AnimatedSprite2D.animation = "right"
		if velocity.x < 0:
			$AnimatedSprite2D.animation = "left"
	elif velocity.y != 0:
		if velocity.y > 0:
			$AnimatedSprite2D.animation = "down"
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "up"
			
	move_and_slide()
	





func _on_chase_radius_body_entered(body: Node2D) -> void:
	if body.has_method("set_state"):
		#body.attack_timer.start()
		body.set_state(SURROUND)
		


func _on_attack_radius_body_entered(body: Node2D) -> void:
	if body.has_method("set_state"):
		body.is_in_attack_area=true
		if body.CAN_ATTACK:
			body.state=HIT
			body.is_hitting = false
			body.CAN_ATTACK=false
			body.cooldown.start()
		else:
			body.state=RANDOM





func _on_attack_radius_body_exited(body: Node2D) -> void:
	print("exited")
	if body.has_method("set_state"):
		body.is_in_attack_area=false
		body.set_state(SURROUND)


func _on_chase_radius_body_exited(body: Node2D) -> void:
	if body.has_method("set_state"):
		body.set_state(SURROUND)




func _on_player_area_body_entered(body: Node2D) -> void:
	take_damage(body)
	
	if body.is_in_group("Enemies"):
		print(body)
		body.set_state(RETREAT)
		
func take_damage(body):
	if body.is_in_group("damage"):
		HEALTH= HEALTH - 10
		body.queue_free()
		
	
