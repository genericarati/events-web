import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

var appFile = require("./app.js");

var app = Main.embed(document.getElementById('root'));

app.ports.toJs.subscribe(function (str) {
  console.log("got from Elm:", str);
  var message = appFile.connect();
  // var message = appFile.subscribe();
  console.log(message);

});


app.ports.toElm.send("");

appFile.disconnect();

registerServiceWorker();
