extends Control

const CONFIG_PATH = "res://settings.cfg"

onready var GAME_SCENE = preload("res://Scenes/Game.tscn")
onready var OPITIONS_SCENE = load("res://Scenes/Options.tscn")
onready var AUDIO_LAYOUT = load("res://default_bus_layout.tres")

var _settings = {
	"Settings" : {
		"Volume" : -10,
		"Fullscreen" : false
	}
}


func _ready():
	_load_settings()


func _load_settings():
	var config = ConfigFile.new()
	
	if config.load(CONFIG_PATH) == OK:
		AudioServer.set_bus_layout(AUDIO_LAYOUT)
		AudioServer.set_bus_volume_db(0, config.get_value("Settings", "Volume"))
		OS.window_fullscreen = config.get_value("Settings", "Fullscreen")
	else:
		for section in _settings.keys():
			for key in _settings[section].keys():
				config.set_value(section, key, _settings[section][key])
		config.save("res://settings.cfg")


func _on_StartButton_pressed():
	get_tree().change_scene_to(GAME_SCENE)


func _on_OpitionsButton_pressed():
	get_tree().change_scene_to(OPITIONS_SCENE)


func _on_QuitButton_pressed():
	get_tree().quit()
