import QtQuick 2.4
import Ubuntu.Components 1.3
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0
import Scriptor 1.0
import "storage.js" as Storage

MainView {
	objectName: "mainView"
	applicationName: "scriptor.newparadigmsoftware"

	property var systemList: [{selected:false, name:"", command:"",
			icon:""}];
	property var lastFocus: -1;

	width: windowSettings.width
	height: windowSettings.height

	Settings {
		id: windowSettings
		category: "Window"
		property int width: units.gu(100)
		property int height: units.gu(75)
		property string iconFolder: picturesLocation
	}

	Component.onDestruction: {
		windowSettings.width = window.width
		windowSettings.height = window.height
//		windowSettings.iconFolder = iconFileDialog.folder
	}

	Page {
		id: page1
		property var toolIconNames: ["add", "remove", "reset", "save", "up", "down"]
		property var toolFunctions: [addSystem, removeSystem,
			loadList, saveList, moveUp, moveDown]

		header: PageHeader {
			id: pageHeader
			visible: !UbuntuApplication.inputMethod.visible
			Icon {
				id: headerIcon
				source: "Scriptor.png"
				anchors.horizontalCenter: parent.horizontalCenter
				height: parent.height
			}
			Text {
				anchors {
					left: headerIcon.right
					verticalCenter: parent.verticalCenter
				}
				text: i18n.tr("-gooey")
			}

			title: i18n.tr("Scriptor")
		}

		Rectangle {
			id: pageView
			anchors {
				top: UbuntuApplication.inputMethod.visible ? parent.top : pageHeader.bottom
				left: parent.left
				right: parent.right
				bottom: parent.bottom
				bottomMargin: UbuntuApplication.inputMethod.keyboardRectangle.height
			}

			ListView {
				id: systemListView
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
								systemListView.currentIndex = -1;
								systemListView.currentIndex = lastFocus;
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
						source: "SystemListItem.qml"
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
				}

				delegate: Component {
					Button {
						height: units.gu(8)
						width: units.gu(8)
						onClicked: page1.toolFunctions[index]()
						iconName: page1.toolIconNames[index]
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
					var i = systemList.length;
					while (i--) {
						systemList[i].selected = bSel;
					}
					page1.refreshModel();
				}
			}
			Text {
				text: i18n.tr("Select All")
				anchors {
					top: chkSelectAll.top
					bottom: chkSelectAll.bottom
					left: chkSelectAll.right
					margins: units.gu(1)
				}
				verticalAlignment: Text.AlignVCenter
				font.pixelSize: height * 2 / 3
			}
		}

		Component.onCompleted: {
			loadList()
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
				systemListView.flick(0, 500)
				break;
			case Qt.Key_Down:
				systemListView.flick(0, -500)
				break;
			case Qt.Key_PageUp:
				systemListView.flick(0, 1024)
				break;
			case Qt.Key_PageDown:
				systemListView.flick(0, -1024)
				break;
			case Qt.Key_Plus:
			case Qt.Key_plusminus:
			case Qt.Key_Equal:
				addSystem()
				break;
			case Qt.Key_Minus:
				removeSystem()
				break;
			}
		}

		function addSystem() {
			var i = systemList.length;
			while (i-- > 0) {
				if (systemList[i].selected) {
					if (i == systemList.length - 1)
						pushEmptySystem();
					else
						insertSystem(i + 1);
					return;
				}
			}
			pushEmptySystem();
		}

		function pushEmptySystem() {
			pushSystem("", "", "");
		}

		function pushSystem(strN, strC, strI) {
			systemList.push({selected:false, name:strN,
						command:strC, icon:strI});
			listModel.append({index:listModel.count});
		}

		function insertSystem(pt) {
			systemList.splice(pt, 0, {selected:false, name:"",
					  command:"", icon:""});
			refreshModel();
		}

		function removeSystem() {
			var isRemoved = false;
			var i = listModel.count;
			while (i-- > 0) {
				if (systemList[i].selected) {
					systemList.splice(i, 1);
					isRemoved = true;
				}
			}
			if (isRemoved) {
				refreshModel();
			} else {
				systemList.pop();
				listModel.remove(listModel.count - 1, 1);
			}
			chkSelectAll.checked = false;
		}

		function loadList() {
			Storage.initDb();
			var localCount = Storage.scriptCount();
			var i;
			var script;
			systemList.splice(0, systemList.length);
			listModel.clear();
			for (i = 0; i < localCount; i++) {
				script = Storage.script(i);
				pushSystem(script.name, script.command, script.icon);
			}
		}

		function saveList() {
			var localCount = listModel.count;
			var i;
			var curItem;
			Storage.initDb(localCount);
			for (i = 0; i < localCount; i++) {
				curItem = systemList[i];
				Storage.setScript(i, curItem.name, curItem.command, curItem.icon);
			}
		}

		function moveUp() {
			console.log("move up not yet implemented");
			refreshModel();
		}

		function moveDown() {
			console.log("move down not yet implemented");
			refreshModel();
		}

		function refreshModel() {
			listModel.clear();
			var i = 0;
			while (listModel.count < systemList.length) {
				listModel.append({index: i++});
			}
		}
	}

	Item {
		id: messageDialog
		// @disable-check M16
//		title: qsTr("May I have your attention, please?")
		visible: false

		function show(caption) {
//			messageDialog.text = caption;
//			messageDialog.open();
		}

		function onError(error) {
//			messageDialog.title = qsTr("Error");
//			messageDialog.text = error;
//			messageDialog.open();
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
}
