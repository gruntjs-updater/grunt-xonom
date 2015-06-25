# grunt-xonom
Script generator between angularjs and expressjs 

#usage


```Javascript
//server side declaration of user.controller.server.js

module.exports = {
 
   getTwits: function(userId, callback) {
     callback([userId + 2])
   }


};

```

```Javascript
//client side usage
app.controller("userController", function(xonom) {
  
  var userId = 1;
  xonom.user.getTwits(userId, function(data) {
     console.log(data);
     #prints 3
  });
})
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
           angular-service: "xonom.service.js",
           express-route: "xonom.route.js"
  }
 }
})
```
This task will generate 2 files xonom.service.js, xonom.route.js

* add line into your server.js file in order to attach xonom.route.js into your express

```Javascript
var express = 
  require("express");

var router = express();
  
require("./xonom.route.js")(router);
```

* add line into your angular.js module declaration file

```Javascript
angular.module("yourApp", ["xonom"]);
```
