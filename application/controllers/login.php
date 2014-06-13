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
		$res = $this->sp('Login', array(
			'Username' => $post->username,
			'Password' => MD5($post->password)
		));
		
		$data = $res->result();
		if($data[0]->UserID != -1)
		{
			$this->session->set_userdata('loggedin',true);
			$this->session->set_userdata('userid',$data[0]->UserID);
			$this->session->set_userdata('username',$data[0]->Username);
			$this->session->set_userdata('accessright',$data[0]->AccessRight);
			$this->session->set_userdata('position',$data[0]->Position);
			$this->session->set_userdata('division',$data[0]->Division);
			
			$this->load->view('json_view', array('json' => array('status' => 'success')));
		}
		else{
			$this->load->view('json_view', array('json' => array('status' => 'failed')));
		}
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */