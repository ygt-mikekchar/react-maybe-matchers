# React Maybe Matchers for Jasmine

Tests using the React test utilities directly are both difficult to read
and inconvenient to type. These matchers are intended to to make it
easier to write tests and to understand what they are doing later.

## DSL for React tests

These matchers will allow us to write tests like:

```coffee
  expect(component).toBeAComponent (it) ->
    it.contains.tags("div")
      .with.cssClass("my-class")
      .and.text("contents")
      .exactly(2).times
      .result()
```

**Note:** text() is not implemented yet.

One of the biggest problems with writing Jasmine matchers for React is that
you often have to search through Reacts tree to find the things you want
to test.  In Rspec (in Ruby) you can often chain matchers together to create
complex and readable tests.  Alas, this is not possible for Jasmine.

To compensate for this we will make a [Maybe monad](monad.md#what-is-a-monad)
which will allow us to chain a series of filters.  People often get flustered
about monads, but their use is very straight forward.

In the example above, `toBeAComponent` accepts a callback, which it will call,
funishing a monad called `it`.  We can then chain a series of tests.

The chain in this example means that I am expecting my component to contain a DOM `div`
with the class `my-css-class`.  This `div` should contain the text, `contents`.
There should be exactly 2 such `divs` in my tree.  The `result()` at the
end simply means, "I'm done with my testing, please calculate the results".

The Maybe monad is a special kind of monad that only processes when
the data is valid.  In this case, if there are no `div` elements, then it
wont bother trying to figure out the cssClass, etc.  It will ignore
everything until it gets to the `result`.  Its a useful technique when
you dont want to constantly check return values for errors.

## Requirements

The matchers need to pluralize strings, so we need to load
[a string pluralizer method](pluralize.litcoffee)

    require("./pluralize.litcoffee")

The [ComponentQuery](./ComponentQuery.litcoffee) is a
[JasmineMonad](./JasmineMonad.litcoffee)
that allows you to take a single React component and make queries
of it, often generating a [ComponentFilter](./ComponentFilter.litcoffee). 

    ComponentQuery = require("./ComponentQuery.litcoffee")

### Main matcher interface

We actually only require one main method in our matchers interface because
all of our matchers are actually implemented as methods on our monads.

    ReactMatchers =

      toBeAComponent: (util, testers) ->
        compare: (component, func) ->
          filter = new ComponentQuery(component, util, testers)
          func(filter)

Export our matchers from this file.

    module.exports = ReactMatchers
