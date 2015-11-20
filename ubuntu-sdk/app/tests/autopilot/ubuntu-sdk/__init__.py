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
