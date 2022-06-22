const express = require("express");
const bodyParser = require("body-parser");
const routes = require("./routes.js");
const path = require("path");

const app = express();

// Middlewares
app.use(express.json());
app.use(express.urlencoded({extended: false}));

app.use(express.static(path.join(__dirname, '/scr/loginSession')));
app.use('/list', express.static(path.join(__dirname, '/scr/mainViewMenu')));

// Routes
app.use(routes);

// Server Listener
app.listen(3000, () => {
	console.log("Sevidor Iniciado...");
});