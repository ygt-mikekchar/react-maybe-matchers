# What is a Monad?

At the risk of writing "Yet another monad tutorial", I want to
write a little bit about monads.

Although many incredibly obtuse articles have been written about
monads they are actually quite simple.
Monads are simply a class that wraps a value.  You can then run
some functions on the values in the class.  Monads have to follow
some rules in order to be monads, but even without knowing these
rules explicitly, you will be able to make and use monads.

## Stucture of a monad

As I said, a monad simply wraps a value.  An easy way to do that is
with the constructor.  For example:

```coffee
class Monad
  constructor: (@value) ->
```

That bit wasn't difficult!  That's all you have to do to wrap a value.
However, I mentioned some rules previously.  One of the rules is that
the functions that work on monads have to return monads.  So they need
a simple way to construct a monad from a value.  We could easily use
the constructor, but then we need to remember the class of the monad
that we want to construct.  It's easier to make a method that does
that for us.

```coffee
  return: (value) ->
    @constructor(value)
```

Again, it's not rocket science.  The above allows us to write `@return(myvalue)`
and get a monad containing `myvalue` in whatever child class of Monad that
we happen to be in.  The choice of the name `return` is based on the
programming language Haskell, which uses this name.  `unit` would also be
traditional.  `return` reads nicely, though, because it will almost always
be called as the very last line of a function (because we want to return
a monad).  In Javascript it will look a bit weird, though:
`return(this.return(myvalue))` as opposed to `@return(myvalue)` as the last
line of a function in coffeescript.

The last thing that we need to be able to do is use the value in the
monad.  Traditionally there is a method called `bind` that accepts a
function and runs it, passing the value as a parameter:

```coffee
  bind: (func) ->
    func(@value)
```

And we are done writing our monad!  Well, to be honest, we still need to
write some functions that operate on the monad.

## Monadic functions

In order to use a monad properly, we need to do 2 things.  The first is
that any function that uses a monad needs to be run using `bind()`.  The
second is that it must return a monad (usually by calling `return()` as
the last line in the function).  It is very convenient, though, to
implement these functions on the monad class itself.  Here is an example:

```coffee
  double: ->
    @bind (value) ->
      @return(value * 2)
```

A little explanation is in order for those who are not so experienced with
idiomatic Coffeescript.  `double` constains a single statement: a call to
`@bind`.  Remember that `@bind` takes a function as a parameter.  We have
elided the parenthesis and have passed in an inline function.  A less
idiomatic (though arguably clearer) version would look like:

```coffee
  double: ->
    @bind((value) -> @return(value *2))
```

So all this function does is run `@bind`, passing it a function that doubles
the value.  The function returns the result as a new monad.

The nice thing about this is that we can eaily chain function.  Let's write
another function:

```coffee
  addFive: ->
    @bind (value) ->
      @return(value + 5)
```

So we can now do things like:

```
expect(new Monad(42).addFive().double().value).toEqual(94)
expect(new Monad(42).double().addFive().value).toEqual(89)
```

## The Maybe monad

As you can see, monads are not actually very complicated.  The
chaining is nice, but you might reasonably think that the monad
is still a bit more complicated that it needs to be if you
are only interested in chaining functions.  You would be correct.
The previous monad is known as the Identity monad and it is
fairly boring and useless.  There are other more interesting
monads.  Here is a maybe monad:

```coffee
class MaybeMonad
  constructor: (@value) ->

  return: (value) ->
    @constructor(value)

  bind: (func) ->
    if @value? then func(@value) else this
```

Basically, it is exactly the same as the Identity monad, but
only runs the function in `bind` if the value isn't undefined
(or null).  That doesn't seem to be very exciting, but it has
tremendously useful consequences.

Imagine that we add our `double` and `addFive` methods to this
Maybe monad.  Let's add another one, invert:

```coffee
  invert: ->
    @bind (value) ->
      if value != 0
        @return(1 / value)
      else
        @return(undefined)
```

Basically we are saying that we can invert values that are
not zero, but that 1 / 0 is undefined.  So we can safely do:

```coffee
expect(new MaybeMonad(42).invert().double().addFive()).toEqual((1/42)*2 + 5)
```

But we can also safely do:

```coffee
expect(new MaybeMonad(0).invert().double().addFive()).toBeUndefined()
```

The first operation returns undefined and we are able to chain all the
other operations without needing to explicitly error check as we go.

This is the power of the Maybe Monad.

