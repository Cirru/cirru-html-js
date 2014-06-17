
Cirru HTML .js
------

Compile Cirru HTML into JavaScript template function.

### Usage

This project is related to Cirru HTML which compiles Cirru to HTML.
This project compiles it to JavaScript instead.

They are sharing similar syntaxes on writing HTML.

Syntax:

* Jade-like(CSS Selectors) syntax for tags(with `class` and `id`)
* `(:a b)` syntax for `a="b"`
* tokens start with `@` are controllers
* `(= a)` to render `a` as text
* `(== a)` to render `a` as html

... and grammars inherited from Cirru Grammar.

Controllers:

* `(@ a)` to get a from resource
* `(@if cond a b)` for conditions, `b` is optional
* `(@unless cond a b)` for conditions, `b` is optional
* `(@rich a b)` to use `a.length>0` as condition
* `(@each xs a)` for rendering `a` in list `xs`
* `(@call a b c)` for running `a(a,b)`
* `(@block a b c)` wrap `a b c` in a block

```
npm i --save-dev cirru-html-js
```
For such a demo, it compiles to:
```coffee
{render} = require 'cirru-html-js'
render '@if (@ a) (div b)'
```
```js
(function(resource, call){
  var html;
  if(resource['a']){html+='<div>b</div>';}
  return html;
})
```
...where `resource` is data passed to render.
`call` is an object of methods that maybe useful in template.

### Tests

```
cd tests
coffee make.coffee test-compile # run performance tests on compiling
coffee make.coffee compile # just compile code
coffee make.coffee test-run # run performance tests on templating
```

Comparing to doT, Cirru HTML.js takes about 3 times of time to compile and run.

### ChangeLog

* `0.0.8`

  * Add error messages and tests

* `0.0.7`

  * Add `@block`

* `0.0.5`

  * Fix condition syntax is `@unless`

* `0.0.4`

  * More flexible attribute values

### License

MIT