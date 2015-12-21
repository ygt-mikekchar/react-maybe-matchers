# Unit tests for String#pluralize

    require("../src/pluralize.litcoffee")

    describe "String#pluralize", ->
      it "does nothing for singular objects", ->
        expect("one #{'bucket'.pluralize(1)}").toEqual("one bucket")

      it "automatically adds an 's' to plural objects", ->
        expect("five #{'bucket'.pluralize(5)}").toEqual("five buckets")

      describe "custom pluralization", ->
        it "pluralizes multiple objects", ->
          expect("two #{'mommy'.pluralize(2, 'mommies')}").toEqual("two mommies")

        it "does not not pluralize singular objects", ->
          expect("there #{'was'.pluralize(1, 'were')} one").toEqual("there was one")
