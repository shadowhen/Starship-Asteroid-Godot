extends Control

const CONFIG_PATH = "res://settings.cfg"

onready var GAME_SCENE = preload("res://Scenes/Game.tscn")
onready var OPITIONS_SCENE = load("res://Scenes/Options.tscn")
onready var AUDIO_LAYOUT = load("res://default_bus_layout.tres")

func _ready():
	_load_settings()


func _load_settings():
	var config = ConfigFile.new()
	
	if config.load(CONFIG_PATH) == OK:
		print("OK")
		AudioServer.set_bus_layout(AUDIO_LAYOUT)
		AudioServer.set_bus_volume_db(0, config.get_value("Settings", "Volume"))
		OS.window_fullscreen = config.get_value("Settings", "Fullscreen")


func _on_StartButton_pressed():
	get_tree().change_scene_to(GAME_SCENE)


func _on_OpitionsButton_pressed():
	get_tree().change_scene_to(OPITIONS_SCENE)


func _on_QuitButton_pressed():
	get_tree().quit()
