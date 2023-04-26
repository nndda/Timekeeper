extends Sprite2D

@export var animation : String

func Play() -> void:
	var animation_node : AnimationPlayer = get_parent().get_node( get_parent().callback_at ) as AnimationPlayer
	animation_node.play( animation )

func AnimFinished( anim_name ) -> void:
	if anim_name == animation: get_parent().queue_free()
