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
import Qt.labs.settings 1.0
import Scriptor 1.0
import "popups.js" as Pops

MainView {
	objectName: "mainView"
	applicationName: "scriptor.newparadigmsoftware"

	readonly property string binBusybox: utils.dataDir() + "/bin/busybox";
	readonly property int applicationVersion: 1

	id: mainView
	width: windowSettings.width
	height: windowSettings.height
	backgroundColor: colorZ0

	Component.onCompleted: firstRunDelay.start()

	Component.onDestruction: {
		windowSettings.width = mainView.width
		windowSettings.height = mainView.height
//		windowSettings.iconFolder = iconFileDialog.folder
	}

	Settings {
		id: windowSettings
		category: "Window"
		property int width: units.gu(100)
		property int height: units.gu(75)
		property bool useDarkTheme: true
		property int lastRunVersion: 0
	}
	Settings {
		id: usageSettings
		category: "Usage"
		property bool showStdOut: true
		property bool showStdErr: true
		property bool isProcDisplay: false
		property string iconFolder: picturesLocation
	}

	property string colorZ0: windowSettings.useDarkTheme ? "black" : "white"
	property string colorZ1: windowSettings.useDarkTheme ? "white" : "black"
	readonly property string colorScriptor: "#4747ff"
	readonly property string colorScriptorPressed: "#ff0000"

	Component {
		id: downloaderComponent
		DownloadDialog {}
	}
	Component {
		id: autoDlComponent
		Dialog {
			id: autoDl
			title: i18n.tr("Download Busybox?");
			text: i18n.tr("Busybox is not found at ") + binBusybox + "\n" +
				  i18n.tr("If you installed this app from the Ubuntu store, then all other commands will be blocked by AppArmor.\n") +
				  i18n.tr("Would you like to download it now?");
			ScriptorButton {
				text: i18n.tr("Yes, please")
				onClicked: {
					PopupUtils.open(downloaderComponent, null, {'autoStart': true});
					PopupUtils.close(autoDl);
				}
			}
			ScriptorButton {
				text: i18n.tr("No thank you")
				onClicked: PopupUtils.close(autoDl);
			}
		}
	}

	PageStack {
		id: pageStack
		Component.onCompleted: push(scriptPage)
		ScriptPage {
			id: scriptPage
			visible: false
			onSettingsClicked: pageStack.push(settingsPage);
			onShowProcBuffer: {
				outputPage.procBuffer = procBuffer;
				pageStack.push(outputPage);
			}
		}
		SettingsPage {
			id: settingsPage
			visible: false
			onSettingsFinished: pageStack.pop();
		}
		Output {
			id: outputPage
			visible: false
			onSettingsClicked: pageStack.push(settingsPage);
		}
		onDepthChanged: {
			if (depth === 0)
				pageStack.push(scriptPage)
		}
	}

	IconFileDialog {
		id: iconFileDialog
		visible: false
		// @disable-check M16
//		folder: windowSettings.iconFolder
		// @disable-check M16
//		onFolderChanged: windowSettings.iconFolder = folder
	}

	Timer {
		id: firstRunDelay
		repeat: false
		interval: 200
		onTriggered: firstCheckInitialize()
	}

	function firstCheckInitialize() {
		if (windowSettings.lastRunVersion < applicationVersion) {
			if (!utils.fileExists(binBusybox))
				PopupUtils.open(autoDlComponent);
			firstRunHelper();
			windowSettings.lastRunVersion = applicationVersion;
		}
	}
	Component {
		id: firstRunComponent
		FirstRun {}
	}
	function firstRunHelper() {
		var opts = {
			'contentWidth': scriptPage.width - units.gu(10),
			'contentHeight': scriptPage.height - units.gu(10)
		};
		PopupUtils.open(firstRunComponent, scriptPage, opts);
	}
}
