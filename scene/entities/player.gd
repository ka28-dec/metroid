extends CharacterBody2D


signal shoot(pos: Vector2, dir: Vector2)


var direction_x : float
var speed := 100
var jump_strength := 300
var gravity := 700
var max_fall_speed := 400
var air_jump_count := 0
var max_air_jumps := 1

const gun_directions = {
	Vector2i(0, 0):  0,
	Vector2i(1,0):   0,
	Vector2i(1,1):   1,
	Vector2i(0,1):   2,
	Vector2i(-1,1):  3,
	Vector2i(-1,0):  4,
	Vector2i(-1,-1): 5,
	Vector2i(0,-1):  6,
	Vector2i(1,-1):  7,
}


func get_input():
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):
			jump()
	if Input.is_action_just_pressed("shoot") and $ReloadTimer.time_left == 0:
		shoot.emit(position, get_local_mouse_position().normalized())
		$ReloadTimer.start()
		# 発射時に十字マーカーが縮むアニメーション
		var tween = get_tree().create_tween()
		tween.tween_property($Marker, "scale", Vector2(0.1, 0.1), 0.2)
		tween.tween_property($Marker, "scale", Vector2(0.5, 0.5), 0.4)


func reset_air_jump_count():
	if is_on_floor():
		air_jump_count = 0


func jump():
	if not is_on_floor():
		if air_jump_count >= max_air_jumps:
			return
		else:
			air_jump_count += 1
	
	velocity.y = -jump_strength


func apply_gravity(delta):
	velocity.y += gravity * delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed


func _physics_process(delta: float) -> void:
	get_input()
	apply_gravity(delta)
	velocity.x = direction_x * speed
	move_and_slide()
	reset_air_jump_count()
	animation()
	update_marker()


func animation():
	if direction_x:
		$Legs.flip_h = direction_x < 0
	
	if is_on_floor():
		$AnimationPlayer.current_animation = 'run' if direction_x else "idle"
	else:
		$AnimationPlayer.current_animation = 'jump'
	
	var raw_dir := get_local_mouse_position().normalized()
	var adjusted_dir := Vector2i(round(raw_dir))
	$Torso.frame = gun_directions[adjusted_dir]


func update_marker():
	$Marker.position = get_local_mouse_position().normalized() * 40
