

/*
 * SPDX-FileCopyrightText: 2021 Reion Wong <reionwong@gmail.com>
 * SPDX-FileCopyrightText: 2024 Elysia <elysia@lingmo.org>
 *
 * SPDX-License-Identifier: GPL-3.0
 */
import QtQuick
import QtQuick.Controls as QQC2
import Qt5Compat.GraphicalEffects
import SddmComponents

import LingmoUI.CompatibleModule 3.0 as LingmoUI

QQC2.ToolButton {
    id: root

    property int currentIndex: -1
    property int rootFontSize
    property color textColor: LingmoUI.Theme.textColor

    visible: menu.count > 1
    implicitHeight: _currentLabel.implicitHeight + 10
    implicitWidth: _currentLabel.implicitWidth + 16

    padding: 6
    spacing: 8

    icon.width: 20
    icon.height: 20
    icon.color: Qt.rgba(textColor.r, textColor.g, textColor.b, enabled ? 1.0 : 0.2)

    contentItem: Row {
        id: _currentLabel
        anchors.centerIn: parent
        spacing: root.spacing

        Image {
            width: root.icon.width
            height: root.icon.height
            source: root.icon.source
            visible: source !== ""
            smooth: true
        }

        QQC2.Label {
            text: instantiator.objectAt(currentIndex)?.text || ""
            font: root.font
            color: root.textColor
        }
    }

    background: Rectangle {
        implicitWidth: 30
        implicitHeight: 30
        radius: height / 2
        color: root.hovered ? Qt.rgba(0, 0, 0, 0.12) : Qt.rgba(0, 0, 0, 0.08)
    }

    DropShadow {
        id: dropShadow
        anchors.fill: _currentLabel
        source: _currentLabel
        z: -1
        horizontalOffset: 1
        verticalOffset: 1
        radius: 6
        samples: radius * 4
        spread: 0.35
        color: Qt.rgba(0, 0, 0, 0.2)
        opacity: 0.5
        visible: true
    }

    onClicked: menu.popup()

    Component.onCompleted: {
        currentIndex = sessionModel.lastIndex
    }

    QQC2.Menu {
        id: menu
        Instantiator {
            id: instantiator
            model: sessionModel
            onObjectAdded: (index, object) => menu.insertItem(index, object)
            onObjectRemoved: (index, object) => menu.removeItem(object)
            delegate: QQC2.MenuItem {
                text: model.name
                onTriggered: {
                    root.currentIndex = model.index
                }
            }
        }
    }
}
