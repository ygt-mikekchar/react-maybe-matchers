# React Maybe Matchers for Jasmine

Tests using the React test utilities directly are both difficult to read
and inconvenient to type. These matchers are intended to to make it
easier to write tests and to understand what they are doing later.

## DSL for React tests

This is an example of the kinds of expectations you can write
with react-maybe-matchers.

```coffee
  expect(component).toBeAComponent (it) ->
    it.contains.tags("div")
      .with.cssClass("my-class")
      .and.text("contents")
      .exactly(2).times
      .result()
```

**Note:** text() is not implemented yet.

### Dependencies

react-maybe-matchers is currently built against Jasmine 2.3.2 and React 0.13.3.
Other versions may work, but have not been tested.  The React version is
probably quite flexible as long as you have one with the test utils.  Unfortunately
this is unlikely the case for Jasmine as they have changed the way matchers
work in some versions of the library.  A more complete compatibility list will
be made soon.

### Installation

We have not yet added react-maybe-matchers to NPM, but you can still install it.
If you are using NPM, you can install with the following
entry in the devDependencies section of your `package.json` file:

```
"react-calendar-pane": "git://github.com/ygt-mikekchar/react-maybe-matchers.git#master",
```

If you wish to use the code directly (for example in a submodule in your project),
simply require `lib/ReactMaybeMatchers.js`.

### Usage

To use custom matchers in Jasmine, you have to do a little bit of set up.  Here
is the typical way to set it up (in Coffeescript):

```coffee
React = require("react/addons")
ReactMaybeMatchers = require("react-maybe-matchers")

describe "some wonderfule thing", ->
  beforeEach ->
    @addMatchers(ReactMatchers)

```

Note that you *must* make a variable called `React` and it *must* point
to the addons version of React (so that the matchers can make use of
the React test utilities).


### API

There is only one one top level matcher.  It is called `toBeAComponent`.
To use it, you simply make an expectation on a React component and
pass a *matcher function*.

```coffee
  expect(component).toBeAComponent(matcherFn)
```

## License

react-maybe-matchers is distributed under the [MIT licence](./LICENSE).

## Literate Source Code

This project is written in
[literate Coffeescript](http://coffeescript.org/#literate).
[Literate programming](https://en.wikipedia.org/wiki/Literate_programming)
(LP) is a style of programming introduced by Donald Knuth and famously
used in the TeX text processing system.  You can
[browse the source code](src/ReactMatchers.litcoffee) for this project.

## Under Development

react-maybe-matchers is currently under development, but is very slightly
useful now.  Please feel free to submit issues or pull requests.
