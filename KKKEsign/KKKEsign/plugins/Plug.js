navigator.faceDetect = function() {
  window.webkit.messageHandlers.KKKWebWWW.postMessage({className: 'EsignPlug', functionName: 'goDetect'});
}

navigator.login = function() {
    window.webkit.messageHandlers.KKKWebWWW.postMessage({className: 'EsignPlug', functionName: 'goLogin'});
}

navigator.hand = function() {
    window.webkit.messageHandlers.KKKWebWWW.postMessage({className: 'EsignPlug', functionName: 'goSignHand'});
}

navigator.back = function() {
    window.webkit.messageHandlers.KKKWebWWW.postMessage({className: 'EsignPlug', functionName: 'goBack'});
}