# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

activateSlider = -> 
	default_weight = $('#weight_display').data('weight')
	default_height = $('#height_display').data('height')
	setWeightDisplay(default_weight)
	setHeightDisplay(default_height) 
	$('#weight_slider').slider({
		orientation: "horizontal"
		min: 80
		max: 300
		value: default_weight
		step: 0.5
		slide: (event, ui) ->
			setWeightDisplay(ui.value)
		})
	$('#height_slider').slider({
		orientation: "horizontal"
		min: 48
		max: 84
		value: default_height
		step: 0.5
		slide: (event, ui) ->
			setHeightDisplay(ui.value)
		})

setHeightDisplay = (height) ->
	Math.floor(height/12)
	$('#feet').text(Math.floor(height/12))
	$('#inches').text(height%12)
	$('#height_input').attr("value", height)

setWeightDisplay = (weight) ->
	$('#weight').text(weight)
	$('#weight_input').attr("value", weight)


$(document).ready activateSlider
$(document).on 'page:load', activateSlider
