import QtQuick
import "../Theme.js" as Theme

Item {
    id: root

    property string symbol: "◉"
    property string value: ""
    property string tooltipTitle: ""
    property string tooltipDetail: ""
    property color indicatorColor: Theme.accent
    property bool showIndicator: true

    implicitWidth: chipBg.implicitWidth
    implicitHeight: 26

    Rectangle {
        id: chipBg
        anchors.fill: parent
        implicitWidth: row.implicitWidth + 14
        radius: Theme.smallRadius
        color: mouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.08) : Qt.rgba(255, 255, 255, 0.03)
        border.width: 1
        border.color: mouseArea.containsMouse ? Theme.glassBorder : Theme.glassBorderSubtle

        Behavior on color { ColorAnimation { duration: Theme.animMicro } }
        Behavior on border.color { ColorAnimation { duration: Theme.animMicro } }

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 5

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.symbol
                font.pixelSize: 11
                color: root.indicatorColor
                visible: root.showIndicator
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.value
                font.family: Theme.monoFontFamily
                font.pixelSize: 11
                font.weight: Font.Bold
                color: "#ffffff"
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    // Modern Liquid Glass Hover Tooltip
    Rectangle {
        id: tooltip
        visible: mouseArea.containsMouse && root.tooltipTitle.length > 0
        opacity: visible ? 1.0 : 0.0
        z: 999
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 8
        width: Math.max(tooltipCol.implicitWidth + 18, 75)
        height: tooltipCol.implicitHeight + 12
        radius: Theme.smallRadius
        color: Theme.glassMedium
        border.width: 1
        border.color: Theme.glassBorder

        Behavior on opacity {
            NumberAnimation { duration: Theme.animMicro; easing.type: Easing.OutCubic }
        }

        Column {
            id: tooltipCol
            anchors.centerIn: parent
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.tooltipTitle
                font.family: Theme.fontFamily
                font.pixelSize: 10
                font.weight: Font.Medium
                color: Theme.textMuted
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.tooltipDetail
                font.family: Theme.monoFontFamily
                font.pixelSize: 11
                font.weight: Font.Bold
                color: Theme.accent
            }
        }
    }
}
