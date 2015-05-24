<div class="top-navigation">
     <p>Настройки виджета <b>{$widget.name}</b></p> 
    
</div>
<div style="padding:12px">
    <form class="pjax" action="{$BASE_URL}admin/widgets_manager/update_widget/{$widget.id}" id="widget_form" method="post">
    {if is_array($polls_array) && count($polls_array)>0}
        <div class="form_text">Выберите голосование:</div>
        <div class="form_input">
            <select name="poll_id">
            {foreach $polls_array as $poll}
                <option value="{$poll.id}" {if $poll.id==$widget.settings.poll_id}selected="selected"{/if}>{$poll.name}</option>
            {/foreach}
            </select>
        </div>
        <div class="form_overflow"></div>

        <div class="form_text"></div>
        <div class="form_input">
            <input type="submit" class="button" value="Сохранить"  />
    {else:}
            <p>Список голосований пуст — создайте новое голосование.</p>
            <a class="pjax btn btn-primary" value="Создать" href="/admin/components/cp/polls/create"></a>
    {/if}
            <a href="/admin/widgets_manager/" class="pjax" >Перейти к списку виджетов</a>
        </div>
    {form_csrf()}
    </form>
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