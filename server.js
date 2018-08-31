var express = require('express');
var bodyParser = require('body-parser');
var process = require('process');
var Base64 = require('js-base64').Base64;
var path = require('path');
var request = require('request');


var port_no = '';


//for production use 'production', for development use 'development'
process.env.NODE_ENV = 'production';
//process.env.NODE_ENV = 'production';

const app = express();
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'node_modules')))


//setting view engine
// app.ejsngine('html', require('ejs').renderFile);
app.set('view engine', 'ejs');

if (app.get('env') == 'development') {
    port_no = 3000;
}

if (app.get('env') == 'production') {
    port_no = 443;
}

app.get('/', (req, res) => {
    res.render('index')
})

//new link for testing

//app.post("/error/critical" ,(req,res) =>{ 
//  console.log("Critical")
//})


//server
 const server = app.listen(port_no, function() {
     console.log("APP Server has been started! Running on port " + server.address().port);
 });


