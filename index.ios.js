/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

const { AppRegistry } = require('react-native');
const Elm = require('./src/bundle');
const elmApp = Elm.App.start();
AppRegistry.registerComponent('movieApp', () => elmApp);