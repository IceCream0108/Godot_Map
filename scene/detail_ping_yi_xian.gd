extends DetailPage



func _on_music_1_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Musics/Audio1StreamPlayer.play()
	else:
		$Musics/Audio1StreamPlayer.playing = false


func _on_music_2_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Musics/Audio1StreamPlayer2.play()
	else:
		$Musics/Audio1StreamPlayer2.playing = false


func _on_music_3_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Musics/Audio1StreamPlayer3.play()
	else:
		$Musics/Audio1StreamPlayer3.playing = false


func _on_music_4_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Musics/Audio1StreamPlayer4.play()
	else:
		$Musics/Audio1StreamPlayer4.playing = false


func _on_music_5_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Musics/Audio1StreamPlayer5.play()
	else:
		$Musics/Audio1StreamPlayer5.playing = false
