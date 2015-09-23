package com.webapp.mongo.controllers;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.webapp.mongo.models.Employee;
import com.webapp.mongo.repositories.EmployeeRepository;

@Controller
public class HomeController {

	@Autowired
	private EmployeeRepository repository;
	
	@Autowired
	HttpSession httpSession;

	@RequestMapping("/")
	public String home(@ModelAttribute("employee") Employee employee) {
		
		repository.deleteAll();
		// save a couple of customers
		repository.save(new Employee("Alice", "Wonderloud", 20, "Dev"));
		repository.save(new Employee("Bob", "Smith", 25, "HR"));
		
		List<Employee> listEmployees = repository.findAll();
		httpSession.setAttribute("listEmployees", listEmployees);
		
		/*
		
		
		// fetch all customers
		System.out.println("Customers found with findAll():");
		System.out.println("-------------------------------");
		for (Customer customer : repository.findAll()) {
			System.out.println(customer);
		}
		System.out.println();
		
		// fetch an individual customer
		System.out.println("Customer found with findByFirstName('Alice'):");
		System.out.println("--------------------------------");
		System.out.println(repository.findByFirstName("Alice"));

		System.out.println("Customers found with findByLastName('Smith'):");
		System.out.println("--------------------------------");
		for (Customer customer : repository.findByLastName("Smith")) {
			System.out.println(customer);
		}*/
		return "home";
	}

}
