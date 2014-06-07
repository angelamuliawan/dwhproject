<?php

function format_input_date($database_date)
{
	$explode = explode(' ', $database_date);
	
	if(count($explode) == 0)
	{
		return '';
	}
	list($year, $month, $date) = explode('-', $explode[0]);
	
	return $date . '-' . $month . '-' . $year;
}