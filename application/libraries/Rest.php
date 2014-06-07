<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Rest {

	protected $request_method;
	protected $request_body = null;
	protected $request_type = 'json';
	
	public function __construct()
	{
		$this->request_method = strtoupper($_SERVER['REQUEST_METHOD']);
	}
	
    public function post(&$output_type = null)
    {
		if($this->request_method != 'POST')
		{
			return null;
		}
		
		if(!is_null($this->request_body))
		{
			return $this->request_body;
		}
		
		$CI = & get_instance();
		$content_type = $CI->input->get_request_header('Content-type');
		if(strpos(strtolower($content_type), 'application/json') !== false)
		{
			$input = file_get_contents('php://input');
			$decoded = json_decode($input);
			if(json_last_error() == JSON_ERROR_NONE)
			{
				$this->request_body = $decoded;
				$output_type = 'JSON';
			}
		}
		elseif(strpos(strtolower($content_type), 'multipart/form-data') !== false)
		{
			$this->request_type = 'form';
			$this->request_body = $_POST;
			
			foreach($_FILES as $key => $val)
			{
				if($val['error'] == 4)
				{
					continue;
				}
				
				if(is_uploaded_file($_FILES[$key]['tmp_name']))
				{
					// remove leading dot or any slash / backslash from the name
					$val['name'] = trim(str_replace(array('/', '\\'), '', $val['name']), ' .');
					
					$this->request_body[$key] = (object) $val;
				}
				
			}
			
			$this->request_body = (object) $this->request_body;
			
			$output_type = 'FORM';
		}
		
		return $this->request_body;
    }
	
	public function move_file($field_name, $destination, $file_name = '')
	{
		if($this->request_type == 'form')
		{
			$file = $this->request_body->$field_name;
			if($file_name == '')
			{
				$file_name = $file['name'];
			}
			move_uploaded_file($file->tmp_name, $destination . '/' . $file_name);
			@chmod($destination, 0666);
		}
		else
		{
		
		}
	}
	
	public function put()
	{
		if($this->request_method != 'PUT')
		{
			return null;
		}
		
		if(!is_null($this->request_body))
		{
			return $this->request_body;
		}
		
		$CI = & get_instance();
		$content_type = $CI->input->get_request_header('Content-type');
		if(strpos(strtolower($content_type), 'application/json') !== false)
		{
			$input = file_get_contents('php://input');
			$decoded = json_decode($input);
			if(json_last_error() == JSON_ERROR_NONE)
			{
				$this->request_body = $decoded;
			}
		}
		
		return $this->request_body;
	}
}

/* End of file Rest.php */