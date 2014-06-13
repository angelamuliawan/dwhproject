<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Home extends AB_Controller {

	/**
	 * Index Page for this controller.
	 *
	 * Maps to the following URL
	 * 		http://example.com/index.php/welcome
	 *	- or -  
	 * 		http://example.com/index.php/welcome/index
	 *	- or -
	 * Since this controller is set as the default controller in 
	 * config/routes.php, it's displayed at http://example.com/
	 *
	 * So any other public methods not prefixed with an underscore will
	 * map to /index.php/welcome/<method_name>
	 * @see http://codeigniter.com/user_guide/general/urls.html
	 */
	public function index()
	{
		if($this->session->userdata('loggedin') == NULL) redirect('login');
		
		$pageContent = $this->load->view('contents/Dashboard','',TRUE);
		$this->load->view('master/template',array('pageContent'=>$pageContent));
	}

	public function doLogout(){
		$this->load->helper('url');
		$this->session->sess_destroy();
		redirect('login');
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */