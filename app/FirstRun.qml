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

	/* Content */
	ListView {
		id: listView
		anchors.fill: rectBg
		anchors.margins: 1
		spacing: units.gu(1)
		model: VisualItemModel {
			LabelForm {
				id: txtWelcome
				width: listView.width
				height: units.gu(8)
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
				color: colorZ1
				font.pixelSize: units.gu(5)
				text: i18n.tr("Welcome to Scriptor!\n");
			}
			LabelArea {
				anchors {
					left: txtWelcome.left
					right: txtWelcome.right
					leftMargin: units.gu(1)
					rightMargin: units.gu(1)
				}
				height: units.gu(35)
				horizontalAlignment: Text.AlignHCenter
				color: colorZ1
				font.pixelSize: units.gu(3)
				text: i18n.tr("If this was installed from the Ubuntu store, it is suggested to download Busybox in the next dialogue.  " +
							  "At any time the download dialogue can be opened from the settings page to install or update Busybox.  " +
							  "It will be installed to the confined bin directory, explained below.  " +
							  "To use it, start any command with `busybox`.\n" +
							  "Here are some hints to get started:\n\n") +
					  utils.dataDir() + " - " +
					  i18n.tr("The starting working directory of commands.\n") +
					  utils.dataDir() + "/bin - " +
					  i18n.tr("The confined bin directory.  Any executable here can be used in commands without a full path.")
			}
			Loader {
				anchors {
					left: txtWelcome.left
					right: txtWelcome.right
					leftMargin: units.gu(1)
					rightMargin: units.gu(1)
				}
				height: units.gu(6)
				sourceComponent: btnRowComponent
				onLoaded: {
					item.iconName = "help";
					item.text = " - " + i18n.tr("Show quick help");
				}
			}
			Loader {
				anchors {
					left: txtWelcome.left
					right: txtWelcome.right
					leftMargin: units.gu(1)
					rightMargin: units.gu(1)
				}
				height: units.gu(6)
				sourceComponent: btnRowComponent
				onLoaded: {
					item.iconName = "settings";
					item.text = " - " + i18n.tr("Settings page");
				}
			}
			Loader {
				anchors {
					left: txtWelcome.left
					right: txtWelcome.right
					leftMargin: units.gu(1)
					rightMargin: units.gu(1)
				}
				height: units.gu(6)
				sourceComponent: btnRowComponent
				onLoaded: {
					item.iconName = "media-playback-start";
					item.text = " - " + i18n.tr("Execute command, icon may be changed with the browse button");
				}
			}
		}
	}
	Component {
		id: btnRowComponent
		Item {
			anchors.fill: parent

			property alias iconName: btn.iconName
			property alias text: label.text
			ScriptorButton {
				id: btn
				width: units.gu(6)
				height: width
			}
			LabelForm {
				id: label
				anchors {
					left: btn.right
					right: parent.right
				}
				height: btn.height
				verticalAlignment: Text.AlignVCenter
				color: colorZ1
				font.pixelSize: units.gu(3)
			}
		}
	}
}
