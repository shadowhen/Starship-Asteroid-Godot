extends Path2D

export (PackedScene) var enemy
export (Vector2) var enemy_speed_range
export (int) var max_number_of_enemies = 5
export (Vector2) var spawn_time_range = Vector2(1.0, 5.0)

onready var timer = $SpawnTime

var player = null
var is_spawning = true


func _ready() -> void:
	randomize_time()
	timer.start()
	player = get_tree().current_scene.get_node("Player")
	player.connect("die", self, "_on_Player_die")


func spawn_enemy(target) -> void:
	# In order to keep the randomness of the spawning mechnaics,
	# the spawn path's follow would be randomized between 0 to 1
	# using the follow's unit offset. This randomization has to
	# take place first, so the spawned enemy can be in the correct
	# position and find the target to go after using given parameters.
	
	$SpawnPathFollow.unit_offset = randf() * 1
	
	var mob = enemy.instance()
	mob.global_position = $SpawnPathFollow.global_position
	
	var speed = randf() * enemy_speed_range.y+enemy_speed_range.x
	var direction = (target.position - mob.global_position).normalized()

	mob.linear_velocity = direction * speed
	
	get_node("..").add_child(mob) 


func randomize_time() -> void:
	timer.wait_time = randf() * spawn_time_range.y+spawn_time_range.x


func _on_Player_die():
	is_spawning = false


func _on_SpawnTime_timeout():
	if is_spawning:
		for i in range(randi() % max_number_of_enemies + 1):
			spawn_enemy(player)
		randomize_time()
		timer.start()
