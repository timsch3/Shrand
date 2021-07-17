extends Particles2D

func _enter_tree():
	emitting = true
	$Particles2D2.emitting = true
	$AnimationPlayer.play("fade_out")
	$Particles2D2/AnimationPlayer.play("fade_out")


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
