extends RichTextLabel

func _ready() -> void:
	push_italics()

func LogText(logText):
	$DebugLabel.append_text(logText) 


