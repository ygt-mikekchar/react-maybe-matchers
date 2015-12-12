Here is a spec

    React = require("react")
    ReactTestUtils = require('react-addons-test-utils')
    ReactMaybeMatchers = require("../src/ReactMaybeMatchers.litcoffee")

    describe "react maybe matchers", ->
      beforeEach ->
        new ReactMaybeMatchers(ReactTestUtils).addTo(jasmine)

      describe "ComponentQuery", ->
        describe "returning a single nodes", ->
          CommentBox = React.createClass
            render: ->
              <div className="commentBox">
                Hello, world!  I am a comment box.
              </div>

          beforeEach ->
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

        describe "returning multiple nodes", ->
          CommentBox = React.createClass
            render: ->
              <div className="commentBox">
                <span>Hello, world!</span> <span>I am a comment box.</span>
              </div>

          beforeEach ->
            @subject = ReactTestUtils.renderIntoDocument(
              <CommentBox />
            )

          it "should find contained elements", ->
            expect(@subject).toBeAComponent (which) ->
              which.contains.tags("span")
                   .result()

          it "should chain ComponentFilter on multiple nodes", ->
            expect(@subject).toBeAComponent (which) ->
              which.contains.tags("span")
                   .exactly(2).times
                   .result()

          it "should allow negative expectation on ComponentFilters", ->
            expect(@subject).not.toBeAComponent (which) ->
              which.contains.tags("span")
                   .exactly(1).time
                   .result()
