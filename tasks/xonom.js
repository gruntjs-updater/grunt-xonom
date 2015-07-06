// Generated by LiveScript 1.3.1
(function(){
  module.exports = function(grunt){
    return grunt.registerTask('xonom', 'Generate api service and route for express', function(){
      var input, output, fs, map, makeObj, join, makeAngularService, getMethods, getMethodsFromFile, camelize, generateObj, mapRoute, applyTemplate;
      input = this.options().input;
      output = this.options().output;
      fs = require('fs');
      map = curry$(function(f, xs){
        var i$, len$, x, results$ = [];
        for (i$ = 0, len$ = xs.length; i$ < len$; ++i$) {
          x = xs[i$];
          results$.push(f(x));
        }
        return results$;
      });
      makeObj = function(it){
        return "{" + it + "}";
      };
      join = curry$(function(d, arr){
        return arr.join(d);
      });
      makeAngularService = function(content){
        return "angular.module('xonom', []).service('xonom', function($http) {\r\n var make = function(name) {\r\n  return function() {\r\n   var args = [].slice.call(arguments);\r\n   var callback = args.pop();\r\n   $http.post(name, args).success(function(data) { callback(null, data.result)  }).error(function(err) { callback(err) });\r\n }\r\n};\r\n return " + content + " \r\n});";
      };
      getMethods = function(str){
        var module, require, obj, res, m;
        module = {
          exports: {}
        };
        require = function(){
          return {};
        };
        obj = eval(str, module, require);
        res = [];
        for (m in module.exports) {
          if (typeof obj[m] === 'function') {
            res.push(m);
          }
        }
        return res;
      };
      getMethodsFromFile = compose$(fs.readFileSync, function(it){
        return it.toString('utf-8');
      }, getMethods);
      camelize = function(str){
        var cp;
        cp = function(m, c){
          if (c) {
            return c.toUpperCase();
          } else {
            return "";
          }
        };
        return str.replace(/[-_\s]+(.)?/g, cp);
      };
      generateObj = function(filename){
        var module, wrap, camel, makeNamedObj, generateObject;
        module = filename.match(/([a-z-]+)\.xonom\.server\.js$/i)[1];
        wrap = function(it){
          return "(" + it + ")";
        };
        camel = camelize(module);
        makeNamedObj = function(content){
          return "\r\n   " + camel + " : " + content;
        };
        generateObject = function(name){
          return "\r\n     " + name + " : make('" + module + "/" + name + "')";
        };
        return makeNamedObj(
        makeObj(
        join(',')(
        map(generateObject)(
        getMethodsFromFile(
        filename)))));
      };
      fs.writeFileSync(output.angularService, makeAngularService(
      makeObj(
      join(',')(
      map(generateObj)(
      input.controllers)))));
      mapRoute = function(filename){
        var module, camel, wrapController, applyRoute;
        module = filename.match(/([a-z-]+)\.controller\.server\.js$/i)[1];
        camel = camelize(module);
        wrapController = function(content){
          return " var " + camel + " = require( __dirname + '/" + filename + "');\r\n" + content + "";
        };
        applyRoute = function(name){
          return " router.post('/" + module + "/" + name + "', function(req, resp) {\r\n var callback = function (result) {resp.send({result: result});\r\n};req.body.push(callback);\r\n" + camel + "." + name + ".apply(this, req.body);});";
        };
        return wrapController(
        join('\r\n')(
        map(applyRoute)(
        getMethodsFromFile(
        filename))));
      };
      applyTemplate = function(content){
        return "module.exports = function(router) {\r\n" + content + " \r\n}";
      };
      return fs.writeFileSync(output.expressRoute, applyTemplate(
      join('\r\n')(
      map(mapRoute)(
      input.controllers))));
    });
  };
  function curry$(f, bound){
    var context,
    _curry = function(args) {
      return f.length > 1 ? function(){
        var params = args ? args.concat() : [];
        context = bound ? context || this : this;
        return params.push.apply(params, arguments) <
            f.length && arguments.length ?
          _curry.call(context, params) : f.apply(context, params);
      } : f;
    };
    return _curry();
  }
  function compose$() {
    var functions = arguments;
    return function() {
      var i, result;
      result = functions[0].apply(this, arguments);
      for (i = 1; i < functions.length; ++i) {
        result = functions[i](result);
      }
      return result;
    };
  }
}).call(this);
