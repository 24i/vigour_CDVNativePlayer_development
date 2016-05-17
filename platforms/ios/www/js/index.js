/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    initialize: function() {this.bindEvents();},
    bindEvents: function() {document.addEventListener('deviceready', this.onDeviceReady, false);},

    onDeviceReady: function() {
        
        app.receivedEvent('deviceready');
        document.getElementById('myButton').addEventListener('click', function() {
                                                             loadMovie("http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
                                                             });
        
        setInterval(function (){ console.log(getProgress())  }, 5000)

//        loadMovie("http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//        document.addEventListener('myEvent', this.onMyEvent, false);

    },
    
    onMyEvent: function() {console.log('onMyEvent');},
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

//function objCMethod(methodName, args, completionHandler) {
//    cordova.exec(
//                 function _(result) {console.log(result)},
//                 function errorHandler(err) {alert('Error')},
//                 'ObjcInterface',
//                 methodName,
//                 [args]
//                 );
//}

function loadMovie(url) {
    cordova.exec(
                 function _(result) {console.log(result)},
                 function errorHandler(err) {alert('Error')},
                 'CDVNativePlayer',
                 'create',
                 [url]
                 );
}

//function loadMovie(url) { objCMethod('load', url) }
//function play() { objCMethod('play') }
//function pause() { objCMethod('pause') }
//function seek(time) { objCMethod('seek', time) }
//function getProgress() { objCMethod('getProgress') }
//function getBuffered() { objCMethod('getBuffered') }

// events tbi
function stalled(info) {console.log(info)}
function paused(info) {console.log(info)}
function playing(info) {console.log(info)}
function canPlay(info) {console.log(info)}

app.initialize();

// will look like this:
//window.nativePlayer = {
//  play: play,
//  pause: function pause () {
//    cordova.exec()
//  }
//}
//
//function play() {
//    
//}

function testNativeCallReceipt(msg) {
    console.log('testNativeCallReceipt' + ' ' + msg);
}