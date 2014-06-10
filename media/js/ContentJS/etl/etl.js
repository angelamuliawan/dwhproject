
var dbDataSource;
$(document).ready(function () {
	//reloadChart();
	//$('#daterange').daterangepicker();

	$(".btn.btn-success.btnTimeTerm").click(function () {
		var form = $(this).attr('referTo');
		$("form[role='form']").slideUp();
		$("#" + form).slideDown();
	});

	$(".icheckbox_flat-red.checked.chkEmployee").click(function () {
		var curFormGroup = $(this).closest("div.form-group");
		// curFormGroup.children().each(function(){
		// $(this).find(".icheckbox_flat-red.checked.chkEmployee").children().attr('aria-checked'));
		// });
	});

	$(".icheckbox_flat-red.checked.chkVendor").click(function () {
		var curFormGroup = $(this).closest("div.form-group");
		// curFormGroup.children().each(function(){
		// $(this).find(".icheckbox_flat-red.checked.chkEmployee").children().attr('aria-checked'));
		// });
	});

	$(".icheckbox_flat-red.checked.chkProduct").click(function () {
		var curFormGroup = $(this).closest("div.form-group");
		// curFormGroup.children().each(function(){
		// $(this).find(".icheckbox_flat-red.checked.chkEmployee").children().attr('aria-checked'));
		// });
	});


	$("#btnSubmitServiceReportPerYear").click(function (e) {
		e.preventDefault();

		AB.ajax({
			url: AB.serviceUri + 'service/serviceReport/getSummaryServiceDynamic',
			type: 'post',
			dataType: 'json',
			data: JSON.stringify(objParam),
			contentType: 'application/json;charset=utf-8',
			success: function (data) {
				//console.table(data);
				dbDataSource = data;
				webix.ready(function () {
					webix.ui({
						container: "serviceReportContainer",
						id: "pivot",
						view: "pivot-chart",
						height: 350,
						width: 1300,
						structure: {
							groupBy: "Bulan",
							values: [{
								name: "Jumlah",
								operation: "max",
								color: "#eed236"
							}, {
								name: "Total",
								operation: "max",
								color: "#36abee"
							}],
							filters: [{
								name: "Jumlah",
								type: "select"
							}]
						},
						data: dbDataSource
					});
				});
			}
		});

	});
});