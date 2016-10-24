navigator.faceDetect = function() {
  window.webkit.messageHandlers.KKKWebWWW.postMessage({className: 'FaceViewController', functionName: 'goDetect'});
}

navigator.login = function() {
    window.webkit.messageHandlers.KKKWebWWW.postMessage({className: 'FaceViewController', functionName: 'goLogin'});
}