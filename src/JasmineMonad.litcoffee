# A monad for Jasmine tests

## Requirements

The matchers need to pluralize strings, so we need to load
[a string pluralizer method](pluralize.litcoffee)

    require("./pluralize.litcoffee")

## JasmineMonad

This is the base class for our matcher monads.  In general, a monad simply wraps
a value and provides a way to run arbitrary functions using those
wrapped values.  If you are not familiar with monads you can
[read more](./monad.md).


    class JasmineMonad

Our monad wraps a few things.

      constructor: (@value, @util, @testers, @messages) ->
        @messages = [] if !@messages?

      return: (value, messages) ->
        new @constructor(value, @util, @testers, messages)

Remember that the `return` function is just a convenience function
that we can use to create new monads of the same type as the one
we are working with.  It is not the `return` keyword.

`util` and `testers` are needed by Jasmine for creating
a result for the matchers.  We need to carry them along.

`messages` is an array containing matcher error messages
from the last run matcher function.  Jasmine has an odd way
of outputting error messages.  When you write a matcher, you
need to supply the error message both for when the matcher does
not pass *and* for when the matcher does not  pass when `.not`
was supplied.  We store these two messages from the last run
matcher in `messages`.

The `value` depends on the type of monad we are constructing.
`JasmineMonad` is the base class and what we store in `value`
depends on the concrete class.

Here is the `bind` function that runs functions working
with the monad.  Because it is a Maybe monad, we only
run the passed function if `passed` (whether or not all
of the matchers up to this point have passed) returns
true:

      bind: (func) ->
        if @passed()
          func(@value)
        else
          this

We dont have any definitive way of determining if the previous
matchers have passed, so we will rely on the matcher functions
to return null when the matcher fails.

      passed: () ->
        @value?

Once we have run our chain of matchers and filters, we need some
way of returning a result to Jasmine.  This should always be
the last method called in the chain.  Notice that it doesnt
return a new monad, but rather the result object that Jasmine
expects.

      result: ->
        result = {}
        result.pass = @util.equals(@passed(), true, @testers)
        if @messages?
          if result.pass
            result.message = @messages[1]
          else
            result.message = @messages[0]
        return result

In constructing the messages it is often the case that you want to
use the word "was/were" depending on the number of items.  This
is a small helper utility.

For example:
```
"there #{@was(1)}" # == "there was 1"
"There #{@was(2)}" # == "there were 2"
```

      was: (num) ->
        'was'.pluralize(num, 'were') + " #{num}"

Similarly we often want to count the number of objects using the
correct pluralization.

For example:
```
"I have #{@count(1, 'apple')}"            # == "I have 1 apple"
"I have #{@count(2, 'apple')}"            # == "I have 2 apples"
"I have #{@count(2, 'mommy', 'mommies')}"  # == "I have 2 mommies" 
```

      count: (num, singular, plural) ->
        "#{num} #{singular.pluralize(num, plural)}"

## Export

    module.exports = JasmineMonad
