module.exports = {
  resolve: {
    alias: {
      jquery: "jquery/src/jquery.js"
    }
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: "elm-webpack-loader",
            options: {
              verbose: true,
              warn: true,
              debug: true
            }
          }
        ]
      }
    ]
  }
};
