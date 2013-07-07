// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require foundation
$(document).foundation();

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require_tree .

/* Start variable definition  */
var slided;
var page_number;
var loading_posts;

var images;
/* End of variable definition */

/* Global startup setup method */
function setup() {
	page_number = 1; 
	slided 		= false;
	loading_posts  = false;

	images = {};
}

function toggleSlide() { 
	if(!slided) {
		$("#adder").slideDown("slow");
		slided = true;
	}
	else {
		$("#adder").slideUp("slow");
		slided = false;
	}
}

function visit(post) {
	alert('ok');
	window.location = post;
	return false;
}
$(document).foundation();

$(function(){ $(document).foundation(); });

/* Jquery observing the more_link link at bottom of index, to process it via JS */
$('#more_link').click(function (event) {
  if(!loading_posts) { 
  		loading_posts = true;
  		alert('Hooray!');
  		 $("#more_button_text").html("<img src='assets/icons/loading.gif'><i>Loading...</i>");  		
  }
  else {
  		 $("#more_button_text").html("Give Me More");
  		 loading_posts = false;
  }
  event.preventDefault(); // Prevent link from following its href
});

function loadImage(url, id) {
	// if parameters not suplied
	if (!url || !id) {
		return false;
	}
	if (!images[url]) {
		// if image has not been loaded
		images[url] 		= new Image();
		// add an onload method for this object for when the src is set and it loads.
		images[url].onload 	= function() { imageLoaded(id, url); }
		// add the src so that the image loads
		images[url].src		= url;
	} else {
		// image is already loaded
		imageLoaded(id, url);
	}
}

function imageLoaded(id, url) {
		// image has been loaded so:
		// switch image using jquery		
		$("#"+id+"").attr('src', ""+images[url].src+"");
		return false;
}

function showImage(url, id) {
		loadImage(url, id);
		//original	= $("#"+id+"").attr('src');
		//images[id] 	= [new Image(), $("#"+id+"").attr('src')]
		//images[id] 	= url 
		//$("#"+id+"").attr('src', ""+url+"");
		return false;
}


