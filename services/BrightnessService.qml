import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property bool hasBrightness: false
    property int percentage: 100 // 0 - 100
    property string deviceName: ""

    Process {
        id: detectProc
        command: ["brightnessctl", "info"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var out = text.trim();
                if (out.length > 0 && !out.includes("No device")) {
                    root.hasBrightness = true;
                    var matchDev = out.match(/Device '([^']+)'/);
                    if (matchDev) root.deviceName = matchDev[1];
                    var matchPct = out.match(/\((\d+)%\)/);
                    if (matchPct) root.percentage = parseInt(matchPct[1]);
                } else {
                    root.hasBrightness = false;
                }
            }
        }
    }

    function setBrightness(pct) {
        var clamped = Math.max(1, Math.min(100, pct));
        root.percentage = clamped;
        setProc.command = ["brightnessctl", "set", clamped + "%"];
        setProc.running = false;
        setProc.running = true;
    }

    Process { id: setProc }
}
