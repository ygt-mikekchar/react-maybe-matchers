# DomComponentFilter

DomComponentFilter is a ComponentFilter for Dom components
in the React tree.  Originally Dom components were similar
to React components in that they had props and state on
them.  As of 0.15 this will change, so we need to make
sure that DomComponents can only access the things
that they have access to.

    ComponentFilter = require("./ComponentFilter.litcoffee")

## A monad for filtering collections of React Dom components

    class DomComponentFilter extends ComponentFilter

      constructor: (@value, @util, @testers, @messages) ->
        super(@value, @util, @testers, @messages)

#### Filtering nodes by CSS class

      cssClass: (cssClass) ->
        @bind (nodes) =>
          match = (a, b) ->
            return false if !b?
            b == a

          if nodes?.length
            matched = (node for node in nodes when match(cssClass, node.className))
          else
            matched = []

          messages = [
            "Expected to find DOM node with class #{cssClass}, but it was not there."
            "Expected not to find DOM node with class #{cssClass}, but there #{@was(matched.length)}."
          ]

          if matched.length > 0
            @return(matched, messages)
          else
            @return(null, messages)

#### Filtering nodes containing text

      text: (string) ->
        @bind (nodes) =>
          match = (a, b) ->
            return false if !b?
            b.indexOf(a) != -1

          if nodes?.length
            matched = (node for node in nodes when match(string, node.textContent))
          else
            matched = []

          messages = [
            "Expected to find DOM node containing text #{string}, but it was not there."
            "Expected not to find DOM node containing text #{string}, but there #{@was(matched.length)}."
          ]

          if matched.length > 0
            @return(matched, messages)
          else
            @return(null, messages)

Export our filter from this file.

    module.exports = DomComponentFilter
