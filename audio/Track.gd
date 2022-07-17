extends AudioStreamPlayer

# A custom AudioStreamPlayer that will either loop or delete itself on completion

var isLooping := false
var trackType := 0

func _on_Track_finished():
	if isLooping:
		play()
	else:
		queue_free()
