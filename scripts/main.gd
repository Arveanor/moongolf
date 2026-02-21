extends Node2D

var body_scene = preload("res://scenes/planet.tscn")


@onready var star = $star
#@onready var planet = $planet
#@onready var planet2 = $planet2
#@onready var planet3 = $planet3
#@onready var planet4 = $planet4
@onready var camera = $Camera2D
@onready var label = $CanvasLayer/Control/Label
@onready var cogcursor = $cogcursor
@onready var celestial_bodies = []

@onready var camera_target = star
@export var gamemode = "standard"
var camera_target_index = 0



func _ready():
	print("Main._ready() system_builder_bodies = " + str(Constants.system_builder_bodies))
	celestial_bodies.append(star)
	for child in self.get_children(): # adding bodies from scene for qp
		if child is GGBody and !(child is GGControlledBody):
			planetary_setup(child)

	for body in Constants.system_builder_bodies:
		body.z_index = 2
		planetary_setup(body)
		self.add_child(body)
		
	
	star.celestial_bodies = celestial_bodies
	camera.zoom = Constants.camera_zoom
		
func planetary_setup(body):
	if( gamemode == "debug_parallels" ):
		_capture_test(body)
	else:
		celestial_bodies.append(body)
		if body.moon_of != null:
			body.linear_velocity = calculate_sov(body) + (1.0 * calculate_sov(body, body.moon_of)) #+ body.moon_of.linear_velocity
			print("moon lv = %.2v" % body.linear_velocity)
			print("moon's planet lv = %.2v" % body.moon_of.linear_velocity)
		else:
			body.linear_velocity = calculate_sov(body) * body.DEBUG_ELIPTICALITY
		# need to know that a body is a moon
		# need to know which planet that moon belongs to
		# then calculate sov off planet and star

	body.celestial_bodies = celestial_bodies


func get_bodies():
	return celestial_bodies

func add_body(body):
	pass
	
func remove_body(body):
	pass

func calculate_sov(body, orbiting = star):
	var direction_vec = body.global_position.direction_to(orbiting.global_position).orthogonal()
	var orbital_radius = (body.global_position - orbiting.global_position).length()
	print("main.calculate_sov(): orbital_radius = %.1f" % orbital_radius)
	var V = pow(Constants.big_G * orbiting.mass / orbital_radius, 0.5)
	
	return V * direction_vec
	
	
func _process(delta):
	#var planet_od = planet.global_position.distance_to(star.global_position)
	#var moon_to_planet_od = planet.global_position.distance_to(planet2.global_position)
	var stringy_v = "(" + String.num(star.linear_velocity.x, 2) + ", " + String.num(star.linear_velocity.y, 2) + ")"
	label.set_text("Vroom (How Bigly): " + stringy_v) 
	#"\nPlanet OD: " + String.num_uint64(planet_od) +
	#"\nMoon-Planet OD: " + String.num_uint64(moon_to_planet_od))
	calculate_gravity_center()
	camera.global_position = camera_target.global_position
	
func pun_sum(accumulator, next):
	accumulator.global_position += (next.global_position * next.mass)
	accumulator.mass += next.mass
	return accumulator

func calculate_gravity_center():
	var avg_theoretical_body = body_scene.instantiate()
	avg_theoretical_body.mass = 0.001 #quashing error the old fashioned way
	avg_theoretical_body.global_position = Vector2(0, 0)
	avg_theoretical_body = celestial_bodies.reduce(pun_sum, avg_theoretical_body)
	cogcursor.global_position = avg_theoretical_body.global_position / avg_theoretical_body.mass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_SHIFT:
				camera_target_index = (camera_target_index + 1) % celestial_bodies.size()
				camera_target = celestial_bodies[camera_target_index]
			if event.keycode == KEY_R:
				get_tree().reload_current_scene()
				

# Used for testing inbound bodies and their ideal capture trajectories
func _capture_test(body):
	body.linear_velocity = body.initial_velocity

func _camera_zoom_step(step = 0.1):
	camera.zoom.x += step
	camera.zoom.y += step
	Constants.camera_zoom = camera.zoom
	
func _slow_lerp_func_thing(b1, b2):
	var tval = 0.1
	b1.velocity = b1.velocity.lerp(b2.velocity, tval)
