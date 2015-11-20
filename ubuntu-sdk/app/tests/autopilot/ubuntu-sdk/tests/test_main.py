# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

from autopilot.matchers import Eventually
from testtools.matchers import Equals
from ubuntu-sdk import tests


class MainViewTestCase(tests.BaseTestCase):
    """Tests for the mainview"""

    def setUp(self):
        super(MainViewTestCase, self).setUp()

    def test_click_button(self):
        # Find and click the button
        button = self.app.main_view.get_button()
        self.app.pointing_device.click_object(button)

        # Make an assertion about what should happen
        label = self.app.main_view.get_label()
        self.assertThat(label.text, Eventually(Equals('..world!')))
