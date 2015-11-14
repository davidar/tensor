// Based on http://stackoverflow.com/a/28514691/78204

var timers = [];

function Timer() {
    return Qt.createQmlObject("import QtQuick 2.0; Timer {}", global.window);
}

function setTimeout(callback, delay) {
    var timer = new Timer();
    timer.interval = delay;
    timer.repeat = false;
    timer.triggered.connect(function() {
        callback();
        timer.destroy();
    });
    timer.start();
    timers.push(timer);
    return timers.length - 1;
}

function clearTimeout(id) {
    timers[id].stop();
    timers[id].destroy();
    timers[id] = null;
    return;
}
