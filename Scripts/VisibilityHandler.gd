extends Node

@export var to_parent_position : bool = false

func _ready(): if to_parent_position:
	$VisibleOnScreenEnabler2D.position =\
	get_parent().position
