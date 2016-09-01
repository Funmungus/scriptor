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

import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Page {
	id: root
	signal settingsFinished
	header: HeaderForm {
		id: pageHeader
		btnOptions.visible: false
	}
	Component {
		id: downloaderComponent
		DownloadDialog {}
	}
	ScrollView {
		width: root.width
		anchors {
			top: UbuntuApplication.inputMethod.visible ? root.top : pageHeader.bottom
			topMargin: units.gu(3)
			bottom: parent.bottom
			bottomMargin: UbuntuApplication.inputMethod.keyboardRectangle.height
		}
		Column {
			width: root.width
			spacing: units.gu(1)
			Item {
				width: root.width
				height: chkProcDisplay.height
				CheckBox {
					id: chkProcDisplay
					anchors {
						left: parent.left
						margins: units.gu(1)
					}
					height: units.gu(8)
					width: units.gu(8)

					onCheckedChanged: usageSettings.isProcDisplay = checked
				}
				Binding {
					target: chkProcDisplay
					property: "checked"
					value: usageSettings.isProcDisplay
				}
				LabelForm {
					text: i18n.tr("Show command output every time it is used")
					anchors {
						top: chkProcDisplay.top
						bottom: chkProcDisplay.bottom
						left: chkProcDisplay.right
						right: parent.right
						margins: units.gu(1)
					}
					verticalAlignment: Text.AlignVCenter
					font.pixelSize: height * 2 / 3
				}
			}
			Item {
				width: root.width
				height: chkDarkTheme.height
				CheckBox {
					id: chkDarkTheme
					anchors {
						left: parent.left
						margins: units.gu(1)
					}
					height: units.gu(8)
					width: units.gu(8)

					onCheckedChanged: windowSettings.useDarkTheme = checked
				}
				Binding {
					target: chkDarkTheme
					property: "checked"
					value: windowSettings.useDarkTheme
				}
				LabelForm {
					text: i18n.tr("Use dark theme")
					anchors {
						top: chkDarkTheme.top
						bottom: chkDarkTheme.bottom
						left: chkDarkTheme.right
						right: parent.right
						margins: units.gu(1)
					}
					verticalAlignment: Text.AlignVCenter
					font.pixelSize: height * 2 / 3
				}
			}
			ScriptorButton {
				anchors {
					left: parent.left
					right: parent.right
					margins: units.gu(1)
				}
				text: i18n.tr("Download Busybox")
				onClicked: {
					PopupUtils.open(downloaderComponent);
					settingsFinished();
				}
			}
		}
	}
}
