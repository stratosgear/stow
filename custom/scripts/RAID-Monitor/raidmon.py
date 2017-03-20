#!/usr/bin/python
# -*- coding: UTF-8 -*-
#
#       raidmon.py - mdadm RAID-Monitor
#       
#       Copyright 2008 Thimo Kraemer <thimo.kraemer@joonis.de>
#       
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.


from datetime import datetime
import sys
import os
import subprocess
import pygtk
pygtk.require('2.0')
import gtk
import gobject
import re


class RaidMonitor:
    
    def __init__(self):
        self.period = 300
        self.path = os.path.dirname(sys.argv[0])
        self.pattern = re.compile('\[[U_]*_[U_]*\]')
        self.title = 'RAID Monitor'
        self.message = 'Initializing...'
        self.status = 'RAID status not available'
        
        self.dialog = None
        self.icon = gtk.StatusIcon()

        menu = gtk.Menu()
        item = gtk.ImageMenuItem(gtk.STOCK_ABOUT)
        item.connect('activate', self.show_dialog)
        menu.append(item)
        item = gtk.ImageMenuItem(gtk.STOCK_REFRESH)
        item.connect('activate', self.check_raid)
        menu.append(item)
        item = gtk.SeparatorMenuItem()
        menu.append(item)
        item = gtk.ImageMenuItem(gtk.STOCK_QUIT)
        item.connect('activate', self.quit)
        menu.append(item)
        
        self.icon.connect('activate', self.show_dialog)
        self.icon.connect('popup-menu', self.popup_menu, menu)
        self.check_raid()
        self.icon.set_visible(True)

    def popup_menu(self, widget, button, time, menu=None):
        if button == 3:
            if menu:
                menu.show_all()
                menu.popup(None, None, None, 3, time)

    def show_dialog(self, widget=None):
        if self.dialog:
            self.dialog.destroy()
        
        if self.icon.get_blinking():
            dlg_type = gtk.MESSAGE_WARNING
        else:
            dlg_type = gtk.MESSAGE_INFO
        
        self.dialog = gtk.MessageDialog(
            parent=None,
            type=dlg_type,
            buttons=gtk.BUTTONS_CLOSE,
            message_format=self.message
            )
        self.dialog.set_icon(self.icon.get_pixbuf())
        self.dialog.set_title(self.title)
        self.dialog.format_secondary_text(self.status)
        self.dialog.run()
        if self.dialog:
            self.dialog.destroy()
            self.dialog = None
    
    def quit(self, widget):
        if self.dialog:
            self.dialog.destroy()
        self.icon.set_visible(False)
        gtk.main_quit()
    
    def check_raid(self, widget=None):
        proc = subprocess.Popen(['cat', '/proc/mdstat'], stdout=subprocess.PIPE)
        self.status = proc.communicate()[0]
        if self.status.find('raid') == -1 or self.pattern.search(self.status):
            if not self.status:
                self.status = "Could not execute 'cat /proc/mdstat'"
            self.title = 'RAID Monitor - Error'
            self.icon.set_from_file(self.path+'/err.png')
            self.icon.set_blinking(True)
            gtk.gdk.beep()
        else:
            self.title = 'RAID Monitor - Running'
            self.icon.set_from_file(self.path+'/ok.png')
            self.icon.set_blinking(False)
            gobject.timeout_add(self.period*1000, self.check_raid)
        
        self.icon.set_tooltip(self.title)
        self.message = 'Last updated: ' + datetime.now().ctime()
        
        if self.dialog:
            self.show_dialog()


if __name__ == "__main__":
    rm = RaidMonitor()
    gtk.main()
