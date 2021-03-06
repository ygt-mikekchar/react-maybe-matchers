# React Maybe Matchers for Jasmine

Tests using the React test utilities directly are both difficult to read
and inconvenient to type. These matchers are intended to to make it
easier to write tests and to understand what they are doing later.

One of the biggest problems with writing Jasmine matchers for React is that
you often have to search through Reacts tree to find the things you want
to test.  In Rspec (in Ruby) you can often chain matchers together to create
complex and readable tests.  Alas, this is not possible for Jasmine.

To compensate for this we will make a [Maybe monad](monad.md#what-is-a-monad)
which will allow us to chain a series of filters.  People often get flustered
about monads, but their use is very straight forward.

## DSL for React tests

These matchers will allow us to write tests like:

```coffee
  expect(component).toBeAComponent (which) ->
    which.contains.tags("div")
         .with.cssClass("my-class")
         .and.text("contents")
         .exactly(2).times
         .result()
```

In the example above, `toBeAComponent` accepts a callback, which it will call,
funishing a monad called `which`.  We can then chain a series of tests.

The chain in this example means that I am expecting my component to contain a DOM `div`
with the class `my-css-class`.  This `div` should contain the text, `contents`.
There should be exactly 2 such `divs` in my tree.  The `result()` at the
end simply means, "I'm done with my testing, please calculate the results".

The Maybe monad is a special kind of monad that only processes when
the data is valid.  In this case, if there are no `div` elements, then it
wont bother trying to figure out the cssClass, etc.  It will ignore
everything until it gets to the `result`.  Its a useful technique when
you don't want to constantly check return values for errors.

### Requirements

The main matcher interface will return a
[ComponentQuery](./ComponentQuery.litcoffee#componentquery).  This is a
[JasmineMonad](./JasmineMonad.litcoffee#a-monad-for-jasmine-tests)
that allows you to take a single React component and make queries
of it, often generating a [ComponentFilter](./ComponentFilter.litcoffee#componentfilter) 
or [DomComponentFilter](./DomComponentFilter.litcoffee#domcomponentfilter)

    ComponentQuery = require("./ComponentQuery.litcoffee")

### Using ReactMaybeMatchers

The matchers need to use the React test utils in order to
inspect the React/DOM tree for components.  `@reactUtils`
here is the result of `require("react-addons-test-utils")`

    class ReactMaybeMatchers
      constructor: (@reactUtils) ->

In order to use ReactMaybeMatchers, you have to add
the matchers to the jasmine instance.

      addTo: (jasmine) ->
        jasmine.addMatchers(this)

Here is the typical way to set up the matchers in a spec:

```coffee
React = require("react")
ReactTestUtils = require('react-addons-test-utils')
ReactMaybeMatchers = require("../src/ReactMaybeMatchers.litcoffee")

describe "some wonderful thing", ->
  beforeEach ->
    new ReactMaybeMatchers(ReactTestUtils).addTo(jasmine)
```

### Main Matcher Interface

We actually only require one main method in our matchers interface because
all of our matchers are actually implemented as methods on our monads.

      # The matcher gets called with a different `this` pointer,
      # so we need to use a fat arrow here.
      toBeAComponent: (util, testers) =>
        compare: (component, func) =>
          filter = new ComponentQuery(@reactUtils, component, util, testers)
          func(filter)

### Exported Classes

    module.exports = ReactMaybeMatchers
