<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class AB_Controller extends CI_Controller {
	public function __construct()
	{
		parent::__construct();
		
		$this->load->library('session');
		$this->load->library('rest');
		//$this->load->helper('general');
		
		// if($use_session)
		// {
			// $username = $this->session->userdata('username');
			// if(!$username)
			// {
				// $this->denyRequest();
			// }
		// }
	}
	
	// public function denyRequest() {
		// header("Content-Type: application/json;charset=utf-8", true, 401);
		// echo '{"status":"error","errno":"1","error":"No valid sessions found. Unathorized access."}';
		// exit;
	// }
	
	public function sp($sp_name, $array = array())
	{
		$param_name = array();
		$param_list = array();
		foreach($array as $key => $val)
		{
			$param_name[] = '@' . $key . '=?';
			$param_list[] = $val;
		}
		
		$sp_name .= ' '. implode(', ', $param_name);
	
		return $this->db->query($sp_name, $param_list);
	}
}

/* End of file BM_Controller.php */