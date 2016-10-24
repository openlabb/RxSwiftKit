console = {
  log: function (string) {
    window.webkit.messageHandlers.KKKWebWWW.postMessage({className: 'Console', functionName: 'log', data: string});
  }
}