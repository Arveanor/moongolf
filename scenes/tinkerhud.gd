extends Control

@onready var root = get_tree().root.get_child(1)
@onready var planets_slider = $VBoxContainer/PlanetsSlider

var planet_scene = preload("res://scenes/planet.tscn")
var planets_slider_prev = 0

func _on_restart_button_pressed():
	var planet
	var planet_spacing = 80
	Constants.system_builder_bodies.clear()
	for i in range(planets_slider.value):
		planet = planet_scene.instantiate()
		planet.mass = 1.0
		planet.global_position = Vector2(535, 200 - i * planet_spacing)
		planet.will_draw_tail = true	
		planet.initial_velocity = Vector2(75.0, -50.0)
		Constants.system_builder_bodies.append(planet)
	get_tree().reload_current_scene()

func _on_zoom_in_pressed():
	root._camera_zoom_step()

func _on_zoom_out_pressed():
	root._camera_zoom_step(-0.1)

# value_changed is a meaningless variable that godot engineers
# dreamed up while smoking meth, don't try to use it for anything
func _on_planets_slider_updated(_value_changed:bool):
	var planet
	var planet_spacing = 80	
	if planets_slider.value != planets_slider_prev:
		Constants.system_builder_bodies.clear()
		for i in range(planets_slider.value):
			planet = planet_scene.instantiate()
			planet.mass = 1.0
			planet.global_position = Vector2(535, 200 - i * planet_spacing)
			planet.will_draw_tail = true	
			Constants.system_builder_bodies.append(planet)
		planets_slider_prev = planets_slider.value
