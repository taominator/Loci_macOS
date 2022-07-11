import QtQuick
import QtQuick.Controls

Item {
    anchors.fill: parent

    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        model: card_model

        property string deckname
        property string card_id
        property string question_content
        property string answer_content
        delegate: Rectangle {

            height: index < m_model.getNumInternalFields() ? 0 : m_model.getBorderWidth() * 4
            clip: true
            z: 10
            width: listView.width

            Rectangle {
                height: m_model.getBorderWidth() * 2
                color: "#D5E9F9"
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
            }

            Rectangle {
                height: m_model.getBorderWidth() * 2
                color: "#90CBFC"
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
            }

            Text {
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
                padding: m_model.getBorderWidth() / 2
                font.pixelSize: parent.height * (1/5)
                text: "Field: " + field
            }

            property string original_content
            TextField {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                padding: m_model.getBorderWidth() / 2
                font.pixelSize: parent.height * (1/5)
                text: content
                placeholderText: qsTr("Enter field content here")
                background: Rectangle {
                    opacity: 0
                }

                onEditingFinished: {
                    if (parent.original_content == listView.question_content) {
                        dbmanager.updateQuestion(listView.deckname, listView.card_id, field, text)
                    }
                    else if(parent.original_content == listView.answer_content) {
                        dbmanager.updateAnswer(listView.deckname, listView.card_id, field, text)
                    }
                    else {
                        dbmanager.updateFieldContent(listView.deckname, listView.card_id, field, text)
                    }
                }
            }


            Component.onCompleted: {
                original_content = content
                if (field === "deckname") {
                    listView.deckname = content
                }
                else if (field === "id") {
                    listView.card_id = content
                }
                else if(field === "Question") {
                    listView.question_content = content
                }
                else if (field === "Answer") {
                    listView.answer_content = content
                }
            }
        }
    }
}
