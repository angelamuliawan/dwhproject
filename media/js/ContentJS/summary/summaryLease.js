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
          { valueField: "JumlahKomputerDisewa", name: "Jumlah Komputer Disewa" },
          { valueField: "TotalPenyewaanKomputer", name: "Total Penyewaan Komputer (In Million)" }
      ],
      legend: {
          verticalAlignment: "bottom",
          horizontalAlignment: "center"
      },
      title: "Lease summary this year"
  });

}

$(document).ready(function(){
  AB.ajax({
      url: AB.serviceUri + 'summary/summaryLease/getSummaryLease',
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

