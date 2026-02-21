extends RigidBody2D

class_name GGBody

@onready var root = get_tree().root.get_child(1)
@onready var display_text = $Label
@export var moon_of: GGBody = null

var tail = Line2D.new()
var celestial_bodies
var timer = Timer.new()
@export var will_draw_tail = false
@export var will_display_text = true
@export var tail_color = Color.TURQUOISE
@export var DEBUG_ELIPTICALITY = 1.0
@export var initial_velocity = Vector2(0.0, 0.0)
@export var DEBUG_LABEL_DISPLAY_MODE = "unimplemented"
@export var is_moon = false


var trapped_bodies = []

func _ready():
	if will_draw_tail:
		root.call_deferred("add_child", tail)
		tail.z_index = 1
		tail.add_point(self.global_position)
		tail.default_color = tail_color
		add_child(timer)
		timer.wait_time = 1.0
		timer.timeout.connect(_on_timer_timeout)
		timer.one_shot = false
		timer.start()
		#timer.timeout.connect(draw_tail)
	
func _physics_process(_delta):
	display_info()
	var combined_gforce = calc_total_force()
	#print(combined_gforce)
	self.apply_central_force(combined_gforce)
	apprehend_moon()
	draw_tail()

func display_info():
	#var sov = root.calculate_sov(self)
	#var angle_to_sov = self.linear_velocity.angle_to(sov)
	var energy = 0.5 * self.linear_velocity.length_squared() * self.mass / 1000
	var d = celestial_bodies[0].global_position.distance_to(self.global_position)
	var potential_energy = -1 * Constants.big_G * self.mass * celestial_bodies[0].mass / d / 1000
	var mechanical_energy = energy + potential_energy

	if(display_text and will_display_text):	
		#display_text.set_text("DV = %.2f | DRad = %.4f" % [self.linear_velocity.length() - sov.length(), angle_to_sov])
		#display_text.set_text("E = %.2f | PE = %.2f" % [energy, potential_energy])
		display_text.set_text("Escape Energy = %.2f" % mechanical_energy)
		if(mechanical_energy > -150.0):
			update_tail_color()
			
		
		#display_text.set_text("V = " + String.num(self.linear_velocity.length(), 2) + ", d = " + String.num(d, 2))
		#display_text.set_text("DV = %.2v" % (self.linear_velocity - root.calculate_sov(self)))

func update_tail_color():
	pass

func calc_total_force():
	var accumulated_force = Vector2(0.0, 0.0)
	if celestial_bodies == null:
		return accumulated_force
	for body in celestial_bodies:
		if body != self:
			var to_body = body.global_position - self.global_position
			#print(str(Constants.big_G) + " * " + str(self.mass * body.mass) + " / " + str(to_body.length_squared()) + " * " + str(to_body.normalized()))
			accumulated_force += Constants.big_G * (self.mass * body.mass / to_body.length_squared()) * to_body.normalized()
	return accumulated_force
		
func _on_timer_timeout():
	pass
	
func draw_tail():
	tail.add_point(self.global_position)	
	if tail.points.size() >= 1800:
		tail.remove_point(0)
	
# create overlap area
# check bodies in overlap area
# apply mods to the body
func apprehend_moon():
	var relative_sov
	var relative_v
	for body in trapped_bodies:
		relative_sov = root.calculate_sov(body, self) + self.linear_velocity
		body.linear_velocity = body.linear_velocity.lerp(relative_sov, 0.1)
		relative_v = body.linear_velocity - self.linear_velocity # should give us body's v relative to self
	

func _on_body_entered_trap(_body):
	if(_body.is_moon):
		trapped_bodies.append(_body)

func _on_body_exited_trap(_body):
	var i = trapped_bodies.find(_body)
	if i != -1:
		trapped_bodies.remove_at(i)
	else:
		print("Warning: body.gd:_on_body_exited_trap Body not found in array for removal")
