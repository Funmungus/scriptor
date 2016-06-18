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

# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
"""Ubuntu Touch App Autopilot tests."""

import os
import logging

import Scriptor

from autopilot.testcase import AutopilotTestCase
from autopilot import logging as autopilot_logging

import ubuntuuitoolkit
from ubuntuuitoolkit import base

logger = logging.getLogger(__name__)


class BaseTestCase(AutopilotTestCase):

    """A common test case class

    """

    local_location = os.path.dirname(os.path.dirname(os.getcwd()))
    local_location_qml = os.path.join(local_location, 'Main.qml')
    click_package = '{0}.{1}'.format('Scriptor', 'NewParadigmSoftware')

    def setUp(self):
        super(BaseTestCase, self).setUp()
        self.launcher, self.test_type = self.get_launcher_and_type()
        self.app = Scriptor.TouchApp(self.launcher(), self.test_type)

    def get_launcher_and_type(self):
        if os.path.exists(self.local_location_qml):
            launcher = self.launch_test_local
            test_type = 'local'
        else:
            launcher = self.launch_test_click
            test_type = 'click'
        return launcher, test_type

    @autopilot_logging.log_action(logger.info)
    def launch_test_local(self):
        return self.launch_test_application(
            base.get_qmlscene_launch_command(),
            self.local_location_qml,
            app_type='qt',
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)

    @autopilot_logging.log_action(logger.info)
    def launch_test_click(self):
        return self.launch_click_package(
            self.click_package,
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)
