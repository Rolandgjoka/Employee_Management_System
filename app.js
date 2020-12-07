var mysql = require("mysql");
const inquirer = require("inquirer");
const cTable = require("console.table");
const env = require("dotenv").config();

var PORT = process.env.PORT || 3306;

var connection = mysql.createConnection({
    host: "localhost",
    port: 3306,
    user: "root",
    password: "rootroot",
    database: "employee_managerDB"
});

connection.connect(function(err) {
    if (err) throw err;
    // con.query("CREATE database employee_managerDB", function (err, result) {
    //     if (err) throw err;
    //     console.log("Database created");
    // });
    startPrompt();
});

function startPrompt() {
    inquirer.prompt([
    {
    type: "list",
    message: "What would you like to do?",
    name: "choice",
    choices: [
              "View All Employees?", 
              "View All Employee's By Roles?",
              "View all Emplyees By Deparments", 
              "Add Employee?",
              "Add Role?",
              "Add Department?",
              "Exit"
            ]
    }
]).then(function(val) {
        switch (val.choice) {
            case "View All Employees?":
              viewAllEmployees();
            break;
    
          case "View All Employee's By Roles?":
              viewAllRoles();
            break;
          case "View all Emplyees By Deparments":
              viewAllDepartments();
            break;
          
          case "Add Employee?":
                addEmployee();
              break;

            case "Add Role?":
                addRole();
              break;
      
            case "Add Department?":
                addDepartment();
              break;

            case "Exit":
                connection.end();
                break;
    
            }
    })
}

function viewAllEmployees() {
    connection.query("SELECT employee.first_name, employee.last_name, role.title, role.salary, department.name, CONCAT(e.first_name, ' ' ,e.last_name) AS Manager FROM employee INNER JOIN role on role.id = employee.role_id INNER JOIN department on department.id = role.department_id left join employee e on employee.manager_id = e.id;", 
    function(err, res) {
      if (err) throw err
      console.table(res)
      startPrompt()
  })
}

function viewAllRoles() {
  connection.query("SELECT employee.first_name, employee.last_name, role.title AS Title FROM employee JOIN role ON employee.role_id = role.id;", 
  function(err, res) {
  if (err) throw err
  console.table(res)
  startPrompt()
  })
}

function viewAllDepartments() {
  connection.query("SELECT employee.first_name, employee.last_name, department.name AS Department FROM employee JOIN role ON employee.role_id = role.id JOIN department ON role.department_id = department.id ORDER BY employee.id;", 
  function(err, res) {
    if (err) throw err
    console.table(res)
    startPrompt()
  })
}


 