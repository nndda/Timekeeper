extends Sprite2D

func _ready():
	$Area2D.monitoring = true
func _on_area_entered(area):
	print(area)
	if area.get_name() == "Broom":
		$AnimationPlayer.play("Cleaned")

func _on_AnimationPlayer_finished(anim_name):
	if anim_name == "Cleaned": queue_free()
