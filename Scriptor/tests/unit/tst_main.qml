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
import QtTest 1.0
import Ubuntu.Test 1.0
import "../../"
// See more details at https://developer.ubuntu.com/api/qml/sdk-14.10/Ubuntu.Test.UbuntuTestCase

// Execute these tests with:
//   qmltestrunner

Item {

	width: units.gu(100)
	height: units.gu(75)

	// The objects
	Main {
		id: main
	}

	UbuntuTestCase {
		name: "MainTestCase"

		when: windowShown


		function init() {
			var label = findChild(main, "label");
			// See the compare method documentation at https://developer.ubuntu.com/api/qml/sdk-14.10/QtTest.TestCase/#compare-method
			compare("Hello world..", label.text);
		}

		function test_clickButtonMustChangeLabel() {
			var button = findChild(main, "button");
			var buttonCenter = centerOf(button)
			mouseClick(button, buttonCenter.x, buttonCenter.y);
			var label = findChild(main, "label");
			// See the tryCompare method documentation at https://developer.ubuntu.com/api/qml/sdk-14.10/QtTest.TestCase/#tryCompare-method
			tryCompare(label, "text", "..from Cpp Backend", 1);
		}
	}
}

