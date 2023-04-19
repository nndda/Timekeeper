extends Area2D

@export_node_path( "Node" ) var callback_at : NodePath
@export var callback_function : String
@export var callback_reset : String
@export var one_time : bool = true


func _ready():
	if one_time: disconnect( "body_exited",
	Callable( self, "_on_body_exited" ) )


func CallFunction( reset : bool = false ) -> void:
	var method : String = callback_function if !reset else callback_reset

	if get_node( callback_at ).has_method( method ):
		get_node( callback_at ).call( method )

	if one_time: queue_free()


func _on_body_entered( body ):
	if body.get_name() == "Player": CallFunction()

func _on_body_exited( body ):
	if body.get_name() == "Player": CallFunction( true )
