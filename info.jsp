<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>信息管理</title>
<%
	// 权限验证
	if(session.getAttribute("currentUser")==null){
		response.sendRedirect("index.jsp");
		return;
	}
%>
<link rel="stylesheet" type="text/css" href="jquery-easyui-1.3.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="jquery-easyui-1.3.3/themes/icon.css">
<script type="text/javascript" src="jquery-easyui-1.3.3/jquery.min.js"></script>
<script type="text/javascript" src="jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">
	var url;
	function searchGrade(){
		$('#dg').datagrid('load',{
			id:$('#s_id').val(),
			date:$('#s_date').datetimebox("getValue"),
			date1:$('#s_date1').datetimebox("getValue"),
			distance:$('#s_distance').val(),
			distance1:$('#s_distance1').val()
		});
	}
	
	function deleteGrade(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length==0){
			$.messager.alert("系统提示","请选择要删除的数据！");
			return;
		}
		var strIds=[];
		for(var i=0;i<selectedRows.length;i++){
			strIds.push(selectedRows[i].id);
		}
		var ids=strIds.join(",");
		$.messager.confirm("系统提示","您确认要删掉这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
			if(r){
				$.post("Delete",{delIds:ids},function(result){
					if(result.success){
						$.messager.alert("系统提示","您已成功删除<font color=red>"+result.delNums+"</font>条数据！");
						$("#dg").datagrid("reload");
					}else{
						$.messager.alert('系统提示','<font color=red>'+selectedRows[result.errorIndex].gradeName+'</font>'+result.errorMsg);
					}
				},"json");
			}
		});
	}
	
	
	function openGradeAddDialog(){
		$("#dlg").dialog("open").dialog("setTitle","添加信息");
		url="Add";
	}
	
	function openGradeModifyDialog(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length!=1){
			$.messager.alert("系统提示","请选择一条要编辑的数据！");
			return;
		}
		var row=selectedRows[0];
		$("#dlg").dialog("open").dialog("setTitle","编辑信息");
		$("#fm").form("load",row);
		url="Update?id="+row.id;
	}
	
	function closeGradeDialog(){
		$("#dlg").dialog("close");
		resetValue();
	}
	
	function resetValue(){
		$('#date').datetimebox('setValue', '');
		$("#distance").val("");
	}
	
	
	function saveGrade(){
		$("#fm").form("submit",{
			url:url,
			onSubmit:function(){
				return $(this).form("validate");
			},
			success:
			function(data){
			var data = eval('(' + data + ')');
			if(data.success){
				$("#dlg").dialog("close");
				resetValue();
				$("#dg").datagrid("reload");
				$.messager.alert("系统提示",data.succMsg);
			}else{
			$("#dlg").dialog("close");
			resetValue();
			$.messager.alert("系统提示",data.errorMsg);
			}
		}
	});
}
</script>
</head>
<body style="margin: 5px;">
	<table id="dg" title="信息" class="easyui-datagrid" fitColumns="true"
	 pagination="true" rownumbers="true" url="InfoList" fit="true" toolbar="#tb">
		<thead>
			<tr>
				<th field="cb" checkbox="true"></th>
				<th field="id" width="150">编号</th>
				<th field="date" width="250">日期</th>
				<th field="distance" width="250">距离</th>
			</tr>
		</thead>
	</table>
	
	<div id="tb">
		<div>
			<a href="javascript:openGradeAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a>
			<a href="javascript:openGradeModifyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
			<a href="javascript:deleteGrade()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
		</div>
		<div>
		&nbsp;编号：&nbsp;<input type="text" name="s_id" id="s_id"/>
		&nbsp;日期：&nbsp;<input type="text" name="s_date" id="s_date" class="easyui-datetimebox" data-options="required:false,showSeconds:true"/>
		---&nbsp;<input type="text" name="s_date1" id="s_date1" class="easyui-datetimebox" data-options="required:false,showSeconds:true"/>
		&nbsp;距离：&nbsp;<input type="text" name="s_distance" id="s_distance"/>
		---&nbsp;<input type="text" name="s_distance1" id="s_distance1"/>
		<a href="javascript:searchGrade()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
		</div>
	</div>
	
	<div id="dlg" class="easyui-dialog" style="width: 400px;height: 280px;padding: 10px 20px"
		closed="true" buttons="#dlg-buttons">
		<form id="fm" method="post">
			<table>
				<tr>
					<td>日期：</td>
					<td><input type="text" name="date" id="date" class="easyui-datetimebox" data-options="required:true,showSeconds:true"/></td>
				</tr>
				<tr>
					<td>距离：</td>
					<td><input type="text" name="distance" id="distance" class="easyui-validatebox"  required="true"/></td>
				</tr>
			</table>
		</form>
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:saveGrade()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeGradeDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
</body>
</html>