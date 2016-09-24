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
		anchors.margins: units.gu(1)
		spacing: units.gu(1)
		model: VisualItemModel {
			LabelForm {
				width: listView.width
				height: units.gu(8)
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
				color: colorZ1
				font.pixelSize: units.gu(5)
				text: i18n.tr("Quick Help\n");
			}
			LabelForm {
				width: listView.width
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
				color: colorZ1
				font.pixelSize: units.gu(3)
				text: utils.dataDir() + " - " +
					  i18n.tr("The starting working directory of commands.")
			}
			LabelForm {
				width: listView.width
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
				color: colorZ1
				font.pixelSize: units.gu(3)
				text: utils.dataDir() + "/bin - " +
					  i18n.tr("The confined bin directory.  Any executable here can be used in commands without a full path.")
			}
			Loader {
				width: listView.width
				height: units.gu(6)
				sourceComponent: btnHelpComponent
				onLoaded: {
					item.iconName = "media-playback-start";
					item.text = " - " + i18n.tr("Execute command, changing icon not yet implemented");
				}
			}
			Loader {
				width: listView.width
				height: units.gu(6)
				sourceComponent: btnHelpComponent
				onLoaded: {
					item.iconName = "settings";
					item.text = " - " + i18n.tr("Settings page");
				}
			}
			Loader {
				width: listView.width
				height: units.gu(6)
				sourceComponent: btnHelpComponent
				onLoaded: {
					item.iconName = "add";
					item.text = " - " + i18n.tr("Add one new script after selection, or to the end of the list");
				}
			}
			Loader {
				width: listView.width
				height: units.gu(6)
				sourceComponent: btnHelpComponent
				onLoaded: {
					item.iconName = "remove";
					item.text = " - " + i18n.tr("Remove selected items");
				}
			}
			Loader {
				width: listView.width
				height: units.gu(6)
				sourceComponent: btnHelpComponent
				onLoaded: {
					item.iconName = "reset";
					item.text = " - " + i18n.tr("Load scripts that have been saved");
				}
			}
			Loader {
				width: listView.width
				height: units.gu(6)
				sourceComponent: btnHelpComponent
				onLoaded: {
					item.iconName = "save";
					item.text = " - " + i18n.tr("Save all scripts");
				}
			}
			Loader {
				width: listView.width
				height: units.gu(6)
				sourceComponent: btnHelpComponent
				onLoaded: {
					item.iconName = "up";
					item.text = " - " + i18n.tr("Move up, not yet implemented");
				}
			}
			Loader {
				width: listView.width
				height: units.gu(6)
				sourceComponent: btnHelpComponent
				onLoaded: {
					item.iconName = "down";
					item.text = " - " + i18n.tr("Move down, not yet implemented");
				}
			}
			Loader {
				width: listView.width
				height: units.gu(6)
				sourceComponent: btnHelpComponent
				onLoaded: {
					item.iconName = "insert-image";
					item.text = " - " + i18n.tr("Browse, not yet implemented");
				}
			}
			Loader {
				width: listView.width
				height: units.gu(6)
				sourceComponent: btnHelpComponent
				onLoaded: {
					item.iconName = "note";
					item.text = " - " + i18n.tr("View command output");
				}
			}
		}
	}
	Component {
		id: btnHelpComponent
		Item {
			anchors.fill: parent

			property alias iconName: btn.iconName
			property alias text: lbl.text
			ScriptorButton {
				id: btn
				width: units.gu(6)
				height: width
			}
			LabelForm {
				id: lbl
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
