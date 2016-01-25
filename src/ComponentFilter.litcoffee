# ComponentFilter

This class filters collections of React components, often for
the purpose of finding a DOM node with a specific CSS
class, or ID.

## Example

```
componentFilter.with.cssClass("my-class")
               .exactly(2).times
               .result()
```

This will take the list of nodes in componentFilter,
filter them by cssClass and return a matching result
if there are exactly 2 of them.

## Requirements

The [JasmineMonad](./JasmineMonad.litcoffee#a-monad-for-jasmine-tests) is a "maybe" monad that
allows us to chain our matcher functions in a fluent way.

    JasmineMonad = require("./JasmineMonad.litcoffee")

### A monad for filtering collections of React components

    class ComponentFilter extends JasmineMonad

      constructor: (@value, @util, @testers, @messages) ->
        super(@value, @util, @testers, @messages)

#### English helpers

Because this monad deals with filtering lists of components
it is nice to have a couple of dummy properties that
allow us to use a more fluent English expression.
`@with`, `@and` and `time` can be used for that purpose.

        @with = this
        @and = this
        @time = this
        @times = this

#### Filtering nodes by CSS class

      # TODO: Is this necessary?  Does anyone add className
      # to a component?  What does it mean?
      cssClass: (cssClass) ->
        @bind (nodes) =>
          match = (a, b) ->
            return false if !b?
            b.indexOf(a) != -1

          if nodes?.length
            matched = (node for node in nodes when match(cssClass, node.props.className))
          else
            matched = []

          messages = [
            "Expected to find component with className #{cssClass}, but it was not there."
            "Expected not to find component with className #{cssClass}, but there #{@was(matched.length)}."
          ]

          if matched.length > 0
            @return(matched, messages)
          else
            @return(null, messages)

#### Enforcing the number of nodes

      exactly: (num) ->
        @bind (nodes) =>
          messages = [
            "Expected to find exactly #{@count(num, 'node')}, but there #{@was(nodes.length)}"
            "Expected not find #{@count(num, 'node')}, but there #{@was(nodes.length)}."
          ]

          if nodes.length == num
            @return(nodes, messages)
          else
            @return(null, messages)

### Allow a debug message to be outputted

Sometimes when debugging you want to be able to take a look at the
nodes and output some stuff to the console.  If you pass a
a function which returns a string to the `debug` method, it will
fail the test and print that string.

      debug: (callback) ->
        @bind (nodes) =>
          output = callback(nodes)
          messages = [
            output
            output
          ]
          @return(null, messages)

Export our matchers from this file.

    module.exports = ComponentFilter
