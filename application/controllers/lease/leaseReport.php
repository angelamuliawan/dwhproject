<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class LeaseReport extends AB_Controller {

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
		if(!strstr($this->session->userdata('accessright'),'all') && !strstr($this->session->userdata('accessright'),'leaseReport')) redirect('home');

		$pageContent = $this->load->view('contents/lease/leaseReport','',TRUE);
		$this->load->view('master/template',array('pageContent'=>$pageContent));
	}
	
	public function getSummaryLeaseDynamicPerYear(){
		$post = $this->rest->post();
		$res = $this->sp('Summary_Penyewaan_Dynamic_PerYear', array
			(
				'year' => $post->year,
				'isSelectedCustomer' => $post->isSelectedCustomer,
				'isSelectedComputer' => $post->isSelectedComputer,
				'list_column' => $post->list_column
			)
		);
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
		
	}

	public function getSummaryLeaseDynamicPerQuarter(){
		$post = $this->rest->post();
		$res = $this->sp('Summary_Penyewaan_Dynamic_PerQuarter', array
			(
				'year' => $post->year,
				'quarter' => $post->quarter,
				'isSelectedCustomer' => $post->isSelectedCustomer,
				'isSelectedComputer' => $post->isSelectedComputer,
				'list_column' => $post->list_column
			)
		);
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
	}

	public function getSummaryLeaseDynamicPerMonth(){
		$post = $this->rest->post();
		$res = $this->sp('Summary_Penyewaan_Dynamic_PerMonth', array
			(
				'year' => $post->year,
				'month' => $post->month,
				'isSelectedCustomer' => $post->isSelectedCustomer,
				'isSelectedComputer' => $post->isSelectedComputer,
				'list_column' => $post->list_column
			)
		);
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
	}

	public function getSummaryLeaseDynamicPerDate(){
		$post = $this->rest->post();
		$res = $this->sp('Summary_Penyewaan_Dynamic_PerDate', array
			(
				'date' => $post->date,
				'isSelectedCustomer' => $post->isSelectedCustomer,
				'isSelectedComputer' => $post->isSelectedComputer,
				'list_column' => $post->list_column
			)
		);
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */
?>