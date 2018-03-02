var $ = require('jquery');
var popper = require('popper.js');
var bootstrap = require('bootstrap');
var SockJs = require('sockjs-client');
var stomp = require('stompjs');

var stompClient = null;
//  console.log("i am in app.js function");
//
// $(function () {
//     $("form").on('submit', function (e) {
//         e.preventDefault();
//     });
//     $( "#connect" ).click(function() { connect(); });
//     $( "#disconnect" ).click(function() { disconnect(); });
//     $( "#send" ).click(function() { sendName(); });
// });

module.exports = {


    connect: function(){
            console.log("in connect function")
            var socket = new SockJs('http://localhost:8080/gs-guide-websocket');
            stompClient = Stomp.over(socket);
            stompClient.connect({},function(frame){
                console.log('connected: ', frame);
                sendName();
                if (stompClient !== null) {
                      stompClient.subscribe('/topic/greetings',function(greeting){
                      console.log("getting message back from team");
                      console.log(greeting.content);
                      return "From Spring boot WebSocket hellow!!";
                   });
                }
                else{
                  return "empty";
                }
            });
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
