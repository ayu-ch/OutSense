extends Node2D
#@onready var ray = $CharacterBody2D/RayCast2D2
var grenade_scene = preload("res://scenes/grenade.tscn")
var Click_Position = Vector2(0,0)
var throw_force = 180
@onready var player = $CharacterBody2D
@onready var ray = $CharacterBody2D/RayCast2D2
var ray_scene = preload("res://scenes/ray.tscn")
var m
var mid
var time =0
var r = false
var val=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
var grenade

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = player.position
	var mouse_position = get_global_mouse_position()
	val += delta
	if Input.is_action_just_pressed("left_mouse_click"):
		Click_Position = get_global_mouse_position()
		print("click position")
		print(Click_Position)
		print("Player")
		print(pos)
		#if (Click_Position.y>pos.y):
		m = (Click_Position + 3 * pos)/4
		print(m)
		m.y = m.y - 0.5*abs(Click_Position.y-pos.y) - 0.5*abs(Click_Position.x-pos.x)
		print(m)
		#elif (pos.y>Click_Position.y):
			#m = (Click_Position + 3 * pos)/4
			#m.y = m.y + 0.5 * (pos.y-Click_Position.y)
		#var t = delta
		
		
		grenade = grenade_scene.instantiate()
		add_child(grenade)
		grenade.position = pos
		print(grenade.position)
		
	
	if Input.is_action_just_pressed("L"):
		r = !r
	if(r):
		if(val>=0.3):
			val=0
			ray.target_position = mouse_position
			var ray_node = ray_scene.instantiate()
			add_child(ray_node)
			ray_node.position=pos
			var direction = (ray.target_position-pos).normalized()
			var angle = direction.angle()
			ray_node.rotation = angle
			ray_node.apply_impulse(direction*throw_force)
	if(m && grenade && !r):
		#if(grenade.position):
		print("hello")
		grenade.position = bezeir(time,pos)
		print(grenade.position)
		time+= delta
		print(time)
		if(time>0.5):
			m=0
			time=0
			
	
		
		
		#throw_grenade(Click_Position, pos,delta)

func bezeir(t,pos):
	var p1 = pos.lerp(m,2*t)
	var p2 = m.lerp(Click_Position,2*t)
	var r = p1.lerp(p2,2*t)
	return r

#func throw_grenade(target_position: Vector2, pos, delta):
	#position = $".".position
	#var grenade = grenade_scene.instantiate()
	
	#add_child(grenade)
	#grenade.position = bezeir(time,pos)
	#
	#time+= delta
	#print("player position")
	#print(pos)
	#ray.target_position = Click_Position
	#var direction = (Click_Position - pos).normalized()
	#print(direction)
	#grenade.apply_impulse(direction*throw_force)
