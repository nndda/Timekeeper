extends Line2D

func _ready(): if !get_parent().active: Run( 0 )

func Run( speed : float = 2.0 ) -> void:
	material.set_shader_parameter( "speed_scale", speed )
