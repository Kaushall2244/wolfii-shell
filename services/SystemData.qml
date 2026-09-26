import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    // Metrics
    property int cpuUsage: 0         // 0 - 100%
    property int ramUsage: 0         // 0 - 100%
    property real ramUsedGb: 0.0
    property real ramTotalGb: 0.0
    property int tempCelsius: 0      // Celsius
    property bool hasTemp: false

    // Internal state for CPU calculation
    property var _prevCpu: null
    property string _thermalPath: ""

    // Read /proc/stat for CPU
    FileView {
        id: fileStat
        path: "/proc/stat"
        printErrors: false
    }

    // Read /proc/meminfo for RAM
    FileView {
        id: fileMeminfo
        path: "/proc/meminfo"
        printErrors: false
    }

    // Read temperature
    FileView {
        id: fileTemp
        path: root._thermalPath
        printErrors: false
        onLoaded: {
            var raw = parseFloat(fileTemp.text().trim());
            if (!isNaN(raw) && raw > 0) {
                root.tempCelsius = Math.round(raw > 200 ? raw / 1000 : raw);
                root.hasTemp = true;
            }
        }
    }

    // One-time dynamic detection of best thermal path
    Process {
        id: thermalDetectProc
        command: [
            "sh", "-c",
            "for h in /sys/class/hwmon/hwmon*; do [ -d \"$h\" ] || continue; for l in \"$h\"/temp*_label; do [ -f \"$l\" ] || continue; if grep -qE 'Package id 0|Tctl|Tdie|CPU' \"$l\" 2>/dev/null; then inp=\"${l%_label}_input\"; [ -f \"$inp\" ] && echo \"$inp\" && exit 0; fi; done; done; for z in /sys/class/thermal/thermal_zone*; do [ -d \"$z\" ] || continue; type=$(cat \"$z/type\" 2>/dev/null); case \"$type\" in x86_pkg_temp|cpu*|TCPU|soc_thermal) [ -f \"$z/temp\" ] && echo \"$z/temp\" && exit 0;; esac; done; for t in /sys/class/hwmon/hwmon*/temp1_input /sys/class/thermal/thermal_zone0/temp; do [ -f \"$t\" ] && echo \"$t\" && exit 0; done"
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var found = text.trim();
                if (found.length > 0) {
                    root._thermalPath = found;
                    fileTemp.reload();
                }
            }
        }
    }

    function updateCpu() {
        fileStat.reload();
        var content = fileStat.text();
        var match = content.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
        if (match) {
            var stats = match.slice(1).map(Number);
            var total = stats.reduce((a, b) => a + b, 0);
            var idle = stats[3];
            if (root._prevCpu) {
                var totalDiff = total - root._prevCpu.total;
                var idleDiff = idle - root._prevCpu.idle;
                if (totalDiff > 0) {
                    var pct = Math.round((1.0 - (idleDiff / totalDiff)) * 100);
                    root.cpuUsage = Math.max(0, Math.min(100, pct));
                }
            }
            root._prevCpu = { total: total, idle: idle };
        }
    }

    function updateRam() {
        fileMeminfo.reload();
        var content = fileMeminfo.text();
        var totalMatch = content.match(/MemTotal:\s+(\d+)/);
        var availMatch = content.match(/MemAvailable:\s+(\d+)/);
        if (totalMatch && availMatch) {
            var totalKb = Number(totalMatch[1]);
            var availKb = Number(availMatch[1]);
            var usedKb = totalKb - availKb;
            root.ramUsage = Math.round((usedKb / totalKb) * 100);
            root.ramUsedGb = Math.round((usedKb / (1024 * 1024)) * 10) / 10;
            root.ramTotalGb = Math.round((totalKb / (1024 * 1024)) * 10) / 10;
        }
    }

    function updateTemp() {
        if (root._thermalPath.length > 0) {
            fileTemp.reload();
        }
    }

    // Timer for CPU & RAM (~1.2s)
    Timer {
        interval: 1200
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.updateCpu();
            root.updateRam();
        }
    }

    // Timer for Temperature (~3s)
    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.updateTemp();
        }
    }
}
