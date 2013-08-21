import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

Page {
    property alias loader: gameLoader

    NoGame {
        anchors.fill: parent
        visible: gameLoader.status !== Loader.Ready
    }

    Loader {
        x: 0
        y: 0
        id: gameLoader
        source: ""
        //TODO: load asynchronous gives problem with the repeater adding and removing items
        //asynchronous: true
        //visible: status == Loader.Ready
    }

    Binding {
        target: gameLoader.item
        property: "parentWidth"
        value: width
    }

    Binding {
        target: gameLoader.item
        property: "parentHeight"
        value: height
    }

    Connections {
        target: gameLoader.item
        onEnd: {
            setStats(gamesModel.get(selectedGameIndex).dbName, won)
            PopupUtils.open("EndDialog.qml", gamePage, {"won":won})
        }
    }

    tools: ToolbarItems {
        ToolbarButton {
            text: "undo"
            enabled: gameLoader.item?gameLoader.item.hasPreviousMove:false
            onTriggered: {
                gameLoader.item.undo()
            }
        }
        ToolbarButton {
            text: "redo"
            enabled: gameLoader.item?gameLoader.item.hasNextMove:false
            onTriggered: {
                gameLoader.item.redo()
            }
        }
        ToolbarButton {
            text: "new game"
            onTriggered: {
                newGame()
            }
        }
        ToolbarButton {
            text: "restart"
            onTriggered: {
                restartGame()
            }
        }
    }
}