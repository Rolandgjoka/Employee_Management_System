USE employee_managerDB;

INSERT INTO department(name)
VALUES ("Sales"),("IS")("Claims"),("HR"),("e-Biz");

SELECT * FROM department;

INSERT INTO role(title,salary,department_id)
VALUES 
("Sales Agent",40000.00,1),
("Team Lead",65000.00,1),
("Sales Manager",80000.00,1),
("Scrum Master",40000.00,2),
("DevOps",85000.00,2),
("IS Manager",110000.00,2),
("Claims Representative",55000.00,3),
("HR Representative",80000.00,4),
("Manager",50000.00,5),
("Team member",40000.00,5);

SELECT * FROM role;

SELECT 
	department.id,
	department.name,
    role.id ,
    role.title,
    role.salary
FROM department 
	INNER JOIN role on role.department_id = department.id
ORDER BY department.id, role.salary ASC;

INSERT INTO employee(first_name, last_name,role_id)
VALUES
("John","Doe",1),
("Mike","Smith",2),
("Homer","Simpson",3),
("Dwight","Schrute",4),


SELECT * FROM employee;

UPDATE employee SET manager_id = 2 WHERE id = 1;
UPDATE employee SET manager_id = 3 WHERE id = 2;
UPDATE employee SET manager_id = 7 WHERE id = 4;
UPDATE employee SET manager_id = 7 WHERE id = 5;
UPDATE employee SET manager_id = 7 WHERE id = 6;
UPDATE employee SET manager_id = 11 WHERE id = 8;
UPDATE employee SET manager_id = 11 WHERE id = 9;
UPDATE employee SET manager_id = 11 WHERE id = 10;

SELECT * FROM employee;

SELECT
	employee.first_name,
    employee.last_name,
    department.name,
    role.title    
FROM employee 
	INNER JOIN role on role.id = employee.role_id
    INNER JOIN department on department.id = role.department_id
ORDER BY employee.id;



SELECT DISTINCT 
emp1.id,
concat(emp1.first_name, ' ', emp1.last_name) AS Employee,
ro1.title AS Job_Title,
dep1.name AS Department,
ro1.salary,
concat(man1.first_name, ' ', man1.last_name) AS Manager_Name 
FROM employee emp1
INNER JOIN role ro1 ON ro1.id = emp1.role_id 
INNER JOIN department dep1 ON ro1.department_id = dep1.id 
LEFT JOIN employee man1 ON emp1.manager_id = man1.id
JOIN employee emp2 ON ro1.id = emp2.role_id ORDER BY id;


SELECT 
department.name AS Department, sum(salary) AS Payroll_Total
FROM employee_managerdb.employee 
INNER JOIN employee_managerdb.ROLE ON role.id = employee.role_id 
INNER JOIN employee_managerdb.department ON role.department_id = department.id 
GROUP BY department.name;

SELECT 
role.title AS Title, name AS Department, role.salary AS Salary
FROM employee_managerDB.department 
INNER JOIN employee_managerdb.role ON employee_managerdb.department.id = employee_managerDB.role.department_id

unction addEmployee() {
    connection.query("SELECT title FROM employee_managerDB.role;", function(err, res) {
        if (err) throw err;
        let roleArr = [];
        inquirer
          .prompt([
              {
                  name: "role",
                  type: "rawlist",
                  choices: function() {
                      for (let i = 0; i < res.length; i++) {
                          roleArr.push(res[i].title);
                      }
                      return roleArr;
                  },
                  message: "What is the employee's role?"
              },
              {
                  name: "firstname",
                  type: "input",
                  message: "What is the employee's first name?",
              },
              {
                  name: "lastname",
                  type: "input",
                  message: "What is the employee's last name?"
              },
              {
                  name: "manager",
                  type: "number",
                  message: "What is the employee's manager's ID?"
              }
          ])
          .then(function(answer) {
              connection.query("INSERT INTO employee SET ?",
              {
                  first_name: answer.firstname,
                  last_name: answer.lastname,
                  role_id: roleArr.indexOf(answer.role)+1,
                  manager_id: answer.manager
              });
              runQuestions();
          });
    });
}

function viewEmployee() {
    let query = "SELECT DISTINCT emp1.id, concat(emp1.first_name, ' ', emp1.last_name) AS Employee, ro1.title AS Job_Title, ";
    query += "dep1.name AS Department, ro1.salary, concat(man1.first_name, ' ', man1.last_name) AS Manager_Name FROM employee emp1 ";
    query += "INNER JOIN role ro1 ON ro1.id = emp1.role_id INNER JOIN department dep1 ON ro1.department_id = dep1.id LEFT JOIN employee man1 ";
    query += "ON emp1.manager_id = man1.id INNER JOIN employee emp2 ON ro1.id = emp2.role_id ORDER BY id";
    connection.query(query, function(err, res) {
        if (err) throw err;
        console.table(res);
        runQuestions();
    });
}

function addDepartment() {
inquirer
    .prompt(
        {
            name: "dept",
            type: "input",
            message: "What is the name of the new department you'd like to add?"
        }
    ).then(function(answer) {
        let query = "INSERT INTO department SET ?"
        connection.query(query, { name: answer.dept }, function(err) {
            if (err) throw err;
            runQuestions();
        });
    });
}

function viewDepartments() {
    let query = "SELECT name AS Department, sum(salary) AS Payroll_Total FROM employee_managerdb.employee "
    query += "INNER JOIN employee_managerdb.ROLE ON role.id = employee.role_id "
    query += "INNER JOIN employee_managerdb.department ON role.department_id = department.id GROUP BY department.name;";

    connection.query(query, function(err, res) {
        if (err) throw err;
        console.table(res);
        runQuestions();
    });
}

function addRole() {
    let query = "SELECT name FROM employee_managerDB.department";

    connection.query(query, function(err, res) {
        if (err) throw err;
        let deptARR = [];

        inquirer
            .prompt([
                {
                    name: "dept",
                    type: "rawlist",
                    choices: function() {
                        for(let i = 0; i < res.length; i++) {
                            deptARR.push(res[i].name);
                        }
                    return deptARR;
                    },
                    message: "What department would you like to add the new role to?"
                },
                {
                    name: "role",
                    type: "input",
                    message: "What is the name of the new role?"
                },
                {
                    name: "salary",
                    type: "number",
                    message: "What is the base salary for the new role?"
                }
            ]).then(function(answer) {
                let query = "INSERT INTO role SET ?";
                connection.query(query, {
                    title: answer.role,
                    salary: answer.salary,
                    department_id: deptARR.indexOf(answer.dept)+1
                }, function(err) {
                    if (err) throw err;
                    runQuestions();
                });
            });
    });
}

function viewRoles() {
let query = "SELECT role.title AS Title, name AS Department, role.salary AS Salary FROM employee_managerDB.department ";
query += "INNER JOIN employee_managerdb.role ON employee_managerdb.department.id = employee_managerDB.role.department_id;";

connection.query(query, function(err, res) {
    if (err) throw err;
    console.table(res);
    runQuestions();
})
}

function updateRole() {
    let query = "SELECT DISTINCT emp1.id, concat(emp1.first_name, ' ', emp1.last_name) AS Employee, ro1.title AS Job_Title, ";
    query += "dep1.name AS Department, ro1.salary, concat(man1.first_name, ' ', man1.last_name) AS Manager_Name FROM employee emp1 ";
    query += "INNER JOIN role ro1 ON ro1.id = emp1.role_id INNER JOIN department dep1 ON ro1.department_id = dep1.id LEFT JOIN employee man1 ";
    query += "ON emp1.manager_id = man1.id INNER JOIN employee emp2 ON ro1.id = emp2.role_id ORDER BY id";

    connection.query(query, function(err, res) {
        if (err) throw err;
        let empArr = [];
        let roleArr = [];
        inquirer
            .prompt([
                {
                    name: "updatedEmp",
                    type: "list",
                    choices: function() {
                        for (let i = 0; i < res.length; i++) {
                            empArr.push(res[i].Employee)
                        }
                        return empArr;
                    },
                    message: "Which employee would you like to update role for?"
                },
                {
                    name: "updatedRole",
                    type: "list",
                    choices: function() {
                        for (let i = 0; i < res.length; i++) {
                            roleArr.push(res[i].Job_Title)
                        }
                        return roleArr;
                    },
                    message: "Choose new role"
                }
            ])
            .then(function(answer) {
                connection.query("UPDATE role SET title = ? WHERE id = ?", [answer.updatedRole, empArr.indexOf(answer.updatedEmp)+1]);
                runQuestions();
            })
    })

}
