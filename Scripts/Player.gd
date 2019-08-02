extends RigidBody2D

signal die
signal shoot
signal damage

export (float) var speed = 5.0
export (float) var rotate_speed = 5.0
export (float) var max_speed = 10.0

export (PackedScene) var weapon
export (PackedScene) var death_particle_effect

onready var weapon_2d = $Weapon2D

var direction = Vector2()
var rotate_direction = 0.0

var player_health = 5
var is_game_over = false


func _ready():
	connect("die", self, "_on_Player_game_over")
	connect("damage", self, "_on_Player_damage")

func _process(delta):
	if not is_game_over and not get_tree().paused:
		_get_input()


func _physics_process(delta):
	linear_velocity.x = clamp(linear_velocity.x, -max_speed, max_speed)
	linear_velocity.y = clamp(linear_velocity.y, -max_speed, max_speed)
	
	apply_central_impulse(transform.y * direction.y * speed)
	apply_torque_impulse(rotate_direction * rotate_speed)


func _get_input() -> void:
	direction = Vector2()
	rotate_direction = 0
	
	# Moves the ship
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		
	# Rotates the ship
	if Input.is_action_pressed("move_left"):
		rotate_direction -= 1
	if Input.is_action_pressed("move_right"):
		rotate_direction += 1
		
	if Input.is_action_pressed("shoot") and $FireRate.time_left <= 0.0:
		shoot(weapon_2d.global_position, global_rotation)

		
func shoot(weapon_position : Vector2, weapon_rotation : float):
	var bullet = weapon.instance()
	bullet.global_position = weapon_position
	bullet.global_rotation = weapon_rotation
	get_tree().current_scene.add_child(bullet)

	emit_signal("shoot")
	$FireRate.start()


func _on_Player_damage():
	self.player_health -= 1
	if self.player_health <= 0 and not is_game_over:
		var death_effect = death_particle_effect.instance()
		death_effect.global_position = self.global_position
		
		get_tree().current_scene.add_child(death_effect)
		death_effect.one_shot = true
		
		emit_signal("die")
		queue_free()
	else:
		$Sprite.frame += 1


func _on_Player_game_over():
	direction = Vector2()
	rotate_direction = 0
	is_game_over = true
