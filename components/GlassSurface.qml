import QtQuick
import "../Theme.js" as Theme

Rectangle {
    id: root

    // Level 1 = TopBar, indicators (Soft glass)
    // Level 2 = Popups, audio, wifi (Medium glass)
    // Level 3 = Control center, launcher, notification center, settings (Strong glass)
    property int level: 1
    property color customColor: "transparent"
    property real customOpacity: 1.0
    property color customBorderColor: "transparent"
    property real customRadius: -1

    radius: customRadius >= 0 ? customRadius : (level === 1 ? Theme.radius : (level === 2 ? Theme.radius : Theme.largeRadius))
    
    // Deep dark base color that completely prevents desktop windows/editor text from bleeding through
    color: customColor !== "transparent" 
        ? customColor 
        : (level === 1 ? Theme.glassSoft : (level === 2 ? Theme.glassMedium : Theme.glassStrong))

    opacity: customOpacity

    border.width: 1
    border.color: customBorderColor !== "transparent" 
        ? customBorderColor 
        : (level === 1 ? Theme.glassBorder : (level === 2 ? Theme.glassBorder : Theme.glassBorderStrong))

    // Top specular highlight line for physical liquid glass depth
    Rectangle {
        id: specularHighlight
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 1
        anchors.leftMargin: root.radius > 0 ? Math.min(root.radius, 14) : 2
        anchors.rightMargin: root.radius > 0 ? Math.min(root.radius, 14) : 2
        height: 1
        radius: 0.5
        color: Theme.glassHighlight
    }
}
