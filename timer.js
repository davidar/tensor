// Based on http://stackoverflow.com/a/28514691/78204

var global = { window: null };
var timers = [];

function Timer(id) {
    return Qt.createQmlObject("import QtQuick 2.0; Timer { id: " + id + " }", global.window);
}

function setTimeout(callback, delay) {
    if(delay === 0) {
        callback();
        return;
    }

    var id = timers.length;
    var timer = new Timer("timer" + id);
    timer.interval = delay;
    timer.repeat = false;
    timer.triggered.connect(function() {
        console.log("Timeout timer #", id);
        callback();
        timer.destroy();
    });
    timer.start();
    timers.push(timer);
    console.log("Creating timer #", id);
    return id;
}

function clearTimeout(id) {
    timers[id].stop();
    timers[id].destroy();
    timers[id] = null;
    console.log("Destroying timer #", id);
    return;
}
