<?php

/**
 * Reformat the date to database format
 *
 * @param string The unformated date
 * @param array Optional parameter which contains the input time format and separator
 * 		Fix: new optional parameter which will return for default value if no value is entered.
 *			This fix may prevent the database server to produce error message because of the improper date format
 *			The best default value is 0000-00-00 since this value is accepted by the MySQL database server
 *			(I don't know if any other database may accept this value as their default date value)
 * @return string The Formated date (yyyy-mm-dd)
 */
function dbdate($date, $format = array('format' => 'd/m/y', 'separator' => '/', 'default' => '1900-01-01'))
{
	if(!is_array($format))
	{
		return;
	}
	
	// fix here: try to look for the default value if the date string is zero length
	if(!$date)
	{
		return $format['default'];
	}
	$preformated = explode($format['separator'], $date);
	if(count($preformated) != 3)
	{
		return;
	}
	$formatpos = explode($format['separator'], $format['format']);
	$form = array(0, 0, 0);
	foreach($formatpos as $i => $type)
	{
		switch($type)
		{
			case 'd':
			case 'dd':
				$form[2] = intval($preformated[$i]);
				break;
			case 'm':
			case 'mm':
				$form[1] = intval($preformated[$i]);
				break;
			case 'y':
			case 'yy':
			case 'yyyy':
				$form[0] = intval($preformated[$i]);
				break;
		}
	}

	$result = $form[0]."-".$form[1]."-".$form[2];
	return $result;
}

function json($data)
{
	header('Content-Type: application/json');
	echo json_encode($data);
	
	return true;
}