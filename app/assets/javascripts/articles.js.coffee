# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
drag_and_slide = $ ->
	drag_and_slide = () ->
		# THE FEEDS
		###########################################################
		
		# SET INITIAL STATE
		$('#gray-screen').hide()
		$('#feeds-wrapper').hide()
		
		# LISTENERS
		# display the feeds menu
		$('#feeds-button-wrapper').click ->
			$('#gray-screen').css
				"height": $(document).height()
			$('#gray-screen').show()
			$('#feeds-wrapper').show()
		$('#gray-screen').click ->
			$(this).hide()
			$('#feeds-wrapper').hide()

		
		# menu options
		$('.feed').click ->
			$('#gray-screen').hide()
			$('#feeds-wrapper').hide()
			$('#loading-sign-wrapper').show()
			$('#items-wrapper').remove()
			kind = $(this).data("kind")
			$.ajax
				url: '/articles/update',
				data: { feed: kind }
				success: (data) ->
					$('#main-area').html(data)
					$('#loading-sign-wrapper').hide()
					drag_and_slide()
				type: 'POST'		
	

		
				
		
		# THE DRAGGER
		###########################################################
	
		# make it draggable
		$('#slider-controls-wrapper').draggable()
	
	
	
		# THE SLIDER
		############################################################
	
		# SET EVERYTHING
		# Define the variables.
		current_position = 0
		items = $('.item-wrapper')
		items_slider = $('#items')
		items_wrapper = $('#items-wrapper')
		number_of_items = items.length
		item_width = 860
		item_wrapper_width = 960
		item_height = 600
		
		# Add css, so that if there is no javascript,
		# it will degrade nicely.
		items_wrapper.css
			"overflow": "hidden"
		items_slider.css
			"width": number_of_items * item_wrapper_width
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
				'margin-left': -( item_wrapper_width * current_position )
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
	
	
		# Generic control listeners
		#$('.control').live "mousedown", ->
			#$(this).css
			#	"background-color:": "rgb(100,100,100)",
			#	"border-radius": '25px'
		#$('.control').live "mouseup", ->
			#$(this).css
			#	"background-color": "rgba(50,50,50,.5)"
			
		# Left click listeners
		$('#left-control').click ->
			slide_right()
			clearTimeout( t )
		
		# right click listeners	
		$('#right-control').click ->
			slide_left()
			clearTimeout( t )
	
		# pause button listeners	
		$('#pause-control').click ->
			slide()
			clearTimeout( t )
	
		# play button listeners
		$('#play-control').click ->
			automate()
		
		# MISC
		# the loading sign wrapper for the ajax refresh
		$('#loading-sign-wrapper').hide()
	
	
	drag_and_slide()

		
