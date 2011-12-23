# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	
	# SET EVERYTHING
	# Define the variables.
	current_position = 0
	items = $('.item-wrapper')
	items_slider = $('#items')
	items_wrapper = $('#items-wrapper')
	number_of_items = items.length
	item_width = 960
	item_height = 600
		
	# Add css, so that if there is no javascript,
	# it will degrade nicely.
	items_wrapper.css
		"overflow": "hidden"
	items_slider.css
		"width": number_of_items * item_width
	items.css
		"float": "left",
		"width": item_width,
		"height": item_height

	# Set the timeout variable
	t = setTimeout( =>
		automate()
	,5000 )


	
	# THE HOW TO SLIDE FUNCTIONS
	# general slide
	slide = () ->
		current_position = 0 if current_position > number_of_items - 1
		current_position = number_of_items - 1 if current_position < 0
		items_slider.animate
			'margin-left': -( item_width * current_position )
			1000
			
	# slide left
	slide_left = () ->
		current_position += 1
		slide()
	
	# slide right
	slide_right = () ->
		current_position -= 1
		slide()
	

	
	# THE WHEN TO SLIDE FUNCTIONS
	# animation
	automate = () ->
		slide_left()
		t = setTimeout( =>
			automate()
		,5000 )
	
	# Left click listeners
	$('#left-control').click ->
		slide_right()
		clearTimeout( t )
	$('#left-control').live "mousedown", ->
		$(this).css
			"border-right": "25px solid rgb(100,100,100)"
	$('#left-control').live "mouseup", ->
		$(this).css
			"border-right": "25px solid rgba(50,50,50,.5)"
		
	# right click listeners	
	$('#right-control').click ->
		slide_left()
		clearTimeout( t )
	$('#right-control').live "mousedown", ->
		$(this).css
			"border-left": "25px solid rgb(100,100,100)"
	$('#right-control').live "mouseup", ->
		$(this).css
			"border-left": "25px solid rgba(50,50,50,.5)"
	
	# pause button listeners	
	$('#pause-control').click ->
			slide()
			clearTimeout( t )
	$('#pause-control').live "mousedown", ->
		$(this).css
			"border-right": "7.5px solid rgb(100,100,100)"
			"border-left": "7.5px solid rgb(100,100,100)"
	$('#pause-control').live "mouseup", ->
		$(this).css
			"border-right": "7.5px solid rgba(50,50,50,.5)",
			"border-left": "7.5px solid rgba(50,50,50,.5)"