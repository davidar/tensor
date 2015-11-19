.pragma library
var global = { window: null };

Qt.include("timer.js");
Qt.include("qrc:/qml-request/index.js")
Qt.include("qrc:/matrix-js-sdk/dist/browser-matrix-dev.js")

global.matrixcs.request(request)
