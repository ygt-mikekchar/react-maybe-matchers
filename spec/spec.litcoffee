Here is a failing spec

    React = require("react")
    ReactTestUtils = require('react-addons-test-utils')
    ReactMaybeMatchers = require("../src/ReactMaybeMatchers.litcoffee")

    describe "react maybe matchers", ->
      beforeEach ->
        new ReactMaybeMatchers(ReactTestUtils).addTo(this)

      it "should fail", ->
        expect(false).toEqual(true)
