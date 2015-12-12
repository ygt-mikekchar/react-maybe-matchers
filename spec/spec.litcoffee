Here is a failing spec

    React = require("react")
    ReactTestUtils = require('react-addons-test-utils')
    ReactMaybeMatchers = require("../src/ReactMaybeMatchers.litcoffee")

    CommentBox = React.createClass
      render: ->
        <div className="commentBox">
          Hello, world!  I am a comment box.
        </div>

    describe "react maybe matchers", ->
      beforeEach ->
        new ReactMaybeMatchers(ReactTestUtils).addTo(jasmine)
        @subject = ReactTestUtils.renderIntoDocument(
          <CommentBox />
        )

      it "should be a component", ->
        expect(@subject).toBeAComponent (it) ->
          it.contains.tags("div")
            .result()
