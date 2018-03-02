import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

var appFile = require("./app.js");

var app = Main.embed(document.getElementById('root'));

app.ports.requestTradePort.subscribe(function (order) {
   appFile.subscribe(function(err, result){
     console.log(err, result);
     app.ports.toElm.send(result);
     // appFile.disconnect();
   }, order);
});

app.ports.connectToStompPort.subscribe(function (connectMessage){
  appFile.connect();
});


registerServiceWorker();
//To do List
//call disconnect function on browser close event or on transfer to other page
