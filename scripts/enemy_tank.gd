extends CharacterBody2D

@onready var HealthBar = $Healthbar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HealthBar.value=100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage):
	HealthBar.value-=damage
	if HealthBar.value<=0:
		queue_free()
