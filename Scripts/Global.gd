extends Node

var user_data : Dictionary = {
	high_score			= 0,
	best_time			= false
}

const GRAVITY		: float = 980
var gravity_scale	: float = 1.0
var time_scale		: float = 1.0

var camera_boundary : PackedInt32Array = [0,0,0,0]
