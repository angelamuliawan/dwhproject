$(document).ready(function(){
	
	// BM.ajax({
		// url: BM.serviceUri + 'testpage/getmember/' + q,
		// type: 'get',
		// success: function(d) {
			// $('[name=nim]').val(d.NIM);
			// $('[name=name]').val(d.Name);
			// $('[name=address]').val(d.Address);
			// $('[name=dob]').val(BM.formatDate(d.DOB));
			// $('[name=pob]').val(d.POB);
			// $('[name=class]').val(d.Class);
		// }
	// });

	
	$('#loginForm').submit(function(e){
		e.preventDefault();
		var loginParam = $(this).serializeJSON();
		//loginParam.editnim = psv.id;
		AB.ajax({
			url: AB.serviceUri + 'login/loginUser',
			type: 'post',
			dataType: 'json',
			contentType: 'application/json;charset=utf-8',
			data: JSON.stringify(loginParam),
			success:function(data){
				if(data.status == 'success') {
					location.href = AB.dashboardUri;
				} else {
					alert('Login failed');
				}
			}
		});
		
		// else {
			// BM.ajax({
				// url: BM.serviceUri + 'testpage/insertmember',
				// type: 'post',
				// dataType: 'json',
				// contentType: 'application/json;charset=utf-8',
				// data: JSON.stringify($(this).serializeJSON()),
				// success:function(data){
					// if(data.status == 'success') {
						// psv.parent.loadTable();
					// } else {
						// alert('There are validation errors');
					// }
				// }
			// });
		// }
		
		
	});

});