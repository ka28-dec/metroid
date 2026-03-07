extends Area2D

var speed := 400
var direction := Vector2.ZERO


func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.1).from(Vector2.ZERO)


func _process(delta: float) -> void:
	position += direction * speed * delta


func setup(pos: Vector2, dir: Vector2):
	position = pos + dir * 16
	direction = dir
	rotation = dir.angle()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit()
	queue_free()
