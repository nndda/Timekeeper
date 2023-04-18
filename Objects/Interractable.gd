extends Area2D

var allow_interract : bool = true

signal interracted

func _ready(): $Label.hide()

func _process( _delta ):
	if glbl.current_interractable == self and allow_interract:
		if Input.is_action_just_pressed( "Interract" ):
			emit_signal( "interracted" )

func _on_body_entered( body ):
	if body.get_name() == "Player":
		glbl.current_interractable = self
		$Label.show()

func _on_body_exited( body ):
	if body.get_name() == "Player":
		glbl.current_interractable = null
		$Label.hide()
