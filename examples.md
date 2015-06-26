p API looks like simple javascript function declaration on server-side 
and function invoke on client-side. Last argument must be callback function

#EXAMPLES

#send and obtain simple string from the server
```Javascript
//test.controller.server.js
module.exports = {
    apiFunction: function(str, callback) {
        callback("response: " + str);
    }
};
//test.angular-controller.client.js
app.controller("someController", function(xonom) {
     
     xonom.test.apiFunction("test", function(err, result) {
        console.log(result) //=> "response: test"
     });
});
```

#send json to the server
```Javascript
//test.controller.server.js
module.exports = {
    apiFunction: function(json, callback) {
        console.log(json); //=> {  test: 1 }
        callback('send string back to the client');
    }
};
//test.angular-controller.client.js
app.controller("someController", function(xonom) {
     var json = {
        test: 1
     };
     
     xonom.test.apiFunction(json, function(err, result) {
        console.log(result) //=> 'send string back to the client'
     });
});
```

#obtain json from the server
```Javascript
//test.controller.server.js
module.exports = {
    apiFunction: function(callback) {
        var json = {
           test: 1
        };
        
        callback(json);
    }
};
//test.angular-controller.client.js
app.controller("someController", function(xonom) {
     var json = {
        test: 1
     };
     
     xonom.test.apiFunction(function(err, result) {
        console.log(result) //=> {  test: 1 }
     });
});
```

