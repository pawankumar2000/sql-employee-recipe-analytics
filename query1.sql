create database workato;
use workato;

create table employees(
emp_no int(11) not null,
birth_date Date not null,
first_name varchar(14) not null,
last_name varchar(16) not null,
gender enum('M','F') not null,
hire_date Date not null,
primary key (emp_no)
);
create table departments(
dept_no char(4) not null,
dept_name varchar(40) not null,
primary key(dept_no)
);
create table dept_emp(
emp_no int(11) not null,
dept_no char(4) not null,
from_date Date not null,
to_date Date not null,
primary key (emp_no,dept_no),
foreign key (emp_no) references employees(emp_no),
foreign key (dept_no) references departments(dept_no)
);
create table dept_manager(
emp_no int(11) not null,
dept_no char(4) not null,
from_date Date,
to_date Date,
primary key(emp_no, dept_no),
foreign key (dept_no) references departments(dept_no)
); 
create table salaries(
emp_no int(11) not null,
salary int(11) not null,
from_date date not null,
to_date date not null
);
create table titles(
emp_no int(11) not null,
title varchar(50) not null,
from_date date not null,
to_date date not null,
primary key (emp_no),
foreign key (emp_no) references employees(emp_no)
);

-- 1) List all employees for each department with their first name, last name, emp_no, dept_no & dept_name
select 
    e.first_name,
    e.last_name,
    e.emp_no,
    de.dept_no,
    d.dept_name
from employees e
join dept_emp de
	on de.emp_no=e.emp_no
join departments d
	on d.dept_no=de.dept_no;
    
-- 2) List all employees where their salary exceeds the salary of their manager
-- I dont have data to find the salary of dept_manager as the csv file(salaries) doesn't have any information about employees of dept_manager 

-- 3) List highest salaried employees for each department
select 
	d.dept_no, d.dept_name, e.emp_no, e.first_name, e.last_name, s.salary
from departments d
join dept_emp de on d.dept_no = de.dept_no
join employees e on de.emp_no = e.emp_no
join salaries s on e.emp_no = s.emp_no
where (de.dept_no, s.salary) in (
    select de.dept_no, max(s.salary)
    from dept_emp de
    join salaries s on de.emp_no = s.emp_no
    group by de.dept_no
)
order by de.dept_no;

-- 4)  List all employees that don't have a manager 
select e.emp_no,e.first_name,e.last_name
from employees e
where e.emp_no in (
		select emp_no from dept_manager
);
-- 5) List all employees who are their own manager
select de.emp_no 
from dept_emp de
join dept_manager dm
on de.emp_no=dm.emp_no;

-- 6) List all employees who have been hired prior to their manager
select de.emp_no as emp_id ,e.first_name as emp_name,e.hire_date as emp_hire_date,
	   dm.emp_no as mgr_id,m.first_name as managr_name,m.hire_date as managr_hire_date
from dept_emp de 
join dept_manager dm
on de.dept_no=dm.dept_no
join employees e
on e.emp_no=de.emp_no
join employees m
on m.emp_no=dm.emp_no
where e.hire_date<m.hire_date

