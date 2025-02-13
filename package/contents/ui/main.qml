import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0

Item {
    Plasmoid.compactRepresentation: RowLayout {
        id: compactLayout
        anchors.verticalCenter: parent.verticalCenter
        Layout.minimumWidth: compactLayout.implicitWidth
        Layout.minimumHeight: 10
        Layout.preferredWidth: 250
        Layout.preferredHeight: 10

        PlasmaComponents.Label {
            text: plasmoid.configuration.taskName ? plasmoid.configuration.taskName + ":" : plasmoid.configuration.targetValue + "/" + plasmoid.configuration.currentValue
        }

        PlasmaComponents.ProgressBar {
            value: plasmoid.configuration.currentValue / plasmoid.configuration.targetValue
            Layout.fillWidth: true
        }

        PlasmaComponents.Label {
            text: Math.round(plasmoid.configuration.currentValue / plasmoid.configuration.targetValue * 100) + "%"
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
        Layout.preferredWidth: 300
        Layout.preferredHeight: 220
        anchors.margins: 6
        spacing: 16

        PlasmaExtras.Heading {
            level: 1
            text: i18n("Progress tracker")
        }
        RowLayout {

            PlasmaComponents.Label {
                text: Math.round(plasmoid.configuration.currentValue / plasmoid.configuration.targetValue * 100) + "%"
            }
            PlasmaComponents.ProgressBar {
                value: plasmoid.configuration.currentValue / plasmoid.configuration.targetValue
                Layout.fillWidth: true
            }
            PlasmaComponents.Label {
                text: plasmoid.configuration.currentValue + "/" + plasmoid.configuration.targetValue
            }
        }
        RowLayout {
            spacing: 10

            ColumnLayout {
                PlasmaComponents.Label {
                    text: i18n("Task name")
                }
                PlasmaComponents.TextField {
                    id: taskField
                    placeholderText: i18n("Optional")
                    text: plasmoid.configuration.taskName
                    Layout.fillWidth: true
                    onEditingFinished: {
                        plasmoid.configuration.taskName = taskField.text;
                    }
                }
            }
            ColumnLayout {
                PlasmaComponents.Label {
                    text: i18n("Task target")
                }
                PlasmaComponents.TextField {
                    id: targetField
                    placeholderText: i18n("Target")
                    text: plasmoid.configuration.targetValue
                    Layout.fillWidth: true
                    onEditingFinished: {
                        plasmoid.configuration.targetValue = parseFloat(targetField.text);
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
                text: i18n("Current progress")
            }
            RowLayout {
                PlasmaComponents.Button {
                    icon.name: "remove"
                    onClicked: {
                        if (plasmoid.configuration.currentValue > 0)
                            plasmoid.configuration.currentValue--;
                    }
                }
                PlasmaComponents.TextField {
                    id: currentField
                    placeholderText: i18n("Current")
                    text: plasmoid.configuration.currentValue
                    Layout.fillWidth: true
                    onEditingFinished: {
                        plasmoid.configuration.currentValue = parseFloat(currentField.text);
                    }
                    validator: IntValidator {
                        bottom: 0
                        top: plasmoid.configuration.targetValue
                    }
                }
                PlasmaComponents.Button {
                    icon.name: "gtk-add"
                    onClicked: {
                        if (plasmoid.configuration.currentValue < plasmoid.configuration.targetValue)
                            plasmoid.configuration.currentValue++;
                    }
                }
            }
        }
    }
}
