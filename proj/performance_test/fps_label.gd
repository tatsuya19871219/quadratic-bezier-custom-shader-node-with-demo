extends Label

func _process(delta):
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	#print(fps) # Prints the FPS to the console.
	self.text = "FPS: {fps}".format({"fps": fps}) 
