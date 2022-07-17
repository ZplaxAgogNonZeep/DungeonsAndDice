extends Node


# Manages various audio track signals. 

func startTrack(trackName : String, trackType : int, isLooping : bool):
	# Takes a track and decides what to do with it with the given variables.
	# toReplace variable will end any playing track at the given index with 0 as null
	# Track Type will affect which library to pull track from:
	# 0 = SFX
	# 1 = Music
	
	var track = preload("res://audio/Track.tscn").instance()
	var folder : String
	match trackType:
		0:
			track.volume_db = get_parent().sfx_volume
			folder = "SFX"
		1:
			track.volume_db = get_parent().music_volume
			folder = "music"
		_:
			print("startTrack() given an Invalid trackType at " + str(trackType))
	
	# This will crash if things go wrong so don't get things wrong!!!!
	track.stream = load("res://audio/" + folder + "/" + trackName + ".wav")
	
	track.trackType = trackType
	track.isLooping = isLooping
	
	
	add_child(track)
	track.play()

func clearAudio(trackType : int, clearAll:=false):
	# Deletes all tracks of a given type, if clearAll is given, deletes all tracks
	if clearAll:
		for i in range(get_child_count()):
			get_child(0).queue_free()
	else:
		for i in range(get_child_count()):
			if get_child(0).trackType == trackType:
				get_child(0).queue_free()

func changeVolume(trackType : int, value : float):
	# Changes all tracks of a specific type to a given volume
	for i in range(get_child_count()):
		if get_child(i).trackType == trackType:
			get_child(i).volume_db = value
