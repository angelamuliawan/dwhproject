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
	
	$(".icheckbox_flat-red.checked.chkComputer").click(function(){
		var curFormGroup = $(this).closest("div.form-group");
	});
	
	$(".icheckbox_flat-red.checked.chkCustomer").click(function(){
		var curFormGroup = $(this).closest("div.form-group");
	});
	

	
	$("#btnSubmitPurchaseReportPerDate").click(function(e){
		e.preventDefault();
		var curFormGroupComputer = $("#formColumnComputer");
		var curFormGroupCustomer = $("#formColumnCustomer");
		
		var totalCheckedColumnComputer = 0;
		var totalCheckedColumnCustomer = 0;

		var list_column_computer = '';
		var list_column_customer = '';
		
		curFormGroupComputer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkComputer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnComputer++;
				list_column_computer = list_column_computer + $(this).children().attr('data-value');
			}
		});
		curFormGroupCustomer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkCustomer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnCustomer++;
				list_column_customer = list_column_customer + $(this).children().attr('data-value');
			}
		});

		
		var list_column = list_column_customer + list_column_computer;
		list_column = list_column.substr(0, list_column.length - 1);
		
		var date = $("#txtDateLease").val();
		var isSelectedComputer = ( totalCheckedColumnComputer > 0) ? 1 : 0;
		var isSelectedCustomer = ( totalCheckedColumnCustomer > 0) ? 1 : 0;;
		
		var objParam = {
			'date' : date,
			'isSelectedComputer' : isSelectedComputer,
			'isSelectedCustomer' : isSelectedCustomer,
			'list_column' : list_column
		}
alert(objParam['date'] + objParam['isSelectedComputer']+objParam['isSelectedCustomer']+objParam['list_column']);
		
		AB.ajax({
			url: AB.serviceUri + 'lease/leaseReport/getSummaryLeaseDynamicPerDate',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				//console.table(data);
				// color: "#eed236"
				// color: "#36abee"
				dbDataSource = data;
				webix.ready(function(){
					webix.ui({
						container:"leaseReportContainer",
						id:"pivot",
						view:"pivot-chart",
						height:350,
						width:1300,
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

	$("#btnSubmitLeaseReportPerQuarter").click(function(e){
		e.preventDefault();
		var curFormGroupComputer = $("#formColumnComputer");
		var curFormGroupCustomer = $("#formColumnCustomer");
		
		var totalCheckedColumnComputer = 0;
		var totalCheckedColumnCustomer = 0;

		var list_column_computer = '';
		var list_column_customer = '';
		
		curFormGroupComputer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkComputer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnComputer++;
				list_column_computer = list_column_computer + $(this).children().attr('data-value');
			}
		});
		curFormGroupCustomer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkCustomer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnCustomer++;
				list_column_customer = list_column_customer + $(this).children().attr('data-value');
			}
		});

		var list_column = list_column_customer + list_column_computer;
		list_column = list_column.substr(0, list_column.length - 1);
		
		
		var year = $("#ddlYear2 option:selected").text();
		var quarter = $("#ddlQuarter option:selected").val();
		var isSelectedComputer = ( totalCheckedColumnComputer > 0) ? 1 : 0;
		var isSelectedCustomer = ( totalCheckedColumnCustomer > 0) ? 1 : 0;;
		//alert(quarter)
		var objParam = {
			'year' : year,
			'quarter' : quarter,
			'isSelectedComputer' : isSelectedComputer,
			'isSelectedCustomer' : isSelectedCustomer,
			'list_column' : list_column
		}
		
		//alert(objParam['year'] +alert['quarter']+ objParam['isSelectedComputer']+objParam['isSelectedCustomer']+objParam['list_column']);
		
	
		AB.ajax({
			url: AB.serviceUri + 'lease/leaseReport/getSummaryLeaseDynamicPerQuarter',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				//console.table(data);
				// color: "#eed236"
				// color: "#36abee"
				dbDataSource = data;
				webix.ready(function(){
					webix.ui({
						container:"leaseReportContainer",
						id:"pivot",
						view:"pivot-chart",
						height:350,
						width:1300,
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
	
	$("#btnSubmitLeaseReportPerMonth").click(function(e){
		e.preventDefault();
		var curFormGroupComputer = $("#formColumnComputer");
		var curFormGroupCustomer = $("#formColumnCustomer");
		
		var totalCheckedColumnComputer = 0;
		var totalCheckedColumnCustomer = 0;

		var list_column_computer = '';
		var list_column_customer = '';
		
		curFormGroupComputer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkComputer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnComputer++;
				list_column_computer = list_column_computer + $(this).children().attr('data-value');
			}
		});
		curFormGroupCustomer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkCustomer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnCustomer++;
				list_column_customer = list_column_customer + $(this).children().attr('data-value');
			}
		});
		
		var list_column = list_column_customer + list_column_computer;
		list_column = list_column.substr(0, list_column.length - 1);
		
		var year = $("#ddlYear3 option:selected").text();
		var month = $("#ddlMonth option:selected").val();
		var isSelectedComputer = ( totalCheckedColumnComputer > 0) ? 1 : 0;
		var isSelectedCustomer = ( totalCheckedColumnCustomer > 0) ? 1 : 0;;
		
		var objParam = {
			'year' : year,
			'month' : month,
			'isSelectedComputer' : isSelectedComputer,
			'isSelectedCustomer' : isSelectedCustomer,
			'list_column' : list_column
		}
		
		//alert(objParam['year'] +alert['month']+ objParam['isSelectedComputer']+objParam['isSelectedCustomer']+objParam['list_column']);
		
	
		

		AB.ajax({
			url: AB.serviceUri + 'lease/leaseReport/getSummaryLeaseDynamicPerMonth',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				//console.table(data);
				// color: "#eed236"
				// color: "#36abee"
				dbDataSource = data;
				webix.ready(function(){
					webix.ui({
						container:"leaseReportContainer",
						id:"pivot",
						view:"pivot-chart",
						height:350,
						width:1300,
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
	
	$("#btnSubmitLeaseReportPerYear").click(function(e){
	
		e.preventDefault();
		var curFormGroupComputer = $("#formColumnComputer");
		var curFormGroupCustomer = $("#formColumnCustomer");
		
		var totalCheckedColumnComputer = 0;
		var totalCheckedColumnCustomer = 0;

		var list_column_computer = '';
		var list_column_customer = '';
		
		curFormGroupComputer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkComputer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnComputer++;
				list_column_computer = list_column_computer + $(this).children().attr('data-value');
			}
		});
		curFormGroupCustomer.children().each(function(){
			if($(this).find(".icheckbox_flat-red.chkCustomer").children().attr('aria-checked') == 'true'){
				totalCheckedColumnCustomer++;
				list_column_customer = list_column_customer + $(this).children().attr('data-value');
			}
		});
		
		var list_column = list_column_customer + list_column_computer;
		list_column = list_column.substr(0, list_column.length - 1);
		
		//alert(list_column);
		var year = $("#ddlYear option:selected").text();
		var isSelectedComputer = ( totalCheckedColumnComputer > 0) ? 1 : 0;
		var isSelectedCustomer = ( totalCheckedColumnCustomer > 0) ? 1 : 0;;
		var objParam = {
			'year' : year,
			'isSelectedComputer' : isSelectedComputer,
			'isSelectedCustomer' : isSelectedCustomer,
			'list_column' : list_column
		}
		
		
		
		
	//	alert(objParam['year'] + objParam['isSelectedComputer']+objParam['isSelectedCustomer']+objParam['list_column']);
		AB.ajax({
			url: AB.serviceUri + 'lease/leaseReport/getSummaryLeaseDynamicPerYear',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success:function(data){
				//console.table(data);
				dbDataSource = data;
				webix.ready(function(){
					webix.ui({
						container:"leaseReportContainer",
						id:"pivot",
						view:"pivot-chart",
						height:350,
						width:1300,
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
