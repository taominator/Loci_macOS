import QtQuick 2.0

Item {
    anchors.fill: parent

    property bool is_visible: false
    property bool next: false

    Rectangle {
        id: back_bar
        color: "#5F7A93"
        height: parent.height * (2/20)
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        Text {
            anchors.centerIn: parent
            text: "Back"
            font.pixelSize: parent.height / 3
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                is_visible = !is_visible
            }
        }
    }

    Rectangle {
        id: page_content
        height: parent.height * (18/20)

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }


        Rectangle {
            id: card_side
            color: "teal"
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: button_bar.top
            }

            property bool show_front: true
            ListView {
                id: review_view
                anchors.fill: parent

                model: card_model

                delegate: Rectangle {
                    height: dbmanager.get_height(card_side.show_front, model.row)
                    color: "#1777CB"
                    clip: true
                    width: review_view.width

                    Text {
                        height: parent.height / 2
                        anchors.centerIn: parent
                        //anchors {
                        //    left: parent.left
                        //    right: parent.right
                        //    top: parent.top
                        //}
                        text: content
                        font.pixelSize: parent.height * (1/3)
                    }
                }
            }
        }

        Rectangle {
            id: show_bar
            color: "cyan"
            height: parent.height * (1/10)
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            visible: true

            Text {
                anchors.centerIn: parent
                text: "Show Answer"
                font.pixelSize: parent.height / 3
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    show_bar.visible = !show_bar.visible
                    button_bar.visible = !button_bar.visible

                    card_side.show_front = false
                    review_view.forceLayout()
                }
            }
        }

        Rectangle {
            id: button_bar
            color: "green"
            height: parent.height * (1/10)
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            visible: false



            Rectangle {
                id: again_button
                width: parent.width / 4
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                color: "orange"
                Text {
                    anchors.centerIn: parent
                    text: "Again"
                    font.pixelSize: parent.height / 3
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        dbmanager.againButton()
                        is_visible = !is_visible
                        next = !next
                    }
                }
            }

            Rectangle {
                id: hard_button
                width: parent.width / 4
                anchors {
                    left: again_button.right
                    top: parent.top
                    bottom: parent.bottom
                }
                color: "yellow"
                Text {
                    anchors.centerIn: parent
                    text: "Hard"
                    font.pixelSize: parent.height / 3
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        dbmanager.hardButton()
                        is_visible = !is_visible
                        next = !next
                    }
                }
            }

            Rectangle {
                id: good_button
                width: parent.width / 4
                anchors {
                    left: hard_button.right
                    top: parent.top
                    bottom: parent.bottom
                }
                color: "lime"
                Text {
                    anchors.centerIn: parent
                    text: "Good"
                    font.pixelSize: parent.height / 3
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        dbmanager.goodButton()
                        is_visible = !is_visible
                        next = !next
                    }
                }
            }

            Rectangle {
                id: easy_button
                width: parent.width / 4
                anchors {
                    left: good_button.right
                    top: parent.top
                    bottom: parent.bottom
                }
                color: "blue"
                Text {
                    anchors.centerIn: parent
                    text: "Easy"
                    font.pixelSize: parent.height / 3
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        dbmanager.easyButton()
                        is_visible = !is_visible
                        next = !next
                    }
                }
            }
        }
    }
}
