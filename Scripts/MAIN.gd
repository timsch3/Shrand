extends Node

var points = 0
var shots = 14

func _ready():
	$UI/HBox2/GameOver.visible = false


func _process(_delta):
	$UI/HBox/Shots.text = str("Shots left: ", shots+1)
	$UI/HBox/Time.text = str("Time left: ", int($Countdown.get_time_left()))
	$UI/HBox/Points.text = str("Points: ", points)
	
	if shots == 0:
		$GameOver.start(1)
	
	if Input.is_action_just_pressed("ui_accept") and get_tree().paused:
		get_tree().paused = false
		get_tree().reload_current_scene()
		
func game_over():
	get_tree().paused = true
	$UI/HBox2/GameOver.visible = true
		
func _on_Countdown_timeout():
	game_over()
	
func _on_GameOver_timeout():
	game_over()
