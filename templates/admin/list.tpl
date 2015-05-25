<section class="mini-layout">
    <div class="frame_title clearfix">
        <div class="pull-left">
            <span class="help-inline"></span>
            <span class="title">Модуль описание</span>
        </div>
        <div class="pull-right">
            <div class="d-i_b">
                <a href="/admin/components/cp/appeals/" class="t-d_n m-r_15"><span class="f-s_14">←</span> <span class="t-d_u">Вернуться</span></a>
            </div>
        </div>
    </div> 

    {if count($polls)==0}
    <div id="notice" style="width:500px;">Список голосований пустой.
    <a href="/admin/components/cp/polls/create" class="pjax">Создать.</a>
    </div>
    {return}
{/if}

<div class="top-navigation"> 

        <div align="right" style="padding:7px 13px;">
		<a href="/admin/components/cp/polls/create" class="pjax">Создать.</a>
        </div>
</div>
<div style="clear:both;"></div>

<div style="clear:both"></div>

<div id="sortable" >
		  <table id="pages_table" class="table table-fluid table-full table-bordered">
		  	<thead>
                <th width="5px">ID</th>
				<th>Название</th>
				<th width="24px;"></th>
			</thead>
			<tbody>
		{foreach $polls as $poll}
			 
		<tr>
            <td>{$poll.poll.id}</td>
            <td>
                <a href="/admin/components/cp/polls/edit/{$poll.poll.id}" class="pjax">{encode($poll.poll.name)}</a>
				<br><small>
				{foreach $poll.answers as $answer}
					{$answer.text} ({$answer.totalVotes})
					<br>
				{/foreach}
				</small>
            </td>
            <td>
			<img onclick="confirm_delete_poll({$poll.poll.id});" src="{$THEME}/images/delete.png"  style="cursor:pointer" width="16" height="16" title="Удалить" />
			</td>
		</tr>
		{/foreach}
			</tbody>
			<tfoot>
				<tr>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</tfoot>
		  </table>
</div>


{literal}
    	<script type="text/javascript">
		  
        function confirm_delete_poll(id)
        {
          
             
                if(confirm('Удалить голосование'))
                {
                         
				  $.ajax({
						type:'POST', 
						url: '/admin/components/cp/polls/delete/' + id,
						data: 'id='+$(this).data('id')+'&val='+data, // serializes the form's elements.
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
						 
        }  
		</script>
{/literal}

</section>
			
			 