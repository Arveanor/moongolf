extends Control

var qp_scenes = [preload("res://scenes/quickplay01.tscn"), preload("res://scenes/quickplay02.tscn")]
var sys_builder_scene = preload("res://scenes/system_builder.tscn")

var planet_scene = preload("res://scenes/planet.tscn")

@onready var root_menu = $RootMenu
var sys_builder
var root_menu_children = []

func _ready():
	sys_builder = sys_builder_scene.instantiate()
	root_menu_children = root_menu.get_children()

func _on_quick_play_pressed():
	get_tree().change_scene_to_packed(qp_scenes[0])

func _on_system_builder_pressed():
	# add system builder scene
	#self.remove_child(root_menu)
	for child in root_menu_children:
		root_menu.remove_child(child)
	root_menu.add_child(sys_builder)


func _on_quit_game_pressed():
	# notification so i remember it exists if i need it later
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()



func _on_quick_play3_pressed():
	get_tree().change_scene_to_packed(qp_scenes[0])

func _on_quick_play2_pressed():
	get_tree().change_scene_to_packed(qp_scenes[0])

func _on_quick_play1_pressed():
	get_tree().change_scene_to_packed(qp_scenes[1])

