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

The [JasmineMonad](./JasmineMonad.litcoffee) is a "maybe" monad that
allows us to chain our matcher functions in a fluent way.

    JasmineMonad = require("./JasmineMonad.litcoffee")

The matchers need to pluralize strings, so we need to load
[a string pluralizer method](pluralize.litcoffee)

    require("./pluralize.litcoffee")

### A monad for filtering collections of React components

    class ComponentFilter extends JasmineMonad

Because this monad deals with filtering lists of components
it is nice to have a couple of dummy properties that
allow us to use a more fluent English expression.
`@with`, `@and` and `time` can be used for that purpose.

      constructor: (@value, @util, @testers, @messages) ->
        super(@value, @util, @testers, @messages)
        @with = this
        @and = this
        @time = this
        @times = this

#### Filtering nodes by CSS class

As this is the first monadic function we have seen, I will describe it
in a bit more detail.  Notice that the first line is a call to `@bind`.
You pass it a callback which accepts a list of components.  `@bind` will run
the function and pass `@value` in as the `component`.  You might be
wondering, "why dont we just use @value directly -- it is available
to us".  The reason we dont is because `@bind` is implementing our
Maybe functionality.  If we neglect to call it, we will lose that
functionality.  Although it is tempting to go around the structure
of the monad and treat it as any other object, it is better to follow
the interface.

Secondly, you will notice that we call `@return` at the end.  This
builds a new Monad, wrapping the new component list and messages.  Note that
we return `null` in the case that our matcher fails.  This will stop
all subsequently chained matchers from running.

Be careful to only have one exit point in your monadic functions.
Otherwise you will have silly looking code that looks like:
`return @return(component, messages)`.

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
            "Expected to find DOM node with class #{cssClass}, but it was not there."
            "Expected not to find DOM node with class #{cssClass}, but there #{@was(matched.length)}."
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

Export our matchers from this file.

    module.exports = ComponentFilter
