#!/usr/bin/env python3
import html
import json
import time
import sys

from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtQml import *
from PyQt5.QtWidgets import *
from PyQt5.QtQuick import *

from matrix_client.client import MatrixClient

# https://bugs.launchpad.net/ubuntu/+source/python-qt4/+bug/941826
import ctypes
from ctypes import util
ctypes.CDLL(util.find_library('GL'), ctypes.RTLD_GLOBAL)

class Worker(QThread):
    signal = pyqtSignal(str,str)
    
    def __init__(self, parent = None):
        QThread.__init__(self, parent)
        self.exiting = False
        self.client = None
    
    def __del__(self):
        self.exiting = True
        self.wait()
    
    def create_listener(self, alias):
        def f(event):
            print(alias, event)
            self.signal.emit(alias, json.dumps(event))
        return f
    
    def work(self, client):
        self.client = client
        self.start()
    
    def run(self):
        while not self.exiting:
            self.client.listen_for_events()

class Controller(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.rooms = {}
        
        self.userList = {}
        self.userProxy = {}
        
        self.roomList = QStandardItemModel()
        self.roomProxy = QSortFilterProxyModel()
        self.roomProxy.setSourceModel(self.roomList)
        
        self.engine = QQmlApplicationEngine()
        self.context = self.engine.rootContext()
        self.context.setContextProperty('main', self)
        self.context.setContextProperty('rooms', self.roomProxy)
        self.engine.load(QUrl.fromLocalFile(__file__.replace('.py', '.qml')))
        
        self.window = self.engine.rootObjects()[0]
        self.window.show()

        self.client = MatrixClient("https://matrix.org")
        self.worker = Worker()
    
    def addUser(self, roomAlias, user):
        item = QStandardItem()
        item.setData(QVariant(str(user)), Qt.DisplayRole)
        self.userList[roomAlias].appendRow(item)
        self.userProxy[roomAlias].sort(0)
    
    def roomName(self, room):
        if room.name or room.update_room_name():
            return room.name
        if len(room.aliases) > 0 or room.update_aliases():
            return room.aliases[0]
        return '+'.join(room.members)
    
    def addRoom(self, room):
        # TODO: update members
        alias = self.roomName(room)
        print("Adding room " + alias)
        self.rooms[alias] = room
        
        room.add_listener(self.worker.create_listener(alias))
        
        item = QStandardItem()
        item.setData(QVariant(str(alias)), Qt.DisplayRole)
        self.roomList.appendRow(item)
        self.roomProxy.sort(0)
        
        self.userList[alias] = QStandardItemModel()
        self.userProxy[alias] = QSortFilterProxyModel()
        self.userProxy[alias].setSourceModel(self.userList[alias])
        
        for user in self.rooms[alias].members:
            self.addUser(alias, user)
        
        self.window.addRoom(alias, self.userProxy[alias])
    
    @pyqtSlot(str)
    def joinRoom(self, alias):
        room = self.client.join_room(alias)
        self.addRoom(room)
        
    @pyqtSlot(str)
    def sendMessage(self, msg):
        self.rooms[self.window.currentRoom()].send_text(msg)
    
    @pyqtSlot(str,str)
    def login(self, user, password):
        token = self.client.login_with_password(user,password)
        # TODO: save token
        self.worker.signal.connect(self.receiveEvent)
        self.worker.work(self.client)
        for room in self.client.get_rooms().values():
            self.addRoom(room)
    
    @pyqtSlot(str,str)
    def receiveEvent(self, room, msg):
        event = json.loads(msg)
        ty = event['type']
        if   ty == 'm.room.message':
            self.mRoomMessage(room, event)
        elif ty == 'm.typing':
            self.mTyping(room, event)
        elif ty == 'm.receipt':
            pass
        else:
            self.window.showMessage(room, "<font color=red>Unhandled message type: " + ty + "</font>")

    def mRoomMessage(self, room, event):
        self.window.showMessage(room,
            "<font color=gray>[{}]</font> <strong>{}:</strong> {}".format(
                time.strftime('%H:%M:%S'), event['user_id'],
                html.escape(event['content']['body'])))

    def mTyping(self, room, event):
        ids = event['content']['user_ids']
        if ids:
            self.window.setStatus(room, " Currently typing: " + ', '.join(ids))
        else:
            self.window.setStatus(room, '')

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ctrl = Controller()
    sys.exit(app.exec_())
