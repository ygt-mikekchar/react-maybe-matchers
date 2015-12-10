path = require("path")

module.exports = {
  entry: {
    // ReactMaybeMatchers.litcoffee is in an array to work around the problem
    // that Webpack refuses to allow something to require a file that is an
    // entry point
    ReactMaybeMatchers: [path.join(__dirname, "/src/ReactMaybeMatchers.litcoffee")],
    spec: path.join(__dirname, "/spec/spec.litcoffee"),
  },
  output: {
    path: path.join(__dirname, "/lib"),
    filename: "[name].js"
  },
  module: {
    loaders: [
      { test: /\.cjsx$/, loaders: ['coffee', 'cjsx']},
      { test: /\.coffee$/, loader: 'coffee' },
      { test: /\.litcoffee$/, loaders: ['coffee?literate', 'cjsx?literate']}
    ]
  }
};
