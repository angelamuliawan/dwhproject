function reloadChart(){

}
var dbDataSource;
$(document).ready(function(){

	$(".btn.btn-success.btnTimeTerm").click(function(){
		var form = $(this).attr('referTo');
		$("form[role='form']").slideUp();
		$("#" + form).slideDown();
	});
	
	$(".icheckbox_flat-red.checked.chkEmployee").click(function(){
		var curFormGroup = $(this).closest("div.form-group");
	});
	
	$(".icheckbox_flat-red.checked.chkVendor").click(function(){
		var curFormGroup = $(this).closest("div.form-group");
	});
	
	$(".icheckbox_flat-red.checked.chkProduct").click(function(){
		var curFormGroup = $(this).closest("div.form-group");
	});

	
	$("#btnSubmitSalesReportPerDate").click(function(e){
		e.preventDefault();
		var curFormGroupEmployee = $("#formColumnEmployee");
		var curFormGroupCustomer = $("#formColumnCustomer");
		var curFormGroupProduct = $("#formColumnProduct");
		
		var totalCheckedColumnEmployee = 0;
		var totalCheckedColumnCustomer = 0;
		var totalCheckedColumnProduct = 0;
		
		var list_column_employee = '';
		var list_column_customer = '';
		var list_column_product = '';
		
		curFormGroupEmployee.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkEmployee").children().attr('aria-checked') == 'true'){
				totalCheckedColumnEmployee++;
				list_column_employee = list_column_employee + $(this).children().attr('data-value');
			}
		});
		curFormGroupCustomer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkCustomer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnCustomer++;
				list_column_customer = list_column_customer + $(this).children().attr('data-value');
			}
		});
		curFormGroupProduct.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkProduct").children().attr('aria-checked') == 'true'){
				totalCheckedColumnProduct++;
				list_column_product = list_column_product + $(this).children().attr('data-value');
			}
		});
		
		var list_column = list_column_employee + list_column_customer + list_column_product;
		list_column = list_column.substr(0, list_column.length - 1);

		var date = $("#txtDateSales").val();
		var isSelectedEmployee = (totalCheckedColumnEmployee > 0) ? 1 : 0;
		var isSelectedCustomer = (totalCheckedColumnCustomer > 0) ? 1 : 0;;
		var isSelectedProduct = (totalCheckedColumnProduct > 0) ? 1 : 0;;
		
		var objParam = {
			'date' : date,
			'isSelectedEmployee' : isSelectedEmployee,
			'isSelectedCustomer' : isSelectedCustomer,
			'isSelectedProduct' : isSelectedProduct,
			'list_column' : list_column
		}

		AB.ajax({
			url: AB.serviceUri + 'sales/salesReport/getSummarySalesDynamicPerDate',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				dbDataSource = data;
				$("#salesReportContainer").empty();
				webix.ready(function(){
					webix.ui({
						container:"salesReportContainer",
						id:"pivot",
						view:"pivot-chart",
						height:350,
						width:950,
						structure:{
							groupBy: "Tanggal",
							values: [{name:"Jumlah", operation:"max"},{name:"Total", operation:"max"}],
							filters:[{name:"Jumlah", type:"select"}]
						},
						data: dbDataSource
					});
				});
			}
		});
	});	

	$("#btnSubmitSalesReportPerQuarter").click(function(e){
		e.preventDefault();
		var curFormGroupEmployee = $("#formColumnEmployee");
		var curFormGroupCustomer = $("#formColumnCustomer");
		var curFormGroupProduct = $("#formColumnProduct");
		
		var totalCheckedColumnEmployee = 0;
		var totalCheckedColumnCustomer = 0;
		var totalCheckedColumnProduct = 0;
		
		var list_column_employee = '';
		var list_column_customer = '';
		var list_column_product = '';
		
		curFormGroupEmployee.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkEmployee").children().attr('aria-checked') == 'true'){
				totalCheckedColumnEmployee++;
				list_column_employee = list_column_employee + $(this).children().attr('data-value');
			}
		});
		curFormGroupCustomer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkCustomer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnCustomer++;
				list_column_customer = list_column_customer + $(this).children().attr('data-value');
			}
		});
		curFormGroupProduct.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkProduct").children().attr('aria-checked') == 'true'){
				totalCheckedColumnProduct++;
				list_column_product = list_column_product + $(this).children().attr('data-value');
			}
		});

		var list_column = list_column_employee + list_column_customer + list_column_product;
		list_column = list_column.substr(0, list_column.length - 1);
		
		var year = $("#ddlYear2 option:selected").text();
		var quarter = $("#ddlQuarter option:selected").val();
		var isSelectedEmployee = (totalCheckedColumnEmployee > 0) ? 1 : 0;
		var isSelectedCustomer = (totalCheckedColumnCustomer > 0) ? 1 : 0;;
		var isSelectedProduct = (totalCheckedColumnProduct > 0) ? 1 : 0;;
		
		var objParam = {
			'year' : year,
			'quarter' : quarter,
			'isSelectedEmployee' : isSelectedEmployee,
			'isSelectedCustomer' : isSelectedCustomer,
			'isSelectedProduct' : isSelectedProduct,
			'list_column' : list_column
		}

		AB.ajax({
			url: AB.serviceUri + 'sales/salesReport/getSummarySalesDynamicPerQuarter',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				dbDataSource = data;
				$("#salesReportContainer").empty();
				webix.ready(function(){
					webix.ui({
						container:"salesReportContainer",
						id:"pivot",
						view:"pivot-chart",
						height:350,
						width:950,
						structure:{
							groupBy: "Bulan",
							values: [{name:"Jumlah", operation:"max"},{name:"Total", operation:"max"}],
							filters:[{name:"Jumlah", type:"select"}]
						},
						data: dbDataSource
					});
				});
			}
		});
	});	
	
	$("#btnSubmitSalesReportPerMonth").click(function(e){
		e.preventDefault();
		var curFormGroupEmployee = $("#formColumnEmployee");
		var curFormGroupCustomer = $("#formColumnCustomer");
		var curFormGroupProduct = $("#formColumnProduct");
		
		var totalCheckedColumnEmployee = 0;
		var totalCheckedColumnCustomer = 0;
		var totalCheckedColumnProduct = 0;
		
		var list_column_employee = '';
		var list_column_customer = '';
		var list_column_product = '';
		
		curFormGroupEmployee.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkEmployee").children().attr('aria-checked') == 'true'){
				totalCheckedColumnEmployee++;
				list_column_employee = list_column_employee + $(this).children().attr('data-value');
			}
		});
		curFormGroupCustomer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkCustomer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnCustomer++;
				list_column_customer = list_column_customer + $(this).children().attr('data-value');
			}
		});
		curFormGroupProduct.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkProduct").children().attr('aria-checked') == 'true'){
				totalCheckedColumnProduct++;
				list_column_product = list_column_product + $(this).children().attr('data-value');
			}
		});

		var list_column = list_column_employee + list_column_customer + list_column_product;
		list_column = list_column.substr(0, list_column.length - 1);
		
		var year = $("#ddlYear3 option:selected").text();
		var month = $("#ddlMonth option:selected").val();
		var isSelectedEmployee = (totalCheckedColumnEmployee > 0) ? 1 : 0;
		var isSelectedCustomer = (totalCheckedColumnCustomer > 0) ? 1 : 0;;
		var isSelectedProduct = (totalCheckedColumnProduct > 0) ? 1 : 0;;
		
		var objParam = {
			'year' : year,
			'month' : month,
			'isSelectedEmployee' : isSelectedEmployee,
			'isSelectedCustomer' : isSelectedCustomer,
			'isSelectedProduct' : isSelectedProduct,
			'list_column' : list_column
		}

		AB.ajax({
			url: AB.serviceUri + 'sales/salesReport/getSummarySalesDynamicPerMonth',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				dbDataSource = data;
				$("#salesReportContainer").empty();
				webix.ready(function(){
					webix.ui({
						container:"salesReportContainer",
						id:"pivot",
						view:"pivot-chart",
						height:350,
						width:950,
						structure:{
							groupBy: "Hari",
							values: [{name:"Jumlah", operation:"max"},{name:"Total", operation:"max"}],
							filters:[{name:"Jumlah", type:"select"}]
						},
						data: dbDataSource
					});
				});
			}
		});
	});	
	
	$("#btnSubmitSalesReportPerYear").click(function(e){
		e.preventDefault();
		var curFormGroupEmployee = $("#formColumnEmployee");
		var curFormGroupCustomer = $("#formColumnCustomer");
		var curFormGroupProduct = $("#formColumnProduct");
		
		var totalCheckedColumnEmployee = 0;
		var totalCheckedColumnCustomer = 0;
		var totalCheckedColumnProduct = 0;
		
		var list_column_employee = '';
		var list_column_customer = '';
		var list_column_product = '';
		
		curFormGroupEmployee.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkEmployee").children().attr('aria-checked') == 'true'){
				totalCheckedColumnEmployee++;
				list_column_employee = list_column_employee + $(this).children().attr('data-value');
			}
		});
		curFormGroupCustomer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkCustomer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnCustomer++;
				list_column_customer = list_column_customer + $(this).children().attr('data-value');
			}
		});
		curFormGroupProduct.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkProduct").children().attr('aria-checked') == 'true'){
				totalCheckedColumnProduct++;
				list_column_product = list_column_product + $(this).children().attr('data-value');
			}
		});

		var list_column = list_column_employee + list_column_customer + list_column_product;
		list_column = list_column.substr(0, list_column.length - 1);
		
		var year = $("#ddlYear1 option:selected").text();
		var isSelectedEmployee = (totalCheckedColumnEmployee > 0) ? 1 : 0;
		var isSelectedCustomer = (totalCheckedColumnCustomer > 0) ? 1 : 0;;
		var isSelectedProduct = (totalCheckedColumnProduct > 0) ? 1 : 0;;
		
		var objParam = {
			'year' : year,
			'isSelectedEmployee' : isSelectedEmployee,
			'isSelectedCustomer' : isSelectedCustomer,
			'isSelectedProduct' : isSelectedProduct,
			'list_column' : list_column
		}

		AB.ajax({
			url: AB.serviceUri + 'sales/salesReport/getSummarySalesDynamicPerYear',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				dbDataSource = data;
				$("#salesReportContainer").empty();
				webix.ready(function(){
					webix.ui({
						container:"salesReportContainer",
						id:"pivot",
						view:"pivot-chart",
						height:350,
						width:950,
						structure:{
							groupBy: "Bulan",
							values: [{name:"Jumlah", operation:"max", color: "#eed236"},{name:"Total", operation:"max", color: "#36abee"}],
							filters:[{name:"Jumlah", type:"select"}]
						},
						data: dbDataSource
					});
				});
			}
		});
	});
});
