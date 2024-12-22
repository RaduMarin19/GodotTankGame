extends StaticBody2D

const SPEED = 30
@onready var BULLET = preload("res://scenes/bullet.tscn")

var canShoot=true	
func _ready():
	$Timer.connect("timeout",Callable(self, "_on_timer_timeout"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_pressed("shoot")):
		fire_bullet()
	#Handling turret rotation
	if(Input.is_action_pressed("rotation_left")):
		rotation_degrees-= SPEED * delta
		$CollisionShape2D.rotation_degrees -= SPEED * delta
		$CollisionShape2D2.rotation_degrees-= SPEED * delta
	if(Input.is_action_pressed("rotation_right")):
		rotation_degrees+= SPEED * delta
		$CollisionShape2D.rotation_degrees += SPEED * delta
		$CollisionShape2D2.rotation_degrees+= SPEED * delta
		

func _on_timer_timeout():
	canShoot=true
	$AnimatedSprite2D.play("Default")

func fire_bullet():
	if BULLET && canShoot:
		$Timer.start(0.8)
		canShoot=false
		$AnimatedSprite2D.play("Shooting")
		# Create a new bullet instance
		var bullet =  BULLET.instantiate()

		# Set the bullet's position to the spawn point
		bullet.global_position = $CollisionShape2D2.global_position  # Replace Position2D with your bullet spawn node
		
		# Set the bullet's direction based on turret rotation
		var angle = $CollisionShape2D2.rotation
		bullet.direction = Vector2(cos(angle), sin(angle)).normalized()

		# Add the bullet to the scene
		get_tree().current_scene.add_child(bullet)
