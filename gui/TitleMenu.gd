extends Control

onready var settings_panel = $SettingsPanel

onready var seed_edit = $HBoxContainer/SeedEdit

func _on_StartButton_button_up():
	pass # Replace with function body.

func _on_SettingsButton_button_up():
	$SettingsPanel.show()

func _on_QuitButton_button_up():
	pass # Replace with function body.


func _on_CloseSettingsButton_button_up():
	settings_panel.hide()
