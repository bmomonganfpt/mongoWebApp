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
<script src="lib/sockjs-0.3.min.js"></script>
<script src="lib/stomp.min.js"></script>


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
		<table id="table" class="table table-bordered">
			<thead>
				<tr>
					<th><strong>First Name</strong></th>
					<th><strong>Last Name</strong></th>
					<th><strong>Age</strong></th>
					<th><strong>Department</strong></th>
					<th><strong>Action</strong></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="employee" items="${listEmployees}">
					<tr id="row${employee.id}">
						<td> <input type="text" style="border: none;" id="firstName${employee.id}" value="${employee.firstName}"/></td>
						<td> <input type="text" style="border: none;" id="lastName${employee.id}" value="${employee.lastName}"/></td>
						<td> <input type="text" style="border: none;" id="age${employee.id}" value="${employee.age}"/></td>
						<td> <input type="text" style="border: none;" id="department${employee.id}" value="${employee.department}"/></td>
						<td><button id="delete${employee.id}" class="btn btn-primary btn-xs">Delete</button>
							<button id="update${employee.id}" class="btn btn-primary btn-xs">Update</button>
						</td>
					</tr>
				</c:forEach>
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
	var stompClient = null;
	var socket = new SockJS('/hello');
	stompClient = Stomp.over(socket);
	stompClient.connect({}, function(frame) {
		stompClient.subscribe('/topic/greetings', function(greeting){
			showGreeting(JSON.parse(greeting.body).content);
		});
	});
	
	function showGreeting(message) {
		$("#table").find('tbody').append(message);
	}
	
	$("#submit").click(function(){
		var firstName = $('#firstName').val();
		var lastName = $('#lastName').val();
		var age = $('#age').val();
		var department = $('#department').val();
		stompClient.send("/app/hello", {}, JSON.stringify({ 'firstName': firstName, 'lastName' : lastName, 'age' : age , 'department' : department  }));
	});
    
	$("#table").on("click", "tr button[id^='delete']", del);
	$("#table").on("click", "tr button[id^='update']", update);

	function del(event){
		var thisId = $(this).attr('id').substring(6);		
		$.post("delete", {
			id : thisId
		},		
		function (employee) {
			$("#row" + thisId).remove();	
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
		});	
	}

	$("#add").click(function () {
		alert('hello');
		$("#addModal").modal({
			show : false
		});
		$("#addModal").modal('show');
	});
});
</script>
</html>