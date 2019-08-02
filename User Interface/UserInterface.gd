extends Control

func update_score(score):
	$ScoreLabel.text = str(score)

func play_weapon_cooldown():
	$AnimationPlayer.play("WeaponCooldown")