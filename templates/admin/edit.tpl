<div class="top-navigation">
        <div style="float:left;">
            <ul>
            <li>
                <p>Редактирование голосования</p>
            </li>
            </ul>
        </div>
</div>
<div style="clear:both;"></div>

<form method="post" action="{site_url('admin/components/cp/polls/edit/' . $poll.id)}" id="polls_create_form" style="width:100%;" class="pjax">

<div class="form_text">Язык:</div>
		<div class="form_input"> 
		    <select name="lang">
			  {if count($langs) > 1}
					{foreach $langs as $l}
						<option value="{$l.id}" {if $l.id==$poll.lang}selected="true"{/if}>{$l.lang_name}</option>
					{/foreach}
				{/if}
			</select>
		</div>

       	<div class="form_text">Название:</div>
		<div class="form_input">
		    <input type="text" class="textbox_long" name="name" value="{encode($poll.name)}" />
		    <span style="color:red;">*</span>
		</div>
        <div class="form_overflow"></div>

        {$n=1}
        {foreach $answers as $a}
       	<div class="form_text">Ответ {$n}:</div>
		<div class="form_input">
		    <input type="text" class="textbox_long" name="answers[{$a.id}]" value="{encode($a.text)}" />
		    <a class="pjax" href="/admin/components/cp/polls/delete_answer/{$poll.id}/{$a.id}"><img align="middle" src="{$THEME}/images/delete.png"  title="Удалить" width="16" height="16" style="cursor:pointer;" /></a>
		</div>
        <div class="form_overflow"></div>
        {$n++}
        {/foreach}

       	<div class="form_text">Следующий ответ:</div>
		<div class="form_input">
		    <input type="text" class="textbox_long" name="next_answer" value="" />
		</div>
        <div class="form_overflow"></div>
		{form_csrf()}
   		<div class="form_text"></div>
		<div class="form_input">
            <input type="submit" name="button"  class="button_130" value="Сохранить" />
            &nbsp;&nbsp;
			<a href="/admin/components/cp/polls/" class="pjax">Закрыть и перейти к списку голосований</a>
        </div>
		<div class="form_overflow"></div>
</form>
	{literal}
<script>
 	$("form.pjax").submit(function() {
       var action =  $(this).attr('action');
       var method =  $(this).attr('method');
  	  $.ajax({
          type:method,
          url: action,
          data: $(this).serialize(), // serializes the form's elements.
          success: function(data)
          {
        	  $.pjax({
                  url: window.location.pathname,
                  container: '#mainContent',
                  timeout: 1000
              });
              showMessage('Готово','Выполненно успешно');
          }
        });

   return false;  
   }); 
   </script>
	{/literal}