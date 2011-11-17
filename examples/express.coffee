express = require 'express'
app = express.createServer()

{Polymorph, compilers} = require '../index'

polymorph = new Polymorph {
  path: "#{__dirname}/assets"
}

polymorph.form '.js', '.coffee', compilers.coffee
polymorph.form '.js', compilers.uglify
polymorph.form '.html', '.jade', compilers.jade
polymorph.form '.css', '.styl', compilers.stylus

app.use polymorph.middleware()

app.listen 3000
