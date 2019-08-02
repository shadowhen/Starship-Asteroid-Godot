extends Node

const STATE_PLAY = "PLAY"
const STATE_PAUSE = "PAUSE"
const STATE_GAME_OVER = "GAME_OVER"
const STATE_OPTIONS = "OPTIONS"

onready var player = $Player
onready var ui = $UI
onready var audio_manager = $AudioManager
onready var enemy_spawner = $SpawnPath
onready var options = $Options

var score = 0
var player_dead = false
var current_state = STATE_PLAY


func _ready():
	randomize()
	$UI.update_score(score)
	player.connect("die", self, "game_over")
	player.connect("shoot", ui, "play_weapon_cooldown")
	player.connect("shoot", audio_manager, "play", ["LaserAudio"])
	player.connect("damage", audio_manager, "play", ["StarshipDamage"])

func _unhandled_key_input(event):
	if event.is_action_pressed("pause_game"):
		match current_state:
			STATE_PLAY:
				open_game_menu()
			STATE_PAUSE:
				close_game_menu()
			STATE_OPTIONS:
				close_options()


func open_game_menu():
	get_tree().paused = true
	$GameMenu.show()
	current_state = STATE_PAUSE
	enemy_spawner.timer.paused = true


func close_game_menu():
	get_tree().paused = false
	$GameMenu.hide()
	current_state = STATE_PLAY
	enemy_spawner.timer.paused = false


func open_options():
	match current_state:
		STATE_PAUSE:
			$GameMenu.hide()
		STATE_GAME_OVER:
			$GameOver.hide()
	current_state = STATE_OPTIONS
	options.show()
	options.load_settings()


func close_options():
	options.hide()
	options.save_settings()
	
	print("player_dead: " + str(player_dead))
	
	if player_dead:
		current_state = STATE_GAME_OVER
		$GameOver.show()
		print("showing game over")
	elif not player_dead:
		current_state = STATE_PAUSE
		$GameMenu.show()
		print("showing game menu")


func game_over():
	player_dead = true
	audio_manager.play("StarshipDeath")
	ui.hide()
	$GameOver.show()
	$GameOver/ScoreContainer/Score.text = str(score).pad_zeros(10)
	
	print($GameMenu)
	current_state = STATE_GAME_OVER
	
	get_tree().paused = true


func _return_to_main_menu():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	get_tree().paused = false


func add_points(points):
	score += points
	$UI.update_score(score)

func _on_Zone_body_exited(body):
	body.queue_free()


func _on_Zone_area_exited(area):
	area.queue_free()

	
func _on_RestartButton_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
