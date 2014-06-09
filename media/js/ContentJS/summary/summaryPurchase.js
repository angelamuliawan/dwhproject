var dbDataSource;
function reloadChart(){
  
  $("#chartContainer").dxChart({
      equalBarWidth: false,
      dataSource: dbDataSource,
      commonSeriesSettings: {
          argumentField: "Bulan",
          type: "bar"
      },
      series: [
          { valueField: "JumlahPeralatanKomputerDibeli", name: "Jumlah Peralatan Komputer Dibeli" },
          { valueField: "TotalPembelianPeralatanKomputer", name: "Total Pembelian Peralatan Komputer (In Million)" }
      ],
      legend: {
          verticalAlignment: "bottom",
          horizontalAlignment: "center"
      },
      title: "Purchase summary this year"
  });

}

$(document).ready(function(){
  AB.ajax({
      url: AB.serviceUri + 'summary/summaryPurchase/getSummaryPurchase',
      type: 'post',
      dataType: 'json',
      contentType: 'application/json;charset=utf-8',
      success:function(data){
        dbDataSource = data;
        console.table(dbDataSource);
        reloadChart();
      }
    });
});

