# String#pluralize method

Many of the tests need to output plural versions of
objects.  This is just a handy utility to help with that.

## Examples

```
"one #{'bucket'.pluralize(1)}"            # == "one bucket"
"five #{'bucket'.pluralize(5)}"           # == "five buckets"
"two #{'mommy'.pluralize(2, 'mommies')}"  # == "two mommies"
"there #{'was'.pluralize(1, 'were')} one" # == "there was one"
```

**TODO:** Write some tests ;-)

    String.prototype.pluralize = (num, plural) ->
      return this if num == 1
      if plural? then plural else "#{this}s"
