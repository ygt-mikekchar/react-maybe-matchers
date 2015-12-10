# ComponentQuery

When we first start out, we are likely to have only a single
component.  This monad is used for querying that component
and getting a list of nodes that we will filter later.
 
## Example

```
componentQuery.contains
              .tags("div")
              .result()
```

This will take a component in the componentFilter
and generate a ComponentFilter with the DOM nodes
that have the tag "div".  In this particular example,
it will return a matching result if there are any
such nodes.

## Requirements

The [JasmineMonad](./JasmineMonad.litcoffee)is a "maybe" monad that
allows us to chain our matcher functions in a fluent way.

    JasmineMonad = require("./JasmineMonad.litcoffee")

The [ComponentFilter](./ComponentFilter.litcoffee) is a JasmineMonad
that allows you to filter and match collections of React components.

    ComponentFilter = require("./ComponentFilter.litcoffee")

## A monad for making queries of single Components

    class ComponentQuery extends JasmineMonad

      constructor: (@reactUtils, @value, @util, @testers, @messages) ->
        super(@value, @util, @testers, @messages)

#### English Helpers

It is nice to have use this word to make the expectation read more easily.

        @contains = this

#### Unit method for ComponentFilter

Most of the methods on `ComponentQuery` will actually want to
return a ComponentFilter so the user can filter the collection of returned 
nodes.  If we were using a language with strong typing the compiler
would be able to construct the correct the correct Monad based
on the types.  However, we are using Coffeescript, so we have to
give it a helping hand by making a different `return` method.

      returnMany: (nodes, messages) ->
        new ComponentFilter(nodes, @util, @testers, messages)

#### Testing for DOM tags

One of the most common kinds of tests is to determine whether or not
a component contains a DOM "tag" (eg "h1", "div", etc). This matcher
passes if there is at least one.


      tags: (tag) ->
        @bind (component) =>
          nodes = @reactUtils.scryRenderedDOMComponentsWithTag(component, tag)
          messages = [
            "Expected to find DOM tag #{tag}, but it was not there."
            "Expected not to find DOM tag #{tag}, but there #{@was(nodes.length)}."
          ]
          if nodes.length > 0
            @returnMany(nodes, messages)
          else
            @return(null, messages)

Export our matchers from this file.

    module.exports = ComponentQuery
