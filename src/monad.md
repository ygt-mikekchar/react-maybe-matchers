# What is a Monad?

At the risk of writing
[yet another monad tutorial](https://wiki.haskell.org/Monad_tutorials_timeline),
I want to write a little bit about monads.

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
the functions that work on monads have to return monads.  We need
a simple way to construct a monad from a value.  You may be excused for
thinking that the constructor is a perfectly simply way to construct
objects, but it has a small problem.  If we make a subclass of this
class, it might be difficult to know what the name of the constructor
is.  For this (and other historical reasons), we will create a helper
method.

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

The nice thing about this is that we can eaily chain functions.  Let's write
another function:

```coffee
  addFive: ->
    @bind (value) ->
      @return(value + 5)
```

So we can now do things like:

```
expect(
  new Monad(42)
    .addFive()
    .double()
    .value
).toEqual(94)

expect(
  new Monad(42)
    .double()
    .addFive()
    .value
).toEqual(89)
```

### Our complete Identity Monad

Here is the code again for the entire monad, along with our two
numerical functions:

```coffee
class Monad
  constructor: (@value) ->

  return: (value) ->
    @constructor(value)

  bind: (func) ->
    func(@value)

  double: ->
    @bind (value) ->
      @return(value * 2)

  addFive: ->
    @bind (value) ->
      @return(value + 5)
```

As you can see, monads are not actually very complicated.  The
chaining is nice, but you might reasonably think that the monad
is still a bit more complicated that it needs to be if you
are only interested in chaining functions.  You would be correct.
This is an example of an "Identity Monad".  It doesn't really give
you any interesting abilities and is arguably a waste of typing.

## The Maybe monad

While the previous monad is fairly boring and useless, there are
other more interesting monads.  By simply changing the definition
of the `bind` method we can turn this into a "Maybe Monad".

```coffee
class MaybeMonad extends Monad
  bind: (func) ->
    if @value? then func(@value) else this
```

Basically, it is exactly the same as the Identity monad, but
only runs the function in `bind` if the value isn't undefined
(or null).  That doesn't seem to be very exciting, but it has
tremendously useful consequences.

Let's add another numerical method to this monad: invert.

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
expect(
  new MaybeMonad(42)
    .invert()
    .double()
    .addFive()
    .value
).toEqual((1/42)*2 + 5)
```

This is unsurprising, but we can also safely do:

```coffee
expect(new MaybeMonad(0)
  .invert()  // Wait!  This will give an undefined value!
  .double()
  .addFive()
  .value
).toBeUndefined()
```

Even though the the invert operation is undefined, we don't have
to do any error checking along the way, because the Maybe Monad
simply declines to run any of the functions after the first one
fails.  Instead it forwards on the undefined value all the way
to the end.

This is the power of the Maybe Monad.  There are many, many useful
monads, but even if you only learn to use the maybe monad it will
serve you well.

