$(document).ready(function(){
	/* left column resize */
	(function(){
		var colw = sessionStorage.getItem('lcw'),
			leftColumn = $('#left-column');
		leftColumn.width(colw);
		leftColumn.resizable({
			handles: 'e'
		});
		$('.ui-resizable-e').on('mouseup', function(){
			colw = leftColumn.width();
			sessionStorage.setItem('lcw', colw);
		});
	})();
	/* */

	/* aside fold */
	(function(){
		var page = $('#page'),
			foldedClass = 'aside-folded',
			settingsLink = '',
			trigger = $('.aside-fold-trigger'),
			icon = trigger.find('i.fa');
	    trigger.on('click', function(e){
	    	e.preventDefault();
	    	if (page.hasClass(foldedClass)) {
	    		page.removeClass(foldedClass);
	    		settingsLink = '/user/preferences/set/admin_aside_fold_control/1';
	    	} else {
	    		page.addClass(foldedClass);
	    		settingsLink = '/user/preferences/set/admin_aside_fold_control/0';
	    	};
    		icon.toggleClass('fa-dedent fa-indent');
	    	$.ajax({
			  method: 'POST',
			  url: settingsLink
			})
	    });
	})();
	/* */

	/* aside dropdown */
	(function(){
		var trigger = $('.navi-wrap .dropdown'),
			duration = 200;
		trigger.on('show.bs.dropdown', function(e){
			var y = $(this).offset().top + ($(this).outerHeight() / 2),
				menu = $(this).find('.dropdown-menu').first(),
				menuH = menu.outerHeight(),
				menuTop = y - (menuH / 2),
				menuBottom = window.innerHeight - menuH - menuTop;
			if (menuH > (window.innerHeight - 10)) {
				menu.css({'top': 10, 'bottom': 10});
			} else if (menuTop < 5) {
				menu.css({'top': 10, 'bottom': 'auto'});
			} else if (menuBottom < 5) {
				menu.css({'bottom': 10, 'top': 'auto'});
			} else {
			    menu.css({'top': y - (menuH / 2), 'bottom': 'auto'});
			};
		    menu.stop(true, true).fadeIn({queue:false, duration:duration}).animate({marginLeft:'+=50'}, duration);
		});
		trigger.on('hide.bs.dropdown', function(e){
		    $(this).find('.dropdown-menu').first().stop(true, true).fadeOut({queue:false, duration:duration}).animate({marginLeft:'-=50'}, duration);
		});
		$('.dropdown-menu').on('click', function(e){
			e.stopPropagation();
		})
	})();
	/* */

	/* aside folded tooltips */
	(function(){
		$('.aside-folded .aside-nav').on('mouseover', 'a', function(){
			var y = $(this).offset().top + ($(this).outerHeight() / 2);
			$(this).find('.tt').css('top', y);
		});
	})();
	/* */

	/* edit tabs */
	(function(){
		var control = $('.edit-tab-control'),
			trigger = control.find('a'),
			tabs = $('.edit-tabs'),
			tab = tabs.find('.tab'),
			i = 0;
		trigger.eq(0).addClass('active');
		tab.not(tab.eq(0)).hide();
		trigger.on('click', function(){
			i = $(this).index();
			trigger.removeClass('active');
			$(this).addClass('active');
			tab.eq(i).fadeIn().siblings().hide();
		})
	})();
	/* */
});