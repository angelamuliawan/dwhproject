<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class ManageAccess extends AB_Controller {

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
		if(!strstr($this->session->userdata('accessright'),'all')) redirect('home');

		
		$pageContent = $this->load->view('contents/ManageAccess','',TRUE);
		$this->load->view('master/template',array('pageContent'=>$pageContent));
	}
	public function getUserName(){
		$res = $this->sp('GetUserName');
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
    }
   	public function getPageName(){
		$res = $this->sp('GetPageName');
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
    }
    public function getAccess(){
		$res = $this->sp('GetAccess');
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
    }
    public function deleteUserAccess(){
    	$post = $this->rest->post();
		$res = $this->sp('DeleteAccess', 
			array(
				'PageID' => $post->pageid,
				'UserID' => $post->userid
			));
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
    }

    public function insertUserAccess(){
    	$post = $this->rest->post();
		$res = $this->sp('InsertUserAccess', 
			array(
				'PageID' => $post->pageid,
				'UserID' => $post->userid
			));
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
    }
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */