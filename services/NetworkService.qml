import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property bool isConnected: false
    property bool isWifiEnabled: true
    property string activeSsid: ""
    property int activeSignal: 0
    property var availableNetworks: [] // Array of { ssid, signal, security, inUse }

    // Scan available networks
    function rescan() {
        if (!scanProc.running) {
            scanProc.running = true;
        }
    }

    // Toggle Wi-Fi radio
    function toggleWifi() {
        var next = !isWifiEnabled;
        isWifiEnabled = next;
        toggleProc.command = ["nmcli", "radio", "wifi", next ? "on" : "off"];
        toggleProc.running = false;
        toggleProc.running = true;
        rescan();
    }

    // Connect to network
    function connectNetwork(ssid, password) {
        if (!ssid) return;
        if (password && password.length > 0) {
            connectProc.command = ["nmcli", "dev", "wifi", "connect", ssid, "password", password];
        } else {
            connectProc.command = ["nmcli", "dev", "wifi", "connect", ssid];
        }
        connectProc.running = false;
        connectProc.running = true;
    }

    Process {
        id: statusProc
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "dev"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.trim().split("\n");
                var connectedWifi = false;
                for (var i = 0; i < lines.length; i++) {
                    var parts = lines[i].split(":");
                    if (parts[0] === "wifi" && parts[1] === "connected") {
                        connectedWifi = true;
                        if (parts[2]) root.activeSsid = parts[2];
                    }
                }
                root.isConnected = connectedWifi;
            }
        }
    }

    Process {
        id: scanProc
        command: ["nmcli", "-t", "-f", "IN-USE,SSID,SIGNAL,SECURITY", "dev", "wifi", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.trim().split("\n");
                var list = [];
                var seen = {};
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();
                    if (!line) continue;
                    var parts = line.split(":");
                    if (parts.length >= 3) {
                        var inUse = parts[0] === "*";
                        var ssid = parts[1];
                        var signal = parseInt(parts[2]) || 0;
                        var sec = parts[3] || "Open";
                        if (ssid && ssid.length > 0 && !seen[ssid]) {
                            seen[ssid] = true;
                            if (inUse) {
                                root.activeSsid = ssid;
                                root.activeSignal = signal;
                                root.isConnected = true;
                            }
                            list.push({
                                ssid: ssid,
                                signal: signal,
                                security: sec,
                                inUse: inUse
                            });
                        }
                    }
                }
                // Sort by signal descending
                list.sort((a, b) => b.signal - a.signal);
                root.availableNetworks = list;
            }
        }
    }

    Process { id: toggleProc }
    Process { 
        id: connectProc 
        onExited: root.rescan()
    }

    // Refresh initially
    Component.onCompleted: {
        rescan();
    }
}
