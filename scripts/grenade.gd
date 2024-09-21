extends RigidBody2D
#var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	explode() # Replace with function body.


func explode():
	queue_free()

func _process(delta: float) -> void:
	print("grenade")
	print(position)
	#velocity = Vector2()
	#velocity.y = delta * 30
	#pass
