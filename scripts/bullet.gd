extends Area2D

@export var speed =1000.0 
var direction = Vector2.ZERO

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_body_entered(body) -> void:
	if body.has_method("take_damage"):
		body.take_damage.rpc_id(body.get_multiplayer_authority())
	queue_free()
