<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Image CMS
 *
 * Polls Module
 * Usage:
* 	    <!-- Загружаем голосование по ID -->
        {$data = modules::load('polls')->getPoll(3)}

        {if $data.userVoted}
            <!-- Пользователь уже голосовал в опросе. Выводим результаты -->
            <div style="width:100%;position:relative;">
            {foreach $data['answers'] as $answer}
                {encode($answer.text)} ({$answer.percent}%)
                <div style="width:{$answer.percent}%;background-color:silver;height:5px;"></div>
            {/foreach}
            </div>
        {else:}
            <!-- Пользователь не голосовал в опросе. Выводим форму голосования -->
            <form action="" method="post">
            {foreach $data['answers'] as $answer}
                <label><input name="cms_polls_make_vote" value="{$answer.id}" type="radio">{echo encode($answer.text)}</label><br/>
            {/foreach}
            <input type="submit" value="Проголосовать">
            {form_csrf()}
            </form>
        {/if}
 */

class Polls extends MY_Controller {

    protected $poll = null;

	public function __construct()
	{
		parent::__construct(); 
		$this->load->helper('cookie');
	}

	// Index function
	public function index()
	{
        return false;
	}

	// Autoload default function
	public function vote()
	{
        if (isset($_POST['cms_polls_make_vote']))
        {
            $answer_id = (int)$_POST['cms_polls_make_vote'];

			
		 
            // Load answer
            $this->db->where('id',$answer_id)->limit(1);
            $answer = $this->db->get('cms_polls_answers')->row_array();

            if (!$_COOKIE['imagecms_polls_cookie_'.$answer['poll_id']])
            {

                $this->db->where( array( 'poll_id' => $answer['poll_id'], 'ip' => $this->input->ip_address() ) );
                $result = $this->db->get('cms_polls_voters')->row_array();

                if( count($result) == 0 )
                {
                    // Insert new vote
                    $this->db->insert('cms_polls_voters',array(
                        'poll_id'   => $answer['poll_id'],
                        'answer_id' => $answer['id'],
                        'date'      => time(),
                        'ip'        => $this->input->ip_address(),
                    ));
                }

               
                $cookie = array(
                   'name'   => 'imagecms_polls_cookie_'.$answer['poll_id'],
                   'value'  => true,
                   'expire' => 60*60*24*31,
                   'path'   => '/',
                );

                set_cookie($cookie);
               $poll = $this->getPoll($answer['poll_id']);  
			   echo $this->template->fetch('widgets/polls',array('data'=>$poll));
            }
        }
	}
 
	
	 function chose_locale()
    {

        $url = $this->uri->uri_string();
        $url_arr = explode('/', $url);
        $languages = $this->db->where('identif',$url_arr[0])->get('languages')->row();
        

        if (empty($languages)){
            $languages = $this->db->where('default', 1)->get('languages')->row();
            $lang = $languages->id;
        }else{
            $lang = $languages->id;			
		}

        return $lang;
    }

    public function getPoll($pollId=null)
    {
        // Load poll
        $this->db->limit(1);
		
		if(!$this->input->is_ajax_request()){
			$this->db->where('lang',$this->chose_locale());
		}
		
		if (!$pollId){
		$this->db->order_by('id','random');
		}else{
        $this->db->where('id', $pollId);
		}
		$this->db->limit(1);
        $poll = $this->db->get('cms_polls');
        if ($poll->num_rows() == 0)
            return false;
        else
            $poll = $poll->row_array();

        $this->poll = $poll;

        // Load answers
        $this->db->where('poll_id',$poll['id']);
        $this->db->order_by('position','ASC');
        $answers = $this->db->get('cms_polls_answers');

        if (sizeof($answers) == 0)
            return false;
        else
            $answers = $answers->result_array();

        // Calculate percent of votes for each answer
        $totalVotes=0;
        for($i=0;$i<count($answers);$i++)
        {
            $this->db->where('answer_id',$answers[$i]['id']);
            $this->db->where('poll_id',(int)$poll['id']);
            $this->db->from('cms_polls_voters');
            $answers[$i]['totalVotes']=$this->db->count_all_results();
            $totalVotes = $totalVotes+$answers[$i]['totalVotes'];
        }

        for($i=0;$i<count($answers);$i++)
        {
            $answers[$i]['percent'] = @round($answers[$i]['totalVotes'] / $totalVotes * 100);
        }

        return array(
            'totalVotes'=>$totalVotes,
            'poll'=>$poll,
            'answers'=>$answers,
            'userVoted'=>$this->hasVoted(),
        );
    }
	
	 

    protected function hasVoted()
    {
        if ($this->poll !== null && !$this->input->is_ajax_request())
        {
            if(!$_COOKIE['imagecms_polls_cookie_'.$this->poll['id']])
                return false;
            else
                return true;
        }else{
			return true;
		}
    }

    // Install
    public function _install()
    {

    	if( $this->dx_auth->is_admin() == FALSE) exit;

        $this->db->query('
        CREATE TABLE  `cms_polls` (
        `id` INT( 11 ) NOT NULL AUTO_INCREMENT ,
        `name` VARCHAR( 255 ) NOT NULL ,
        PRIMARY KEY (  `id` )
        ) ENGINE = MYISAM ;');

        $this->db->query('
        CREATE TABLE  `cms_polls_answers` (
        `id` INT( 11 ) NOT NULL AUTO_INCREMENT ,
        `poll_id` INT( 11 ) NOT NULL ,
        `text` VARCHAR( 255 ) NOT NULL ,
        PRIMARY KEY (  `id` )
        ) ENGINE = MYISAM ;');

        $this->db->query('ALTER TABLE  `cms_polls_answers` ADD INDEX (  `poll_id` );');

        $this->db->query('
        CREATE TABLE  `cms_polls_voters` (
        `id` INT( 11 ) NOT NULL AUTO_INCREMENT ,
        `poll_id` INT( 11 ) NOT NULL ,
        `answer_id` INT( 11 ) NOT NULL ,
        `date` INT( 11 ) NOT NULL ,
        `ip` VARCHAR( 50 ) NOT NULL ,
        PRIMARY KEY (  `id` ) ,
        INDEX (  `poll_id` ,  `answer_id` )
        ) ENGINE = MYISAM ;');

        $this->db->query('ALTER TABLE  `cms_polls_answers` ADD  `position` INT( 5 ) NOT NULL ,
        ADD INDEX (  `position` )');

        $this->db
            ->where('name', strtolower('polls'))
            ->update('components', array('autoload' => 1, 'in_menu' => 1, 'enabled' => 0) );
    }

    // Delete module
    public function _deinstall()
    {
       	if( $this->dx_auth->is_admin() == FALSE) exit;
        $this->load->dbforge();
        $this->dbforge->drop_table('cms_polls');
        $this->dbforge->drop_table('cms_polls_answers');
        $this->dbforge->drop_table('cms_polls_voters');
    }

    /**
     * Display template file
     */
	private function display_tpl($file = '')
	{
        $file = realpath(dirname(__FILE__)).'/templates/public/'.$file.'.tpl';
		$this->template->display('file:'.$file);
	}

    /**
     * Fetch template file
     */
	private function fetch_tpl($file = '')
	{
        $file = realpath(dirname(__FILE__)).'/templates/public/'.$file.'.tpl';
		return $this->template->fetch('file:'.$file);
	}

}

/* End of file polls.php */
