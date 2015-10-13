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