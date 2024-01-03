import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id:root
    width: 640
    height: 480
    visible: true
    title: qsTr("Disciplinae")

    menuBar: MenuBar {
            Menu {
                title: qsTr("&Project")
                Action {
                    text: qsTr("&New...")
                }

                Action {
                    text: qsTr("&Open...")
                }

                Action {
                    text: qsTr("&Save")
                }

                Action {
                    text: qsTr("Save &As...")
                }

                MenuSeparator { }

                Action {
                    text: qsTr("&Quit")
                    shortcut: StandardKey.Quit
                    onTriggered: Qt.quit()
                }
            }
            Menu {
                title: qsTr("&Edit")
                Action {
                    text: qsTr("&Cut")
                }

                Action {
                    text: qsTr("&Copy")
                }

                Action {
                    text: qsTr("&Paste")
                }
            }
            Menu {
                title: qsTr("&Help")
                Action  { text: qsTr("&About") }
            }
            Menu {
                title: qsTr("&Test")
                Menu {
                    title: qsTr("&Test")
                    Action { text: qsTr("&Test") }
                }
            }
    }
}
