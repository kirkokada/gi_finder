# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ -> 
	default_weight = 190
	default_height = 70
	$('#weight').text(default_weight)
	$('#feet').text(5)
	$('#inches').text(10)
	$('#weight_input').attr("value", default_weight)
	$('#height_input').attr("value", default_height)
	weight_slider = $('#weight_slider')
	weight_slider.slider({
		orientation: "horizontal"
		min: 80
		max: 300
		value: default_weight
		step: 0.5
		slide: (event, ui) ->
			$('#weight').text(ui.value)
			$('#weight_input').attr("value", ui.value)
		})
	height_slider = $('#height_slider')
	height_slider.slider({
		orientation: "horizontal"
		min: 48
		max: 84
		value: default_height
		step: 0.5
		slide: (event, ui) ->
			$('#feet').text(Math.floor(ui.value/12))
			$('#inches').text(ui.value%12)
			$('#height_input').attr("value", ui.value)
		})
