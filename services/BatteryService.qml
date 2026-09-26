import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property bool hasBattery: false
    property int percentage: 100
    property string status: "Full" // "Charging", "Discharging", "Full", "Not charging"
    property bool isCharging: status === "Charging"

    property string _batDir: ""

    // Detect battery directory dynamically
    Process {
        id: batDetectProc
        command: [
            "sh", "-c",
            "for b in /sys/class/power_supply/BAT* /sys/class/power_supply/battery; do [ -d \"$b\" ] && [ -f \"$b/capacity\" ] && echo \"$b\" && exit 0; done"
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var found = text.trim();
                if (found.length > 0) {
                    root._batDir = found;
                    root.hasBattery = true;
                    fileCapacity.path = found + "/capacity";
                    fileStatus.path = found + "/status";
                    root.updateBattery();
                } else {
                    root.hasBattery = false;
                }
            }
        }
    }

    FileView {
        id: fileCapacity
        printErrors: false
        onLoaded: {
            var val = parseInt(fileCapacity.text().trim());
            if (!isNaN(val)) {
                root.percentage = Math.max(0, Math.min(100, val));
            }
        }
    }

    FileView {
        id: fileStatus
        printErrors: false
        onLoaded: {
            var st = fileStatus.text().trim();
            if (st.length > 0) {
                root.status = st;
            }
        }
    }

    function updateBattery() {
        if (root.hasBattery) {
            fileCapacity.reload();
            fileStatus.reload();
        }
    }

    Timer {
        interval: 6000
        running: root.hasBattery
        repeat: true
        onTriggered: root.updateBattery()
    }
}
