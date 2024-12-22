extends StaticBody2D

@export var speed =200.0  # Bullet speed (adjust as needed)
var direction = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("firing bulet")
	position += direction * speed * delta

func _on_Bullet_body_entered(body):
	body.take_damage(10);
	queue_free()
