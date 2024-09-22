extends Area2D

var damage=25
#var player_pos
func _ready() -> void:
	#position=player_pos
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
func _process(delta: float) -> void:
	pass	
