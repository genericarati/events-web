var $ = require('jquery');
var popper = require('popper.js');
var bootstrap = require('bootstrap');
var SockJs = require('sockjs-client');
var stomp = require('stompjs');

var stompClient = null;

$(function () {
    $("form").on('submit', function (e) {
        e.preventDefault();
    });
    $( "#connect" ).click(function() { connect(); });
    $( "#disconnect" ).click(function() { disconnect(); });
    $( "#send" ).click(function() { sendName(); });
});

function sendName() {
    stompClient.send("/app/hello", {}, JSON.stringify({'name': $("#name").val()}));
}

function connect(){
  var socket = new SockJs('http://localhost:8080/gs-guide-websocket');
  stompClient = Stomp.over(socket);
  stompClient.connect({},function(frame){
      setConnected(true);
      console.log('connected: ', frame);
      stompClient.subscribe('/topic/greetings',function(greeting){
          showGreeting(JSON.parse(greeting.body).content);
      });
  });
}

function disconnect() {
    if (stompClient !== null) {
        stompClient.disconnect();
    }
    setConnected(false);
    console.log("Disconnected");
}

function setConnected(connected) {
    $("#connect").prop("disabled", connected);
    $("#disconnect").prop("disabled", !connected);
    if (connected) {
        $("#conversation").show();
    }
    else {
        $("#conversation").hide();
    }
    $("#greetings").html("");
}

function showGreeting(message) {
    $("#greetings").append("<tr><td>" + message + "</td></tr>");
}
