var $ = require('jquery');
var popper = require('popper.js');
var bootstrap = require('bootstrap');
var SockJs = require('sockjs-client');
var stomp = require('stompjs');

var stompClient = null;


module.exports = {


    connect: function(){
            console.log("in connect function")
            var socket = new SockJs('http://localhost:8080/gs-guide-websocket');
            stompClient = Stomp.over(socket);
            stompClient.connect({},function(frame){
                console.log('connected: ', frame);
            });
      },

    subscribe: function(){
              sendName();
              if (stompClient !== null) {
                  stompClient.subscribe('/topic/greetings',function(greeting){
                  console.log("getting message back from team");
                  console.log(greeting.content);
                  // return "From Spring boot WebSocket hellow!!";
              });
            }
    },

     disconnect: function() {
        if (stompClient !== null) {
            stompClient.disconnect();
        }
        console.log("Disconnected");
    }
}


function sendName() {
  stompClient.send("/app/hello", {}, JSON.stringify({'name': "nameChanged"}));
}
