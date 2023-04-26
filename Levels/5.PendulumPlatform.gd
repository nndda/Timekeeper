extends Node2D

@export_node_path( "Node2D" ) var follow

func _physics_process( _delta ):
	global_position = get_node( follow ).global_position
