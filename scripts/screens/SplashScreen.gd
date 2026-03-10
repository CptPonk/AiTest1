extends Control
## Splash screen with animated transition to main menu

class_name SplashScreen

@onready var fade_rect = $FadeRect/FadeOverlay
@onready var logo = $CanvasLayer/LogoContainer/VBoxContainer/Logo
@onready var subtitle = $CanvasLayer/LogoContainer/VBoxContainer/Subtitle

var _skip_animation = false

func _ready() -> void:
	# Fade in animation
	fade_rect.modulate = Color.BLACK
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate", Color.TRANSPARENT, 0.5)
	
	# Animate logo
	tween.set_parallel(true)
	tween.tween_property(logo, "modulate", Color.WHITE, 1.0)
	tween.tween_property(subtitle, "modulate", Color.WHITE, 1.0)
	
	# Wait for animation or input
	await get_tree().create_timer(3.0).timeout
	
	if not _skip_animation:
		_transition_to_menu()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		_skip_animation = true
		_transition_to_menu()

func _transition_to_menu() -> void:
	# Fade out
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate", Color.BLACK, 0.5)
	await tween.finished
	
	get_node("/root/ScreenManager").goto_screen("main_menu")
