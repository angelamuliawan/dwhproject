$(document).ready(function () {

	$(".btnETLNow").click(function (e) {
		e.preventDefault();
		//console.log("button");
		var dimensiWaktu = $("#dimensiWaktu");
		var dimensiCustomer = $("#dimensiCustomer");
		var dimensiEmployee = $("#dimensiEmployee");
		var dimensiVendor = $("#dimensiVendor");
		var dimensiProduct = $("#dimensiProduct");
		var dimensiServiceType = $("#dimensiServiceType");
		var dimensiComputerRent = $("#dimensiComputerRent");
		
	
		var faktaPembelian = $("#faktaPembelian");
		var faktaPenjualan = $("#faktaPenjualan");
		var faktaLayananService = $("#faktaLayananService");
		var faktaPenyewaan = $("#faktaPenyewaan");

		
			AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_dimensiwaktu',
			type: 'post',
			async : false,
			beforeSend: function (xhr) {
				dimensiWaktu.css("width", Math.floor((Math.random() * 100) + 1) + "%");
			},
			success: function (data) {
				dimensiWaktu.css("width", "100%");
				dimensiWaktu.html("");
				dimensiWaktu.append(data[0].RowAffected + " record(s) inserted");
			}
		});
		
		AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_dimensicustomer',
			type: 'post',
			async : false,
			beforeSend: function (xhr) {
				dimensiCustomer.css("width", Math.floor((Math.random() * 100) + 1) + "%");
			},
			success: function (data) {
				dimensiCustomer.css("width", "100%");
				dimensiCustomer.html("");
				dimensiCustomer.append(data[0].RowAffected + " record(s) inserted");
			}
		});
		
		
		AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_dimensiemployee',
			type: 'post',
			async : false,
			beforeSend: function (xhr) {
				dimensiEmployee.css("width", Math.floor((Math.random() * 100) + 1) + "%");
			},
			success: function (data) {
				dimensiEmployee.css("width", "100%");
				dimensiEmployee.html("");
				dimensiEmployee.append(data[0].RowAffected + " record(s) inserted");
			}
		});
		
		AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_dimensivendor',
			type: 'post',
			async : false,
			beforeSend: function (xhr) {
				dimensiVendor.css("width", Math.floor((Math.random() * 100) + 1) + "%");
			},
			success: function (data) {
				dimensiVendor.css("width", "100%");
				dimensiVendor.html("");
				dimensiVendor.append(data[0].RowAffected + " record(s) inserted");
			}
		});
		
		
		AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_dimensiproduct',
			type: 'post',
			async : false,
			beforeSend: function (xhr) {
				dimensiProduct.css("width", Math.floor((Math.random() * 100) + 1) + "%");
			},
			success: function (data) {
				dimensiProduct.css("width", "100%");
				dimensiProduct.html("");
				dimensiProduct.append(data[0].RowAffected + " record(s) inserted");
			}
		});
		
		AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_dimensiservicetype',
			type: 'post',
			async : false,
			beforeSend: function (xhr) {
				dimensiServiceType.css("width", Math.floor((Math.random() * 100) + 1) + "%");
			},
			success: function (data) {
				dimensiServiceType.css("width", "100%");
				dimensiServiceType.html("");
				dimensiServiceType.append(data[0].RowAffected + " record(s) inserted");
			}
		});
		
		AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_dimensicomputerrent',
			type: 'post',
			async : false,
			beforeSend: function (xhr) {
				dimensiComputerRent.css("width", Math.floor((Math.random() * 100) + 1) + "%");
			},
			success: function (data) {
				dimensiComputerRent.css("width", "100%");
				dimensiComputerRent.html("");
				dimensiComputerRent.append(data[0].RowAffected + " record(s) inserted");
			}
		});
		
		
		AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_faktapembelian',
			type: 'post',
			async : false,
			beforeSend: function (xhr) {
				faktaPembelian.css("width", Math.floor((Math.random() * 100) + 1) + "%");
			},
			success: function (data) {
				faktaPembelian.css("width", "100%");
				faktaPembelian.html("");
				faktaPembelian.append(data[0].RowAffected + " record(s) inserted");
			}
		});
		
		AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_faktapenjualan',
			type: 'post',
			async : false,
			beforeSend: function (xhr) {
				faktaPenjualan.css("width", Math.floor((Math.random() * 100) + 1) + "%");
			},
			success: function (data) {
				faktaPenjualan.css("width", "100%");
				faktaPenjualan.html("");
				faktaPenjualan.append(data[0].RowAffected + " record(s) inserted");
			}
		});

		
		AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_faktalayananservice',
			type: 'post',
			async : false,
			beforeSend: function (xhr) {
				faktaLayananService.css("width", Math.floor((Math.random() * 100) + 1) + "%");
			},
			success: function (data) {
				faktaLayananService.css("width", "100%");
				faktaLayananService.html("");
				faktaLayananService.append(data[0].RowAffected + " record(s) inserted");
			}
		});

		
		AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_faktapenyewaan',
			type: 'post',
			async : false,
			beforeSend: function (xhr) {
				faktaPenyewaan.css("width", Math.floor((Math.random() * 100) + 1) + "%");
			},
			success: function (data) {
				faktaPenyewaan.css("width", "100%");
				faktaPenyewaan.html("");
				faktaPenyewaan.append(data[0].RowAffected + " record(s) inserted");
			}
		});


	});
});