package com.webapp.mongo.models;

import org.springframework.data.annotation.Id;

public class Employee {

	@Id
	private String id;

	private String firstName;
	private String lastName;
	private int age;
	private String department;

	public Employee() {
	}

	public Employee(String firstName, String lastName, int age, String department) {
		super();
		this.firstName = firstName;
		this.lastName = lastName;
		this.age = age;
		this.department = department;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	@Override
	public String toString() {
		return String.format("Customer[id=%s, firstName='%s', lastName='%s']", id, firstName, lastName);
	}

}
