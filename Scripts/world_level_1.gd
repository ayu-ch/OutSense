extends Node2D
@onready var enemy: CharacterBody2D = $enemy

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2

var can_grenade = true
var grenade_scene = preload("res://Scenes/grenade_2.tscn")
var Click_Position = Vector2(0,0)
var final_position= Vector2(0,0)
var throw_force = 180
@onready var player =$Player
#@onready var ray =$Player/RayCast2D
@onready var grenade_cooldown: Timer = $grenade_cooldown

var ray_scene = preload("res://Scenes/ray.tscn")
var m
var mid
var time =0
var r = false
var val=0
var max_radius = 1200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_2d.play()
	pass # Replace with function body.
var grenade

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = player.global_position
	var mouse_position = get_global_mouse_position()
	val += delta
	#if !grenade_cooldown.is_stopped():
	if Input.is_action_just_pressed("left_mouse_click") && can_grenade:
		can_grenade= false
		grenade_cooldown.start()
		Click_Position = get_global_mouse_position()
		#final_position = get_final_position(pos, Click_Position, max_radius)
		final_position=Click_Position
		

		m = (final_position + 3 * pos)/4
		m.y = m.y - 0.5*abs(final_position.y-pos.y) - 0.5 * abs(final_position.x-pos.x)
		grenade = grenade_scene.instantiate()
		audio_stream_player_2d_2.play()
		add_child(grenade)
		grenade.position = pos
		time=0
		
	
	#if Input.is_action_just_pressed("X"):
		#r= true
		#if(val>=0.3):
			#val=0
			#ray.target_position = mouse_position
			#var ray_node = ray_scene.instantiate()
			#add_child(ray_node)
			#ray_node.position=pos
			#var direction = (ray.target_position-pos).normalized()
			#var angle = direction.angle()
			#ray_node.rotation = angle
			#ray_node.apply_impulse(direction*throw_force*4)
			#r=false
	if(m && grenade):
		#if(grenade.position):
		grenade.position = bezeir(time,pos)
		time+= delta
		if(time>0.5):
			m=0
			time=0
	if(is_instance_valid(grenade)):
		var distance=sqrt((enemy.position.x-grenade.position.x)**2 + (enemy.position.y-grenade.position.y)**2)
		var radius=200
		if(distance<radius):
			enemy.HEALTH= enemy.HEALTH - grenade.damage
			grenade.queue_free()
			grenade=null
		
			
	
		
		
		#throw_grenade(Click_Position, pos,delta)

func bezeir(t,pos):
	t=t*2
	var p1 = pos.lerp(m,t)
	var p2 = m.lerp(final_position,t)
	var r = p1.lerp(p2,t)
	return r

func get_final_position(player_pos: Vector2, click_pos: Vector2, max_radius: float) -> Vector2:
	var distance = player_pos.distance_to(click_pos)
	if distance <= max_radius:
		return click_pos 
	else:
		# Find the point on the circle at max_radius distance from player_pos
		var direction = (click_pos - player_pos).normalized()
		return player_pos+ direction * max_radius  # Point at max_radius distance in the same direction

func _on_grenade_cooldown_timeout() -> void:
	can_grenade=true
	
func hit():
	#ray.target_position = player.position
	var ray_node = ray_scene.instantiate()
	#ray_node.target_position = player.position
	add_child(ray_node)
	ray_node.position=enemy.position
	var direction = (player.position - ray_node.position).normalized()
	var angle = direction.angle()
	ray_node.rotation = angle
	ray_node.apply_impulse(direction*100*4)
