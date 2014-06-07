<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Login extends AB_Controller {

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
	 
	public function __construct()
	{
		parent::__construct();
	}
	public function index()
	{
		$this->load->view('contents/login');
	}
	
	public function loginUser()
	{
		$post = $this->rest->post();
		// $result = $this->sp('Login', array(
			// 'Username' => '',
			// 'Password' => ''
		// ));

		$query = $this->db->query("Login @Username = ?, @Password = ?", array($post->username, MD5($post->password)));
		$user = $query->row();
		
		if($user)
		{
			// $payload['json'] = array(
				// 'status' => 'failed'
			// );
			// return $this->load->view('json_view', $payload);
			
			// dont forget to set userdata here
			$this->load->view('json_view', array('json' => array('status' => 'success')));
		}
		else{
			$this->load->view('json_view', array('json' => array('status' => 'failed')));
		}
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */