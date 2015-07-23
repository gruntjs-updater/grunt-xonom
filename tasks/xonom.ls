module.exports = (grunt)->
  grunt.register-task do 
      * \xonom
      * 'Generate api service and route for express'
      * ->
            const input = @options!.input
            const output = @options!.output
            const make-service = @options!.make-service ? (name)->
                !->
                    const args = [].slice.call(arguments)
                    const callback = args.pop!
                    $http
                      .post name, args 
                      .success (data)-> callback null, data.result
                      .error (err)-> callback err
            const make-route = @options!.make-route ? (func) ->
                (req, resp) !->
                    req.body.push (result)->
                      resp.send do 
                          result: result
                    func.apply this, req.body
            
            #input: server controllers filenames array
            #output: generated angular service 'api'
            const fs = require \fs
            const map = (f, xs) -->
              [f x for x in xs]
            const make-obj = -> "{#it}"
        
            const join = (d, arr) -->
               arr.join d
            const make-angular-service = (content)->
                "angular.module('xonom', []).service('$xonom', function($http) {
                    \r\n var make = #{make-service.to-string!};
                   \r\n return #content 
                \r\n});"
            const get-methods = (str)->
                        const module = {}
                        const require = -> ->
                        const obj = eval str, module, require
                        const res = []
                        const exports = module.exports!
                        for m of exports
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
                   filename.match(/([a-z-]+)\.api/i)?1
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
            const path = require \path
            const map-route = (filename) ->
                const module = 
                   filename.match(/([a-z-]+)\.api/i).1
                const camel = 
                    camelize module
                const abs = path.resolve filename
                const wrap-controller = (content)->
                    " var #camel = $xonom.require('#abs');\r\n
                      
                      #content
                    "
                const apply-route = (name)->
                   " $router.post('/#module/#name', make(#camel.#name));
                   "
                
                filename |> get-methods-from-file
                         |> map apply-route
                         |> join \\r\n
                         |> wrap-controller
                
            const apply-template = (content)->
              "module.exports = function($router, $xonom) {\r\n
                     var make = #{make-route.to-string!};\r\n
                     #content \r\n
                  }
              " 
            
            input.controllers |> map map-route
                              |> join \\r\n
                              |> apply-template
                              |> fs.write-file-sync output.express-route, _