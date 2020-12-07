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

