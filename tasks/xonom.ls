module.exports = (grunt)->
  grunt.register-task do 
      * \xonom
      * 'Generate api service and route for express'
      * ->
            const input = @options!.input
            const output = @options!.output
            
            #input: server controllers filenames array
            #output: generated angular service 'api'
            const fs = require \fs
            const map = (f, xs) -->
              [f x for x in xs]
            const make-obj = -> "{#it}"
        
            const join = (d, arr) -->
               arr.join d
            const make-angular-service = (content)->
                "angular.module('xonom', []).service('xonom', function($http) {
                    \r\n var make = function(name) {
                      \r\n  return function() {
                        \r\n   var args = [].slice.call(arguments);
                        \r\n   var callback = args.pop();
                        \r\n   $http.post(name, 
                                   args)
                             .success(function(data) { callback(null, data.result)  })
                             .error(function(err) { callback(err) });
                     \r\n }
                   \r\n};
                   \r\n return #content 
                \r\n});"
            const get-methods = (str)->
                        const module = 
                             exports : {}
                        const require = -> {}
                        const obj = eval str, module, require
                        const res = []
                        for m of module.exports
                          if typeof obj[m] is \function
                            res.push m
                        res
            const get-methods-from-file = fs.read-file-sync >> (.to-string(\utf-8)) >> get-methods
            const camelize = (str)->
                  const cp = (m , c)->
                    if c then c.to-upper-case! else ""
                  str.replace /[-_\s]+(.)?/g , cp
            const generate-obj = (filename) ->
                
                
                const module = 
                   filename.match(/([a-z-]+)\.xonom/i)?1
                #console.log filename, module
                
                const wrap = -> "(#it)"
                
                
                
                const camel = 
                    camelize module
                    
                const make-named-obj = (content)->
                    "\r\n   #camel : #content"
                const generate-object = (name)->
                  "
                     \r\n     #name : make('#module/#name')
                  "
                
                filename |> get-methods-from-file
                         |> map generate-object
                         |> join \,
                         |> make-obj
                         |> make-named-obj
            input.controllers |> map generate-obj
                              |> join \,
                              |> make-obj
                              |> make-angular-service
                              |> fs.write-file-sync output.angular-service, _
            const map-route = (filename) ->
                const module = 
                   filename.match(/([a-z-]+)\.xonom/i).1
                const camel = 
                    camelize module
                const wrap-controller = (content)->
                    " var #camel = require( __dirname + '/#filename');\r\n
                      
                      #content
                    "
                const apply-route = (name)->
                   " router.post('/#module/#name', make(#camel.#name));
                   "
                
                filename |> get-methods-from-file
                         |> map apply-route
                         |> join \\r\n
                         |> wrap-controller
                
            const apply-template = (content)->
              
              const make = (func) !->
                      (req, resp) !->
                          const callback = (result)->
                              resp.send do 
                                  result: result
                              req.body.push callback
                              func.apply this, req.body
              "module.exports = function(router) {
                     var make = #{make.to-string!}
                     #content \r\n
                  }
              " 
            
            input.controllers |> map map-route
                              |> join \\r\n
                              |> apply-template
                              |> fs.write-file-sync output.express-route, _