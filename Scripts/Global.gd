extends Node

var user_data : Dictionary = {
	high_score			= 0,
	best_time			= false
}

const GRAVITY		: float = 980
var gravity_scale	: float = 1.0
var time_scale		: float = 1.0

var camera_boundary : PackedInt32Array = [0,0,0,0]

var current_level : Object
var current_interractable : Object


func get_children_if( prefix : String, target : Node ) -> Array[ Node ]:
	var output : Array[ Node ] = []
	for child in target.get_children():
		if child.get_name().begins_with( prefix ):
			output.append( child )
	return output
