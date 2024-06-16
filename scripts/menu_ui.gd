extends CanvasLayer

signal go_game
signal save_game
signal loading_game
signal exit_game

#继续游戏
func _on_go_button_button_down():
	go_game.emit()

#保存游戏
func _on_save_button_button_down():
	save_game.emit()

#加载游戏
func _on_loading_button_button_down():
	loading_game.emit()

#离开游戏
func _on_exit_button_button_down():
	exit_game.emit()
