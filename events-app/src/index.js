import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

var appFile = require("./app.js");

var app = Main.embed(document.getElementById('root'));

app.ports.requestTradePort.subscribe(function (str) {
   console.log("From elm - Asking to get message from subscriptions");
   appFile.subscribe(function(err, result){
     console.log(err, result);
     app.ports.toElm.send(result);
     appFile.disconnect();
   });
});

app.ports.connectToStompPort.subscribe(function (connectMessage){
  console.log("From elm - Asking to connect to stomp client");
  appFile.connect();
});

registerServiceWorker();
