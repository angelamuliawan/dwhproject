$(document).ready(function(){
	AB.ajax({
		url: AB.serviceUri + 'manageAccess/getUserName',
		type: 'post',
		async : false,
		dataType: 'json',
		contentType: 'application/json;charset=utf-8',
		success:function(data){
			for(var i=0; i<data.length; i++)
			{
				$('.ddlUser').append(
					'<option value='+data[i].UserID+'>'+data[i].UserName+'</option>'
				)
			}
		}
	});

	AB.ajax({
		url: AB.serviceUri + 'manageAccess/getPageName',
		type: 'post',
		dataType: 'json',
		contentType: 'application/json;charset=utf-8',
		success:function(data){
			for(var i=0; i<data.length; i++)
			{
				$('.ddlPage').append(
					'<option value='+data[i].PageID+'>'+data[i].PageID+'</option>'
				)
			}
			loadAccess();
		}
	});

	$("body").on('click', '#btnSaveAccess',function(){

		var userid = $('.ddlUser option:selected').val();
		var pageid = $('.ddlPage option:selected').val();

		AB.ajax({
			url: AB.serviceUri + 'manageAccess/insertUserAccess',
			type: 'post',
			dataType: 'json',
			data : JSON.stringify({pageid : pageid, userid : userid}),
			contentType: 'application/json;charset=utf-8',
			success:function(data){						
				alert("Item successfully added.");
				location.href = AB.serviceUri + 'manageAccess';
			}
		});
	});

});

function loadAccess(){
	AB.ajax({
		url: AB.serviceUri + 'manageAccess/getAccess',
		type: 'post',
		dataType: 'json',
		contentType: 'application/json;charset=utf-8',
		success:function(data){
			var table = $("#tblAccess");
			$("tbody",table).find("tr").not("#iTemplateAcc").remove();
			for(var i = 0; i<data.length; i++)
			{
				var newRow = $("#iTemplateAcc",table).clone().css("display","").removeAttr("id");
				$(".iUser",newRow).empty().text(data[i].UserName).attr('data-id', data[i].UserID);
				$(".iPage",newRow).empty().text(data[i].PageID);
				$(".btnDeleteAccess",newRow).attr('data-id',data[i].PageID).click(function(){

					var conf = confirm("Do you want to delete this item ?");
					if(conf){
						var pageid = $(this).closest("tr").find(".btnDeleteAccess").attr('data-id');
						var userid = $(this).closest("tr").find(".iUser").attr('data-id');
						AB.ajax({
							url: AB.serviceUri + 'manageAccess/deleteUserAccess',
							type: 'post',
							dataType: 'json',
							data : JSON.stringify({pageid : pageid, userid : userid}),
							contentType: 'application/json;charset=utf-8',
							success:function(data){						
								alert("Item successfully deleted.");
								location.href = AB.serviceUri + 'manageAccess';
							}
						});
					}
				});
				$("tbody",table).append(newRow);
			}
			var tmp = $("#iTemplateAcc").clone().css("display", "").removeAttr("id").removeClass("loop").addClass("datarow");
			
			$(".iAction",tmp).empty().append('<a style="cursor:pointer;" id="btnSaveAccess">Save</a>');
			$("#tblAccess tbody").append(tmp);
			
			$("#iTemplateAcc").remove();
		}
	});
}