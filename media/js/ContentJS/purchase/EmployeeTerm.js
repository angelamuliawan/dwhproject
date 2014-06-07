function reloadChart(){
	//alert($("#chartContainer").width());
	$("#chartContainer").dxChart({
		dataSource: [
			{day: "Monday", oranges: 3},
			{day: "Tuesday", oranges: 2},
			{day: "Wednesday", oranges: 3},
			{day: "Thursday", oranges: 4},
			{day: "Friday", oranges: 6},
			{day: "Saturday", oranges: 11},
			{day: "Sunday", oranges: 4} ],
	 
		series: {
			argumentField: "day",
			valueField: "oranges",
			name: "My oranges",
			type: "bar",
			color: '#ffa500'
		}
	});
}

$(document).ready(function(){
	reloadChart();
	$('#daterange').daterangepicker();
});