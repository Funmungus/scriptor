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
import Ubuntu.Components 1.3
import Scriptor 1.0

// See more details @ http://qt-project.org/doc/qt-5.0/qtquick/qml-testcase.html

// Execute tests with:
//   qmltestrunner

Item {
	// The objects
	MyType {
		id: objectUnderTest
	}

	TestCase {
		name: "MyType"

		function init() {
			console.debug(">> init");
			compare("",objectUnderTest.helloWorld,"text was not empty on init");
			console.debug("<< init");
		}

		function cleanup() {
			console.debug(">> cleanup");
			console.debug("<< cleanup");
		}

		function initTestCase() {
			console.debug(">> initTestCase");
			console.debug("<< initTestCase");
		}

		function cleanupTestCase() {
			console.debug(">> cleanupTestCase");
			console.debug("<< cleanupTestCase");
		}

		function test_canReadAndWriteText() {
			var expected = "Hello World 2";

			objectUnderTest.helloWorld = expected;

			compare(expected,objectUnderTest.helloWorld,"expected did not equal result");
		}
	}
}

