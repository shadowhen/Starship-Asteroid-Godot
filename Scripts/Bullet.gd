extends Area2D

export (float) var speed = 5.0

func _process(delta):
	if not get_tree().paused:
		self.position += -transform.y * speed

func _on_Lifetime_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	if "Enemies" in body.get_groups():
		body.queue_free()
		
		# Match the enemy type to give correct points
		if "Asteroids" in body.get_groups():
			get_node("..").add_points(1)
			get_node("..").audio_manager.play("AsteroidExplosion")
		
		queue_free()
