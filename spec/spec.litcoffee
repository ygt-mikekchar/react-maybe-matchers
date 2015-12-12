Here is a spec

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

      it "should find contained elements", ->
        expect(@subject).toBeAComponent (which) ->
          which.contains.tags("div")
               .result()

      it "should not find elements that don't exist", ->
        expect(@subject).not.toBeAComponent (which) ->
          which.contains.tags("a")
               .result()
