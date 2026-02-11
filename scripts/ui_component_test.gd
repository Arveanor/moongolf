extends HBoxContainer

@onready var mass_label = $VBoxContainer/Label3
@onready var moons_label = $VBoxContainer2/Label4
@onready var moons_slider_label = $VBoxContainer2/HBoxContainer2/TextureRect/RichTextLabel
@onready var mass_slider_label = $VBoxContainer/HBoxContainer/TextureRect/Label

@onready var moon_detail = preload("res://scenes/sysbuilder_moon_detail.tscn")

var base_label_text = "Debug Mode "

func _ready():
	mass_label.set_text("" + base_label_text + " Mass")
	moons_label.set_text("" + base_label_text + " Moons")
	
func update_planet_tags(ordinal):
	base_label_text = "Planet " + str(ordinal)

func _update_moons_label(value):
	var old_value = int(moons_slider_label.text)
	moons_slider_label.set_text(str(value))
	
	if old_value < value: 
		print("remove items")
	else:
		print("instantiate and add_child")
	
func _update_mass_label(value):
	mass_slider_label.set_text(str(value))
