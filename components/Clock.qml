import QtQuick
import Quickshell
import "../Theme.js" as Theme

Item {
    id: root

    property var themeConfig: null
    property string timeString: ""
    property string dateString: ""

    implicitWidth: clockPill.implicitWidth
    implicitHeight: 26

    function updateTime() {
        var now = new Date();
        var hours = now.getHours();
        var minutes = now.getMinutes();
        var ampm = hours >= 12 ? "PM" : "AM";
        hours = hours % 12;
        hours = hours ? hours : 12;
        var hStr = hours < 10 ? "0" + hours : "" + hours;
        var mStr = minutes < 10 ? "0" + minutes : "" + minutes;
        root.timeString = hStr + ":" + mStr + ampm;
        
        var options = { weekday: 'short', month: 'short', day: 'numeric' };
        root.dateString = now.toLocaleDateString(undefined, options);
    }

    Timer {
        id: syncTimer
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.updateTime();
            var sec = new Date().getSeconds();
            var remainMs = (60 - sec) * 1000;
            interval = Math.max(1000, remainMs);
        }
    }

    // Integrated subtle glass chip
    Rectangle {
        id: clockPill
        anchors.centerIn: parent
        implicitWidth: timeLabel.implicitWidth + 20
        height: 26
        radius: height / 2
        color: clockMouse.containsMouse 
            ? Qt.rgba(255, 255, 255, 0.08) 
            : Qt.rgba(0, 0, 0, 0.22)
        border.width: 1
        border.color: clockMouse.containsMouse 
            ? (root.themeConfig ? root.themeConfig.borderStrong : Theme.glassBorder) 
            : (root.themeConfig ? root.themeConfig.borderSubtle : Theme.glassBorderSubtle)

        Behavior on color { ColorAnimation { duration: Theme.animMicro } }
        Behavior on border.color { ColorAnimation { duration: Theme.animMicro } }

        Text {
            id: timeLabel
            anchors.centerIn: parent
            text: root.timeString
            font.family: Theme.fontFamily
            font.pixelSize: 12
            font.weight: Font.Bold
            font.letterSpacing: 0.5
            color: root.themeConfig ? root.themeConfig.text : Theme.text

            Behavior on color { ColorAnimation { duration: Theme.animMicro } }
        }

        MouseArea {
            id: clockMouse
            anchors.fill: parent
            hoverEnabled: true
        }
    }
}
