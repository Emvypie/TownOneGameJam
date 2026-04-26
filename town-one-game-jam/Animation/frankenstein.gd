extends Node3D

@export var period_vfx: Array[GPUParticles3D]
@export var comma_vfx: Array[GPUParticles3D]

func _ready():
	for vfx in period_vfx:
		if vfx:
			vfx.emitting = false

	for vfx in comma_vfx:
		if vfx:
			vfx.emitting = false

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:

		if event.keycode == KEY_PERIOD:
			for vfx in period_vfx:
				if vfx:
					vfx.emitting = true

		elif event.keycode == KEY_COMMA:
			for vfx in comma_vfx:
				if vfx:
					vfx.emitting = true
