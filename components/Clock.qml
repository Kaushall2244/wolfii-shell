import QtQuick
import Quickshell
import "../Theme.js" as Theme

Item {
    id: root

    property string timeString: ""
    property string dateString: ""

    implicitWidth: timeLabel.implicitWidth + 12
    implicitHeight: 28

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

    Text {
        id: timeLabel
        anchors.centerIn: parent
        text: root.timeString
        font.family: Theme.fontFamily
        font.pixelSize: 13
        font.weight: Font.DemiBold
        font.letterSpacing: 0.6
        color: Theme.text
    }
}
