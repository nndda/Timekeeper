extends RichTextLabel

func _ready():
	if DisplayServer.is_touchscreen_available():
		hide()
	else: show()
