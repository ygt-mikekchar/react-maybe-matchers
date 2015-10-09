path = require("path")

module.exports = {
  entry: {
    ReactMaybeMatchers: path.join(__dirname, "/src/ReactMatchers.litcoffee"),
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
