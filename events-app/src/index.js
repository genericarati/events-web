import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

var appFile = require("./app.js");

var app = Main.embed(document.getElementById('root'));

app.ports.requestTradePort.subscribe(function (tradeRequest) {
   appFile.subscribe(function(err, result){
     console.log(err, result);
     app.ports.responseTradePort.send(result);
     // appFile.disconnect();
   }, tradeRequest);
});

app.ports.connectToStompPort.subscribe(function (connectMessage){
  appFile.connect();
});


registerServiceWorker();
//To do List
//call disconnect function on browser close event or on transfer to other page
