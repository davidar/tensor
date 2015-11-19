.pragma library
var global = { window: null };

Qt.include("timer.js");
Qt.include("qml-request/index.js")
Qt.include("matrix-js-sdk/dist/browser-matrix-dev.js")

global.matrixcs.request(request)
