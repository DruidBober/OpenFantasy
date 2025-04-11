extends TextEdit




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

var lastFps = 0
var currentFps = 0
var avgFps = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentFps = Engine.get_frames_per_second()
	if currentFps != lastFps:
		avgFps += currentFps
		avgFps /= 2
	lastFps = currentFps
	

	text = "FPS: " + str(avgFps).pad_decimals(0)
