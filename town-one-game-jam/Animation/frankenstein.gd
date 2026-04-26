extends Node3D

@export var vfx_list: Array[GPUParticles3D]

func _ready():
	for vfx in vfx_list:
		if vfx:
			vfx.emitting = false

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:

		if event.keycode == KEY_PERIOD:
			for vfx in vfx_list:
				if vfx:
					vfx.emitting = true
