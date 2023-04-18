extends Node2D

@export_node_path( "ColorRect", "ReferenceRect" ) var camera_boundary
@export_category( "Objectives" )
@export var gearwheel_objectives : Array[ NodePath ]
@export var spider_objectives : Array[ NodePath ]
@export_node_path( "Node2D" ) var door_to_next_level

signal objective_completed

func _ready():
	var camlim = get_node( camera_boundary )
	glbl.camera_boundary = [
		int( camlim.position.x ),
		int( camlim.position.y ),
		int( camlim.position.x + camlim.size.x ),
		int( camlim.position.y + camlim.size.y )
	]

	for gear in gearwheel_objectives:
		get_node( gear ).connect( "activated", Callable( self, "ObjectiveCompleted" ) )


func  ObjectiveCompleted() -> Array[ bool ]:
	var check_gears : Array[ bool ] = []
	for gear in gearwheel_objectives:
		check_gears.append( get_node( gear ).active )
	return check_gears
