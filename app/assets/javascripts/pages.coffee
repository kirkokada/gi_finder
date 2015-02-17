# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ -> 
	start_weight = 190
	$('#weight').text(start_weight)
	$('#feet').text(5)
	$('#inches').text(10)
	weight_slider = $('#weight_slider')
	weight_slider.slider({
		orientation: "horizontal"
		min: 80
		max: 300
		value: 190
		step: 0.5
		slide: (event, ui) ->
			$('#weight').text(ui.value)
		})
	height_slider = $('#height_slider')
	height_slider.slider({
		orientation: "horizontal"
		min: 48
		max: 84
		value: 70
		step: 0.5
		slide: (event, ui) ->
			$('#feet').text(Math.floor(ui.value/12))
			$('#inches').text(ui.value%12)
		})
