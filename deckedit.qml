import QtQuick
import QtQuick.Controls

Item {
    anchors.fill: parent

    Rectangle {
        id: page_content
        height: parent.height * (19/20)
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Rectangle {
            id: edit_deck
            height: parent.height * (4/10)
            anchors{
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Rectangle {
                color: "#9CCCF4"
                id: add_delete_deck
                height: parent.height / 3
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                Text {
                    anchors.centerIn: parent
                    text: "Add / Delete Deck"
                    font.pixelSize: parent.height * (1/3)
                }
            }

            Rectangle {
                id: deck_deckname
                height: parent.height / 3
                anchors {
                    top: add_delete_deck.bottom
                    left: parent.left
                    right: parent.right
                }

                Rectangle {
                    color: "#69B3F1"
                    id: placeholder_deck
                    width: parent.width / 5
                    anchors {
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Deckname: "
                        font.pixelSize: parent.height * (1/4)
                    }

                }

                Rectangle {
                    color: "#69B3F1"
                    id: deckinput_deck
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        right: parent.right
                        left: placeholder_deck.right
                    }

                    TextField {
                        id: deck_deck_input
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                        }
                        font.pixelSize: parent.height * (1/4)
                        placeholderText: qsTr("Enter deckname here")
                        background: Rectangle {
                            opacity: 0
                        }
                    }
                }

            }

            Rectangle {
                color: "blue"
                id: buttons_deck
                anchors {
                    top: deck_deckname.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                Rectangle {
                    color: add_deck_area.containsMouse? "#51979F" : "#0276D6"
                    id: add_deck
                    width: parent.width / 2
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "Add Deck"
                        font.pixelSize: parent.height / 4
                    }
                    MouseArea {
                        id: add_deck_area
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            dbmanager.create_table(deck_deck_input.text)
                        }
                    }
                }

                Rectangle {
                    color: delete_deck_area.containsMouse? "#51979F" : "#316A99"
                    id: delete_deck
                    width: parent.width / 2
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: add_deck.right
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "Delete Deck"
                        font.pixelSize: parent.height / 4
                    }
                    MouseArea {
                        id: delete_deck_area
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            dbmanager.drop_table(deck_deck_input.text)
                        }
                    }
                }
            }
        }


        Rectangle {
            color: "indigo"
            id: field_rect
            anchors {
                top: edit_deck.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Rectangle {
                color: "#9CCCF4"
                id: add_delete_field
                height: parent.height / 4
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                Text {
                    anchors.centerIn: parent
                    text: "Add / Delete Field"
                    font.pixelSize: parent.height * (1/3)
                }
            }

            Rectangle {
                id: field_fieldname
                height: parent.height / 4
                anchors {
                    top: add_delete_field.bottom
                    left: parent.left
                    right: parent.right
                }

                Rectangle {
                    color: "#558FBF"
                    id: placeholder_field
                    width: parent.width / 5
                    anchors {
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Fieldname: "
                        font.pixelSize: parent.height * (1/4)
                    }

                }

                Rectangle {
                    color: "#558FBF"
                    id: fieldinput_field
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        right: parent.right
                        left: placeholder_field.right
                    }

                    TextField {
                        id: field_field_input
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                        }
                        font.pixelSize: parent.height * (1/4)
                        placeholderText: qsTr("Enter fieldname here")
                        background: Rectangle {
                            opacity: 0
                        }
                    }
                }

            }

            Rectangle {
                id: field_deckname
                height: parent.height / 4
                anchors {
                    top: field_fieldname.bottom
                    left: parent.left
                    right: parent.right
                }

                Rectangle {
                    color: "#69B3F1"
                    id: placeholder_deck_field
                    width: parent.width / 5
                    anchors {
                        top: parent.top
                        left: parent.left
                        bottom: parent.bottom
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Deckname: "
                        font.pixelSize: parent.height * (1/4)
                    }

                }

                Rectangle {
                    color: "#69B3F1"
                    id: deckinput_field
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        right: parent.right
                        left: placeholder_deck_field.right
                    }

                    TextField {
                        id: field_deck_input
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                        }
                        font.pixelSize: parent.height * (1/4)
                        placeholderText: qsTr("Enter deckname here")
                        background: Rectangle {
                            opacity: 0
                        }
                    }
                }

            }

            Rectangle {
                id: buttons_field
                anchors {
                    top: field_deckname.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                Rectangle {
                    color: add_field_area.containsMouse? "#51979F" : "#0276D6"
                    id: add_field
                    width: parent.width / 2
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "Add Field"
                        font.pixelSize: parent.height / 4
                    }
                    MouseArea {
                        id: add_field_area
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            dbmanager.create_field(field_deck_input.text, field_field_input.text)
                        }
                    }
                }

                Rectangle {
                    color: delete_field_area.containsMouse? "#51979F" : "#316A99"
                    id: delete_field
                    width: parent.width / 2
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: add_field.right
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "Delete field"
                        font.pixelSize: parent.height / 4
                    }
                    MouseArea {
                        id: delete_field_area
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            dbmanager.drop_field(field_deck_input.text, field_field_input.text)
                        }
                    }
                }
            }
        }
    }
}
