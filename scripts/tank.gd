extends CharacterBody2D

const SPEED = 300.0
const TURRET_SPEED=100.0
var player_state
var can_shoot=true

@onready var ray_cast = $Turret/RayCast2D
@onready var BULLET = preload("res://scenes/bullet.tscn")
var spawn_positions = [
	Vector2(-300, 800), 
	Vector2(0, 300),
	Vector2(300, 1200), 
	Vector2(600, 543)
]

var current_spawn_index = 0

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready() ->void:
	if not is_multiplayer_authority(): return
	var spawn_point = get_next_spawn_point()
	global_position = spawn_point

func get_next_spawn_point():
	current_spawn_index = str(name).to_int() % spawn_positions.size()
	print(current_spawn_index)
	var spawn_point = spawn_positions[current_spawn_index]
	return spawn_point

func _process(delta):
	if not is_multiplayer_authority() : return
	var direction =Input.get_vector("left","right","up","down")
	if direction.x==0 and direction.y==0:
		player_state="idle"
	else:
		player_state="moving"
	velocity=direction*SPEED
	move_and_slide()
	turret_movement(delta)
	if Input.is_action_pressed("shoot"):
		shoot.rpc()

func turret_movement(delta):
	if Input.is_action_pressed("rotation_left"):
		$Turret.rotation_degrees-=TURRET_SPEED*delta
		$Turret/BarrelTip.rotation_degrees-=TURRET_SPEED*delta
	if Input.is_action_pressed("rotation_right"):
		$Turret.rotation_degrees+=TURRET_SPEED*delta
		$Turret/BarrelTip.rotation_degrees+=TURRET_SPEED*delta

@rpc("call_local")
func shoot():
	if not is_multiplayer_authority(): return
	if can_shoot:
		$Turret/TurretSprite.play("shooting")
		
		create_bullet.rpc()
		
		can_shoot=false
		$Timer.start(0.7)
		if ray_cast.is_colliding():
			var hit_player = ray_cast.get_collider()
			if hit_player.has_method("take_damage"):
				hit_player.take_damage.rpc_id(hit_player.get_multiplayer_authority())

@rpc("call_local")
func create_bullet():
	var bullet = BULLET.instantiate()
	
	bullet.global_position = $Turret/BarrelTip.global_position
	
	var angle = $Turret/BarrelTip.rotation
	bullet.direction = Vector2(cos(angle),sin(angle)).normalized()
	
	get_tree().get_root().add_child(bullet)

func _on_timer_timeout() -> void:
	can_shoot=true
	$Turret/TurretSprite.play("idle")

@rpc("any_peer")
func take_damage(damage=10):
	$Healthbar.value-=damage
	if $Healthbar.value<=0:
		can_shoot=false
		$remove.start(1)
		$BodySprite.hide()
		$Turret/TurretSprite.play("exploding")

func _on_remove_timeout() -> void:
	queue_free()
