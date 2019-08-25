extends Control

const SAVE_PATH = "res://settings.cfg"

onready var container = $SettingsContainer
onready var volume_slider = container.get_node("VolumeContainer/HSlider")
onready var fullscreen_toggle = container.get_node("CheckBox")
onready var main_menu_scene = load("res://Scenes/MainMenu.tscn")

export (AudioBusLayout) var audio_bus_layout
export (bool) var go_to_return_scene = true

var _config_file = ConfigFile.new()
var _settings = {
	"Settings" : {
		"Volume" : -10,
		"Fullscreen" : false
	}
}


func _ready():
	AudioServer.set_bus_layout(audio_bus_layout)
	load_settings()


func load_settings():
	# Attempts to load a config file, and
	# if loading has failed, the program would create new settings
	# using default parameters
	match _config_file.load(SAVE_PATH):
		OK:
			# Copies settings from the file into the dictorary being used for now
			for section in _settings.keys():
				for key in _settings[section].keys():
					_settings[section][key] = _config_file.get_value(section, key)
			
			volume_slider.value = _config_file.get_value("Settings", "Volume")
			fullscreen_toggle.pressed = _config_file.get_value("Settings", "Fullscreen")
		ERR_CANT_OPEN:
			save_settings()


func save_settings():
	for section in _settings.keys():
		for key in _settings[section].keys():
			_config_file.set_value(section, key, _settings[section][key])
	_config_file.save(SAVE_PATH)


func _on_FullscreenBox_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	_settings["Settings"]["Fullscreen"] = button_pressed


func _on_VolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	_settings["Settings"]["Volume"] = value


func _on_ReturnButton_pressed():
	save_settings()
	if go_to_return_scene:
		get_tree().change_scene_to(main_menu_scene)


func _on_TestAudioButton_pressed():
	$TestAudio.play()
