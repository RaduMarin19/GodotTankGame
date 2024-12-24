extends CharacterBody2D

const SPEED = 300.0
const TURRET_SPEED=100.0
var player_state
var can_shoot=true

@onready var BULLET = preload("res://scenes/bullet.tscn")

func _ready() ->void:
	pass

func _process(delta):
	var direction =Input.get_vector("left","right","up","down")
	if direction.x==0 and direction.y==0:
		player_state="idle"
	else:
		player_state="moving"
	velocity=direction*SPEED
	move_and_slide()
	turret_movement(delta)
	if Input.is_action_pressed("shoot"):
		shoot()

func turret_movement(delta):
	if Input.is_action_pressed("rotation_left"):
		$Turret.rotation_degrees-=TURRET_SPEED*delta
		$Turret/BarrelTip.rotation_degrees-=TURRET_SPEED*delta
	if Input.is_action_pressed("rotation_right"):
		$Turret.rotation_degrees+=TURRET_SPEED*delta
		$Turret/BarrelTip.rotation_degrees+=TURRET_SPEED*delta

func shoot():
	if can_shoot:
		can_shoot=false
		$Timer.start()
		$Turret/TurretSprite.play("shooting")
		var bullet =  BULLET.instantiate()
		
		bullet.global_position=$Turret/BarrelTip.global_position
		
		var angle =$Turret/BarrelTip.rotation
		
		bullet.direction=Vector2(cos(angle),sin(angle)).normalized()
		
		get_tree().current_scene.add_child(bullet) 

func _on_timer_timeout() -> void:
	can_shoot=true
	$Turret/TurretSprite.play("idle")
