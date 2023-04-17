extends Node2D

@export_node_path( "ColorRect" ) var camera_boundary

func _ready():
	var camlim = get_node( camera_boundary )
	glbl.camera_boundary = [
		int( camlim.position.x ),
		int( camlim.position.y ),
		int( camlim.position.x + camlim.size.x ),
		int( camlim.position.y + camlim.size.y )
	]
