function reloadChart(){
	// var dataSource = [
	//   { state: "China", oil: 4.95, gas: 2.85, coal: 45.56 },
	//   { state: "Russia", oil: 12.94, gas: 17.66, coal: 4.13 },
	//   { state: "USA", oil: 8.51, gas: 19.87, coal: 15.84 },
	//   { state: "Iran", oil: 5.3, gas: 4.39 },
	//   { state: "Canada", oil: 4.08, gas: 5.4 },
	//   { state: "Saudi Arabia", oil: 12.03 },
	//   { state: "Mexico", oil: 3.86 }
	// ];

	// $("#chartContainer").dxChart({
	// 	  equalBarWidth: false,
	// 	  dataSource: dataSource,
	// 	  commonSeriesSettings: {
	// 		  argumentField: "state",
	// 		  type: "bar"
	// 	  },
	// 	  series: [
	// 		  { valueField: "oil", name: "Oil Production" },
	// 		  { valueField: "gas", name: "Gas Production" },
	// 		  { valueField: "coal", name: "Coal Production" }
	// 	  ],
	// 	  legend: {
	// 		  verticalAlignment: "bottom",
	// 		  horizontalAlignment: "center"
	// 	  },
	// 	  title: "Percent of Total Energy Production"
	//   });
}
var dbDataSource;
$(document).ready(function(){
	//reloadChart();
	//$('#daterange').daterangepicker();
	
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

	
	$("#btnSubmitPurchaseReportPerDate").click(function(e){
		e.preventDefault();
		var curFormGroupEmployee = $("#formColumnEmployee");
		var curFormGroupVendor = $("#formColumnVendor");
		var curFormGroupProduct = $("#formColumnProduct");
		
		var totalCheckedColumnEmployee = 0;
		var totalCheckedColumnVendor = 0;
		var totalCheckedColumnProduct = 0;
		
		var list_column_employee = '';
		var list_column_vendor = '';
		var list_column_product = '';
		
		curFormGroupEmployee.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkEmployee").children().attr('aria-checked') == 'true'){
				totalCheckedColumnEmployee++;
				list_column_employee = list_column_employee + $(this).children().attr('data-value');
			}
		});
		curFormGroupVendor.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkVendor").children().attr('aria-checked') == 'true'){
				totalCheckedColumnVendor++;
				list_column_vendor = list_column_vendor + $(this).children().attr('data-value');
			}
		});
		curFormGroupProduct.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkProduct").children().attr('aria-checked') == 'true'){
				totalCheckedColumnProduct++;
				list_column_product = list_column_product + $(this).children().attr('data-value');
			}
		});

		var list_column = list_column_employee + list_column_vendor + list_column_product;
		list_column = list_column.substr(0, list_column.length - 1);
		
		
		var date = $("#txtDatePurchase").val();
		var isSelectedEmployee = (totalCheckedColumnEmployee > 0) ? 1 : 0;
		var isSelectedVendor = (totalCheckedColumnVendor > 0) ? 1 : 0;
		var isSelectedProduct = (totalCheckedColumnProduct > 0) ? 1 : 0;
		
		var objParam = {
			'date' : date,
			'isSelectedEmployee' : isSelectedEmployee,
			'isSelectedVendor' : isSelectedVendor,
			'isSelectedProduct' : isSelectedProduct,
			'list_column' : list_column
		}

		AB.ajax({
			url: AB.serviceUri + 'purchase/purchaseReport/getSummaryPurchaseDynamicPerDate',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				//console.table(data);
				// color: "#eed236"
				// color: "#36abee"
				$("#purchaseReportContainer").empty();
				dbDataSource = data;
				webix.ready(function(){
					webix.ui({
						container:"purchaseReportContainer",
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

	$("#btnSubmitPurchaseReportPerQuarter").click(function(e){
		e.preventDefault();
		var curFormGroupEmployee = $("#formColumnEmployee");
		var curFormGroupVendor = $("#formColumnVendor");
		var curFormGroupProduct = $("#formColumnProduct");
		
		var totalCheckedColumnEmployee = 0;
		var totalCheckedColumnVendor = 0;
		var totalCheckedColumnProduct = 0;
		
		var list_column_employee = '';
		var list_column_vendor = '';
		var list_column_product = '';
		
		curFormGroupEmployee.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkEmployee").children().attr('aria-checked') == 'true'){
				totalCheckedColumnEmployee++;
				list_column_employee = list_column_employee + $(this).children().attr('data-value');
			}
		});
		curFormGroupVendor.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkVendor").children().attr('aria-checked') == 'true'){
				totalCheckedColumnVendor++;
				list_column_vendor = list_column_vendor + $(this).children().attr('data-value');
			}
		});
		curFormGroupProduct.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkProduct").children().attr('aria-checked') == 'true'){
				totalCheckedColumnProduct++;
				list_column_product = list_column_product + $(this).children().attr('data-value');
			}
		});

		var list_column = list_column_employee + list_column_vendor + list_column_product;
		list_column = list_column.substr(0, list_column.length - 1);
		
		var year = $("#ddlYear2 option:selected").text();
		var quarter = $("#ddlQuarter option:selected").val();
		var isSelectedEmployee = (totalCheckedColumnEmployee > 0) ? 1 : 0;
		var isSelectedVendor = (totalCheckedColumnVendor > 0) ? 1 : 0;;
		var isSelectedProduct = (totalCheckedColumnProduct > 0) ? 1 : 0;;
		
		var objParam = {
			'year' : year,
			'quarter' : quarter,
			'isSelectedEmployee' : isSelectedEmployee,
			'isSelectedVendor' : isSelectedVendor,
			'isSelectedProduct' : isSelectedProduct,
			'list_column' : list_column
		}

		AB.ajax({
			url: AB.serviceUri + 'purchase/purchaseReport/getSummaryPurchaseDynamicPerQuarter',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				//console.table(data);
				// color: "#eed236"
				// color: "#36abee"
				$("#purchaseReportContainer").empty();
				dbDataSource = data;
				webix.ready(function(){
					webix.ui({
						container:"purchaseReportContainer",
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
	
	$("#btnSubmitPurchaseReportPerMonth").click(function(e){
		e.preventDefault();
		var curFormGroupEmployee = $("#formColumnEmployee");
		var curFormGroupVendor = $("#formColumnVendor");
		var curFormGroupProduct = $("#formColumnProduct");
		
		var totalCheckedColumnEmployee = 0;
		var totalCheckedColumnVendor = 0;
		var totalCheckedColumnProduct = 0;
		
		var list_column_employee = '';
		var list_column_vendor = '';
		var list_column_product = '';
		
		curFormGroupEmployee.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkEmployee").children().attr('aria-checked') == 'true'){
				totalCheckedColumnEmployee++;
				list_column_employee = list_column_employee + $(this).children().attr('data-value');
			}
		});
		curFormGroupVendor.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkVendor").children().attr('aria-checked') == 'true'){
				totalCheckedColumnVendor++;
				list_column_vendor = list_column_vendor + $(this).children().attr('data-value');
			}
		});
		curFormGroupProduct.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkProduct").children().attr('aria-checked') == 'true'){
				totalCheckedColumnProduct++;
				list_column_product = list_column_product + $(this).children().attr('data-value');
			}
		});

		var list_column = list_column_employee + list_column_vendor + list_column_product;
		list_column = list_column.substr(0, list_column.length - 1);
		
		var year = $("#ddlYear3 option:selected").text();
		var month = $("#ddlMonth option:selected").val();
		var isSelectedEmployee = (totalCheckedColumnEmployee > 0) ? 1 : 0;
		var isSelectedVendor = (totalCheckedColumnVendor > 0) ? 1 : 0;;
		var isSelectedProduct = (totalCheckedColumnProduct > 0) ? 1 : 0;;
		
		var objParam = {
			'year' : year,
			'month' : month,
			'isSelectedEmployee' : isSelectedEmployee,
			'isSelectedVendor' : isSelectedVendor,
			'isSelectedProduct' : isSelectedProduct,
			'list_column' : list_column
		}

		AB.ajax({
			url: AB.serviceUri + 'purchase/purchaseReport/getSummaryPurchaseDynamicPerMonth',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				//console.table(data);
				// color: "#eed236"
				// color: "#36abee"
				$("#purchaseReportContainer").empty();
				dbDataSource = data;
				webix.ready(function(){
					webix.ui({
						container:"purchaseReportContainer",
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
	
	$("#btnSubmitPurchaseReportPerYear").click(function(e){
		e.preventDefault();
		var curFormGroupEmployee = $("#formColumnEmployee");
		var curFormGroupVendor = $("#formColumnVendor");
		var curFormGroupProduct = $("#formColumnProduct");
		
		var totalCheckedColumnEmployee = 0;
		var totalCheckedColumnVendor = 0;
		var totalCheckedColumnProduct = 0;
		
		var list_column_employee = '';
		var list_column_vendor = '';
		var list_column_product = '';
		
		curFormGroupEmployee.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkEmployee").children().attr('aria-checked') == 'true'){
				totalCheckedColumnEmployee++;
				list_column_employee = list_column_employee + $(this).children().attr('data-value');
			}
		});
		curFormGroupVendor.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkVendor").children().attr('aria-checked') == 'true'){
				totalCheckedColumnVendor++;
				list_column_vendor = list_column_vendor + $(this).children().attr('data-value');
			}
		});
		curFormGroupProduct.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkProduct").children().attr('aria-checked') == 'true'){
				totalCheckedColumnProduct++;
				list_column_product = list_column_product + $(this).children().attr('data-value');
			}
		});

		var list_column = list_column_employee + list_column_vendor + list_column_product;
		list_column = list_column.substr(0, list_column.length - 1);
		
		
		var year = $("#ddlYear1 option:selected").text();
		var isSelectedEmployee = (totalCheckedColumnEmployee > 0) ? 1 : 0;
		var isSelectedVendor = (totalCheckedColumnVendor > 0) ? 1 : 0;;
		var isSelectedProduct = (totalCheckedColumnProduct > 0) ? 1 : 0;;
		
		var objParam = {
			'year' : year,
			'isSelectedEmployee' : isSelectedEmployee,
			'isSelectedVendor' : isSelectedVendor,
			'isSelectedProduct' : isSelectedProduct,
			'list_column' : list_column
		}

		AB.ajax({
			url: AB.serviceUri + 'purchase/purchaseReport/getSummaryPurchaseDynamicPerYear',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				//console.table(data);
				$("#purchaseReportContainer").empty();
				dbDataSource = data;
				webix.ready(function(){
					webix.ui({
						container:"purchaseReportContainer",
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
