extends Node2D

func _on_area_body_entered(body):
	if(body.name == "Player"):
		body.emit_signal("update_money", body.money + 1)
		self.queue_free()

