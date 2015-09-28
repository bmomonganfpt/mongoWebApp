<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html lang="en">
<head>
<title>CRUD MongoDB</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.0.3/sockjs.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.js"></script>


</head>
<body>
	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="#">CRUD MongoDB</a>
			</div>
			<div>
				<ul class="nav navbar-nav">
					<li class="active"><a href="#">Home</a></li>
				</ul>
			</div>
		</div>
	</nav>

	<div class="container">
	
		<a href="#" id="add" class="btn btn-primary btn-sm"> <span
			class="glyphicon glyphicon-plus"></span> New Entry
		</a> <br> <br>
		<table id="table" class="table table-bordered table-fixed">
			<thead>
				<tr>
					<th class="col-md-2" style="text-align: center;"><strong>First Name</strong></th>
					<th class="col-md-2" style="text-align: center;"><strong>Last Name</strong></th>
					<th class="col-md-2" style="text-align: center;"><strong>Age</strong></th>
					<th class="col-md-2" style="text-align: center;"><strong>Department</strong></th>
					<th class="col-md-2" style="text-align: center;"><strong>Action</strong></th>
				</tr>
			</thead>
			<tbody>
			
			</tbody>
		</table>
	</div>

	<!-- Modal -->
	<div class="modal fade" id="addModal" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Employee Details</h4>
				</div>
				<div class="modal-body">
					<form role="form">
						<div class="form-group">
						 <input type="text"
								class="form-control" id="firstName" placeholder="First Name">
						</div>
						<div class="form-group">
						 <input type="text"
								class="form-control" id="lastName" placeholder="Last Name">
						</div>

						<div class="form-group">
							<input type="text"
								class="form-control" id="age" placeholder="Age">
						</div>
						<select class="form-control" id="department" >
							<option value='' disabled selected style='display:none;'>Department</option>
						   <option value='HR'>HR</option>
						   <option value='IT'>IT</option>
						   <option value='Dev'>Devs</option>
						   <option value='Staff'>Staff</option>
						</select>			
					</form>
				</div>
				<div class="modal-footer">
					<button class="btn btn-default" data-dismiss="modal" id="submit" >Submit</button>
				</div>
			</div>
		</div>
	</div>
</body>


<script>
$(document).ready(function () {
	loadTable();

	var stompClient = null;
	var socket = new SockJS('/hello');
	stompClient = Stomp.over(socket);
	stompClient.connect({}, function(frame) {
		stompClient.subscribe('/topic/greetings', function(result){
			var rowResult = JSON.parse(result.body);
			if (rowResult.status == "delete") {
				$("#row" + rowResult.id).fadeIn(30000, function(){
					$(this).remove();
				});				
			};

			if (rowResult.status == "add") {
				row(rowResult);
			};
			if (rowResult.status == "update"){
				$("tbody").html("");
				loadTable();
			}
		});
	});

	function websocket(status, id, firstName, lastName, age, department){
		stompClient.send("/app/hello", {}, JSON.stringify({'status' : status, 'id' : id, 'firstName': firstName, 'lastName' : lastName, 'age' : age , 'department' : department}));
	}

	function loadTable(event){
		$.post("read", function (result) {
			$.each(result, function(id, employee) {
	    		row(employee);
			});
		});
	}
	
	$("#submit").click(function(){
		$.post("add", {
			firstName : $('#firstName').val(),
			lastName : $('#lastName').val(),
			age : $('#age').val(),
			department : $('#department').val()
 		},
		function (employee) {
			websocket("add", employee.id, employee.firstName, employee.lastName, employee.age, employee.department);
		});
	});	
    
	$("#table").on("click", "tr button[id^='delete']", del);
	$("#table").on("click", "tr button[id^='update']", update);

	function del(event){
		var delId = $(this).attr('id').substring(6);		
		$.post("delete", {
			id : delId
		},		
		function (employee) {
			websocket("delete", employee.id, employee.firstName, employee.lastName, employee.age, employee.department);
		});
	}
	
	function update(event){
		var update = $(this).attr('id').substring(6);
		$.post("update", {
			id : update,
			firstName : $("#firstName" + update).val(),
			lastName : $("#lastName" + update).val(),
			age : $("#age" + update).val(),
			department : $("#department" + update).val()
		},
		function (employee) {
			websocket("update", employee.id, employee.firstName, employee.lastName, employee.age, employee.department);
		});	
	}

	function row(employee){
		var output = "";
		output += "<tr id='row";
		output += employee.id;
		output += "'><td><input type='text' style='border: none; text-align: center;' id='firstName";
		output += employee.id;
		output += "' value='";
		output += employee.firstName;
		output += "'/></td><td><input type='text' style='border: none; text-align: center;' id='lastName"
		output += employee.id;
		output += "' value='";
		output += employee.lastName;
		output += "'/></td><td><input type='text' style='border: none; text-align: center;' id='age"
		output += employee.id;
		output += "' value='";
		output += employee.age;
		output += "'/></td><td><input type='text' style='border: none; text-align: center;' id='department"
		output += employee.id;
		output += "' value='";
		output += employee.department;
		output += "'/></td><td><button id='delete"
		output += employee.id;
		output += "' class='btn btn-primary btn-xs'>Delete</button> <button id='update";
		output += employee.id;
		output += "' class='btn btn-primary btn-xs'>";
		output += "Update</td> </tr>";
		$("#table").find('tbody').append(output);
	}

	$("#add").click(function () {
		$("#addModal").modal({
			show : false
		});
		$("#addModal").modal('show');
	});
});
</script>
</html>