extends CharacterBody2D

@export var speed := 2000
var direction: Vector2
var player: CharacterBody2D
var health := 3
var is_exploding := false
var chain_distance = 40
var chain_delay = 0.1

func _physics_process(delta: float) -> void:
	if player:
		direction = position.direction_to(player.position)
		velocity = direction * speed * delta
		move_and_slide()


func _on_ditection_area_body_entered(body: Node2D) -> void:
	player = body


func _on_ditection_area_body_exited(_body: Node2D) -> void:
	player = null


func _on_collision_area_body_entered(_body: Node2D) -> void:
	explode()


func hit():
	health -= 1
	if health <= 0:
		explode()
		return
	var tween := get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.RED, 0.05)
	tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.05)


func explode():
	if is_exploding:
		return	
	is_exploding = true	
	
	speed = 0
	$AnimationPlayer.stop()
	$ExplosionSprite.show()
	$AnimatedSprite2D.hide()
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished

	queue_free()


# AnimationPlayer の "explode" アニメーション途中で呼ばれる
# 近くのドローンを誘爆させる
func chain_reaction():
	for drone: CharacterBody2D in get_tree().get_nodes_in_group("Drones"):
		if drone == self:
			continue
		if drone.position.distance_to(position) < chain_distance:
			drone.explode()


# スクリプトだけで、誘爆を遅らせる場合の関数
#func explode(delayed := false):
	#if delayed:
		#await get_tree().create_timer(chain_delay).timeout
	#
	#if is_exploding:
		#return
	#
	#is_exploding = true	
	#for drone: CharacterBody2D in get_tree().get_nodes_in_group("Drones"):
		#if drone == self:
			#continue
		#if drone.position.distance_to(position) < chain_distance:
			#drone.explode(true)
	#
	#speed = 0
	#$ExplosionSprite.show()
	#$AnimatedSprite2D.hide()
	#$AnimationPlayer.play("explode")
	#await $AnimationPlayer.animation_finished
	#queue_free()
