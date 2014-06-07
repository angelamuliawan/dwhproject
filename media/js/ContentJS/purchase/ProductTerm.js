function reloadChart(){
	var dataSource = [
		{ country: "Russia", area: 12 },
		{ country: "Canada", area: 7 },
		{ country: "USA", area: 7 },
		{ country: "China", area: 7 },
		{ country: "Brazil", area: 6 },
		{ country: "Australia", area: 5 },
		{ country: "India", area: 2 },
		{ country: "Others", area: 55 }
	];

	$("#chartContainer").dxPieChart({
		size:{ 
			width: 1200
		},
		dataSource: dataSource,
		series: [
			{
				argumentField: "country",
				valueField: "area",
				label:{
					visible: true,
					connector:{
						visible:true,           
						width: 1
					}
				}
			}
		],
		title: "Area of Countries"
	});
}

$(document).ready(function(){
	reloadChart();
	$('#daterange').daterangepicker();
});