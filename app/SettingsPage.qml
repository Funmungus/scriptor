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
	readonly property int margins: units.gu(1)
	property var fontSizes: ["xx-small", "x-small", "small",
		"medium", "large", "x-large"]
	property int fontIndex: 0
	property int headerFontIndex: 0
	Component.onCompleted: {
		for (var i = 0; i < fontSizes.length; i++) {
			if (windowSettings.fontSize === fontSizes[i]) {
				fontIndex = i;
				cmbFontSize.text = fontSizes[i];
			}
			if (windowSettings.h1 === fontSizes[i]) {
				headerFontIndex = i;
				cmbHeaderFontSize.text = fontSizes[i];
			}
		}
	}

	Component {
		id: downloaderComponent
		DownloadDialog {}
	}
	ScrollView {
		width: root.width
		anchors {
			top: UbuntuApplication.inputMethod.visible ? root.top : pageHeader.bottom
			topMargin: units.gu(2)
			bottom: parent.bottom
			bottomMargin: UbuntuApplication.inputMethod.keyboardRectangle.height
		}
		Column {
			width: root.width
			spacing: margins
			Item {
				anchors {
					left: parent.left
					right: parent.right
					margins: margins
				}
				height: chkProcDisplay.height > lblProcDisplay.height ?
						chkProcDisplay.height : lblProcDisplay.height
				CheckBox {
					id: chkProcDisplay
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					width: windowSettings.unitWidth
					height: width

					checked: usageSettings.isProcDisplay
					onCheckedChanged: usageSettings.isProcDisplay = checked
				}
				LabelForm {
					id: lblProcDisplay
					anchors {
						verticalCenter: parent.verticalCenter
						left: chkProcDisplay.right
						leftMargin: margins
						right: parent.right
					}
					text: i18n.tr("Show command output for every execute")
					verticalAlignment: Text.AlignVCenter
				}
			}
			Item {
				anchors {
					left: parent.left
					right: parent.right
					margins: margins
				}
				height: chkDarkTheme.height > lblDarkTheme.height ?
						chkDarkTheme.height : lblDarkTheme.height
				CheckBox {
					id: chkDarkTheme
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					width: windowSettings.unitWidth
					height: width

					checked: windowSettings.useDarkTheme
					onCheckedChanged: windowSettings.useDarkTheme = checked
				}
				LabelForm {
					id: lblDarkTheme
					anchors {
						verticalCenter: parent.verticalCenter
						left: chkDarkTheme.right
						leftMargin: margins
						right: parent.right
					}
					text: i18n.tr("Use dark theme")
				}
			}
			Item {
				anchors {
					left: parent.left
					right: parent.right
					margins: margins
				}
				height: lblShell.height > editShell.height ?
						lblShell.height : editShell.height
				LabelForm {
					id: lblShell
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					text: i18n.tr("Command shell(/bin/bash): ");
				}
				TextField {
					id: editShell
					anchors {
						verticalCenter: parent.verticalCenter
						left: lblShell.right
						leftMargin: margins
						right: parent.right
					}
					font.pixelSize: FontUtils.sizeToPixels(windowSettings.fontSize)
					text: usageSettings.shell
					onTextChanged: usageSettings.shell = text
				}
			}
			Item {
				anchors {
					left: parent.left
					right: parent.right
					margins: margins
				}
				height: lblShellArg.height > editShellArg.height ?
						lblShellArg.height : editShellArg.height
				LabelForm {
					id: lblShellArg
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					text: i18n.tr("Shell command argument(-c): ");
				}
				TextField {
					id: editShellArg
					anchors {
						verticalCenter: parent.verticalCenter
						left: lblShellArg.right
						leftMargin: margins
						right: parent.right
					}
					font.pixelSize: FontUtils.sizeToPixels(windowSettings.fontSize)
					text: usageSettings.shellArg
					onTextChanged: usageSettings.shellArg = text;
				}
			}
			LabelForm {
				anchors {
					left: parent.left
					right: parent.right
					margins: margins
				}
				horizontalAlignment: Text.AlignHCenter
				text: i18n.tr("Font size:")
			}
			ComboButton {
				id: cmbFontSize
				anchors {
					left: parent.left
					right: parent.right
					margins: margins
				}
				onClicked: expanded = !expanded;
				// @disable-check M17
				font.pixelSize: FontUtils.sizeToPixels(windowSettings.fontSize)
				Column {
					anchors {
						left: parent.left
						right: parent.right
					}
					spacing: units.gu(1)
					Repeater {
						width: parent.width
						model: fontSizes.length
						Rectangle {
							width: parent.width
							height: lblFontSize.height + units.gu(2)
							color: mouseArea.pressed ?
								       colorScriptorPressed :
								       fontIndexColor(index)
							LabelForm {
								id: lblFontSize
								anchors {
									left: parent.left
									right: parent.right
									margins: units.gu(1)
									verticalCenter: parent.verticalCenter
								}
								color: colorZ0
								text: fontSizes[index]
							}
							MouseArea {
								id: mouseArea
								anchors.fill: parent
								onClicked: {
									fontIndex = index;
									cmbFontSize.text =
											fontSizes[index]
									windowSettings.fontSize =
											fontSizes[index];
									cmbFontSize.expanded = false;
								}
							}
						}
					}
				}
			}
			LabelForm {
				anchors {
					left: parent.left
					right: parent.right
					margins: margins
				}
				horizontalAlignment: Text.AlignHCenter
				text: i18n.tr("Title/Header size:")
			}
			ComboButton {
				id: cmbHeaderFontSize
				anchors {
					left: parent.left
					right: parent.right
					margins: margins
				}
				onClicked: expanded = !expanded;
				// @disable-check M17
				font.pixelSize: FontUtils.sizeToPixels(windowSettings.fontSize)
				Column {
					spacing: units.gu(1)
					Repeater {
						width: parent.width
						model: fontSizes.length
						Rectangle {
							width: parent.width
							height: lblHeaderFontSize.height + units.gu(2)
							color: headerMouseArea.pressed ?
								       colorScriptorPressed :
								       headerFontIndexColor(index)
							LabelForm {
								id: lblHeaderFontSize
								anchors {
									left: parent.left
									right: parent.right
									margins: units.gu(1)
									verticalCenter: parent.verticalCenter
								}
								color: colorZ0
								text: fontSizes[index]
							}
							MouseArea {
								id: headerMouseArea
								anchors.fill: parent
								onClicked: {
									headerFontIndex = index;
									cmbHeaderFontSize.text =
											fontSizes[index]
									windowSettings.h1 =
											fontSizes[index];
									cmbHeaderFontSize.expanded = false;
								}
							}
						}
					}
				}
			}
			Item {
				anchors {
					left: parent.left
					right: parent.right
					margins: margins
				}
				height : lblItemSize.height > editItemSize.height ?
						 lblItemSize.height : editItemSize.height
				LabelForm {
					id: lblItemSize
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					text: i18n.tr("Item size base: ")
				}
				TextField {
					id: editItemSize
					anchors {
						left: lblItemSize.right
						leftMargin: margins
						right: parent.right
					}
					inputMethodHints: Qt.ImhDigitsOnly
					text: windowSettings.unitWidth
					onTextChanged: windowSettings.unitWidth = Number(text)
				}
			}

			ScriptorButton {
				anchors {
					left: parent.left
					right: parent.right
					margins: margins
				}
				text: i18n.tr("Download Busybox")
				onClicked: {
					PopupUtils.open(downloaderComponent);
					settingsFinished();
				}
			}
		}
	}
	function fontIndexColor(index) {
		return Number(index) === Number(fontIndex) ? colorScriptor : colorZ1;
	}
	function headerFontIndexColor(index) {
		return Number(index) === Number(headerFontIndex) ? colorScriptor : colorZ1;
	}
}
