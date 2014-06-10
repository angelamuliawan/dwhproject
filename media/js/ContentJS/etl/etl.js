$(document).ready(function () {

	$(".btnETLNow").click(function (e) {
		e.preventDefault();
		console.log("button");
		var faktaPembelian = $("#faktaPembelian");
		var faktaPenjualan = $("#faktaPenjualan");
		var faktaLayananService = $("#faktaLayananService");
		var faktaPenyewaan = $("#faktaPenyewaan");

		AB.ajax({
			url: AB.serviceUri + 'etl/main/proses_faktapembelian',
			type: 'post',
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