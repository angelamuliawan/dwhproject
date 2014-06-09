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
          { valueField: "JumlahPeralatanKomputerDijual", name: "Jumlah Peralatan Komputer Dijual" },
          { valueField: "TotalPenjualanPeralatanKomputer", name: "Total Penjualan Peralatan Komputer (In Million)" }
      ],
      legend: {
          verticalAlignment: "bottom",
          horizontalAlignment: "center"
      },
      title: "Sales summary this year"
  });

}

$(document).ready(function(){
  AB.ajax({
      url: AB.serviceUri + 'summary/summarySales/getSummarySales',
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

