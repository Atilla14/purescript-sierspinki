const path = require('path')

module.exports = {
  entry: "./output",
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "bundle.js",
    publicPath: "/public/"
  },
  module: {
    loaders: [
      // {
      //   test: /\.css$/,
      //   exclude: /node_modules/,
      //   use: [
      //     {
      //       loader: 'css-loader',
      //       options: {
      //         sourceMap: true,
      //         importLoaders: 1,
      //       }
      //     },
      //     {
      //       loader: 'postcss-loader',
      //       options: {
      //         sourceMap: 'inline',
      //       }
      //     }
      //   ]
      // },
      {
        test: /\.(jpe?g|png|gif)$/i,
        use: 'file-loader'
      }
    ]
  }
}