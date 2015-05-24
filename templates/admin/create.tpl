<div class="container backup_container">
    <section class="mini-layout">
        <div class="frame_title clearfix">
            <div class="pull-left">
                <span class="help-inline"></span>
                <span class="title">{lang("Создание нового голосования","polls")}</span>
            </div>
            <div class="pull-right">
                <div class="d-i_b">
                    <!--<a href="/admin/dashboard" class="t-d_n m-r_15"><span class="f-s_14">←</span> <span class="t-d_u">{lang("Go back","admin")}</span></a>-->
                    <!--button type="button" class="btn btn-small btn-primary action_on formSubmit" data-form="#saveSettings" data-action="edit" data-submit><i class="icon-ok icon-white"></i>{lang("Save","admin")}</button-->
                </div>
            </div>
        </div>
        <div class="row-fluid">
            <div class="span12"> 
<div style="clear:both;"></div>

<form method="post" class="pjax" action="{site_url('admin/components/cp/polls/create')}" id="polls_create_form" style="width:100%;">
	{form_csrf()}
	 	<div class="form_text">Язык:</div>
		<div class="form_input"> 
		    <select name="lang">
			  {if count($langs) > 1}
					{foreach $langs as $l}
						<option value="{$l.id}">{$l.lang_name}</option>
					{/foreach}
				{/if}
			</select>
		</div>
		
       	<div class="form_text">Название:</div>
		<div class="form_input">
		    <input type="text" class="textbox_long" name="name" value="" />
		    <span style="color:red;">*</span>
		</div>
        <div class="form_overflow"></div>

       	<div class="form_text">Ответ 1:</div>
		<div class="form_input">
		    <input type="text" class="textbox_long" name="answers[]" value="" />
		</div>
        <div class="form_overflow"></div>

       	<div class="form_text">Ответ 2:</div>
		<div class="form_input">
		    <input type="text" class="textbox_long" name="answers[]" value="" />
		</div>
        <div class="form_overflow"></div>

       	<div class="form_text">Ответ 3:</div>
		<div class="form_input">
		    <input type="text" class="textbox_long" name="answers[]" value="" />
		</div>
        <div class="form_overflow"></div>

       	<div class="form_text">Ответ 4:</div>
		<div class="form_input">
		    <input type="text" class="textbox_long" name="answers[]" value="" />
		</div>
        <div class="form_overflow"></div>

       	<div class="form_text">Ответ 5:</div>
		<div class="form_input">
		    <input type="text" class="textbox_long" name="answers[]" value="" />
		</div>
        <div class="form_overflow"></div>

   		<div class="form_text"></div>
		<div class="form_input">
            <input type="submit" name="button"  class="btn btn-primary" value="Создать"/>
        </div>
		<div class="form_overflow"></div>
</form>

			
			</div>
			</div>
			</section>
			</div>
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