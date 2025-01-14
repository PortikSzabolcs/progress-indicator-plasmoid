import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0

Item {
  id: root

  property var goal: 100
  property var currentProgress: 0
  property var taskName: null

  Plasmoid.compactRepresentation: RowLayout {
    id: compactLayout
    anchors.verticalCenter: parent.verticalCenter
    Layout.minimumWidth: compactLayout.implicitWidth
    Layout.minimumHeight: 10
    Layout.preferredWidth: 250 * PlasmaCore.Units.devicePixelRatio
    Layout.preferredHeight: 10 * PlasmaCore.Units.devicePixelRatio
      
    PlasmaComponents.Label {
      text: taskName ? taskName + ":" : goal + "/" + currentProgress
    }
    
    PlasmaComponents.ProgressBar {
      id: progressBar
      value: currentProgress / goal
      Layout.fillWidth: true
    }

    PlasmaComponents.Label {
      text: Math.round(currentProgress / goal * 100) + "%"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: plasmoid.expanded = !plasmoid.expanded
    }
  }
  
  Plasmoid.fullRepresentation: ColumnLayout {
      id: mainLayout
      Layout.minimumWidth: implicitWidth + 10
      Layout.minimumHeight: implicitHeight + 10
      Layout.preferredWidth: 300 * PlasmaCore.Units.devicePixelRatio
      Layout.preferredHeight: 220 * PlasmaCore.Units.devicePixelRatio
      anchors.margins: 6
      spacing: 16

      PlasmaExtras.Heading {
        level: 1
        text: "Progress tracker"
      }
      RowLayout {

        PlasmaComponents.Label {
          text: Math.round(currentProgress / goal * 100) + "%"
        }
        PlasmaComponents.ProgressBar {
          id: progressBar
          value: currentProgress / goal
          Layout.fillWidth: true
        }
        PlasmaComponents.Label {
          text: currentProgress + "/" + goal
        }
      }
      RowLayout {
        spacing: 10

        ColumnLayout {
          PlasmaComponents.Label {
            text: "Task name"
          }
          PlasmaComponents.TextField {
            id: taskField
            placeholderText: "Optional"
            text: taskName
            Layout.fillWidth: true
            onEditingFinished: {
              taskName = taskField.text
            }
          }
        }
        ColumnLayout {
          PlasmaComponents.Label {
            text: "Task goal"
          }
          PlasmaComponents.TextField {
            id: goalField
            placeholderText: "Goal"
            text: goal
            Layout.fillWidth: true
            onEditingFinished: {
              goal = parseFloat(goalField.text)
            }
            validator: IntValidator {
              bottom: 0
              top: 10000
            }
          }
        }
      }
      ColumnLayout {
        PlasmaComponents.Label {
          text: "Current progress"
        }
        RowLayout {
          PlasmaComponents.Button {
            icon.name: "remove"
            ToolTip.text: "Decrement"
            onClicked: {
              if (currentProgress > 0) currentProgress--
            }
          }
          PlasmaComponents.TextField {
            id: currentField
            placeholderText: "Current"
            text: currentProgress
            Layout.fillWidth: true
            onEditingFinished: {
              currentProgress = parseFloat(currentField.text)
            }
            validator: IntValidator {
            bottom: 0
            top: 10000
          }
          }
          PlasmaComponents.Button {
            icon.name: "gtk-add"
            ToolTip.text: "Increment"
            onClicked: {
              currentProgress++
            }
          }
        }
      }
  }

}
