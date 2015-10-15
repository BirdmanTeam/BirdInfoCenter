// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.min
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function select_current_page(controller_name, controller_action){
    var menu_elems = $('.nav-wrapper ul li a');
    var do_active;
    switch(controller_action){
        case 'index':
        case 'new':
                do_active = true;
            break;
        default:
                do_active = false;
            break;
    }
    if (do_active) {
        switch (controller_name) {
            case 'news':
                menu_elems.eq(0).addClass('choosen-grope');
                break;
            case 'sport':
                menu_elems.eq(1).addClass('choosen-grope');
                break;
            case 'music':
                menu_elems.eq(2).addClass('choosen-grope');
                break;
            case 'politic':
                menu_elems.eq(3).addClass('choosen-grope');
                break;
            case 'economic':
                menu_elems.eq(4).addClass('choosen-grope');
                break;
            case 'sessions':
                menu_elems.eq(5).addClass('choosen-grope');
                break;
        }
    }
}

$(document).ready(function(){

    var $aside = $("#sidebar");

    $(window).scroll(function(){
        if ( $(this).scrollTop() > 500 && !$aside.hasClass("sidebarfixed")){
            $aside.addClass("sidebarfixed").hide().fadeTo("slow",1);


        } else if($(this).scrollTop() <= 500 && $aside.hasClass("sidebarfixed")) {
            $aside.removeClass("sidebarfixed");
        }
    });
});
