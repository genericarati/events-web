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
                    stompClient.subscribe('/topic/greetings',function(greeting){
                    console.log("getting message back from team");
                    callback(null, "from spring boot websocket hello!!")
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
  stompClient.send("/app/hello", {}, JSON.stringify(order));
}
