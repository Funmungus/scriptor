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
import QtQuick.LocalStorage 2.0

import Scriptor 1.0
import "storage.js" as Storage
import "popups.js" as Pops

Page {
	id: root
	readonly property string binBusybox: utils.dataDir() + "/bin/busybox";
	property var toolIconNames: ["add", "remove", "reset", "save", "up", "down", "help"]
	property var toolFunctions: [addProc, removeProc,
		loadList, saveList, moveUp, moveDown, openHelp]
	property var procList: [{selected:false, name:"", command:"",
			icon:""}];
	property int lastFocus: -1;

	signal settingsClicked
	property alias pageHeader: pageHeader
	header: HeaderForm {
		id: pageHeader
		btnOptions.onClicked: settingsClicked();
	}

	Component.onCompleted: loadList();

	Rectangle {
		id: pageView
		anchors {
			top: UbuntuApplication.inputMethod.visible ? parent.top : pageHeader.bottom
			left: parent.left
			right: parent.right
			bottom: parent.bottom
			bottomMargin: UbuntuApplication.inputMethod.keyboardRectangle.height
		}

		color: "black"
		ListView {
			id: procListView
			orientation: ListView.Vertical
			flickableDirection: Flickable.VerticalFlick
			spacing: units.gu(1)
			anchors {
				top: chkSelectAll.bottom
				left: parent.left
				right: parent.right
				bottom: parent.bottom
				margins: units.gu(1)
			}
			Connections {
				target: UbuntuApplication.inputMethod
				onVisibleChanged: {
					if (UbuntuApplication.inputMethod.visible) {
						if (lastFocus > 0 && lastFocus < listModel.count) {
							procListView.currentIndex = -1;
							procListView.currentIndex = lastFocus;
						}
					}
				}
			}

			model: ListModel {
				id: listModel
				ListElement {
					index: 0
				}
			}

			delegate: Component {
				id: listDelegate
				Loader {
					source: Qt.resolvedUrl("ProcessListItem.qml")
					anchors.left: parent.left
					anchors.right: parent.right
				}
			}
		}

		ListView {
			id: toolBarListView
			orientation: ListView.Horizontal
			flickableDirection: Flickable.HorizontalFlick
			spacing: units.gu(1)
			anchors {
				top: parent.top
				left: parent.left
				right: parent.right
				margins: units.gu(1)
			}
			height: units.gu(8)

			model: ListModel {
				id: toolModel
				ListElement { index: 0 }
				ListElement { index: 1 }
				ListElement { index: 2 }
				ListElement { index: 3 }
				ListElement { index: 4 }
				ListElement { index: 5 }
				ListElement { index: 6 }
			}

			delegate: Component {
				Button {
					height: units.gu(8)
					width: units.gu(8)
					onClicked: root.toolFunctions[index]()
					color: colorScriptor
					iconName: root.toolIconNames[index]
				}
			}
		}

		CheckBox {
			id: chkSelectAll
			anchors {
				top: toolBarListView.bottom
				left: parent.left
				margins: units.gu(1)
			}
			height: units.gu(8)
			width: units.gu(8)

			onCheckedChanged: {
				var bSel = chkSelectAll.checked;
				var i = procList.length;
				while (i--) {
					procList[i].selected = bSel;
				}
				root.refreshModel();
			}
		}
		LabelForm {
			text: i18n.tr("Select All")
			anchors {
				top: chkSelectAll.top
				bottom: chkSelectAll.bottom
				left: chkSelectAll.right
				right: parent.right
				margins: units.gu(1)
			}
			verticalAlignment: Text.AlignVCenter
			font.pixelSize: height * 2 / 3
		}
	}

	Keys.onPressed: {
		switch (event.key) {
		case Qt.Key_S:
			if (event.modifiers === Qt.ControlModifier ||
					event.modifiers === Qt.AltModifier) {
				saveList()
			}
			break;
		case Qt.Key_L:
			if (event.modifiers === Qt.ControlModifier ||
					event.modifiers === Qt.AltModifier) {
				loadList()
			}
			break;
		case Qt.Key_Up:
			procListView.flick(0, 500)
			break;
		case Qt.Key_Down:
			procListView.flick(0, -500)
			break;
		case Qt.Key_PageUp:
			procListView.flick(0, 1024)
			break;
		case Qt.Key_PageDown:
			procListView.flick(0, -1024)
			break;
		case Qt.Key_Plus:
		case Qt.Key_plusminus:
		case Qt.Key_Equal:
			addProc()
			break;
		case Qt.Key_Minus:
			removeProc()
			break;
		}
	}

	function addProc() {
		var i = procList.length;
		while (i-- > 0) {
			if (procList[i].selected) {
				if (i == procList.length - 1)
					pushEmptyProc();
				else
					insertProc(i + 1);
				return;
			}
		}
		pushEmptyProc();
	}

	function pushEmptyProc() {
		if (utils.fileExists(binBusybox))
			pushProc("", "busybox sh -c \"\"", "");
		else
			pushProc("", "bash -c \"\"", "");
	}

	function pushProc(strN, strC, strI) {
		procList.push({selected:false, name:strN,
					command:strC, icon:strI});
		listModel.append({index:listModel.count});
	}

	function insertProc(pt) {
		procList.splice(pt, 0, {selected:false, name:"",
				  command:"", icon:""});
		refreshModel();
	}

	function removeProc() {
		var isRemoved = false;
		var i = listModel.count;
		while (i-- > 0) {
			if (procList[i].selected) {
				procList.splice(i, 1);
				isRemoved = true;
			}
		}
		if (isRemoved) {
			refreshModel();
		} else if (procList.length > 0){
			procList.pop();
			listModel.remove(listModel.count - 1, 1);
		}
		chkSelectAll.checked = false;
	}

	function loadList() {
		Storage.initDb();
		var localCount = Storage.scriptCount();
		var i;
		var script;
		procList.splice(0, procList.length);
		listModel.clear();
		for (i = 0; i < localCount; i++) {
			script = Storage.script(i);
			pushProc(script.name, script.command, script.icon);
		}
	}

	function saveList() {
		var localCount = listModel.count;
		var i;
		var curItem;
		Storage.initDb(localCount);
		for (i = 0; i < localCount; i++) {
			curItem = procList[i];
			Storage.setScript(i, curItem.name, curItem.command, curItem.icon);
		}
	}

	function moveUp() {
		Pops.showMessage(toolBarListView, i18n.tr("move up not yet implemented"));
		refreshModel();
	}

	function moveDown() {
		Pops.showMessage(toolBarListView, i18n.tr("move down not yet implemented"));
		refreshModel();
	}

	function refreshModel() {
		listModel.clear();
		var i = 0;
		while (listModel.count < procList.length) {
			listModel.append({index: i++});
		}
	}

	function openHelp() {
		Pops.showMessage(root, i18n.tr("Help menu not yet implemented"));
	}
}
