{if $data}
<div class="voteForm"> 
<h3 style="margin-bottom:0.5em">{$data.poll.name}</h3>
{if $data.userVoted}
	<!-- Пользователь уже голосовал в опросе. Выводим результаты -->
	<div style="width:100%;position:relative;"> 
	{foreach $data['answers'] as $answer}
	   	{encode($answer.text)} ({$answer.percent}%)
	    <div class="progress"><div class="progress-bar progress-bar-info progress-bar-striped" aria-valuenow="{($answer.percent>0?$answer.percent:1)}" aria-valuemin="0" aria-valuemax="100" style="width:{($answer.percent>0?$answer.percent:1)}%;"></div></div>
	{/foreach}
	</div>
{else:}
 
	<!-- Пользователь не голосовал в опросе. Выводим форму голосования -->
	<form id="PollForm" method="POST">
	<div class="controls">
	{foreach $data['answers'] as $answer}
		<label class="radio">
			<input selected="selected" id="cms_polls_make_vote_{$answer.id}" name="cms_polls_make_vote" value="{$answer.id}" type="radio">
			{echo encode($answer.text)}
		</label>
	{/foreach}
	</div> 
	<input type="submit" class="btn btn-primary" value="{lang('Проголосовать','polls')}" style="margin-top:0.5em">
	{form_csrf()}
	</form>
	
	
	{literal}
<script>
 	$("#PollForm").submit(function() { 
  	  $.ajax({
          type:"POST",
          url: "/polls/vote",
          data: $(this).serialize(), // serializes the form's elements.
          success: function(data)
          {
        	  $('.voteForm').html(data);
              
          }
        });

   return false;  
   }); 
   </script>
	{/literal}
{/if}
</div>
{/if} 
