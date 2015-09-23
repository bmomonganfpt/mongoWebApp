<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html lang="en">
<head>
<title>CRUD MongoDB</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script
	src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

<script>
$(document).ready(function () {
	function add() {
		$.post("", {
			text : $('#search').val()
		},
		
		function (data) {
			$('#result').text('');
			var output = '<ul class="searchresults" style="text-align: center">';
			$.each(data, function (key,	val) {
				output += '<li>';
				output += '<a style="text-decoration: none; color: red; font-family: Arial" href="/user/' + val.id + '">'
				 + '<h2>'
				 + val.name
				 + '</h2>'
				'</a>';
				output += '</li>';
			});
			output += '</ul>';
			$('#result').append(output);
		});
	}
	
	$("#add").click(function () {
		$("#addModal").modal({
			show : false
		});
		$("#addModal").modal('show');
	});
});
</script>

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
		<table class="table table-bordered">
			<thead>
				<tr>
					<th><strong>First Name</strong></th>
					<th><strong>Last Name</strong></th>
					<th><strong>Age</strong></th>
					<th><strong>Department</strong></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="employee" items="${listEmployees}">
					<tr>
						<td>${employee.firstName}</td>
						<td>${employee.lastName}</td>
						<td>${employee.age}</td>
						<td>${employee.department}</td>
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
					<form:form role="form" modelAttribute="employee">
					
						<div class="form-group">
							<form:label path="firstName">First Name</form:label>
							<form:input cssClass="form-control" path="firstName"  />
						</div>
						
						<div class="form-group">
							<form:label path="lastName">Last Name</form:label>
							<form:input cssClass="form-control" path="firstName"  />
						</div>
						
						<div class="form-group">
							<form:label path="age">Age</form:label>
							<form:input cssClass="form-control" path="firstName"  />
						</div>
						
						<div class="form-group">
							<form:label path="department">Department</form:label>
							<form:select cssClass="form-control" path="department">
								<form:option value="HR">HR</form:option>
								<form:option value="IT">IT</form:option>
								<form:option value="Dev">Devs</form:option>
								<form:option value="Staff">Staff</form:option>
							</form:select>
						</div>
					</form:form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal" onkeyup="add();">Submit</button>
				</div>
			</div>

		</div>
	</div>

</body>
</html>
