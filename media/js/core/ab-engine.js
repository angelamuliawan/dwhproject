var AB = {
	// --------------------------------------------
	// Global states
	
	//HASH_NULL: 0,
	//HASH_AFTER_EXECUTE: 1,
	//HASH_AFTER_CHANGE: 2,
	//HASH_PERSIST: 3,
	
	//defaultRel: 'primaryspace',
	//rel: 'primaryspace',
	//defaultClickState: [],
	//viewer: null,
	
	//currentSubView: null,
	
	// lastHash: '',
	// ndLastHash: '',
	// lastParam: '',
	// resetDefaultClick: function(){
		
	// },
	// beforeHashChange: null,
	// //detachHashChange: 0,
	// executionStack: [],
	// scriptStack: [],
	
	// // --------------------------------------------
	// // general utility functions that should be able to be used globally
	// clearBeforeHashChange: function() {
		// this.beforeHashChange = null;
		// //this.detachHashChange = this.HASH_NULL;
	// },
	
	instId : '01',
	loginUri: 'http://localhost/dwhproject/index.php',
	//imageUri: 'http://localhost/portalstaff/images/',
	serviceUri: 'http://localhost/dwhproject/',
	dashboardUri: 'http://localhost/dwhproject/home',
	//uploadUri: 'http://localhost/useruploads/',
	months: ['','January','February','March','April','May','June','July','August','September','October','November','December'],
	shortMonths: ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
	
	redirect: function(){
	
	},
	formatLongDate: function(date) {
		if(typeof date != 'string' || /^\d{4}-\d\d-\d\d$/.test(date) == false) {
			return 'Invalid format (yyyy-mm-dd)';
		}
		
		var month = AB.months;
		var d = date.split(/-/);
		if(d[1][0]=='0'){
			d[1] = parseInt(d[1][1]);
		} else {
			d[1] = parseInt(d[1]);
		}
		
		if(d[2][0]=='0'){
			d[2] = d[2][1];
		}
		return d[2] + ' ' + month[d[1]] + ' ' + d[0];
	},
	
	formatShortDate: function(date) {
		if(typeof date != 'string' || /^\d{4}-\d\d-\d\d$/.test(date) == false) {
			return 'Invalid format (yyyy-mm-dd)';
		}
		var month = AB.shortMonths;
		var d = date.split(/-/);
		if(d[1][0]=='0'){
			d[1] = parseInt(d[1][1]);
		} else {
			d[1] = parseInt(d[1]);
		}
		
		if(d[2][0]=='0'){
			d[2] = d[2][1];
		}
		return d[2] + ' ' + month[d[1]] + ' ' + d[0];
	},
	
	formatDate: function(date) {
		var d = date.split(/-/);
		return d[2] + '/' + d[1] + '/' + d[0];
	},
	
	formatPeriod: function(period) {
		var p = period.split(/-/);
		p[0] = p[0] + '/' + (parseInt(p[0]) + 1).toString();
		
		if(p[1] == '1') {
			p[1] = 'Odd';
		} else {
			p[1] = 'Even';
		}
		
		if(p[2] == '0') { 
			return p[0] + ' - ' + p[1];
		}
		
		return p[0] + ' - ' + p[1] + ' - ' + p[2];
	},
	formatNumber: function(number) {
		if(number == null) return number;
		var num = number.toString();
		if(/^-?[0-9.]*(,[0-9]*)?$/.test(num)) {
			num=num.replace(/\./g,'').split(',');
			var s2='',dot='';
			while(num[0].length>0){
				if(num[0]=='-') {
					s2='-'+s2;
					break;
				}
				s2=num[0].substr((num[0].length-3>=0 ? num[0].length-3 : 0), 3)+dot+s2;
				dot='.';
				num[0]=num[0].substr(0,num[0].length-3);
			}
			if(num.length>1) s2+=','+num[1];
			num=s2;
		}
		
		return num;
	},
	formatShortTime: function(time) {
		var t = time.split(':');
		return t[0]+':'+t[1];
	},
	formatLongTime: function(time) {
		var t = time.split(':');
		return t[0]+':'+t[1]+':'+t[2].substr(0,2);
	},
	formatDateTime: function(input, formatDateCallback, formatTimeCallback) {
		formatDateCallback = formatDateCallback || 'Date';
		formatTimeCallback = formatTimeCallback || 'ShortTime';
		
		var t = input.split(' ');
		var call = 'format' + formatDateCallback;
		var date = AB[call](t[0]);
		
		var time = t[1];
		if(formatTimeCallback != '') {
			var callTime = 'format' + formatTimeCallback;
			time = AB[callTime](time);
		}
		
		return date + ' ' + time;
	},
	ajax: function(options) {
		var ajaxOpt = options;
		//var success = options.success;
		
		/*ajaxOpt.success = function(data) {
			// session expired or no session found
			success(data);
		};*/
		
		ajaxOpt.error = function(jqXHR, textStatus, errorThrown) {
			if(typeof error == 'function') {
				options.error(jqXHR, textStatus, errorThrown);
				return;
			}
			
			try {
				var o = $.parseJSON(jqXHR.responseText);
				if(o.status == 'error' && o.errno == '1') {
					location.href = AB.loginUri;
					return;
				}
			} catch(e) {
				alert('Error occured when parsing JSON. Get response text: ' + jqXHR.responseText);
			}
		};
		
		if(ajaxOpt.type.toLowerCase() == 'post') {
			ajaxOpt.contentType = 'application/json;charset=utf-8';
		}
		
		return $.ajax(ajaxOpt);
	}
};

// --------------------------------------------
// jquery extension
(function($){
	$.fn.slideCarousel = function(o) {
		// slide for some element
		var recLeft = true;
		var recRight = true;
		var e=this;
		var car=0;
		var recCount = $('li', $(e)).length;
		
		var l=$('<div class="slideleft"></div>');
		var r=$('<div class="slideright"></div>');
		
		$(e).jcarousel({
			scroll: 3,
			initCallback: function(car){
				if(car.first == 1) {
					recLeft=false;
				} else {
					recLeft=true;
				}
				
				if(car.last == recCount) {
					recRight=false;
				} else {
					recRight=true;
				}
				
				l.click(function(){
					car.prev();
					recLeft=true;
					if(car.first == 1) {
						$(this).css('display','none');
						recLeft=false;
					} else {
						$(this).css('display','block');
						recLeft=true;
					}
					
					if(car.last == recCount) {
						$(r).css('display','none');
						recRight=false;
					} else {
						$(r).css('display','block');
						recRight=true;
					}
					return false;
				});
				
				r.click(function(){
					car.next();
					if(car.first == 1) {
						$(l).css('display','none');
						recLeft=false;
					} else {
						$(l).css('display','block');
						recLeft=true;
					}
					
					if(car.last == recCount) {
						$(r).css('display','none');
						recRight=false;
					} else {
						$(r).css('display','block');
						recRight=true;
					}
					return false;
				});
				
				$(e).after(l);
				$(e).after(r);
			},
			// This tells jCarousel NOT to autobuild prev/next buttons
			buttonNextHTML: null,
			buttonPrevHTML: null
		});
		$(e).bind('mouseover', sliding);
		$(l).bind('mouseover', sliding);
		$(r).bind('mouseover', sliding);
		
		function sliding() {
			if(recLeft) {
				$(l).css('display','block');
			}
			if(recRight) {
				$(r).css('display','block');
			}
		}
		
		$(e).bind('mouseout',function(e){
			$(l).css('display','none');
			$(r).css('display','none');
		});
	};

	$.fn.wizardBox = function(o) {
		
		// binding next and back button
		$('.nextstepbutton').click(function(){
			var el=$('.wizardbox.current');
			el.next().addClass('current');
			el.removeClass('current');
			setCurrentWizardStep();
		});
		
		$('.backstepbutton').click(function(){
			var el=$('.wizardbox.current');
			el.prev().addClass('current');
			el.removeClass('current');
			setCurrentWizardStep();
		});
		
		function setCurrentWizardStep() {
			var i = $('.wizardbox.current').index();
			$('.wizardstep li').removeClass('current');
			$('.wizardstep li').eq(i).addClass('current');
		}
		
		AB.beforeHashChange = this.confirmChange;
		
		// get header for each step
		var h = [];
		$.each($('.wizardbox h3'),function(a,b){
			h.push($(b).text());
		});
		
		// add wizard step
		var l = $('.wizardbox').length;
		var ul = $('<ul></ul>');
		for(var j=0; j<l; j++) {
			var li = $('<li></li>').text(h[j]).attr('data-step',j).bind('click',function(){
				var idx = $(this).attr('data-step');
				$('.wizardbox').removeClass('current');
				$('.wizardbox').eq(idx).addClass('current');
				$('.wizardstep li').removeClass('current');
				$('.wizardstep li').eq(idx).addClass('current');
			});
			ul.append(li);
		}
		ul.append('<li></li>');
		$('.wizardstep').append(ul);
		setCurrentWizardStep();
	};

	$.fn.toolTips = function(o) {
		var xp = $(o).offset().left,
			yp = $(o).offset().right
		
		var x=$('<div style=""></div>');
	};
	
	
	$.fn.serializeJSON=function() {
		var json = {};
		jQuery.map($(this).serializeArray(), function(n, i){
			json[n['name']] = n['value'];
		});
		return json;
	};
	
	// as seen on https://github.com/macek/jquery-to-json
	$.fn.toJSON=function(options) {
		options = $.extend({}, options);

		var self = this,
			json = {},
			push_counters = {},
			patterns = {
				"validate": /^[a-zA-Z][a-zA-Z0-9_]*(?:\[(?:\d*|[a-zA-Z0-9_]+)\])*$/,
				"key":      /[a-zA-Z0-9_]+|(?=\[\])/g,
				"push":     /^$/,
				"fixed":    /^\d+$/,
				"named":    /^[a-zA-Z0-9_]+$/
			};
			
		this.build = function(base, key, value){
			base[key] = value;
			return base;
		};

		this.push_counter = function(key){
			if(push_counters[key] === undefined){
				push_counters[key] = 0;
			}
			return push_counters[key]++;
		};

		$.each($(this).serializeArray(), function(){

			// skip invalid keys
			if(!patterns.validate.test(this.name)){
				return;
			}

			var k,
				keys = this.name.match(patterns.key),
				merge = this.value,
				reverse_key = this.name;

			while((k = keys.pop()) !== undefined){

				// adjust reverse_key
				reverse_key = reverse_key.replace(new RegExp("\\[" + k + "\\]$"), '');

				// push
				if(k.match(patterns.push)){
					merge = self.build([], self.push_counter(reverse_key), merge);
				}

				// fixed
				else if(k.match(patterns.fixed)){
					merge = self.build([], k, merge);
				}

				// named
				else if(k.match(patterns.named)){
					merge = self.build({}, k, merge);
				}
			}

			json = $.extend(true, json, merge);
		});

		return json;
	};
	
	$.fn.assignForm=function(data, formating) {
		for(var s in data) {
			if(formating && formating[s]) {
				data[s] = formating[s].type == 'date' ? AB.formatDate(data[s]) : data[s];
			}
			$('[name=' + s + ']', this).val(data[s]);
		}
			
		return;
	};
	
	
// https://github.com/macek/jquery-to-json
$.fn.toJSON = function(options){
	options = $.extend({}, options);

	var self = this,
		json = {},
		push_counters = {},
		patterns = {
			"validate": /^[a-zA-Z][a-zA-Z0-9_]*(?:\[(?:\d*|[a-zA-Z0-9_]+)\])*$/,
			"key":      /[a-zA-Z0-9_]+|(?=\[\])/g,
			"push":     /^$/,
			"fixed":    /^\d+$/,
			"named":    /^[a-zA-Z0-9_]+$/
		};
		
	this.build = function(base, key, value){
		base[key] = value;
		return base;
	};

	this.push_counter = function(key){
		if(push_counters[key] === undefined){
			push_counters[key] = 0;
		}
		return push_counters[key]++;
	};

	$.each($(this).serializeArray(), function(){

		// skip invalid keys
		if(!patterns.validate.test(this.name)){
			return;
		}

		var k,
			keys = this.name.match(patterns.key),
			merge = this.value,
			reverse_key = this.name;

		while((k = keys.pop()) !== undefined){

			// adjust reverse_key
			reverse_key = reverse_key.replace(new RegExp("\\[" + k + "\\]$"), '');

			// push
			if(k.match(patterns.push)){
				merge = self.build([], self.push_counter(reverse_key), merge);
			}

			// fixed
			else if(k.match(patterns.fixed)){
				merge = self.build([], k, merge);
			}

			// named
			else if(k.match(patterns.named)){
				merge = self.build({}, k, merge);
			}
		}

		json = $.extend(true, json, merge);
	});

	return json;
};
})( jQuery );