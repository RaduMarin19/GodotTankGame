extends Area2D

@export var speed =1000.0  # Bullet speed (adjust as needed)
var direction = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_body_entered(body) -> void:
	queue_free()
