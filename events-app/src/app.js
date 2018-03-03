var $ = require('jquery');
var popper = require('popper.js');
var bootstrap = require('bootstrap');
var SockJs = require('sockjs-client');
var stomp = require('stompjs');

var stompClient = null;


module.exports = {


    connect: function(){
            var socket = new SockJs('http://localhost:8080/gs-guide-websocket');
            stompClient = Stomp.over(socket);
            stompClient.connect({},function(frame){
                console.log('connected: ', frame);
            });
      },

    subscribe: function(callback, order){
              sendOrderToSpring(order);
                if (stompClient !== null) {
                    stompClient.subscribe('/topic/tradeResponse',function(tradeResponse){
                    callback(null, JSON.parse(tradeResponse.body))
                });
              }else {
                  callback("There was error.","");
              }
    },

     disconnect: function() {
        if (stompClient !== null) {
            stompClient.disconnect();
        }
        console.log("Disconnected");
    }
}


function sendOrderToSpring(order) {
  stompClient.send("/app/trade", {}, JSON.stringify(order));
}
