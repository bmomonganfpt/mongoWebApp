package com.webapp.mongo.repositories;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.webapp.mongo.models.Employee;

public interface EmployeeRepository extends MongoRepository<Employee, Long> {
	
	public Employee findByFirstName(String firstName);
	public List<Employee> findByLastName(String lastName);
}
