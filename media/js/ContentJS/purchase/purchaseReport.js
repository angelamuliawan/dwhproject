function reloadChart(){
	var dataSource = [
	  { state: "China", oil: 4.95, gas: 2.85, coal: 45.56 },
	  { state: "Russia", oil: 12.94, gas: 17.66, coal: 4.13 },
	  { state: "USA", oil: 8.51, gas: 19.87, coal: 15.84 },
	  { state: "Iran", oil: 5.3, gas: 4.39 },
	  { state: "Canada", oil: 4.08, gas: 5.4 },
	  { state: "Saudi Arabia", oil: 12.03 },
	  { state: "Mexico", oil: 3.86 }
	];

	$("#chartContainer").dxChart({
		  equalBarWidth: false,
		  dataSource: dataSource,
		  commonSeriesSettings: {
			  argumentField: "state",
			  type: "bar"
		  },
		  series: [
			  { valueField: "oil", name: "Oil Production" },
			  { valueField: "gas", name: "Gas Production" },
			  { valueField: "coal", name: "Coal Production" }
		  ],
		  legend: {
			  verticalAlignment: "bottom",
			  horizontalAlignment: "center"
		  },
		  title: "Percent of Total Energy Production"
	  });
}

$(document).ready(function(){
	//reloadChart();
	//$('#daterange').daterangepicker();
	
	// webix.ready(function(){
		// webix.ui({
			// container:"testA",
			// id:"pivot",
			// view:"pivot-chart",
			// height:350,
			// width:950,
			// structure:{
				// groupBy: "continent",
				// values: [{name:"balance", operation:"max", color: "#eed236"},{name:"oil", operation:"max", color: "#36abee"}],
				// filters:[{name:"year", type:"select"},{name:"continent", type:"select"}]
			// },
			// url: "/dwhproject/media/js/webix/common/data.json"
		// });
	// });
	
	$(".btn.btn-success.btnTimeTerm").click(function(){
		var form = $(this).attr('referTo');
		$("form[role='form']").slideUp();
		$("#" + form).slideDown();
	});
	
	$(".icheckbox_flat-red.checked.chkEmployee").click(function(){
		var curFormGroup = $(this).closest("div.form-group");
		// curFormGroup.children().each(function(){
			// $(this).find(".icheckbox_flat-red.checked.chkEmployee").children().attr('aria-checked'));
		// });
	});
	
	$(".icheckbox_flat-red.checked.chkVendor").click(function(){
		var curFormGroup = $(this).closest("div.form-group");
		// curFormGroup.children().each(function(){
			// $(this).find(".icheckbox_flat-red.checked.chkEmployee").children().attr('aria-checked'));
		// });
	});
	
	$(".icheckbox_flat-red.checked.chkProduct").click(function(){
		var curFormGroup = $(this).closest("div.form-group");
		// curFormGroup.children().each(function(){
			// $(this).find(".icheckbox_flat-red.checked.chkEmployee").children().attr('aria-checked'));
		// });
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
				list_column_employee = list_column_employee
			}
		});
		curFormGroupVendor.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkVendor").children().attr('aria-checked') == 'true'){
				totalCheckedColumnVendor++;
			}
		});
		curFormGroupProduct.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkProduct").children().attr('aria-checked') == 'true'){
				totalCheckedColumnProduct++;
			}
		});
		
		var year = $("#ddlYear option:selected").text();
		var isSelectedEmployee = (totalCheckedColumnEmployee > 0) ? 1 : 0;
		var isSelectedVendor = (totalCheckedColumnVendor > 0) ? 1 : 0;;
		var isSelectedProduct = (totalCheckedColumnProduct > 0) ? 1 : 0;;
		
		// AB.ajax({
			// url: AB.serviceUri + 'purchase/purchaseReport/getSummaryPurchaseDynamic',
			// type: 'post',
			// dataType: 'json',
			// data: JSON.stringify(),
			// contentType: 'application/json;charset=utf-8',
			// success:function(data){
				// dbDataSource = data;
				// console.table(dbDataSource);
			// }
		// });
		
	});
});
