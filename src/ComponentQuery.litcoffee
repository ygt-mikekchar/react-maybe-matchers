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

The [JasmineMonad](./JasmineMonad.litcoffee) is a "maybe" monad that
allows us to chain our matcher functions in a fluent way.

    JasmineMonad = require("./JasmineMonad.litcoffee")

The [ComponentFilter](./ComponentFilter.litcoffee) is a JasmineMonad
that allows you to filter and match collections of React components.

    ComponentFilter = require("./ComponentFilter.litcoffee")

The [DomComponentFilter](./DomComponentFilter.litcoffee) is a JasmineMonad
that allows you to filter and match collections of DOM components.

    DomComponentFilter = require("./DomComponentFilter.litcoffee")

## A monad for making queries of single Components

    class ComponentQuery extends JasmineMonad

      constructor: (@reactUtils, @value, @util, @testers, @messages) ->
        super(@value, @util, @testers, @messages)

#### English Helpers

It is nice to have use this word to make the expectation read more easily.

        @contains = this

#### Unit method for ComponentQuery

Most of the methods on `ComponentQuery` will actually want to
return a ComponentFilter so the user can filter the collection of returned 
nodes.  If we were using a language with strong typing the compiler
would be able to construct the correct the correct Monad based
on the types.  However, we are using Coffeescript, so we have to
give it a helping hand by making a different `return` method.

      return: (nodes, messages) ->
        new ComponentFilter(nodes, @util, @testers, messages)

In the past DOM nodes in the React tree were treated similarly to
React components.  This will change in 0.15, so we need to make
sure to create the correct filter object.

      returnDom: (nodes, messages) ->
        new DomComponentFilter(nodes, @util, @testers, messages)

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
            @returnDom(nodes, messages)
          else
            @returnDom(null, messages)

#### Testing directly for DOM with class

Sometimes you don't care what kind of tag the DOM nodes have.  You just
want ensure that there is *something* with the required class.

      cssClass: (cssClass) ->
        @bind (component) =>
          nodes = @reactUtils.scryRenderedDOMComponentsWithClass(component, cssClass)
          messages = [
            "Expected to find DOM node with class #{cssClass}, but it was not there."
            "Expected not to find DOM node with class #{cssClass}, but there #{@was(nodes.length)}."
          ]
          if nodes.length > 0
            @returnDom(nodes, messages)
          else
            @returnDom(null, messages)

#### Testing for React component types

Another common kind of test is to determine whether or not
a component contains a React component of a certain type. This matcher
passes if there is at least one.

FIXME: It would be nice to print the name of the component that
you want to find in the error messages, but it doesn't appear
to be available.

      type: (type) ->
        @bind (component) =>
          nodes = @reactUtils.scryRenderedComponentsWithType(component, type)
          messages = [
            "Expected to find a React component, but it was not there."
            "Expected not to find a React component, but there #{@was(nodes.length)}."
          ]
          if nodes.length > 0
            @return(nodes, messages)
          else
            @return(null, messages)

Export our matchers from this file.

    module.exports = ComponentQuery
