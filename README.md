# grunt-xonom
Script generator between angularjs and expressjs 

##EXAMPLE

###Structure

```sh
app/
 components/
  user/
   user.controller.client.js
   user.controller.server.js
   user.jade
```

###User.controller.server.js

You declare export functions with last callback argument

```Javascript 
var db = require('./your-server-db.js');
module.exports = {
   all : function(callback) {
         // `user` collection is declared in config.json
         db.user.find({}, { name: 1, _id: 1, connections: 1 }, function( err, users)  {
              callback(users);
         });
   },
   one: function(id, callback) {
        db.user.findOne({ _id: id }, function( err, user ) {
              callback(user);
        });
   }
};
```

###User.controller.client.js

And use them on client side. Xonom generates middleware for you

```Javascript 

app.controller("user", function($scope, xonom) {
  //`user` extracted from filename
  xonom.user.all(function(err, users)) {
    $scope.users = users;
  };
  
  $scope.getDetails = function(id) {
     xonom.user.one(id, function(err, details) { 
        $scope.details = details;
     };
  };
});

```

###User.jade

```Jade 
.user.component(ng:controller="user")
 .details(ng:if="details")
  h3 details.name
  p Connections: {{details.connections.length}}
  p Events: {{details.events.length}}
 .users
   .user(ng:repeat="user in users" ng:click="getDetails(user._id)")
      h3 {{user.name}}
      p Connections: {{user.connections.length}}
```





#install
* npm install grunt-xonom
* add grunt task grunt-xonom into your gruntfile.js

```Javascript
grunt.initConfig({
  xonom: {
      options: {
        input: {
          controllers: [ 'user.controller.server.js' ]
        },
        output: {
           angular-service: "xonom.service.js"
           ,express-route: "xonom.route.js"
           /*makeSercice: function() { ... } */
           /*makeRoute: function() { ... } */
  }
 }
});

grunt.registerTask("grunt-xonom");
```
This task generates 2 files xonom.service.js, xonom.route.js based on input controllers

xonom.service.js contains angular service declaration with generated functions for communication with server
xonom.route.js contains express routes for communication with client

* add line into your server.js file in order to attach xonom.route.js into your express

```Javascript
var express = 
  require("express");

var router = express();
  
require("./xonom.route.js")(router);
```

* add line into your angular.js module declaration file

```Html
<head>
  ...
  <script type="text/javascript" src="angular.js" />
  <script type="text/javascript" src="xonom.service.js" />
  ...
</head>
```

```Javascript
angular.module("yourApp", ["xonom"]);
angular.controller("userController", function(xonom) {

 //use xonom inside controller

}
```
