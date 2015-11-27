.pragma library
var global = { window: null }

function include(files, init) {
    var loaded = 0;
    function _include(file) {
        Qt.include(file, function(res) {
            switch(res.status) {
                case 0:
                    console.log("Loaded", file, ".")
                    loaded++
                    if(loaded === files.length) init()
                    break
                case 1: console.log("Loading", file, "..."); break
                case 2: console.log("Network error while loading", file, "!"); break
                case 3: console.log("[", file, "]", res.exception); break
            }
        })
    }
    for(var i = 0; i < files.length; i++) _include(files[i])
}

include([ "timer.js"
        , "../qml-request/index.js"
        , "../matrix-js-sdk/dist/0.3.0/browser-matrix-0.3.0.js"
        ], function() {
    console.log("Initialising")
    global.matrixcs.request(request)
})
