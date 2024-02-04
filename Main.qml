import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Pdf

ApplicationWindow {
    id:root
    width: 640
    height: 480
    visible: true
    title: qsTr("Disciplinae")

    color: "#1A1A1A"
    Universal.theme: Universal.Dark

    menuBar: MenuBar {
            Menu {
                title: qsTr("&Project")
                Action {
                    text: qsTr("&New Project...")
                    shortcut: StandardKey.New
                }
                Action {
                    text: qsTr("&Open Project...")
                    shortcut: StandardKey.Open
                }
                Action {
                    text: qsTr("&Save")
                    shortcut: StandardKey.Save
                }
                Action {
                    text: qsTr("Save &As...")
                    shortcut: StandardKey.SaveAs
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

    PdfDocument {
        id: doc
        source: Qt.resolvedUrl(root.source)
        //onPasswordRequired: passwordDialog.open()
    }

    /*
    *  ---------
    *  | * |   |
    *  |   |   |
    *  ---------
    */
    ToolBar {
        id:tbar
        anchors.right: parent.horizontalCenter
        anchors.left: parent.left
        anchors.top: parent.top
        clip: true
        RowLayout {
            anchors.fill: parent
            anchors.rightMargin: 6
            ToolButton {
                action: Action {
                    text: "Open"
                    shortcut: StandardKey.Open
                    //icon.source: "qrc:/pdfviewer/resources/document-open.svg"
                    onTriggered: fileDialog.open()
                }
            }
            ToolButton {
                action: Action {
                    shortcut: StandardKey.ZoomIn
                    enabled: view.renderScale < 10
                    icon.source: "qrc:/pdfviewer/resources/zoom-in.svg"
                    onTriggered: view.renderScale *= Math.sqrt(2)
                }
            }
            ToolButton {
                action: Action {
                    shortcut: StandardKey.ZoomOut
                    enabled: view.renderScale > 0.1
                    icon.source: "qrc:/pdfviewer/resources/zoom-out.svg"
                    onTriggered: view.renderScale /= Math.sqrt(2)
                }
            }
            ToolButton {
                action: Action {
                    icon.source: "qrc:/pdfviewer/resources/zoom-fit-width.svg"
                    onTriggered: view.scaleToWidth(root.contentItem.width, root.contentItem.height)
                }
            }
            ToolButton {
                action: Action {
                    icon.source: "qrc:/pdfviewer/resources/zoom-fit-best.svg"
                    onTriggered: view.scaleToPage(root.contentItem.width, root.contentItem.height)
                }
            }
            ToolButton {
                action: Action {
                    shortcut: "Ctrl+0"
                    icon.source: "qrc:/pdfviewer/resources/zoom-original.svg"
                    onTriggered: view.resetScale()
                }
            }
            ToolButton {
                action: Action {
                    shortcut: "Ctrl+L"
                    icon.source: "qrc:/pdfviewer/resources/rotate-left.svg"
                    onTriggered: view.pageRotation -= 90
                }
            }
            ToolButton {
                action: Action {
                    shortcut: "Ctrl+R"
                    icon.source: "qrc:/pdfviewer/resources/rotate-right.svg"
                    onTriggered: view.pageRotation += 90
                }
            }
            ToolButton {
                action: Action {
                    icon.source: "qrc:/pdfviewer/resources/go-previous-view-page.svg"
                    enabled: view.backEnabled
                    onTriggered: view.back()
                }
                ToolTip.visible: enabled && hovered
                ToolTip.delay: 2000
                ToolTip.text: "go back"
            }
            SpinBox {
                id: currentPageSB
                from: 1
                to: doc.pageCount
                editable: true
                onValueModified: view.goToPage(value - 1)
                Shortcut {
                    sequence: StandardKey.MoveToPreviousPage
                    onActivated: view.goToPage(currentPageSB.value - 2)
                }
                Shortcut {
                    sequence: StandardKey.MoveToNextPage
                    onActivated: view.goToPage(currentPageSB.value)
                }
            }
            ToolButton {
                action: Action {
                    icon.source: "qrc:/pdfviewer/resources/go-next-view-page.svg"
                    enabled: view.forwardEnabled
                    onTriggered: view.forward()
                }
                ToolTip.visible: enabled && hovered
                ToolTip.delay: 2000
                ToolTip.text: "go forward"
            }
            ToolButton {
                action: Action {
                    text: "Select All"
                    shortcut: StandardKey.SelectAll
                    icon.source: "qrc:/pdfviewer/resources/edit-select-all.svg"
                    onTriggered: view.selectAll()
                }
            }
            ToolButton {
                action: Action {
                    shortcut: StandardKey.Copy
                    icon.source: "qrc:/pdfviewer/resources/edit-copy.svg"
                    enabled: view.selectedText !== ""
                    onTriggered: view.copySelectionToClipboard()
                }
            }
            Shortcut {
                sequence: StandardKey.Find
                onActivated: searchField.forceActiveFocus()
            }
            Shortcut {
                sequence: StandardKey.Quit
                onActivated: Qt.quit()
            }
        }
    }


    /*
    *  ---------
    *  |   |   |
    *  | * |   |
    *  ---------
    */
    PdfMultiPageView {
        id: view
        document: doc
        anchors.right: parent.horizontalCenter
        anchors.left: parent.left
        anchors.top: tbar.bottom
        anchors.bottom: parent.bottom
        clip: true
        //anchors.leftMargin: sidebar.position * sidebar.width
        //searchString: searchField.text
        //onCurrentPageChanged: currentPageSB.value = view.currentPage + 1
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Open a PDF file")
        nameFilters: [ "PDF files (*.pdf)" ]
        onAccepted: doc.source = selectedFile
    }

    DropArea { //from PdfMultiPageView example
        anchors.fill: view
        keys: ["text/uri-list"]
        onEntered: (drag) => {
                       drag.accepted = (drag.proposedAction === Qt.MoveAction || drag.proposedAction === Qt.CopyAction) &&
                       drag.hasUrls && drag.urls[0].endsWith("pdf")
                   }
        onDropped: (drop) => {
                       doc.source = drop.urls[0]
                       drop.acceptProposedAction()
                   }
    }

    /*
    *  ---------
    *  |   | * |
    *  |   |   |
    *  ---------
    */

    Row {
        id: colorTools
        anchors.right: parent.right
        anchors.left: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: canvas.top
        property color paintColor: "#33B5E5"
        spacing: 4
        /*Repeater {
            model: ["#33B5E5", "#99CC00", "#FFBB33", "#FF4444"]
            ColorSquare {
                color: modelData
                active: parent.paintColor === color
                onClicked: {
                    parent.paintColor = color
                }
            }
        }*/
    }

    Canvas {
        id: canvas
        anchors.right: parent.right
        anchors.left: parent.horizontalCenter
        anchors.top: colorTools.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 8
        property real lastX
        property real lastY
        property color color: colorTools.paintColor

        onPaint: {
            var ctx = getContext('2d')
            ctx.lineWidth = 1.5
            ctx.strokeStyle = canvas.color
            ctx.beginPath()
            ctx.moveTo(lastX, lastY)
            lastX = area.mouseX
            lastY = area.mouseY
            ctx.lineTo(lastX, lastY)
            ctx.stroke()
        }
        MouseArea {
            id: area
            anchors.fill: parent
            onPressed: {
                canvas.lastX = mouseX
                canvas.lastY = mouseY
            }
            onPositionChanged: {
                canvas.requestPaint()
            }
        }
    }
}
