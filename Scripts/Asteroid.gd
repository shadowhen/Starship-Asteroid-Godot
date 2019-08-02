extends RigidBody2D

const NUMBER_OF_TEXTURES = 2

export (Vector2) var speed_range = Vector2(1, 5)
export (Vector2) var scale_range = Vector2(1, 1)

func _ready():
	# Enable collision reporting
	contact_monitor = true
	contacts_reported = 2
	
	randomize_asteroid()
	
func randomize_asteroid():
	$Sprite.frame = randi() % NUMBER_OF_TEXTURES
	
	var new_scale = rand_range(scale_range.x, scale_range.y)
	var scale_vector = Vector2(new_scale, new_scale)
	var velocity = rand_range(speed_range.x, speed_range.y)
	
	$Sprite.scale = scale_vector
	$CollisionShape2D.scale = scale_vector
	
	self.rotation = deg2rad(randf() * 360)

func _on_Asteroid_body_entered(body):
	if body.name == "Player":
		body.emit_signal("damage")
		queue_free()

func _on_Lifetime_timeout():
	queue_free()
