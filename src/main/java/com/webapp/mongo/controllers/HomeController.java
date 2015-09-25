package com.webapp.mongo.controllers;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.webapp.mongo.models.Employee;
import com.webapp.mongo.models.websocket.AddRow;
import com.webapp.mongo.models.websocket.Greeting;
import com.webapp.mongo.repositories.EmployeeRepository;

@Controller
public class HomeController {

	@Autowired
	private EmployeeRepository repository;

	@Autowired
	HttpSession httpSession;

	@RequestMapping(value = "/add", method = RequestMethod.POST)
	@ResponseBody
	public Employee addEmployee(@RequestParam("firstName") String firstName, @RequestParam("lastName") String lastName,
			@RequestParam("age") String age, @RequestParam("department") String department) {
		Employee employee = repository.save(new Employee(firstName, lastName, Integer.parseInt(age), department));
		return employee;
	}

	@RequestMapping(value = "/delete")
	@ResponseBody
	public Employee deleteEmployeeById(@RequestParam("id") String id) {
		Employee employee = repository.findOne(id);
		repository.delete(employee);
		return employee;
	}

	@RequestMapping(value = "/update", method = RequestMethod.POST)
	@ResponseBody
	public Employee updateEmployee(@RequestParam("id") String id, @RequestParam("firstName") String firstName,
			@RequestParam("lastName") String lastName, @RequestParam("age") String age,
			@RequestParam("department") String department) {
		Employee employee = repository.findOne(id);
		employee.setFirstName(firstName);
		employee.setLastName(lastName);
		employee.setAge(Integer.parseInt(age));
		employee.setDepartment(department);
		repository.save(employee);
		System.out.println("test");
		return employee;
	}

	@RequestMapping(value = "/home")
	public String home() {

		List<Employee> listEmployees = repository.findAll();
		httpSession.setAttribute("listEmployees", listEmployees);
		return "home";
	}

	///// WEBSOCKET

	@MessageMapping("/hello")
	@SendTo("/topic/greetings")
	public Greeting greeting(AddRow row) throws Exception {
		//Thread.sleep(3000);
		Employee employee = repository.save(
				new Employee(row.getFirstName(), row.getLastName(), 
						Integer.parseInt(row.getAge()), row.getDepartment()));
		return new Greeting(employee.toString());
	}
}
