<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Main extends AB_Controller {

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
		$res = $this->sp('ProsesETL_LastETL');
		$data["data"] = $res->result();
		//var_dump($data[0]->Last_ETL);
		$pageContent = $this->load->view('contents/etl/etl',$data,TRUE);
		$this->load->view('master/template',array('pageContent'=>$pageContent));
	}
	
	public function proses_faktapembelian()
	{
		$res = $this->sp('ProsesETL_FaktaPembelian');
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
	}
	public function proses_faktapenjualan()
	{
		$res = $this->sp('ProsesETL_FaktaPenjualan');
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
	}
	
	public function proses_faktalayananservice()
	{
		$res = $this->sp('ProsesETL_FaktaLayananService');
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
	}
	
	public function proses_faktapenyewaan()
	{
		$res = $this->sp('ProsesETL_FaktaPenyewaan');
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
	}
	
	public function proses_dimensiwaktu()
	{
		$res = $this->sp('ProsesETL_DimensiWaktu');
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
	}
	
	public function proses_dimensicustomer()
	{
		$res = $this->sp('ProsesETL_DimensiCustomer');
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
	}
	
	
	
	public function proses_dimensiemployee()
	{
		$res = $this->sp('ProsesETL_DimensiEmployee');
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
	}
	
	public function proses_dimensivendor()
	{
		$res = $this->sp('ProsesETL_DimensiVendor');
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
	}
	
	public function proses_dimensiproduct()
	{
		$res = $this->sp('ProsesETL_DimensiProduct');
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
	}
	
	public function proses_dimensiservicetype()
	{
		$res = $this->sp('ProsesETL_DimensiServiceType');
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
	}
	
	public function proses_dimensicomputerrent()
	{
		$res = $this->sp('ProsesETL_DimensiComputerRent');
		$data = $res->result();
		$this->load->view('json_view', array('json' => $data));
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */