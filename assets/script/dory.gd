extends CharacterBody2D

var jumpForce = 0
var jumpTimer = 0.0
var jumpTimerStart = 1.0
var gravity = 1000
var gameStarted = false
var screen_size: Vector2
var is_dead = false

@onready var camera = $Camera2D
var is_touching = false
var speed = 10

func timeJump(delta):
	if jumpTimer > 0:
		jumpTimer -= delta

func what_is_floor(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.play("dory_up")
		jumpTimer = 0
	else:
		velocity.y = 0
		$AnimatedSprite2D.play("dory_stop")
		
		jumpTimer += delta
		if jumpTimer >= jumpTimerStart and gameStarted:
			velocity.y = jumpForce
			jumpTimer = 0.0
	
	# Zere a velocidade horizontal ao colidir com o chão
	if is_on_floor():
		velocity.x = 0
	
	move_and_slide()


func _input(event) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			is_touching = true
			gameStarted = true
		else:
			is_touching = false
			

func follow_touch(delta) -> void:
	if is_touching and not is_on_floor() and gameStarted:
		var touch_position = get_global_mouse_position()  # Posição do toque
		# Atualiza a posição do personagem no eixo X apenas se o toque estiver ativo
		position.x += (touch_position.x - position.x) * speed * delta

func update_sprite_direction() -> void:
	# Verifica a direção do movimento com base na posição do toque
	if is_touching and not is_on_floor() and gameStarted:
		var touch_position = get_global_mouse_position()
		if touch_position.x < position.x:
			$AnimatedSprite2D.flip_h = false  # Vira a sprite para a esquerda
		elif touch_position.x > position.x:
			$AnimatedSprite2D.flip_h = true  # Vira a sprite para a direita

func limitViewport(): #Limita o movimentodo jogador na viewport
	position.x = clamp(position.x, 0, screen_size.x)

func die():
	gameStarted = false
func _ready() -> void:
	screen_size = get_viewport().get_size()


func _process(delta: float) -> void:
	if velocity.y < 0:
		$CollisionPolygon2D.disabled = true
	if velocity.y > 0 :
		$CollisionPolygon2D.disabled = false
	jumpForce = -600

	update_sprite_direction()
	follow_touch(delta)
	what_is_floor(delta)
	limitViewport()

	print(is_touching)
	
func _on_body_entered(body):
		if body.is_in_group("Personagem"):
			die()
