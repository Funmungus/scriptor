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
import "Utils.js" as Utils

Page {
	id: root
	property var toolIconNames: ["add", "remove", "reset", "save", "up", "down", "help"]
	property var toolFunctions: [addProc, removeProc,
		loadList, saveList, moveUp, moveDown, openHelp]
	property var procList: [];

	signal settingsClicked
	signal showProcBuffer(var procBuffer)
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
			bottom: parent.bottom
			bottomMargin: UbuntuApplication.inputMethod.keyboardRectangle.height
		}
		width: parent.width
		color: colorZ0

		ListView {
			id: toolBarListView
			anchors {
				top: parent.top
				left: parent.left
				right: parent.right
				margins: units.gu(1)
			}
			orientation: ListView.Horizontal
			flickableDirection: Flickable.HorizontalFlick
			spacing: units.gu(1)
			height: windowSettings.unitWidth
			clip: true

			model: root.toolFunctions.length
			delegate: Component {
				ScriptorButton {
					onClicked: root.toolFunctions[index]()
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
			width: windowSettings.unitWidth
			height: width

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
			anchors {
				verticalCenter: chkSelectAll.verticalCenter
				left: chkSelectAll.right
				right: parent.right
				margins: units.gu(1)
			}
			text: i18n.tr("Select All")
		}
		ListView {
			id: procListView
			orientation: ListView.Vertical
			flickableDirection: Flickable.VerticalFlick
			spacing: units.gu(2)
			anchors {
				top: chkSelectAll.bottom
				bottom: parent.bottom
				margins: units.gu(1)
			}
			width: parent.width
			clip: true

			model: procList.length
			delegate: Component {
				ProcessListItem {
					anchors {
						left: parent.left
						right: parent.right
						margins: units.gu(1)
					}
					onShowProcBuffer: root.showProcBuffer(procBuffer);
				}
			}
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
		var i = procList.length - 1;
		/* Last item selected, just push */
		if (procList.length == 0 || procList[i].selected) {
			pushEmptyProc();
			return;
		}
		while (i-- > 0) {
			if (procList[i].selected) {
				insertProc(i + 1);
				return;
			}
		}
		pushEmptyProc();
	}

	function emptyProc() {
		return {selected:false, name:"", command:"", icon:""};
	}

	function makeProc(strN, strC, strI) {
		return {selected:false, name:strN,
			command:strC, icon:strI};
	}

	function pushEmptyProc() {
		pushProc(emptyProc());
	}

	function pushProc(proc) {
		procList.push(proc);
		procListView.model++;
	}

	function insertProc(pt) {
		procList.splice(pt, 0, emptyProc());
		refreshModel();
	}

	function removeProc() {
		var isRemoved = false;
		var i = procList.length;
		procListView.model = 0;
		while (i-- > 0) {
			if (procList[i].selected) {
				procList.splice(i, 1);
				isRemoved = true;
			}
		}
		if (!isRemoved && procList.length > 0)
			procList.pop();
		refreshModel();
		chkSelectAll.checked = false;
	}

	function loadList() {
		Storage.initDb();
		var localCount = Storage.scriptCount();
		var i;
		var script;
		procListView.model = 0;
		procList.splice(0, procList.length);
		for (i = 0; i < localCount; i++) {
			script = Storage.script(i);
			script.selected = false;
			pushProc(script);
		}
	}

	function saveList() {
		var i;
		var curItem;
		Storage.initDb(procList.length);
		for (i = 0; i < procList.length; i++) {
			curItem = procList[i];
			Storage.setScript(i, curItem.name, curItem.command, curItem.icon);
		}
	}

	function moveUp() {
		if (procList.length <= 1)
			return;
		/* Move down, bubble starting from first */
		procListView.model = 0;
		/* First selected items cannot move */
		var curItem;
		var i = 1;
		if (procList[0].selected) {
			while (i < procList.length && procList[i].selected) {
				++i;
			}
		}
		while (i < procList.length) {
			if (procList[i].selected) {
				curItem = procList[i];
				/* remove current */
				procList.splice(i, 1);
				/* place before previous */
				procList.splice(i - 1, 0, curItem);
			}
			++i;
		}
		procListView.model = procList.length;
	}

	function moveDown() {
		if (procList.length <= 1)
			return;
		/* Move up, bubble starting from last */
		procListView.model = 0;
		var curItem;
		/* Last selected items cannot move */
		var i = procList.length - 2;
		if (procList[procList.length - 1].selected) {
			while (i >= 0 && procList[i].selected) {
				--i;
			}
		}
		while (i >= 0) {
			if (procList[i].selected) {
				curItem = procList[i];
				/* remove current */
				procList.splice(i, 1);
				/* place after next */
				procList.splice(i + 1, 0, curItem);
			}
			--i;
		}
		procListView.model = procList.length;
	}

	function refreshModel() {
		procListView.model = 0;
		procListView.model = procList.length;
	}

	function openHelp() {
		PopupUtils.open(helpComponent, root, {});
	}
	Component {
		id: helpComponent
		Help {
			contentHeight: root.height - units.gu(10)
			contentWidth: root.width - units.gu(10)
		}
	}
}
