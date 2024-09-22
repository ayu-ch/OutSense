extends CanvasLayer

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var grenade_cooldown: Timer = $"../grenade_cooldown"

@onready var grenade_timer: Timer = $"../grenade_timer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse_click"):
		grenade_timer.start()
	if grenade_timer.time_left > 0:
		rich_text_label.text="Grenade cooldown : "+str(round_to_dec(grenade_cooldown.time_left,1))

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
