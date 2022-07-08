import QtQuick

Item {
    anchors.fill: parent

    Rectangle {
        id: leftRect
        width: parent.width * (1/5)
        height: parent.height * (19/20)
        color: "gray"
        z: 0
        anchors {
            left:parent.left
            bottom: parent.bottom
        }

        //--------------------------------------------------------------------------------

        Rectangle {
            id: drag_area
            width: m_model.getBorderWidth()
            color: "#8FCAF9"
            z: 1
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SplitHCursor
                hoverEnabled: true
                property int oldMouseX

                onPressed: {
                    oldMouseX = mouseX
                }

                onPositionChanged: {
                    if (pressed) {
                        leftRect.width = leftRect.width + (mouseX - oldMouseX)
                        rightRect.width = rightRect.width - (mouseX - oldMouseX)

                        if(leftRect.width < m_model.getBorderWidth()*3)
                        {
                            leftRect.width = m_model.getBorderWidth()*3
                            rightRect.width = mainWindow.maxWidth - m_model.getBorderWidth()*3
                        }
                        else if (rightRect.width < m_model.getBorderWidth()*3)
                        {
                            rightRect.width = m_model.getBorderWidth()*3
                            leftRect.width = mainWindow.maxWidth - m_model.getBorderWidth()*3
                        }
                    }
                }
            }
        }

        //--------------------------------------------------------------------------------

        Rectangle {
            id: due_today
            color: state_view.selectedState === "due_today" ? "#91B9DA" : (today_mouse_area.containsMouse? "#A7C2D9" : "#E6F4F4")
            height: m_model.getBorderWidth() * 1.5
            width: parent.width - m_model.getBorderWidth() * 2
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
            }

            Text {
                anchors.fill: parent
                font.pixelSize: m_model.getBorderWidth() * 0.8
                padding: m_model.getBorderWidth() * 0.2
                text: "Due Today"
            }

            MouseArea {
                id: today_mouse_area
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    m_model.callSql(dbmanager.allTableTodayQuery())
                    tableLoader.source = "DeckTableView2.qml"

                    decklist.selectedIndex = -2
                    state_view.selectedState = "due_today"
                }
            }
        }

        //--------------------------------------------------------------------------------

        Rectangle{
            id: card_state
            color: "#BBDDF8"
            height: state_view.minimized? m_model.getBorderWidth() * 1.5 : parent.height * (3/10)
            anchors {
                top: due_today.bottom
                right: parent.right
                left: parent.left
            }

            Rectangle {
                id: minimize_state
                height: m_model.getBorderWidth() * 1.5
                width: m_model.getBorderWidth()
                color: min_state_area.containsMouse? "#51979F" : "black"
                anchors{
                    top: parent.top
                    left: parent.left
                }

                MouseArea {
                    id: min_state_area
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        state_view.minimized = !state_view.minimized
                    }
                }
            }

            Rectangle {
                id: state_bar
                height: m_model.getBorderWidth() * 1.5
                color: statebar_mouse_area.containsMouse? "#A7C2D9" : "#E6F4F4"
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right

                    leftMargin: m_model.getBorderWidth()
                    rightMargin: m_model.getBorderWidth()
                }

                Text {
                    anchors.fill: parent
                    font.pixelSize: m_model.getBorderWidth() * 0.8
                    padding: m_model.getBorderWidth() * 0.2
                    text: "Card State"
                }

                MouseArea {
                    id: statebar_mouse_area
                    anchors.fill: parent
                    hoverEnabled: true

                }
            }

            Rectangle {
                id: state_view
                property bool minimized: false
                color: "#BBDDF8"
                height: parent.height - m_model.getBorderWidth() * 2
                width: state_bar.width - m_model.getBorderWidth()
                anchors {
                    top: state_bar.bottom
                    right: parent.right

                    bottom: minimized? parent.top : parent.bottom
                    leftMargin: m_model.getBorderWidth()
                    rightMargin: m_model.getBorderWidth()
                }

                property string selectedState : ""
                ListView {
                    anchors.fill: parent
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    model: ListModel {
                        ListElement {name: "New"}
                        ListElement {name: "Review"}
                        ListElement {name: "Suspended"}
                        //ListElement {name: "Buried"}
                    }

                    delegate: Rectangle {
                        height: m_model.getBorderWidth() * 1.5
                        width: deckbar.width
                        color: state_view.selectedState === name ? "#91B9DA"  : (stateview_mouse_area.containsMouse? "#A7C2D9" : "#E6F4F4")
                        Text {
                            anchors.fill: parent
                            font.pixelSize: m_model.getBorderWidth() * 0.8
                            padding: m_model.getBorderWidth() * 0.2
                            text: name
                        }

                        MouseArea {
                            id: stateview_mouse_area
                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: {
                                tableLoader.source = "DeckTableView2.qml"
                                m_model.callSql(dbmanager.allTableQuery(name))
                                decklist.selectedIndex = -2
                                state_view.selectedState = name
                            }
                        }
                    }
                }
            }
        }

        //--------------------------------------------------------------------------------

        Rectangle {
            id: decklist
            color: "#BBDDF8"
            anchors {
                top: card_state.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            property int selectedIndex: -2

            Rectangle {
                id: minimize_decklist
                height: m_model.getBorderWidth() * 1.5
                width: m_model.getBorderWidth()
                color: min_decklist_area.containsMouse? "#51979F" : "gray"
                anchors{
                    top: parent.top
                    left: parent.left
                }

                MouseArea {
                    id: min_decklist_area
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        deckview.minimized = !deckview.minimized
                    }
                }
            }

            Rectangle {
                id: deckbar
                height: m_model.getBorderWidth() * 1.5
                color: -1 === decklist.selectedIndex ? "#91B9DA" : (deckbar_mouse_area.containsMouse? "#A7C2D9" : "#E6F4F4")
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right

                    leftMargin: m_model.getBorderWidth()
                    rightMargin: m_model.getBorderWidth()
                }

                Text {
                    anchors.fill: parent
                    font.pixelSize: m_model.getBorderWidth() * 0.8
                    padding: m_model.getBorderWidth() * 0.2
                    text: "Decks"
                }

                MouseArea {
                    id: deckbar_mouse_area
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        decklist.selectedIndex = -1
                        state_view.selectedState = ""
                        tableLoader.source = "DeckTableView2.qml"
                        m_model.callSql(dbmanager.allTableQuery())
                        dbmanager.set_selected_table("")
                    }
                }
            }

            Rectangle {
                id: deckview
                color: "#BBDDF8"
                width: deckbar.width - m_model.getBorderWidth()
                property bool minimized: false
                anchors {
                    top: deckbar.bottom
                    right: parent.right
                    bottom: minimized? parent.top : parent.bottom

                    leftMargin: m_model.getBorderWidth()
                    rightMargin: m_model.getBorderWidth()
                }

                ListView {
                    id: deck_listview
                    anchors.fill: parent
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: m_deckListModel
                    delegate: Rectangle {
                        height: m_model.getBorderWidth() * 1.5
                        width: deckbar.width
                        color: index === decklist.selectedIndex ? "#91B9DA" : (deck_mouse_area.containsMouse? "#A7C2D9" : "#E6F4F4")
                        Text {
                            anchors.fill: parent
                            font.pixelSize: m_model.getBorderWidth() * 0.8
                            padding: m_model.getBorderWidth() * 0.2
                            text: display
                        }

                        MouseArea {
                            id: deck_mouse_area
                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: {
                                decklist.selectedIndex = index
                                state_view.selectedState = ""
                                m_model.callSql("SELECT * FROM " + display)
                                dbmanager.set_selected_table(display)
                                tableLoader.source = "DeckTableView.qml"
                            }
                        }
                    }
                }
            }
        }

        //--------------------------------------------------------------------------------

    }


    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------


    Rectangle {
        id: rightRect
        height: parent.height * (19/20)
        width: parent.width * (4/5)
        color: "teal"//"#E2F7F7"
        z: 0
        anchors {
            //top: parent.top
            right:parent.right
            bottom: parent.bottom
        }

        Rectangle {
            id: options
            height: parent.height * (1/20)
            anchors {
                right: parent.right
                left: parent.left
            }

            Rectangle{
                id: add_card
                color: add_area.containsMouse? "#51979F" : "#1669B2"
                width: parent.width / 5
                clip: true
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                border.color: "gray"
                border.width: m_model.getBorderWidth() / 4
                Text {
                    text: "Add"
                    font.pixelSize: parent. height * (2/3)
                    anchors.centerIn: parent
                }
                MouseArea {
                    id: add_area
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        dbmanager.add_card()
                        tableLoader.source = ""
                        dbmanager.reload_m_model()
                        tableLoader.source = "DeckTableView.qml"
                    }
                }
            }

            Rectangle{
                id: delete_card
                color: delete_area.containsMouse? "#51979F" : "#1669B2"
                width: parent.width / 5
                clip: true
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: add_card.right
                }
                border.color: "gray"
                border.width: m_model.getBorderWidth() / 4
                Text {
                    text: "Delete"
                    font.pixelSize: parent. height * (2/3)
                    anchors.centerIn: parent
                }
                MouseArea {
                    id: delete_area
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        dbmanager.remove_cards()
                        tableLoader.source = ""
                        dbmanager.reload_m_model()
                        tableLoader.source = "DeckTableView.qml"
                    }
                }
            }

            Rectangle{
                id: reset_card
                color: reset_area.containsMouse? "#51979F" : "#1669B2"
                width: parent.width / 5
                clip: true
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: delete_card.right
                }
                border.color: "gray"
                border.width: m_model.getBorderWidth() / 4
                Text {
                    text: "Reset"
                    font.pixelSize: parent. height * (2/3)
                    anchors.centerIn: parent
                }
                MouseArea {
                    id: reset_area
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        dbmanager.reset_cards()
                        tableLoader.source = ""
                        dbmanager.reload_m_model()
                        tableLoader.source = "DeckTableView.qml"
                    }
                }
            }

            Rectangle{
                id: suspend_card
                color: suspend_area.containsMouse? "#51979F" : "#1669B2"
                width: parent.width / 5
                clip: true
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: reset_card.right
                }
                border.color: "gray"
                border.width: m_model.getBorderWidth() / 4

                Text {
                    text: "Suspend"
                    font.pixelSize: parent. height * (2/3)
                    anchors.centerIn: parent
                }
                MouseArea {
                    id: suspend_area
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        dbmanager.suspend_cards()
                        tableLoader.source = ""
                        dbmanager.reload_m_model()
                        tableLoader.source = "DeckTableView.qml"
                    }
                }
            }

            Rectangle{
                id: unsuspend
                color: unsuspend_area.containsMouse? "#51979F" : "#1669B2"
                width: parent.width / 5
                clip: true
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: suspend_card.right
                }
                border.color: "gray"
                border.width: m_model.getBorderWidth() / 4
                Text {
                    text: "Unsuspend"
                    font.pixelSize: parent. height * (2/3)
                    anchors.centerIn: parent
                }
                MouseArea {
                    id: unsuspend_area
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        dbmanager.unsuspend_cards()
                        tableLoader.source = ""
                        dbmanager.reload_m_model()
                        tableLoader.source = "DeckTableView.qml"
                    }
                }
            }
        }

        Rectangle{
            id: upperRightRect
            height: parent.height * (9.5/20)
            color: "#6393B9"
            anchors {
                top: options.bottom
                right: parent.right
                left: parent.left
            }

            Rectangle {
                id: tableRect
                color: "#EAF9F9"
                z: 1
                anchors {
                    top: parent.top
                    right: parent.right
                    left: parent.left
                    bottom: parent.bottom

                    leftMargin: m_model.getBorderWidth()
                    rightMargin: m_model.getBorderWidth()
                    topMargin: m_model.getBorderWidth() / 2
                    bottomMargin: m_model.getBorderWidth() / 2
                }

                Loader {
                    id: tableLoader
                    anchors.fill: parent
                    source: "DeckTableView2.qml"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            card_loader.source = ""
                            card_loader.source = "CardListView.qml"
                        }
                    }
                }
            }
        }
        Rectangle {
            id: lowerRightRect
            height: parent.height * (9.5/20)
            width: rightRect.width
            color: "#6393B9"
            anchors {
                right: parent.right
                bottom: parent.bottom
            }

            Rectangle {
                id: fieldRect
                color: "#6393B9"
                z: 1
                anchors {
                    fill: parent

                    leftMargin: m_model.getBorderWidth()
                    rightMargin: m_model.getBorderWidth()
                    topMargin: m_model.getBorderWidth() / 2
                    bottomMargin: m_model.getBorderWidth() / 2
                }
                Loader{
                    id: card_loader
                    anchors.fill: parent
                    source: "CardListView.qml"
                }
            }
        }
    }
}
