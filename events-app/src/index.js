import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

var appFile = require("./app.js");

var app = Main.embed(document.getElementById('root'));

app.ports.toJs.subscribe(function (str) {
  console.log("got from Elm:", str);
  appFile.connect();
});

app.ports.toElm.send("undefined is not a function");

registerServiceWorker();
