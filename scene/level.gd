extends Node2D

var bullet_scene : PackedScene = preload("res://scene/bullets/bullet.tscn")


func _ready() -> void:
	var light_tween := create_tween()
	light_tween.set_loops()
	light_tween.tween_property($PointLight2D2, "energy", 1.1, 2)
	light_tween.tween_property($PointLight2D2, "energy", 0.4, 2)
	


func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	var bullet := bullet_scene.instantiate() as Area2D
	bullet.setup(pos, dir)
	$Bullets.add_child(bullet)
