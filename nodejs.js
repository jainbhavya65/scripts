var mysql = require('mysql');
var moment = require('moment');
var diff = require('diff');
var cron = require('node-cron')
var nodemailer = require("nodemailer");
var smtpTransport = require('nodemailer-smtp-transport');
var stripe = require('stripe')('sk_test_6pmcf1MsiY5pTMPMaOqxbfXJ');
var async = require('async')

var smtpTransport = nodemailer.createTransport({
    service: "gmail",
    host: "smtp.gmail.com",
    secure: "true",
    auth: {
        user: "bhavya@iface.io",
        pass: "!@!^&iitjee@)!@2"
    }
});

//var con = mysql.createConnection({
//  host: "192.168.123.2",
//  user: "root",
//  password: "redhat",
//  database: "iface_crm_admin"
//});

var pool = mysql.createPool({
    connectionLimit : 10,
    host: "192.168.123.2",
    user: "root",
    password: "redhat",
    database: "iface_crm_admin"
});


pool.getConnection(function (err, connection) {
 if (err) {
                connection.release();
                callback(null, err);
                throw err;
         }
console.log("connected!")
cron.schedule("13 19 * * *", function() {
 connection.query("SELECT * FROM tbl_companies", function (err, result, fields) {
 if (err) throw err;
	connection.query("delete from tbl_expired_databases ;")
	for (let i=0; i< result.length; i++) {
		var date = moment(result[i].subscription_end_date)
		var today = moment(new Date())
		var diffDays =  date.diff(today, 'hours')
		if (diffDays <= "0"){
		connection.query("insert into tbl_expired_databases values ('"+ result[i].company_pid+"');")
			console.log("expired");
		}else {
			console.log(diffDays +"hr are remaning")
		}
	}	
 });
 connection.on('error', function (err) {
                connection.release();
                callback(null, err);
                throw err;
});
});

cron.schedule("15 13 19 * * * ",function() {
connection.query("select * from tbl_expired_databases;", function (err, result, fields) {
	if (err) throw err;
	connection.query("delete from tbl_delete_database ;")
	console.log(result)
	if (result.length === 0) {
		console.log("No Databases are going to delete")
	}else { 
		let companyIdArray = []
		for (var i = 0;  i < result.length; i++) {
			companyIdArray.push(parseInt(result[i].company_pid))
		}
		connection.query("select * from tbl_companies where company_pid in ("+companyIdArray+");", function (err1, result1, field) {
  			if (err1) throw err1
  			async.map(result1,function check(i,mapcallback){
  				var companyinfo = "";
  			 	console.log(i)    
                var date = moment(i.subscription_end_date)
                var today = moment(new Date())
                var diffDays =  date.diff(today, 'hours')
                //console.log(diffDays)
                if (diffDays <= 0){
					if ( i.is_subscribed === 1 ) {
						stripe.subscriptions.retrieve(i.payment_subscription_id, function(err, subscription) {
						if(err){
         					console.log(err);
         					mapcallback(err , null)
						}else{
   							//console.log(subscription.current_period_end)
   					 		var enddate = moment(subscription.current_period_end*1000)
       						//console.log(enddate)
					  		var diff_check = enddate.diff(today, 'hours')
					  		if (diff_check <= 0){
					 			database_delete(function(err , companyinfo){
					 						if(err){
								 		mapcallback(err , null);
								 	}else{
								 		console.log("------------");
								 		console.log(companyinfo)
								 		mapcallback(null , companyinfo)
								 	}
					 			})
					  		}else{
					  			mapcallback("User subscription is extended over stripe" , null)
					  		}
					 		console.log("stripe checked")
					 	}
					});
				} else {
					database_delete(function(err , companyinfo){
					 	if(err){
					 		mapcallback(err , null);
					 	}else{
					 		console.log("------------");
							console.log(companyinfo)
					 		mapcallback(null , companyinfo)
					 	}
					})
        		}
        		}else{
        			mapcallback(null,companyinfo)
        		}
        		
        		function database_delete(callback){
        			console.log(callback)
                	connection.query("insert into tbl_delete_database values ('"+ i.company_pid+"');" , function(err , result){
                		if(err){
                			console.log(err);
                			callback(err , null)
                		}else{
                			companyinfo = {"companyid": i.company_pid,"companyname": i.company_name}
                		    console.log(companyinfo);
                		    callback(null ,companyinfo);
                		}
                	})	
				}
			},function(err,companyinfo){
				console.log("inside callback")
				
  				if(err){
  					console.log(err);
  				}else{
  					console.log(companyinfo)
  					
  				}
  				sendMail(companyinfo)
  			})
	    });

		// for (let j=0; j <result.length; j++) {
		// 	connection.query("select * from tbl_companies where company_pid='"+result[j].company_pid+"'", function (err1, result1, field) {
  // 				if (err1) throw err1
  //     			var date = moment(result1.subscription_end_date)
  //     			var today = moment(new Date())
		// //      var diffDays = parseInt((result[i].date - today) / (1000 * 60 * 60  ))
  //       		var diffDays =  date.diff(today, 'hours')
		// 		if (diffDays <= 0){
  //               	connection.query("insert into tbl_delete_database values ('"+ result[j].company_pid+"');")
  //       	 		companyid = companyid+"\n"+result[j].company_pid;
  //       	 		console.log(companyid)

        	 		
		// 		}else {
  //              	 	console.log(diffDays +"hr are remaning")
  //          		}
  //      		});
	 //   }
		function sendMail(companyinfo){
		console.log("hello")
		console.log(companyinfo)
	   	console.log(companyinfo.length)
	   	let table_body = "";
	   	for(let i=0 ; i < companyinfo.length ; i++){
	   		console.log(typeof companyinfo[i]);
	   			// if(companyinfo[i] !== "undefined"){
	   			// 	table_body += "<tr><td>"+companyinfo[i].companyid+"</td><td>"+companyinfo[i].companyname+"</td></tr>"
	   			// }
	   	}	
	   	var mailOptions={
		        to : "bhavya@iface.io",
		        subject : "company's are going to be delete today",
				html: `<html>
							<head>
								<style>
									#itemList {
    									font-family: arial, sans-serif;
   										border-collapse: collapse;
    									width: 100%;
									}
									td, th {
    									border: 1px solid #dddddd;
    									text-align: left;
    									padding: 8px;
									}
									tr:nth-child(even) {
    									background-color: #dddddd;
									}	
								</style>
							</head>
							<body>
								<h2>Companies List</h2>
								<table id="itemList">
  									<tr>
    									<th>Company Pid</th>
    									<th>Company Name</th>
  									</tr> 
  								</table>
  								<br>
							<a href = 'www.google.com'>View Details</a>
							</body>
						</html>` 
		    }
		    console.log(mailOptions);
		    smtpTransport.sendMail(mailOptions, function(error, response){
		     if(error){
		            console.log(error);
		     }
			else{
		            console.log("Message sent: ");
		         }
			});
	   }
}
});
connection.on('error', function (err) {
                connection.release();
                callback(null, err);
                throw err;
});
});
});
