# grunt-xonom
Script generator between angularjs and expressjs 

##EXAMPLE

###Structure

```sh
app/
 components/
  user/
   user.controller.client.js
   user.api.server.js
   user.jade
```

###User.api.server.js

You declare export functions with last callback argument

```Javascript 
module.exports = function($db) {
   all : function(callback) {
         // `user` collection is declared in config.json
         $db.user.find({}, { name: 1, _id: 1, connections: 1 }, function( err, users)  {
              callback(users);
         });
   },
   one: function(id, callback) {
        $db.user.findOne({ _id: id }, function( err, user ) {
              callback(user);
        });
   }
};
```

###User.controller.client.js

And use them on client side. Xonom generates middleware for you


```Javascript
angular.module("yourApp", ["xonom"]);
```


```Javascript 

app.controller("user", function($scope, $xonom) {
  //`user` extracted from filename
  $xonom.user.all(function(err, users)) {
    $scope.users = users;
  };
  
  $scope.getDetails = function(id) {
     $xonom.user.one(id, function(err, details) { 
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
* npm install xonom grunt-xonom
* add grunt task grunt-xonom into your gruntfile.js

```Javascript
grunt.initConfig({
  xonom: {
      options: {
        input: {
          controllers: [ 'user.controller.server.js' ]
        },
        output: {
           angularService: "xonom.service.js"
           /*,makeService: function() { ... } */
           ,expressRoute: "xonom.route.js"
           /*,makeRoute: function() { ... } */
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
var xonom = 
  require("xonom");

var router = express();
xonom.object("$router", router);
xonom.require("./xonom.route.js")
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
