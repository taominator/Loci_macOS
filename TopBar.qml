import QtQuick

Rectangle {

    property string page: "homescreen.qml"

    height: parent.height * (1/19)
    anchors {
        left: parent.left
        right: parent.right
        top: parent.top
    }

    Rectangle {
        id: home_button
        clip: true
        width: parent.width/6
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        color: home_area.containsMouse? "#51979F" : "#838383"
        MouseArea {
            id: home_area
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                page = "homescreen.qml"
            }
        }
        Text {
            text: "Home"
            anchors.centerIn: parent
            font.pixelSize: m_model.getBorderWidth()
        }
    }

    Rectangle {
        id: deck_button
        clip: true
        width: parent.width/6
        anchors {
            left: home_button.right
            top: parent.top
            bottom: parent.bottom
        }
        color: deck_area.containsMouse? "#51979F" : "#B4B5B7"
        MouseArea {
            id: deck_area
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                page = "deckscreen.qml"
            }
        }
        Text {
            text: "Browse"
            anchors.centerIn: parent
            font.pixelSize: m_model.getBorderWidth()
        }
    }

    Rectangle {
        id: preview_button
        clip: true
        width: parent.width/6
        anchors {
            left: deck_button.right
            top: parent.top
            bottom: parent.bottom
        }
        color: preview_area.containsMouse? "#51979F" : "#838383"
        MouseArea {
            id: preview_area
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                page = "previewscreen.qml"
            }
        }
        Text {
            text: "Preview Card"
            anchors.centerIn: parent
            font.pixelSize: m_model.getBorderWidth()
        }
    }

    Rectangle {
        id: edit_button
        clip: true
        width: parent.width/6
        anchors {
            left: preview_button.right
            top: parent.top
            bottom: parent.bottom
        }
        color: edit_area.containsMouse? "#51979F" : "#B4B5B7"
        MouseArea {
            id: edit_area
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                page = "deckedit.qml"
            }
        }
        Text {
            text: "Edit decks"
            anchors.centerIn: parent
            font.pixelSize: m_model.getBorderWidth()
        }
    }

    Rectangle {
        id: search_button
        clip: true
        anchors {
            left: edit_button.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        color: "#838383"
        //MouseArea {
        //    anchors.fill: parent
        //    cursorShape: Qt.PointingHandCursor
        //    onClicked: {

        //    }
        //}
    }

}
