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
"""Application autopilot helpers."""

import logging
import ubuntuuitoolkit

logger = logging.getLogger(__name__)


class AppException(ubuntuuitoolkit.ToolkitException):

    """Exception raised when there are problems with the Application."""


class TouchApp(object):

    """Autopilot helper object for the application."""

    def __init__(self, app_proxy, test_type):
        self.app = app_proxy
        self.test_type = test_type
        self.main_view = self.app.select_single(MainView)

    @property
    def pointing_device(self):
        return self.app.pointing_device


class MainView(ubuntuuitoolkit.MainView):

    """A helper that makes it easy to interact with the mainview"""

    def __init__(self, *args):
        super(MainView, self).__init__(*args)
        self.visible.wait_for(True, 30)

    def get_button(self):
        return self.select_single('Button', objectName="button")

    def get_label(self):
        return self.select_single('Label', objectName="label")
