<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
* Polls Widgets
*
* @author Andrey Kulakov <skive@skive.su>
* @link http://www.mediadon.ru
* @copyright Copyright (c) 2012 Kulakov Andrey. All rights reserved.
* @version $Id: attachments.php 0000 2012-07-01 9:33:08Z skive $
*/

class Polls_widgets extends MY_Controller {

    //private $defaults = array(
    //        'poll_id' => 1,
    //);

   	public function __construct()
	{
		parent::__construct();
    }

    // Display image block
    public function polls_block_show($widget = array())
    {
     
		$poll = $this->load->module('polls')->getPoll(); 
        return $this->template->fetch('widgets/'.$widget['name'],  array('data' => $poll) );
    }

/*  
  // Configure widget settings
    public function polls_block_show_configure($action = 'show_settings', $widget_data = array())
    {
        if( $this->dx_auth->is_admin() == FALSE) exit; // Only admin access

        switch ($action)
        {
            case 'show_settings':
                $polls_array = $this->db->get('cms_polls')->result_array();
                $this->display_tpl('polls_block_show_form', array('widget' => $widget_data, 'polls_array' => $polls_array));
            break;

            case 'update_settings':
                $this->form_validation->set_rules('poll_id', 'Голосование', 'required|is_natural');

                if ($this->form_validation->run() == FALSE)
                {
                    showMessage( validation_errors() );
                }
                else{
                    $data = array(
                        'poll_id' => (int)set_value('poll_id'),
                    );

                    $this->load->module('admin/widgets_manager')->update_config($widget_data['id'], $data);
                    showMessage('Настройки сохранены.'); 
                }
            break;

            case 'install_defaults':
                //$this->load->module('admin/widgets_manager')->update_config($widget_data['id'], $this->defaults);
            break;
        }
    }
*/	
    // Template functions
	function display_tpl($file, $vars = array())
    {
        $this->template->add_array($vars);
        $file = realpath(dirname(__FILE__)).'/templates/'.$file.'.tpl';
		$this->template->display('file:'.$file);
	}

	function fetch_tpl($file, $vars = array())
    {
        $this->template->add_array($vars);
        $file = realpath(dirname(__FILE__)).'/templates/'.$file.'.tpl';
		return $this->template->fetch('file:'.$file);
	}

}
