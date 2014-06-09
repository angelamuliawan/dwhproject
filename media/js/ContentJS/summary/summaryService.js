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
          { valueField: "JumlahPeralatanKomputerDigunakan", name: "Jumlah Peralatan Komputer Digunakan" },
          { valueField: "TotalServiceKomputer", name: "Total Service Komputer (In Million)" }
      ],
      legend: {
          verticalAlignment: "bottom",
          horizontalAlignment: "center"
      },
      title: "Service summary this year"
  });

}

$(document).ready(function(){
  AB.ajax({
      url: AB.serviceUri + 'summary/summaryService/getSummaryService',
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

