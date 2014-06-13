<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class ServiceReport extends AB_Controller {

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
		$pageContent = $this->load->view('contents/service/serviceReport','',TRUE);
		$this->load->view('master/template',array('pageContent'=>$pageContent));
	}
	
	public function getSummaryServiceDynamicPerYear(){
		$post = $this->rest->post();
		$res = $this->sp('Summary_Service_Dynamic_PerYear', array
			(
				'year' => $post->year,
				'isSelectedEmployee' => $post->isSelectedEmployee,
				'isSelectedCustomer' => $post->isSelectedCustomer,
				'isSelectedProduct' => $post->isSelectedProduct,
				'isSelectedServiceType' => $post->isSelectedServiceType,
				'list_column' => $post->list_column
			)
		);
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
	}
	
	public function getSummaryServiceDynamicPerQuarter(){
		$post = $this->rest->post();
		$res = $this->sp('Summary_Service_Dynamic_PerQuarter', array
			(
				'year' => $post->year,
				'quarter' => $post->quarter,
				'isSelectedEmployee' => $post->isSelectedEmployee,
				'isSelectedCustomer' => $post->isSelectedCustomer,
				'isSelectedProduct' => $post->isSelectedProduct,
				'isSelectedServiceType' => $post->isSelectedServiceType,
				'list_column' => $post->list_column
			)
		);
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
	}

	public function getSummaryServiceDynamicPerMonth(){
		$post = $this->rest->post();
		$res = $this->sp('Summary_Service_Dynamic_PerMonth', array
			(
				'year' => $post->year,
				'month' => $post->month,
				'isSelectedEmployee' => $post->isSelectedEmployee,
				'isSelectedCustomer' => $post->isSelectedCustomer,
				'isSelectedProduct' => $post->isSelectedProduct,
				'isSelectedServiceType' => $post->isSelectedServiceType,
				'list_column' => $post->list_column
			)
		);
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
	}

	public function getSummaryServiceDynamicPerDate(){
		$post = $this->rest->post();
		$res = $this->sp('Summary_Service_Dynamic_PerDate', array
			(
				'date' => $post->date,
				'isSelectedEmployee' => $post->isSelectedEmployee,
				'isSelectedCustomer' => $post->isSelectedCustomer,
				'isSelectedProduct' => $post->isSelectedProduct,
				'isSelectedServiceType' => $post->isSelectedServiceType,
				'list_column' => $post->list_column
			)
		);
		$data = $res -> result();
		$this->load->view('json_view', array('json' => $data));
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */