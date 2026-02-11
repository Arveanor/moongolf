extends Control

@onready var planet_count_slider = $VBoxContainer/HBoxContainer/HSlider
@onready var planet_detail = $VBoxContainer/PlanetDetail
@onready var sb_scene = preload("res://scenes/BaseBuildScene.tscn")
var component_scene = preload("res://scenes/ui_component_test.tscn")
var planet_scene = preload("res://scenes/planet.tscn")
var orbital_distance_step = 170
var orbital_distance_base = 30

@onready var tail_colors = [Color.CHARTREUSE, Color.TURQUOISE, Color.PALE_VIOLET_RED, Color.WEB_PURPLE, Color.RED]
var planet_details = []
var bodies = []
var rng = RandomNumberGenerator.new()

func _ready():
	if is_inside_tree():
		print("Neat!")
		print(get_tree())
	else:
		print("Oh noooo")

func _on_h_slider_drag_ended(value_changed):
	if !value_changed:
		pass
	var value_delta = planet_count_slider.value - planet_detail.get_child_count()
	var value = planet_count_slider.value
	print(value_delta)
	if value_delta > 0:
		for i in range(planet_detail.get_child_count(), value):
			add_planet_detail_entry(i)
			print("loop iter")
	else:
		for i in range(abs(value_delta)):
			planet_detail.remove_child(planet_detail.get_child(-1))

func add_planet_detail_entry(ordinal):
	var detail = component_scene.instantiate()
	detail.update_planet_tags(ordinal + 1)
	planet_detail.add_child(detail)

func _generate_system():
	var planet
	var moon
	var m = 0
	for i in range(planet_count_slider.value):
		planet = planet_scene.instantiate()
		planet.mass = planet_detail.get_child(i).mass_slider_label.text.to_int()
		planet.global_position = Vector2((i + 1) * orbital_distance_step + orbital_distance_base, 0)
		planet.will_draw_tail = true
		planet.tail_color = tail_colors[i]
		m = planet_detail.get_child(i).moons_slider_label.text.to_int()
		for j in range(m):
			moon = planet_scene.instantiate()
			moon.moon_of = planet
			moon.mass = rng.randf_range(0.5, 3.0)
			moon.will_display_text = false
			moon.will_draw_tail = false
			moon.global_position = planet.global_position + Vector2(0.0, (j+1) * 125.0)
			Constants.system_builder_bodies.append(moon)
		Constants.system_builder_bodies.append(planet)
	get_tree().change_scene_to_packed(sb_scene)
