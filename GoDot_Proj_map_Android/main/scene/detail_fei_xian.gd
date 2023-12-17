extends DetailPage




func _on_music_1_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Musics/Audio1StreamPlayer.play()
	else:
		$Musics/Audio1StreamPlayer.playing = false
