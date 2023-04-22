extends Node2D

@export_node_path( "ColorRect", "ReferenceRect" ) var camera_boundary
@export_category( "Objectives" )
@export var gearwheel_objectives : Array[ NodePath ]
var gearwheel_objective_count : int = 0
var gearwheel_objective_total : int = 0
@export var spider_objectives : Array[ NodePath ]
var spider_objectives_count : int = 0

@export_node_path( "Node2D" ) var door_to_next_level
var objective_lights : Array[ Object ]

signal objective_completed( count : int )

func _enter_tree(): glbl.current_level = self

func _ready():
	$UI.show()

	var camlim = get_node( camera_boundary )
	glbl.camera_boundary = [
		int( camlim.position.x ),
		int( camlim.position.y ),
		int( camlim.position.x + camlim.size.x ),
		int( camlim.position.y + camlim.size.y ) ]

	glbl.gravity_scale = 1.0

	var ObjectiveLight = get_node( door_to_next_level ).get_node( "ObjectiveLight" )

	for light in ObjectiveLight.get_children():
		objective_lights.append(
			light.get_child( 0 ) )

	for gear in gearwheel_objectives:
		gearwheel_objective_total += 1

		get_node( gear ).connect( "activated",
		Callable( self, "ObjectiveCompleted" ) )

	get_node( door_to_next_level ).conditional = gearwheel_objective_total

func RestartLevel() -> void:
	get_tree().change_scene_to_file(
		"res://Levels/" +\
		glbl.current_level.get_name() +\
		".tscn" )

func  ObjectiveCompleted() -> void:
	gearwheel_objective_count += 1

	objective_lights[ 0 ].visible = true
	if !objective_lights.is_empty():
		objective_lights.remove_at( 0 )

	objective_completed.emit( gearwheel_objective_count )
