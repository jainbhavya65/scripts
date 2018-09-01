var express = require('express');
var bodyParser = require('body-parser');
var process = require('process');
var Base64 = require('js-base64').Base64;
var path = require('path');
var request = require('request');


var port_no = '';


//for production use 'production', for development use 'development'
process.env.NODE_ENV = 'development';
//process.env.NODE_ENV = 'development';

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

 app.get("/error/crm-push-notification", (req, res) => {
//     // ticket creations
    var body = {
        "ticket": {
            "subject": "System generated Ticket",
            "comment": { "body": "hello" },
            "tags": []
        }
    }
//     // diffrentiate between message from pub/sub or alert 
//     var bodycontain;

//     //from alert
//     if (req.body.hasOwnProperty("incident")) {
//         //Resource Name: define name of resource for which we describe policy 
//         //Policy Name: Name of policy which is created for resource
//         //Summary: give a summary about incident
//         //Condition Name: name of the condition define in policy
//         bodycontain = "Resource Name:" + req.body.incident.resource_name;
//         bodycontain += "\n Policy Name:" + req.body.incident.policy_name;
//         bodycontain += "\n Condition Name:" + req.body.incident.condition_name;
//         bodycontain += "\n Summary:" + req.body.incident.summary;
//         bodycontain += "\n Logs:" + JSON.stringify(req.body.incident);
//         body.ticket.tags.push(req.body.incident.policy_name);
//         body.ticket.tags.push("new_customer");
//     }
//     // from pub/sub
//    if (req.body.hasOwnProperty('message')) {

//         var data = req.body.message.data;
//         // data = Base64.decode(data);
//         console.log(data)
//         var parsedData = data;
//         body.ticket.tags.push(parsedData.resource.type);
//         // to check if it is container
//         if (parsedData.resource.type === 'container') {
//             var logname = parsedData.resource.labels.container_name; // to diffrentiate betweenn forntend and backend
//             var severity = parsedData.severity;
//             //console.log(parsedData.resource.labels.container_name)
//             if (logname === "iface-crm-api") {
//                 body.ticket.tags.push("api_developer");
//             }
//             if (logname === "iface-crm-app") {
//                 body.ticket.tags.push("designing_issue");
//             }
//             if (logname !== undefined && logname !== "") {
//                 body.ticket.tags.push(logname);
//             }

//             if (severity !== undefined && severity !== "") {
//                 body.ticket.tags.push(severity);
//             }
//             bodycontain = "\n TextPayload:" + parsedData.textPayload + "\n TimeOfRequest:" + parsedData.timestamp;
//             if (logname === "default-http-backend" || logname === "nginx-ingress-controller") {
//                 body.ticket.tags.push("new_customer");
//                 //Container Name: name of the container
//                 //Namespace define in which namespace pod is
//                 //Cluster name: name of the cluster
//                 //Pod Name: name of the pod
//                 //Zone: define on which zone it is
//                 //Project name: name of project
//                 //Resource Type: type of resource it is like k8s_cluster
//                 //Severity: define how critical it is  
//                 bodycontain += "Cluster Name:" + parsedData.resource.labels.cluster_name;
//                 bodycontain += "\n Project Name:" + parsedData.resource.labels.project_id;
//                 bodycontain += "\n Conatainer Name:" + parsedData.resource.labels.container_name;
//                 bodycontain += "\n NameSpace:" + parsedData.resource.labels.namespace_id;
//                 bodycontain += "\n Pod Name:" + parsedData.resource.labels.pod_id;
//                 bodycontain += "\n Zone:" + parsedData.resource.labels.zone;
//                 bodycontain += "\n Resource Type:" + parsedData.resource.type;
//                 bodycontain += "\n severity:" + parsedData.severity;
//                 bodycontain += "\n Logs:" + JSON.stringify(parsedData);
//             }
//             //console.log(bodycontain)
//         }
//         else if (parsedData.resource.type === 'http_load_balancer') {
//             //Resource Type: type of resource it is like k8s_cluster
//             //Severity: define how critical it is 
//             //TimeofRequest : time stamp 
//             //Remote IP: ip of the user
//             //Request Method: method used for request like POST,GET,PUT 
//             //Request URL: which url client hit
//             //Status: status code like 200,404
//             //userAgent: From which browser client hit the url
//             bodycontain = "Remote IP:" + parsedData.httpRequest.remoteIp;
//             bodycontain += "\n Request Method:" + parsedData.httpRequest.requestMethod;
//             bodycontain += "\n Request Url:" + parsedData.httpRequest.requestUrl;
//             bodycontain += "\n Status:" + parsedData.httpRequest.status;
//             bodycontain += "\n userAgent:" + parsedData.httpRequest.userAgent;
//             bodycontain += "\n Resource Type" + parsedData.resource.type;
//             bodycontain += "\n Severity:" + parsedData.severity;
//             bodycontain += "\n TimeOfRequest:" + parsedData.timestamp;
//             bodycontain += "\n Logs:" + JSON.stringify(parsedData);
//             body.ticket.tags.push("new_customer");
//             var severity = parsedData.severity;
//             if (severity !== undefined && severity !== "") {
//                 body.ticket.tags.push(severity);
//             }
//         }

//         else if (parsedData.resource.type === 'gce_instance') {
//             if(parsedData.severity === 'NOTICE')
//             var instance_name = parsedData.protoPayload.resourceName.split("/");
//             console.log(instance_name)
//             //Resource Type: type of resource it is like k8s_cluster
//             //Severity: define how critical it is 
//             //TimeofRequest : time stamp 
//             //PrincipalEmail: who perform this action
//             //Instance_name: name of instance create or delete
//             //Operation Type: type of operation perform on instance (delete or create)
//             bodycontain = "PrincipalEmail:" + parsedData.protoPayload.authenticationInfo.principalEmail;
//             bodycontain += "\n Instance_name:" + instance_name[instance_name.length - 1];
//             bodycontain += "\n Operation Type:" + parsedData.protoPayload.response.operationType;
//             bodycontain += "\n Severity:" + parsedData.severity;
//             bodycontain += "\n TimeOfRequest:" + parsedData.timestamp;
//             bodycontain += "\n Resource Type:" + parsedData.resource.type;
//             bodycontain += "\nLogs:" + JSON.stringify(parsedData);
//             body.ticket.tags.push(parsedData.protoPayload.response.operationType);
//             body.ticket.tags.push("new_customer");
//           
            
//         }

//         else if (parsedData.resource.type === 'k8s_cluster') {
//             var operation = parsedData.protoPayload.methodName.split(".");
//             var k8s_resource = parsedData.protoPayload.resourceName.split("/")
//             console.log(operation)
//             //here we extract important information from log string about cluster 
//             //like cluster version which shows current version of cluster
//             //Method Name is the type of operation perform on pod (delete or create)
//             //Namespace define in which namespace pod is
//             //Image: what image is use for deployment
//             //Deployment name: name of the deployment from which pod is create
//             //Container Port: on which port container is running
//             //Node name: on which node pod is running
//             //Cluster name: name of the cluster
//             //Location: define on which zone it is
//             //Project ID: id of project
//             //Resource Type: type of resource it is like k8s_cluster
//             //Severity: define how critical it is 
//             //TimeofRequest : time stamp 
//             bodycontain = "Cluster version:" + parsedData.labels.cluster_version;
//             bodycontain += "\n Method Name:" + operation[operation.length - 1];
//             bodycontain += "\n Resource Name:" + k8s_resource[k8s_resource.length - 1];
//             bodycontain += "\n NameSpace:" + parsedData.protoPayload.response.metadata.namespace;
//             bodycontain += "\n Image:" + parsedData.protoPayload.response.spec.containers[0].image;
//             bodycontain += "\n Deployment Name:" + parsedData.protoPayload.response.spec.containers[0].name;
//             bodycontain += "\n Container Port:" + parsedData.protoPayload.response.spec.containers[0].ports[0].containerPort;
//             bodycontain += "\n Protocol:" + parsedData.protoPayload.response.spec.containers[0].ports[0].protocol;
//             bodycontain += "\n Node Name:" + parsedData.protoPayload.resource.spec.containers[0].nodeName;
//             bodycontain += "\n Cluster Name:" + parsedData.resource.labels.cluster_name;
//             bodycontain += "\n Location:" + parsedData.resource.labels.location;
//             bodycontain += "\n Project ID:" + parsedData.resource.labels.project_id;
//             bodycontain += "\n Resource Type:" + parsedData.resource.type;
//             bodycontain += "\n Severity:" + parsedData.severity;
//             bodycontain += "\n TimeOfRequest:" + parsedData.timestamp;
//             bodycontain += "\n Logs" + JSON.stringify(parsedData);
//             body.ticket.tags.push("new_customer");
//             body.ticket.tags.push(operation[operation.length - 1]);
//             var severity = parsedData.severity;
//             if (severity !== undefined && severity !== "") {
//                 body.ticket.tags.push(severity);
//             }

//             //console.log(parsedData.severity)
//         }
//         else{
//             console.log("No case matched");
//         }
//     }
//     if (bodycontain !== undefined) {
//         body.ticket.comment.body = bodycontain;
//     }

//     // making request to create ticket

    var query = 'Basic ' + Base64.encode('admin@iface.io/token:5N0ZgsqojqpIY3FF3m9pvL4OQQa6UgMeHb18taO4');

     body = JSON.stringify(body);

//    ticket creation
    request({
        url: 'https://support.iface.io/api/v2/tickets.json',
        method: "POST",
        headers: { "Content-Type": "application/json", "Authorization": query },
        body: body
    }, function (error, response, body) {
        //console.log(response)
        console.log(body)
        if (error) {
            console.log(error)
        }
        else if (response.statusCode === 201) {
            res.sendStatus(200);
            console.log()
        }
        else {
            console.log(respose.statusCode)
        }

    })

 })

app.get("/delete-multiple-tickets", (req, res) => {
    // var startIndex = req.body.start;
    // var lastIndex = req.body.last;

    var query = 'Basic ' + Base64.encode('admin@iface.io/token:5N0ZgsqojqpIY3FF3m9pvL4OQQa6UgMeHb18taO4')
    for (var i = 194213 ; i < 195395; i += 100) {
        var url = 'https://support.iface.io/api/v2/tickets/destroy_many.json?ids='
        var str = "";
        for (var j = i; j < i + 100 || j === 195395; j++) {
            str += j + ",";
        }
        url += str;
        console.log(url);
        request({
            url: url,
            method: "DELETE",
            headers: { "Content-Type": "application/json", "Authorization": query }
        }, function (error, response, body) {
            if (error) {
                console.log(error)
            }
            console.log(body)

        })
    }
})
app.get("/delete-permanently-tickets", (req, res) => {
    // var startIndex = req.body.start;
    // var lastIndex = req.body.last;

    var query = 'Basic ' + Base64.encode('admin@iface.io/token:5N0ZgsqojqpIY3FF3m9pvL4OQQa6UgMeHb18taO4')
    for (var i = 193411 ; i < 193460; i += 100) {
        var url = 'https://support.iface.io/api/v2/deleted_tickets/destroy_many?ids='
        var str = "";
        for (var j = i; j < i + 100 || j === 193460; j++) {
            str += j + ",";
        }
        url += str;
        console.log(url);
        request({
            url: url,
            method: "DELETE",
            headers: { "Content-Type": "application/json", "Authorization": query }
        }, function (error, response, body) {
            if (error) {
                console.log(error)
            }
            console.log(body)

        })
    }
})

//server
 const server = app.listen(port_no, function() {
     console.log("APP Server has been started! Running on port " + server.address().port);
 });

// https.createServer(options,app).listen(port_no);
//var listener = https.createServer(options, app).listen(port_no, function () {
//    console.log('Express HTTPS server listening on port ' + listener.address().port);
//});
// var io = require('socket.io').listen(server);

// io.on('connection' , ()=>{
// //console.log("connected")
// })

