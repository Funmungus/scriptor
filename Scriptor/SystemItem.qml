import QtQuick 2.4
import Ubuntu.Components 1.3
import Scriptor 1.0

Item {
	property alias chkSelected: chkSelected
	property alias btnSystem: btnSystem
	property alias btnIcon: btnIcon
	property alias editName: editName
	property alias editCmd: editCmd
	System {
		id: sysCmd
	}

	height: units.gu(15)

	CheckBox {
		id: chkSelected
		anchors {
			top: parent.top
			left: parent.left
			bottom: parent.bottom
		}
		width: units.gu(5)
	}

	Button {
		id: btnSystem
		anchors {
			top: parent.top
			left: chkSelected.right
		}
		height: units.gu(10)
		width: height

		color: "#00000000"
		iconName: "media-playback-start"
		onClicked: {
			sysCmd.command = editCmd.text;
			sysCmd.execute();
		}
	}
	Button {
		id: btnIcon
		anchors {
			top: btnSystem.bottom
			bottom: parent.bottom
			left: btnSystem.left
			right: btnSystem.right
		}

		text: i18n.tr("Browse...")
	}
	TextField {
		id: editName
		anchors {
			left: btnSystem.right
			top: parent.top
			right: parent.right
		}
		height: parent.height / 2

		text: ""
		placeholderText: i18n.tr("Name")
		font.pixelSize: height * 2 / 3
	}
	TextField {
		id: editCmd
		anchors {
			right: editName.right
			top: editName.bottom
			left: editName.left
			bottom: parent.bottom
		}

		text: ""
		placeholderText: i18n.tr("Command")
		font.pixelSize: height * 2 / 3
	}
}
