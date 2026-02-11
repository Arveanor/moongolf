extends GGBody

class_name GGControlledBody

# set up some controls!
var input_force = Vector2(0.0, 0.0)
@export var input_scalar = 5000.0

var w_pressed = false
var a_pressed = false
var s_pressed = false
var d_pressed = false

func _physics_process(delta):
	super._physics_process(delta)
	self.apply_central_force(input_force)
	#print(input_force)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_W and !w_pressed:
				w_pressed = true
				self.add_constant_central_force(Vector2(0.0, -input_scalar))
			elif event.keycode == KEY_A and !a_pressed:
				a_pressed = true
				self.add_constant_central_force(Vector2(-input_scalar, 0.0))
			elif event.keycode == KEY_D and !d_pressed:
				d_pressed = true
				self.add_constant_central_force(Vector2(input_scalar, 0.0))
			elif event.keycode == KEY_S and !s_pressed:
				s_pressed = true
				self.add_constant_central_force(Vector2(0.0, input_scalar))
		elif event.is_released():
			if event.keycode == KEY_W:
				w_pressed = false
				self.add_constant_central_force(Vector2(0.0, input_scalar))
			elif event.keycode == KEY_A:
				a_pressed = false
				self.add_constant_central_force(Vector2(input_scalar, 0.0))
			elif event.keycode == KEY_D:
				d_pressed = false
				self.add_constant_central_force(Vector2(-input_scalar, 0.0))
			elif event.keycode == KEY_S:
				s_pressed = false
				self.add_constant_central_force(Vector2(0.0, -input_scalar))
