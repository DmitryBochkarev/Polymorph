# Polymorph

__Polymorph__ library for compile client dev files on fly, inspired by [connect-assets](http://github.com/TrevorBurnham/connect-assets).

## Example

`server.coffee`

``` coffeescript
express = require 'express'
app = express.createServer()

{Polymorph, compilers} = require 'polymorph'

polymorph = new Polymorph {
  path: "#{__dirname}/assets"
}

polymorph.form '.html', '.jade', compilers.jade
polymorph.form '.js', '.coffee', compilers.coffee
# Uncomment next line for test compressed version of scripts
# polymorph.form '.js', compilers.uglify

app.use polymorph.middleware()

app.listen 3000
```

`assets/index.jade`

``` jade
!!! 5
html
  head
  body
    h1 Jade template!
```

`assets/hello.coffee`

``` coffeescript
class Hello
  constructor: () ->
    alert 'CoffeeScript'

new Hello
```

Run server `coffee server.coffee`.

Then open `http://localhost:3000/index.html` in you browser.

## Features

- Useful for development under frameworks with dynamic class loading ([Ext](http://www.sencha.com/products/extjs/), [Batmanjs](http://batmanjs.org/))
- Recompile only if content changed, but never sent 304 response

## TODO

- Refactoring sources now it is ugly
- May be to realize able to respond 304?

## License

Copyright (c) 2011 Dmitry Bochkarev ([github](http://github.com/dmitrybochkarev))

MIT license

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.