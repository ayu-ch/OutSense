extends CharacterBody2D

@onready var healthbar: ColorRect = $ColorRect/healthbar
#@onready var ray: RayCast2D = $RayCaast2D

@onready var dash_cooldown_timer: Timer = $Dash_Cooldown 

var HEALTH = 100
var dash_cooldown
var NORMAL_SPEED = 150
var DASH_SPEED =1000
var SPEED
var is_dashing = false
const DASH_DURATION = 0.5 
var dash_timer=false
var health_width


enum {
	SURROUND,
	RANDOM,
	HIT,
	RETREAT
}

func _ready() -> void:
	health_width = healthbar.size.x
	SPEED=NORMAL_SPEED
	dash_cooldown=false
	$Dash_Right.emitting=false
	$Dash_Front.emitting=false
	$Dash_Left.emitting=false
	$Dash_Back.emitting=false

func _physics_process(delta: float) -> void:
	
	#draw_line(Vector2(0,0),Vector2(200,200),Color("red"),1.0)
	healthbar.size.x = (HEALTH / 100.0) * health_width
	var directionx := Input.get_axis("move_left", "move_right")
	var directiony := Input.get_axis("move_up", "move_down")
	if Input.is_action_just_pressed("dash") and not is_dashing and not dash_cooldown:
		dash_cooldown=true
		dash_cooldown_timer.start()
		is_dashing = true
		dash_timer = DASH_DURATION
	
	if is_dashing:
		
		SPEED = DASH_SPEED
		dash_timer -= delta
		
		if dash_timer <= 0.0:
			SPEED=NORMAL_SPEED
			is_dashing = false
			$Dash_Right.emitting=false
			$Dash_Front.emitting=false
			$Dash_Left.emitting=false
			$Dash_Back.emitting=false
	
	if directionx:
		velocity.x = directionx * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if directiony:
		velocity.y = directiony * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if velocity.length() > 0:
		if !is_dashing:
			velocity = velocity.normalized() * SPEED
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	if velocity.x != 0:
		if velocity.x > 0:
			$AnimatedSprite2D.animation = "right"
			if is_dashing:
				$Dash_Right.emitting=true
			else:
				$Dash_Right.emitting=false
		if velocity.x < 0:
			$AnimatedSprite2D.animation = "left"
			if is_dashing:
				$Dash_Left.emitting=true
			else:
				$Dash_Left.emitting=false
	elif velocity.y != 0:
		if velocity.y > 0:
			$AnimatedSprite2D.animation = "down"
			if is_dashing:
				$Dash_Front.emitting=true
			else:
				$Dash_Front.emitting=false
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "up"
			if is_dashing:
				$Dash_Back.emitting=true
			else:
				$Dash_Back.emitting=false
			
	move_and_slide()

func _on_attack_radius_body_entered(body: Node2D) -> void:
	print(body)
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
	if body.has_method("set_state"):
		body.is_in_attack_area=false
		body.set_state(SURROUND)


func _on_player_area_body_entered(body: Node2D) -> void:
	take_damage(body)
	
	if body.is_in_group("Enemies"):
		body.set_state(RETREAT)
		
func take_damage(body):
	print(body.get_groups())
	if body.is_in_group("damage_enemy"):
		HEALTH= HEALTH - body.damage
		body.queue_free()
		
	


func _on_chase_radius_body_entered(body: Node2D) -> void:
	if body.has_method("set_state"):
		#body.attack_timer.start()
		body.set_state(SURROUND)
		




func _on_dash_cooldown_timeout():
	dash_cooldown=false


func _on_chase_radius_body_exited(body: Node2D) -> void:
	if body.has_method("set_state"):
		body.set_state(SURROUND)
