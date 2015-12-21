react-maybe-matchers was built to write tests for another project.
The tests for the other project worked as a framework for testing
the matchers.  As such, the specs in this project have lagged behind.
I will try to update some realistic integration tests as soon
as possible.

One of the problems with integration tests is that you can't write
tests for failing matchers.  This project is unfortunately missing
any unit tests (high up on my priority list).

## Integration tests

In the [integration tests](./spec/integration_spec.litcoffee#integration-tests) you
will find examples of how to use the matchers.

    require("./integration_spec.litcoffee")

## String#pluralize unit tests

Some [examples of pluralizing strings]("./pluralize_spec.litcoffee#unit-tests-for-stringpluralize")

    require("./pluralize_spec.litcoffee")
