extends Sprite2D

func ToNextLevel() -> void:

	var next_level : String = "res://Levels/" +\
	str( int( glbl.current_level.get_name() ) + 1 ) + ".tscn"

	get_tree().change_scene_to_file( next_level )

func CompleteObjective() -> void: pass

func _on_interracted():
	pass # Replace with function body.
