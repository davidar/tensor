# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
"""Ubuntu Touch App Autopilot tests."""

import os
import logging

import ubuntu-sdk

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
    click_package = '{0}.{1}'.format('tensor', 'davidar.io')

    def setUp(self):
        super(BaseTestCase, self).setUp()
        self.launcher, self.test_type = self.get_launcher_and_type()
        self.app = ubuntu-sdk.TouchApp(self.launcher(), self.test_type)

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
