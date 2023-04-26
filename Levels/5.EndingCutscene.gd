extends AnimationPlayer

func _process(_delta):
#	if is_playing() and current_animation == "End":
	$"../Lights/ClockFace".visible = true
	$"../Lights/ClockFaceCorner".visible = true
	$"../Lights/ClockFaceCorner2".visible = true
	$"../Lights/ClockFaceCorner3".visible = true
	$"../Lights/ClockFaceCorner4".visible = true
	if current_animation == "End":
#		$"../Player".velocity = Vector2.ZERO
		$"../Player".process_mode = Node.PROCESS_MODE_DISABLED


func _on_ending_cutscene_trigger_body_entered(body):
	if body.get_name() == "Player":
		$".".play( "End" )
		$"../EndingCutsceneTrigger".queue_free()
