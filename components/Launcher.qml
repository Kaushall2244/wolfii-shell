import QtQuick
import Quickshell
import Quickshell.Widgets
import "../Theme.js" as Theme

Item {
    id: root

    property bool isOpen: false
    property string searchText: ""
    property int selectedIndex: 0

    signal closeRequested()

    width: 620
    height: 460
    clip: true

    visible: opacity > 0.001
    opacity: isOpen ? 1.0 : 0.0
    scale: isOpen ? 1.0 : 0.96
    y: isOpen ? 0 : -16

    Behavior on opacity { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }
    Behavior on scale { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }
    Behavior on y { NumberAnimation { duration: Theme.animPopup; easing.type: Easing.OutCubic } }

    onIsOpenChanged: {
        if (isOpen) {
            searchText = "";
            selectedIndex = 0;
            searchInput.text = "";
            searchInput.forceActiveFocus();
        }
    }

    // Filtered application list
    readonly property var filteredApps: {
        var all = DesktopEntries.applications.values || [];
        var query = root.searchText.toLowerCase().trim();
        if (query.length === 0) {
            return all.slice(0, 30);
        }
        var matches = [];
        for (var i = 0; i < all.length; i++) {
            var app = all[i];
            var name = (app.name || "").toLowerCase();
            var comment = (app.comment || "").toLowerCase();
            var id = (app.id || "").toLowerCase();
            if (name.includes(query) || comment.includes(query) || id.includes(query)) {
                matches.push(app);
            }
        }
        return matches.slice(0, 30);
    }

    GlassSurface {
        anchors.fill: parent
        level: 3
        clip: true

        Column {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            // Search Bar Input
            Rectangle {
                width: parent.width
                height: 48
                radius: Theme.cardRadius
                color: Theme.surfaceCard
                border.width: 1
                border.color: searchInput.activeFocus ? Theme.accentGlow : Theme.glassBorderSubtle

                Behavior on border.color { ColorAnimation { duration: Theme.animMicro } }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    spacing: 12

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "󰍉"
                        font.pixelSize: 18
                        color: searchInput.activeFocus ? Theme.accent : Theme.textMuted
                    }

                    TextInput {
                        id: searchInput
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 50
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        color: Theme.text
                        clip: true
                        selectionColor: Theme.accentSoft
                        selectedTextColor: Theme.accent

                        Text {
                            text: "Type to search applications..."
                            font.family: Theme.fontFamily
                            font.pixelSize: 14
                            color: Theme.textDim
                            visible: !searchInput.text && !searchInput.activeFocus
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        onTextChanged: {
                            root.searchText = text;
                            root.selectedIndex = 0;
                        }

                        Keys.onDownPressed: {
                            if (root.selectedIndex < root.filteredApps.length - 1) {
                                root.selectedIndex++;
                                appListView.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                            }
                        }

                        Keys.onUpPressed: {
                            if (root.selectedIndex > 0) {
                                root.selectedIndex--;
                                appListView.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                            }
                        }

                        Keys.onReturnPressed: {
                            if (root.filteredApps.length > 0 && root.selectedIndex >= 0 && root.selectedIndex < root.filteredApps.length) {
                                root.filteredApps[root.selectedIndex].execute();
                                root.closeRequested();
                            }
                        }

                        Keys.onEscapePressed: {
                            root.closeRequested();
                        }
                    }
                }
            }

            // Results List
            ListView {
                id: appListView
                width: parent.width
                height: 360
                clip: true
                spacing: 4
                model: root.filteredApps

                delegate: AnimatedButton {
                    id: appItem
                    width: appListView.width
                    height: 50
                    cornerRadius: Theme.smallRadius
                    defaultBg: root.selectedIndex === index ? Theme.accentSoft : "transparent"
                    hoverBg: root.selectedIndex === index ? Qt.rgba(204/255, 255/255, 0/255, 0.22) : Theme.surfaceHover
                    active: root.selectedIndex === index
                    activeBorderColor: Theme.accentGlow

                    onClicked: {
                        modelData.execute();
                        root.closeRequested();
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 12

                        // App Icon
                        IconImage {
                            anchors.verticalCenter: parent.verticalCenter
                            source: modelData.icon || "application-x-executable"
                            width: 30
                            height: 30
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            width: parent.width - 50

                            Text {
                                text: modelData.name || ""
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                font.weight: root.selectedIndex === index ? Font.Bold : Font.DemiBold
                                color: root.selectedIndex === index ? Theme.accent : Theme.text
                                elide: Text.ElideRight
                                width: parent.width
                            }

                            Text {
                                text: modelData.comment || modelData.genericName || ""
                                font.family: Theme.fontFamily
                                font.pixelSize: 10
                                color: Theme.textMuted
                                elide: Text.ElideRight
                                width: parent.width
                                visible: text.length > 0
                            }
                        }
                    }
                }
            }
        }
    }
}
