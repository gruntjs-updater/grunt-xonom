# grunt-xonom
Script generator between angularjs and expressjs 

#usage

```Javascript
//server side declaration of some.controller.server.js

module.exports = {
   increaseNumber: function(inputNumber, callback) {
     callback(inputNumber + 1)
   }
};

```

```Javascript
//client side usage
app.controller("someController", function(xonom) {
  
  var inputNumber = 1;
  //"some" was extracted from some.controller.server.js
  xonom.some.increaseNumber(inputNumber, function(outputNumber) {
     console.log(outputNumber);  //=> 2
  });
})
```
[More examples](https://github.com/askucher/grunt-xonom/blob/master/examples.md:)

#install
* npm install grunt-xonom
* add grunt task grunt-xonom into your gruntfile.js

```Javascript
grunt.initConfig({
  xonom: {
      options: {
        input: {
          controllers: [ 'some.controller.server.js' ]
        },
        output: {
           angular-service: "xonom.service.js",
           express-route: "xonom.route.js"
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
