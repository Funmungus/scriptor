/*
  Copyright (c) 2016, Jonathan Pelletier
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Popover {
	/* frame */
	Rectangle {
		id: rectFrame
		color: colorZ1
		height: contentHeight
		width: contentWidth
	}
	/* bg */
	Rectangle {
		id: rectBg
		color: colorZ0
		anchors.fill: rectFrame
		anchors.margins: 1
	}

	property var btnIcons: ["media-playback-start", "settings",
		"add", "remove", "reset", "save", "up", "down",
		"insert-image", "note"];

	property var btnLabels: [i18n.tr("Execute command, changing icon not yet implemented"),
		i18n.tr("Settings page"),
		i18n.tr("Add one new script after selection, or to the end of the list"),
		i18n.tr("Remove selected items"),
		i18n.tr("Load scripts that have been saved"),
		i18n.tr("Save all scripts"),
		i18n.tr("Move up"),
		i18n.tr("Move down"),
		i18n.tr("Browse, not yet implemented"),
		i18n.tr("View command output")]

	/* Content */
	ScrollView {
		id: scrollView
		anchors.fill: rectBg
		anchors.margins: units.gu(2)
		Column {
			id: column
			width: scrollView.width
			spacing: units.gu(0.5)
			LabelForm {
				width: scrollView.width
				horizontalAlignment: Text.AlignHCenter
				text: i18n.tr("Quick Help\n");
				font.pixelSize: FontUtils.sizeToPixels(windowSettings.h1)
			}
			LabelForm {
				width: scrollView.width
				text: utils.dataDir() + " - " +
					  i18n.tr("The starting working directory of commands.\n")
			}
			LabelForm {
				width: scrollView.width
				text: utils.dataDir() + "/bin - " +
					  i18n.tr("The confined bin directory.  Any executable here can be used in commands without a full path.\n")
			}
			Repeater {
				width: column.width
				model: btnIcons.length
				Item {
					width: column.width
					height: btn.height > label.height ? btn.height : label.height
					ScriptorButton {
						id: btn
						anchors {
							left: parent.left
							verticalCenter: parent.verticalCenter
						}
						iconName: btnIcons[index]
					}
					LabelForm {
						id: label
						anchors {
							left: btn.right
							right: parent.right
							verticalCenter: parent.verticalCenter
						}
						text: " - " + btnLabels[index]
					}
				}
			}
		}
	}
}
