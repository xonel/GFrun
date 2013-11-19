#! /usr/bin/env python
# -*- coding:Utf­8 ­-*-
############################################################################
##                                                                        ##
##     GladeToScript is an engine that allows to simply use GTK           ##
##   functions from a script/software. Even without deep GTK knowledge    ##
##   you will be able to handle its widgets from a bash script for        ##
##   example.                                                             ##
##                                                                        ##
##     GladeToScript permet d'utiliser simplement des fonctions GTK       ##
##   depuis un script/logiciel. Il permet sans grande connaissances       ##
##   en GTK, de manier ses widgets depuis un script bash par exemple.     ##
##                                                                        ##
############################################################################
##                                                                        ##
##     Copyright (C) 2010-2011  AnsuzPeorth (ansuzpeorth@gmail.com)       ##
##                                                                        ##
## This program is free software: you can redistribute it and/or modify   ##
## it under the terms of the GNU General Public License as published by   ##
## the Free Software Foundation, either version 3 of the License, or      ##
## (at your option) any later version.                                    ##
##                                                                        ##
## This program is distributed in the hope that it will be useful,        ##
## but WITHOUT ANY WARRANTY; without even the implied warranty of         ##
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          ##
## GNU General Public License for more details.                           ##
##                                                                        ##
## You should have received a copy of the GNU General Public License      ##
## along with this program.  If not, see <http://www.gnu.org/licenses/>.  ##
##                                                                        ##
############################################################################
##                                                                        ##
##               One file for the entire source code is a choice          ##
##                for easy integration into bash applications.            ##
##                                                                        ##
############################################################################
import os, os.path
import threading
import subprocess
import time
import gtk
import pygtk
pygtk.require('2.0')
import gobject
import pango
import shlex
import sys
import getopt
import gettext
import re
from xml.dom.minidom import parse
from ConfigParser import ConfigParser

DRAG_DEST_DEFAULT   = gtk.DEST_DEFAULT_ALL
DRAG_ACTION_MOVE    = gtk.gdk.ACTION_MOVE
DRAG_BTN_MASK       = gtk.gdk.BUTTON1_MASK
DRAG_BEFORE         = gtk.TREE_VIEW_DROP_BEFORE
DRAG_AFTER          = gtk.TREE_VIEW_DROP_AFTER
DRAG_INTO_OR_BEFORE = gtk.TREE_VIEW_DROP_INTO_OR_BEFORE
DRAG_INTO_OR_AFTER  = gtk.TREE_VIEW_DROP_INTO_OR_AFTER

gobject.threads_init()


'''
@name glade2script
@authors AnsuzPeorth
@copyright GPL3
@version 2.4.3
@date February 2012
'''

'''
    ***************************************************
    *** CONFIG PARSER
    ***************************************************
'''
class LoadConfig(object):
    def set_gobject_idle_add(self, widget, action, value):
        widget = getattr(self.gui, widget)
        method = getattr(widget, action)
        gobject.idle_add(method, *value)
    
    def set_bool_int_widgets(self, section, gettype, gtkfunction):
        for option in self.options(section):
            value = gettype(section, option)
            self.ENV['G2S%s'%option] = str(value)
            self.set_gobject_idle_add(option, gtkfunction, (value, ))
    
    def set_text_widgets(self, section, gettype, gtkfunction):
        for option in self.options(section):
            value = gettype(section, option)
            self.ENV['G2S%s'%option] = value
            self.set_gobject_idle_add(option, gtkfunction, (value, ))
    
    def set_color_widgets(self, section, gettype, gtkfunction):
        for option in self.options(section):
            value = gettype(section, option)
            color = Gdk.color_parse(value)
            self.ENV['G2S%s'%option] = value
            self.set_gobject_idle_add(option, gtkfunction, (color, ))
    
    def load_WINDOW(self, window):
        x = self.getint('WINDOW:%s'%window, 'x')
        y = self.getint('WINDOW:%s'%window, 'y')
        height = self.getint('WINDOW:%s'%window, 'height')
        width  = self.getint('WINDOW:%s'%window, 'width')
        if x != -1 or y != -1:
            self.set_gobject_idle_add(window, 'move', (x, y))
        if height != -1 or width != -1:
            self.set_gobject_idle_add(window, 'resize', (width, height))
        self.ENV['G2S%s_size'%window] = '%s %s' % (width, height)
        self.ENV['G2S%s_position'%window] = '%s %s' % (x, y)
    
    def load_ENTRY(self):
        self.set_text_widgets('ENTRY', self.get, 'set_text')
    
    def load_LABEL(self):
        self.set_text_widgets('LABEL', self.get, 'set_markup')
    
    def load_TOGGLE(self):
        self.set_bool_int_widgets('TOGGLE', self.getboolean, 'set_active')
    
    def load_COMBO(self):
        self.set_bool_int_widgets('COMBO', self.getint, 'set_active')
    
    def load_SPIN(self):
        self.set_bool_int_widgets('SPIN', self.getfloat, 'set_value')
    
    def load_PANED(self):
        self.set_bool_int_widgets('PANED', self.getint, 'set_position')

    def load_NOTEBOOK(self):
        self.set_bool_int_widgets('NOTEBOOK', self.getint, 'set_current_page')
    
    def load_COLORBUTTON(self):
        self.set_color_widgets('COLORBUTTON', self.get, 'set_color')
    
    def load_COLORDIALOG(self):
        self.set_color_widgets('COLORDIALOG', self.get, 'set_current_color')


class SaveConfig(object):
    def save_WINDOW(self, window):
        section = 'WINDOW:%s' % window
        window  = getattr(self.gui, window)
        x, y    = window.get_position()
        width, height = window.get_size()
        self.set(section, 'x', x)
        self.set(section, 'y', y)
        self.set(section, 'width', width)
        self.set(section, 'height', height)
    
    def get_widgets(self, section, gtkfunction):
        for widget_name in self.options(section):
            if widget_name in self.blackliste: continue
            widget = getattr(self.gui, widget_name)
            value = getattr(widget, gtkfunction)()
            self.set(section, widget_name, value)
    
    def save_ENTRY(self):
        self.get_widgets('ENTRY', 'get_text')
    
    def save_LABEL(self):
        self.get_widgets('LABEL', 'get_text')
    
    def save_COMBO(self):
        self.get_widgets('COMBO', 'get_active')
    
    def save_TOGGLE(self):
        self.get_widgets('TOGGLE', 'get_active')
    
    def save_SPIN(self):
        self.get_widgets('SPIN', 'get_value')
    
    def save_PANED(self):
        self.get_widgets('PANED', 'get_position')
    
    def save_COLORBUTTON(self):
        self.get_widgets('COLORBUTTON', 'get_color')
    
    def save_COLORDIALOG(self):
        self.get_widgets('COLORDIALOG', 'get_current_color')
    
    def save_NOTEBOOK(self):
        self.get_widgets('NOTEBOOK', 'get_current_page')


class ParseConfig(ConfigParser, LoadConfig, SaveConfig):
    def __init__(self, filepath):
        ConfigParser.__init__(self)
        self.filepath = filepath
        self.read(filepath)
        self.ENV = {}
        DEBUG('[[ INIT CONFIG ]]')
    
    def load_config(self, gui):
        self.gui = gui
        for section in self.sections():
            try:
                try:
                    getattr(self, 'load_%s' % section)()
                except:
                    function, widget = section.split(':')
                    getattr(self, 'load_%s' % function)(widget)
            except:
                for variable, value in self.items(section):
                    self.ENV['G2S%s'%variable] = value
        DEBUG('[[ CONFIG LOADED ]]')
        return self.ENV
    
    def get_config(self):
        for section in self.sections():
            for variable, value in self.items(section):
                self.ENV['G2S%s'%variable] = value
        DEBUG('[[ CONFIG GOT ]]')
        return self.ENV
    
    def save_config(self, blackliste):
        self.blackliste = blackliste
        for section in self.sections():
            if section in blackliste: continue
            try:
                try:
                    getattr(self, 'save_%s' % section)()
                except:
                    function, widget = section.split(':')
                    getattr(self, 'save_%s' % function)(widget)
            except:
                #raise
                pass
        with file(self.filepath,'wb') as configfile:
            self.write(configfile)
        DEBUG('[[ CONFIG SAVED ]]')


'''
    ***************************************************
    *** EMBED APPLICATION
    ***************************************************
'''
class Embed(gtk.Socket):
    def __init__(self, widget, cmd):
        self.cmd  = cmd % widget.window.xid
        gtk.Socket.__init__(self)
        self.flag = False
        self.go_embed()

    def go_embed(self):
        #self.embed=ThreadEmbed( self.cmd )
        #self.embed.start()
        args       = shlex.split( self.cmd )
        self.embed = subprocess.Popen(args,stderr=subprocess.STDOUT,
                                            stdout=subprocess.PIPE)
        self.flag  = True

    def stop_embed(self):
        if self.flag: self.embed.stop()


'''
    ***************************************************
    *** CALLBACKS FROM USER ACTION
    ***************************************************
'''
class Callbacks(object):
    '''
    @page callbacks Signals and callbacks
    '''
    '''
    *** Closing interface
    '''
    def gtk_widget_destroy(self,*arg):
        '''
        @brief equivalent to EXIT@@, e.g. to be used for closing via the cross
        '''
        self.th.stop('no')

    def gtk_widget_destroy_save(self,*arg):
        '''
        @brief equivalent to EXIT@@SAVE
        '''
        self.th.stop('yes')

    '''
    *** notify icon
    '''
    def systray_show(self,widget,event=None,arg=None):
        '''
        @brief display the systray
        @info only availble with 'systray' name choosed
        '''
        self.systray.set_visible(True)

    def systray_hide(self,widget,event=None,arg=None):
        '''
        @brief hide the systray
        @info only availble with 'systray' name choosed
        '''
        self.systray.set_visible(False)    

    def on_blinking(self,widget,event=None,arg=None):
        '''
        @brief starts notify icon blinking
        @info only availble with 'systray' name choosed
        '''
        self.systray.set_blinking(True)

    def off_blinking(self,widget,event=None,arg=None):
        '''
        @brief stops notify icon blinking
        @info only availble with 'systray' name choosed
        '''
        self.systray.set_blinking(False)

    '''
    *** widgets couleurs
    '''
    def on_colorbutton(self,widget,event=None,arg=None):
        '''
        @brief the chosen colour
        @info signal: color-set
        '''
        color_gtk = widget.get_color()
        self.gtk_to_rgb(widget, color_gtk)

    def on_colorsel(self,widget,event=None,arg=None):
        '''
        @brief to be filled in for the colorselectiondialog, colorsel­color_selection
        @info signal: color-changed
        @return couleur (#FFEEFF)
        '''
        color_gtk = widget.get_current_color()
        self.gtk_to_rgb(widget, color_gtk)

    def gtk_to_rgb(self,widget, color_gtk):
        color = color_gtk.to_string()
        rgb='#%s%s%s' % ( color[1:3], color[5:7], color[9:11] )
        if import_py is not None:
            getattr(self.th.IMPORT, widget.get_name()) (rgb.upper() )
            return
        self.send_data('%s %s' % (widget.get_name(), rgb.upper() ) )

    '''
    *** widget char font
    '''
    def on_font(self,widget,event=None,arg=None):
        '''
        @brief the chosen font
        @return pangoFontDescription
        '''
        nom  = widget.get_name()
        font = widget.get_font_name()
        if import_py is not None:
            getattr(self.th.IMPORT, widget.get_name()) (font)
            return
        self.send_data('%s %s' % (nom, font ) )

    '''
    *** Widgets management (show, sensitive, active) on - off
    '''
    def on_hide(self,widget,event=None,arg=None):
        '''
        @brief hide a widget
        @info the widget must be indicated in the user data
        '''
        self.set_dic_widget(widget, 1)
        widget.hide()

    def on_show(self,widget,event=None,arg=None):
        '''
        @brief display a widget
        @info the widget must be indicated in the user data
        '''
        self.set_dic_widget(widget, 1)
        widget.show()

    def on_sensitive(self,widget,event=None,arg=None):
        '''
        @brief widget stops being grey
        @info the widget must be indicated in the user data
        '''
        self.set_dic_widget(widget, 0)
        widget.set_sensitive(True)

    def off_sensitive(self,widget,event=None,arg=None):
        '''
        @brief widget becomes grey
        @info the widget must be indicated in the user data
        '''
        self.set_dic_widget(widget, 0)
        widget.set_sensitive(False)

    def on_active(self,widget,event=None,arg=None):
        '''
        @brief toggle activate
        @info the widget must be indicated in the user data
        '''
        self.set_dic_widget(widget, 2)
        widget.set_active(True)

    def off_active(self,widget,event=None,arg=None):
        '''
        @brief toggle deactivate
        @info the widget must be indicated in the user data
        '''
        self.set_dic_widget(widget, 2)
        widget.set_active(False)

    '''
    *** Widgets toggle, management via dictionnary
    '''                
    def toggle_sensitive(self, widget, event=None,arg=None):
        '''
        @brief toggle between grey/not-grey
        @info the widget must be indicated in the user data
        '''
        name = widget.get_name()
        self.set_dic_widget(widget, 0)
        widget.set_sensitive( self.dic_widget[name][0] )

    def toggle_visible(self, widget, event=None,arg=None):
        '''
        @brief toggle between show/hide
        @info the widget must be indicated in the user data
        '''
        name = widget.get_name()
        if self.dic_widget[name][1]:
            widget.hide()
        else:
            widget.show()
        self.set_dic_widget(widget, 1)

    def toggle_active(self, widget, event=None,arg=None):
        '''
        @brief toggle between activate/deactivate
        @info the widget must be indicated in the user data
        '''
        name = widget.get_name()
        self.set_dic_widget(widget, 2)
        widget.set_active( self.dic_widget[name][2] )    

    def set_dic_widget(self, widget, place):
        name = widget.get_name()
        if self.dic_widget[name][place]:
            self.dic_widget[name][place] = False
        else: 
            self.dic_widget[name][place] = True

    '''
    *** filechooser
    '''        
    def on_filechoose(self,widget,event=None,arg=None):
        '''
        @brief the filechooser selection
        @info signal: selection-changed
        @return selected file
        '''
        nom    = widget.get_name()
        valeur = widget.get_filename()
        if valeur == self.var_filechoose or valeur is None: return
        self.var_filechoose = valeur
        if import_py is not None:
            getattr(self.th.IMPORT, nom) (valeur)
            return
        self.send_data('%s %s' % (nom, valeur) )

    '''
    *** combobox, spinbutton, calendar, data input zone, scale,
          context menu, linkbutton, activate
    '''
    def on_combo(self,widget,event=None,arg=None):
        '''
        @brief the combobox selection
        @info signal: changed
        @return selection
        '''
        nom    = widget.get_name()
        #~FIXME GTK3
        valeur = widget.get_active_text()
        if valeur is not None:
            if import_py is not None:
                getattr(self.th.IMPORT, nom) (valeur)
                return
            self.send_data('%s %s' % (nom, valeur) )

    def on_spinbutton(self,widget,*arg):
        '''
        @brief the spinbutton value
        @return value (1.0)
        '''
        nom    = widget.get_name()
        valeur = widget.get_value()
        if import_py is not None:
            getattr(self.th.IMPORT, nom) (valeur)
            return
        self.send_data('%s %s' % (nom, valeur) )

    def on_calendar(self,widget,event=None,arg=None):
        '''
        @brief the chosen date
        @return (year, month, day)
        '''
        nom    = widget.get_name()
        valeur = widget.get_date()
        if import_py is not None:
            getattr(self.th.IMPORT, nom) (valeur)
            return
        self.send_data('%s %s' % (nom, valeur) )

    def on_entry(self,widget, icon=None, event=None):
        '''
        @brief the entry text, or click on primary or secondary icon
        @return sh: text or primary@text or secondary@text
        @return py: (arg, text)
        @return arg = '' or 'primary' or 'secondary'
        '''
        nom    = widget.get_name()
        valeur = widget.get_text()
        try:
            if icon   == gtk.ENTRY_ICON_PRIMARY:
                v = 'primary@'
            elif icon == gtk.ENTRY_ICON_SECONDARY:
                v = 'secondary@'
            else:
                v = ''
        except:
            v = ''
        if import_py is not None:
            getattr(self.th.IMPORT, nom) (valeur, v)
            return
        self.send_data('''%s %s%s''' % (nom, v, valeur) )

    def clear_entry(self,widget, event=None,arg=None):
        '''
        @brief delete the text of an entry
        '''
        widget.set_text('')

    def on_scale(self,widget,event=None,value=None):
        '''
        @brief when the cursor moves
        @info signal: value-changed
        @return (0 to 100)
        '''
        nom    = widget.get_name()
        valeur = widget.get_value()
        if import_py is not None:
            getattr(self.th.IMPORT, nom) (valeur)
            return
        self.send_data('%s %s' % (nom, valeur) )

    def on_menu(self,widget,event=None,arg=None):
        '''
        @brief launch contextmenu
        @info the widget menu must be indicated in the user data
        '''
        if event is not None:
            if event.button == 3:
                widget.popup(None,None,None,event.button,event.time)

    def on_linkbutton(self,widget,event=None,arg=None):
        '''
        @brief web link
        @return http://...
        '''
        nom    = widget.get_name()
        valeur = widget.get_uri()
        if import_py is not None:
            getattr(self.th.IMPORT, nom) (valeur)
            return
        self.send_data('%s %s' % (nom, valeur) )

    '''
    *** user click
    '''
    def clic_droit(self,widget,event=None,arg=None):
        '''
        @brief when right click
        @return clic_droit
        '''
        if event is not None:
            if event.button == 3:
                if import_py is not None:
                    getattr(self.th.IMPORT, widget.get_name()) ('clic_droit')
                    return
                self.send_data('%s %s' % (widget.get_name() , 'clic_droit') )

    def double_clic(self,widget,path=None,view_colomn=None):
        '''
        @brief the treeview selection
        @info signal: row-activated
        @return sh: double_clic@line@data
        @return py: ((path), [row selected,], 'double_clic')
        '''
        self.on_treeview(widget,'dblc')

    def on_clicked(self, widget,event=None,arg=None):
        '''
        @brief can be used for any widget
        @return clicked
        '''
        if self.flag_right_clic:
            self.flag_right_clic = False
        else:
            if import_py is not None:
                getattr(self.th.IMPORT, widget.get_name()) ('clicked')
                return
            self.send_data( '%s %s' % (widget.get_name(), 'clicked') )

    def press_event(self, widget, event=None,arg=None):
        '''
        @brief can be used for any widget
        @return press_event
        '''
        if import_py is not None:
            getattr(self.th.IMPORT, widget.get_name()) ('press_event')
            return
        self.send_data( '%s %s' % (widget.get_name(), 'press_event') )

    def release_event(self, widget, event=None,arg=None):
        '''
        @brief can be used for any widget
        @return release_event
        '''
        if import_py is not None:
            getattr(self.th.IMPORT, widget.get_name()) ('release_event')
            return
        self.send_data( '%s %s' % (widget.get_name(), 'release_event') )

    def get_pointer(self, widget, event=None,arg=None):
        '''
        @brief Curseur location in the widget
        @return sh: pointer@x y
        @return py: ('pointer', x, y)
        '''
        name = widget.get_name()
        x, y = widget.get_pointer()
        if import_py is not None:
            getattr(self.th.IMPORT, widget.get_name()) ('pointer', x, y)
            return
        self.send_data( '%s pointer@%s %s' % (name, x, y) )

    '''
    *** treeview
    '''
    def on_treeview(self,widget,event=None,arg=None):
        '''
        @brief the treeview selection
        @info signal: cursor-changed
        @return sh: line@data
        @return py: ((path), [row selected,])
        '''
        nom = widget.get_name()
        arg = self.th.retourne_selection(nom)
        pyarg = arg
        if arg:
            if event =='dblc':
                if import_py is not None: pyarg.append('double_clic')
                arg='double_clic@%s' % (arg)
            if import_py is not None:
                getattr(self.th.IMPORT, widget.get_name()) (*pyarg)
                return
            self.send_data('%s %s' % (nom, arg) )

    def select_up(self,widget,event=None,arg=None):
        '''
        @brief push up the selected line
        '''
        self.th.TREEUP( '_@@_@@%s' % widget.get_name() )

    def select_down(self,widget,event=None,arg=None):
        '''
        @brief push down the selected line
        '''
        self.th.TREEDOWN( '_@@_@@%s' % widget.get_name() )

    def select_top(self,widget,event=None,arg=None):
        '''
        @brief push up the selected line in first position
        '''
        self.th.TREETOP( '_@@_@@%s' % widget.get_name() )

    def select_bottom(self,widget,event=None,arg=None):
        '''
        @brief push down the selected line in last position
        '''
        self.th.TREEBOTTOM( '_@@_@@%s' % widget.get_name() )

    '''
    *** radio, check, toggle button
    '''
    def on_toggled(self, widget,event=None,arg=None):
        '''
        @brief the status of a check/radio/togglebutton
        @info signal: toggled
        @return True or False
        '''
        nom   =widget.get_name()
        value = widget.get_active()
        self.dic_widget[nom][2] = value
        if import_py is not None:
            getattr(self.th.IMPORT, nom) (value)
            return
        self.send_data('%s %s' % (nom, value) )

    def my_callback(self, widget,event=None,arg=None):
        '''
        @brief can be used for any widget
        @return my_callback
        '''
        if import_py is not None:
            getattr(self.th.IMPORT, widget.get_name()) ('my_callback')
            return
        self.send_data( '%s %s' % (widget.get_name(), 'my_callback') )

    '''
    *** cursor overflight
    '''        
    def enter_notify_event(self, widget,event=None,arg=None):
        '''
        @brief when the cursor enters above a widget
        @info signal: enter-notify-event
        @return enter_notify_event
        '''
        if widget:
            if import_py is not None:
                getattr(self.th.IMPORT, widget.get_name()) ('enter_notify_event')
                return
            self.send_data( '%s %s' % (widget.get_name(), 'enter_notify_event' ) )

    def leave_notify_event(self, widget,event=None,arg=None):
        '''
        @brief when the cursor goes out a widget
        @info signal: leave_notify_event
        @return leave_notify_event
        '''
        if widget:
            if import_py is not None:
                getattr(self.th.IMPORT, widget.get_name()) ('leave_notify_event')
                return
            self.send_data( '%s %s' % (widget.get_name(), 'leave_notify_event' ) )

    '''
    *** keyboard key
    '''
    def key_press(self,widget, event):
        '''
        @brief press a key
        @info signal: key_ press_event
        @return sh: press@key
        @return py: (press, key)
        '''
        key = gtk.gdk.keyval_name(event.keyval)
        if import_py is not None:
            getattr(self.th.IMPORT, widget.get_name()) ('press', key)
            return
        self.send_data( '%s %s' % (widget.get_name(), 'press@%s' % key) )

    def key_release(self,widget, event):
        '''
        @brief release a key
        @info signal: key_ release_event
        @return sh: release@key
        @return py: release, key
        '''
        key = gtk.gdk.keyval_name(event.keyval)
        if import_py is not None:
            getattr(self.th.IMPORT, widget.get_name()) ('release', key)
            return
        self.send_data( '%s %s' % (widget.get_name(), 'release@%s' % key) )

    '''
    *** expander
    '''
    def toggle_expander(self, widget, event=None,arg=None):
        '''
        @brief change the expander state
        @info the widget must be indicated in the user data
        '''
        if widget.get_expanded():
            widget.set_expanded(False)
        else:
            widget.set_expanded(True)

    def on_expander(self, widget, event=None,arg=None):
        '''
        @brief expand the expander
        @info the widget must be indicated in the user data
        '''
        widget.set_expanded(True)

    def off_expander(self, widget, event=None,arg=None):
        '''
        @brief close the expander
        @info the widget must be indicated in the user data
        '''
        widget.set_expanded(False)

    def expander_cb(self, widget, event=None,arg=None):
        '''
        @brief action on expander
        @info signal: activate
        @return True or False
        '''
        if import_py is not None:
            getattr(self.th.IMPORT, widget.get_name()) (widget.get_expanded())
            return
        self.send_data( '%s %s' % (widget.get_name(), widget.get_expanded()))

    '''
    *** terminal
    '''
    def kill_term_child(self, widget, arg=9):
        '''
        @brief kills the process launched in terminal
        '''
        DEBUG('[terminal] kill: %s' % self.terminal_PID)
        try:
            os.kill( self.terminal_PID, arg)
            self.terminal_PID = self.terminal.fork_command()
        except:
            DEBUG('No process or unactive kill -9')

    '''
    *** notebook
    '''
    def on_page(self, widget, event=None,arg=None):
        '''
        @brief Displays a page of the notebook
        @info the page must be indicated in the user data
        '''
        notebook = widget.get_parent()
        num = notebook.page_num(widget)
        notebook.set_current_page( num )

    def page_next(self, widget, event=None,arg=None):
        '''
        @brief Displays next page of the notebook
        @info the notebook must be indicated in the user data
        '''
        widget.next_page()

    def page_prev(self, widget, event=None,arg=None):
        '''
        @brief Displays previous page of the notebook
        @info the notebook must be indicated in the user data
        '''
        widget.prev_page()

    def auto_scale(self, widget, rect=None,arg=None):
        '''
        @brief when the widget size is modified
        @info 
        @return sh: scale@width height
        @return py: ('scale', width, height)
        '''
        x, y, width, height = rect
        if (self.old_scale_width != width or self.old_scale_height != height):
            self.old_scale_width, self.old_scale_height = (width, height)
            if import_py is not None:
                getattr(self.th.IMPORT, widget.get_name()) ('scale', width, height)
                return
            self.send_data( '%s scale@%s %s' % (widget.get_name(), width, height) )

    def auto_scale_img(self, widget, rect=None,arg=None):
        '''
        @brief changes the size of a picture according to its container
        @info put the image in a box and connect the signal
        @info signal: size-allocate, user data: image
        @return sh: img_scale="width height"
        @return py: img_scale = (width, height)
        '''
        x, y, width, height = rect
        if import_py is not None:
            setattr(self.th.IMPORT, widget.get_name()+'_scale', (width, height))
        else:
            self.send_data( 'GET@%s_scale="%s %s"' % (widget.get_name(),
                                                               width, height) )
        filename = self.dic_img[ widget.get_name() ]
        if (self.old_width_img != width or self.old_height_img != height):
            self.old_width_img, self.old_height_img = (width, height)
            size = width
            if height > width:
                size = height
            pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(filename, width, height)
            gobject.idle_add(widget.set_from_pixbuf,pixbuf)
            DEBUG('[[ SCALE IMG ]] %s %s %s'% (width, height, filename))

class GuiWebkit(object):
    '''
    ************************
    *** Webkit navigator ***
    ************************
    '''
    def make_navigateur(self, name, box):
        nav = self.return_navigateur(name)
        box = eval('self.%s' % box)
        scrolled = gtk.ScrolledWindow()
        scrolled.add(nav)
        box.add(scrolled)
        exec( 'self.%s = nav' % name)
        box.show_all()

    def return_navigateur(self, name):
        webview = webkit.WebView()
        webview.set_property('name', name)
        webview.connect("navigation-policy-decision-requested", self.nav_request)
        webview.connect("document-load-finished", self.document_load_finished_cb)
        if name in dic_webrequest:
            idc = webview.connect("resource-request-starting", self.resource_request_cb)
            #dic_websignal[name]["resource-request-starting"] = idc
            self.add_signal_to_dic(name, "webrequest", idc)
        if name in dic_webcache:
            try:
                l = [i for i in os.listdir(dic_webcache[name][0])]
            except: l =[]
            self.liste_cache = l
            idc = webview.connect("resource-request-starting", self.resource_cache_cb)
            #dic_websignal[name]["resource-request-starting"] = idc
            self.add_signal_to_dic(name, "webcache", idc)
        
        if name in dic_webdownload:
            idc = webview.connect("download-requested", self.download_requested_cb)
            #dic_websignal[name]["download-requested"] = idc
            self.add_signal_to_dic(name, "webdownload", idc)
        if name in l_weboverlink:
            idc = webview.connect("hovering-over-link", self.hovering_over_link_cb)
            self.add_signal_to_dic(name, "weboverlink", idc)
            self.old_hovering_link = None
        return webview

    def document_load_finished_cb(self, webview, webframe):
        webview.execute_script('''var oldTitle = document.title;
        function getMyElementAtPoint(value,x,y) {
        var elementPoint = document.elementFromPoint(x,y);
        if(elementPoint.nodeName == 'IMG' && elementPoint.parentNode.nodeName == 'A') {
            if(value == 'html') {
                document.title = elementPoint.parentNode.outerHTML;
            } else {
                /*alert(elementPoint.src);*/
                document.title = elementPoint.src + ' ' + elementPoint.parentNode;
            }
        } else {
            if(value == 'html') {
                document.title = elementPoint.outerHTML;
            } else {
                /*alert(elementPoint);*/
                document.title = elementPoint;
            }
        }
        }
        function createLinkCom()
        {
            var link =  document.createElement("a");
            link.href = '#';
            link.style.display = 'none';
            link.id = 'com_lien';
            document.getElementsByTagName('body')[0].appendChild(link);
            return link;
        }
        function injectJsFile(uri) {
            var arg = document.createElement('script');
            arg.type = "text/javascript";
            arg.src = uri;
            document.getElementsByTagName('body')[0].appendChild(arg);
        }
        function injectCssFile(uri) {
            var arg = document.createElement('link');
            arg.type = "text/css";
            arg.href = uri;
            arg.rel = "stylesheet";
            document.getElementsByTagName('body')[0].appendChild(arg);
        }
        function sendTo(fonction, arg, cmd) {
            var com_lien = document.getElementById("com_lien");
            if(!com_lien) { 
                var com_lien = createLinkCom();
            }
            com_lien.setAttribute("href", cmd + fonction + arg );
            var evt = document.createEvent("cursorEvents");
            evt.initEvent("click", true, true);
            com_lien.dispatchEvent(evt);
        }
        function sendToScript(fonction, arg) {
            sendTo(fonction, ' ' + arg, 'g2s:')
        }
        function sendToGtk(fonction) {
            sendTo(fonction, ' ', 'G2S:')
        }
        ''')
        name = webview.get_name()
        if name in l_webloaded:
            if import_py is not None:
                getattr(self.th.IMPORT, name) ('loaded')
            self.send_data('%s loaded' % name )

    def add_signal_to_dic(self, name, signal, idc):
        try:
            dic_websignal[name][signal] = idc
        except:
            dic_websignal[name] = {signal:idc}

    def append_menuitem(self, widget, dic, menu, name):
        '''
        widget =  window or webview
        dic = { name: [[item, function, value],[....]],}
        menu = gtk.Menu
        name = widget name
        '''
        for elem in dic[name]:
            item, function, value = elem
            if item == 'separator':
                separator = gtk.SeparatorMenuItem()
                menu.append( separator )
                separator.show()
            else:
                menuitem = gtk.MenuItem(label=item)
                menuitem.connect('activate', self.call_function_from_webmenu,
                            item, function, value, widget.get_pointer(), widget)
                menu.append(menuitem)
                menuitem.show()
                try:
                    self.append_submenuitem(widget, menuitem, dic_websubmenu, 
                                         item, self.call_function_from_webmenu)
                except:
                    pass

    def append_submenuitem(self, widget, menuitem, dic, name, callback):
        '''
        widget =  window or webview
        menuitem = gtk.MenuItem
        dic = { name: [[item, function, value],[....]],}
        name = item of gtk.MenuItem
        callback = fonction to call
        '''
        menu = gtk.Menu()
        for elem in dic[name]:
            item, function, value = elem
            if item == 'separator':
                separator = gtk.SeparatorMenuItem()
                menuitem.append( separator )
            else:
                menuit = gtk.MenuItem(label=item)
                menuit.connect('activate', callback,
                                    item, function, value, widget.get_pointer(), widget)
                menu.append(menuit)
        menuitem.set_submenu(menu)
        menu.show_all()

    def populate_popup_cb(self, webview, menu):
        name = webview.get_name()
        if dic_webmenu[name]:
            for item in menu.get_children():
                item.hide()
        try:
            self.append_menuitem(webview, dic_webmenu, menu, name)
        except:
            pass
        menu.show()

    def call_function_from_webmenu(self, menuitem, name, function, value,
                                   t_place, webview):
        webview.execute_script("getMyElementAtPoint('%s', '%s', '%s');" % \
                                               (value, t_place[0], t_place[1]))
        arg = webview.get_main_frame().get_title()
        webview.execute_script("document.title=oldTitle;")
        if import_py is not None:
            getattr(self.th.IMPORT, function) (name, arg)
            return
        self.send_data('%s %s@%s' % (function, name, arg) )
    
    def download_requested_cb(self, webview, download):
        uri         = download.get_uri()
        name        = webview.get_name()
        webdownload = dic_webdownload[name]
        if webdownload == "GetLink":
            if import_py is not None:
                getattr(self.th.IMPORT, name) ('GetLink', uri)
            else:
                self.send_data('%s GetLink@%s' % (name, uri) )
            return False
        dialog = gtk.FileChooserDialog("Choose a destination", None, gtk.FILE_CHOOSER_ACTION_SAVE,
        (gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL, gtk.STOCK_SAVE, gtk.RESPONSE_OK))
        dialog.set_current_name(os.path.basename(uri))
        try:
            dialog.set_current_folder(self.path_folder_download_selected)
        except: pass
        if dialog.run() == gtk.RESPONSE_OK:
            filename = dialog.get_uri()
            self.path_folder_download_selected = os.path.dirname(filename.replace('file://',''))
            if webdownload == 'UserChoose':
                if import_py is not None:
                    getattr(self.th.IMPORT, name) ('UserChoose', uri, filename)
                else:
                    self.send_data('%s UserChoose@%s %s' % (name, uri, filename) )
                dialog.destroy()
                return False
            elif webdownload == 'UserSave':
                n=1
                while os.path.exists(filename.replace('file://','')):
                    path, ext = os.path.splitext(filename)
                    filename = path+str(n)+ext
                    n+=1
                download.set_destination_uri(filename)
                if import_py is not None:
                    getattr(self.th.IMPORT, name) ('UserSave', uri, filename)
                else:
                    self.send_data('%s UserSave@%s %s' % (name, uri, filename) )
                dialog.destroy()
                return True
        dialog.destroy()
        return False

    def resource_cache_cb(self, view, frame, source, request, response):
        name = view.get_name()
        path = source.get_uri ()
        #print '_____path', path
        base = path.split('/')[-1]
        try:
            dossier, pattern, dialog = dic_webcache[name]
            if re.search(pattern, path):
                if not base in self.liste_cache:
                    urllib.urlretrieve(path, os.path.join(dossier, base) )
                    self.liste_cache.append(base)
                    if dialog == 'verbose':
                        if import_py is not None:
                            getattr(self.th.IMPORT, name) ('cache', base)
                        else:
                            self.send_data('%s cache@%s' % (name, base) )
                request.set_uri(os.path.join('file://'+dossier, base) )
        except: pass

    def resource_request_cb(self, view, frame, source, request, response):
        name = view.get_name()
        path = source.get_uri ()
        #print '_____path', path
        base = path.split('/')[-1]
        try:
            pattern = dic_webrequest[name]
            if pattern == 'All':
                if import_py is not None:
                    getattr(self.th.IMPORT, name) ('request', base)
                else:
                    self.send_data('%s request@%s' % (name, base) )
            elif re.search(pattern, path):
                if import_py is not None:
                    getattr(self.th.IMPORT, name) ('request', base)
                else:
                    self.send_data('%s request@%s' % (name, base) )
                request.set_uri('about:blank')
        except: pass

    def nav_request(self, webview, frame, request, navigation_action, policy_decision):
        uri  = request.get_uri()
        name = webview.get_name()
        try:
            if re.search( dic_weblinkfilter[name], uri):
                if import_py is not None:
                    getattr(self.th.IMPORT, name) ('linkfilter', uri)
                else:
                    self.send_data('%s linkfilter@%s' % (name, uri))
                return True
        except: pass 
        if uri.startswith("g2s:"):
            data = uri.replace('g2s:','')
            if import_py is not None:
                name, data = data.split(' ',1)
                getattr(self.th.IMPORT, name) ('linkfilter', urllib.unquote(data))
            else:
                self.send_data(  urllib.unquote(data) )
        elif uri.startswith("G2S:"):
            data = uri.replace('G2S:','')
            data = urllib.unquote(data)
            cmd = data.split('@')[0]
            getattr(self.th, cmd)(data)
        else: return False
        return True

    def hovering_over_link_cb(self, webview, title, uri):
        name = webview.get_name()
        if self.old_hovering_link != uri or uri is None:
            if import_py is not None:
                getattr(self.th.IMPORT, name) ('overlink', uri)
            else:
                self.send_data('%s overlink@%s' % (name, uri) )


class GuiXmlParser(object):
    '''
    ********************
    *** Parser glade ***
    ********************
    '''
    def parse_xml(self):
        self.dic_img = {}
        dom = parse(f_glade)
        l   = dom.getElementsByTagName(USERLIB)
        widgets2ref = ['GtkWindow', 'GtkEventBox', 'GtkTreeView',
                 'GtkStatusbar', 'GtkAboutDialog', 'GtkButton',
                 'GtkComboBoxEntry', 'GtkComboBox', 'GtkImage']
        child2ref = ['sensitive', 'visible', 'active', 'pixbuf']
        for node in l:
            widget = node.attributes['class'].value
            name = node.attributes['id'].value
            #add to dic for each widget 'sensitive', 'visible', 'active',
            # necessary to manage the commands and callback toggle 
            self.dic_widget[name] = [True, False, False]
            if widget in widgets2ref or name.startswith('_'):
                exec_widget = 'self.%s=self.widgets.get_%s("%s")' % (name, USERLIB, name)
                try:
                    exec(exec_widget)
                except:
                    DEBUG("[[ ERROR ]] can't assign widget, name: %s"% name)
                    continue
                if USERLIB == 'object':
                    wid = eval('self.%s' % name)
                    wid.set_name(name)
                DEBUG('[[ WIDGETS ]] ====>>>> %s' % name)
                try:
                    getattr(self, widget)(name)
                except: pass
                #except TypeError,e:
                    #print "Unexpected error:",e
            for child in node.childNodes:
                if (child.nodeType == child.TEXT_NODE or not child.hasAttributes() 
                    or child.nodeName == "child"): continue
                child_name = child.attributes['name'].value
                try:
                    child_data = child.firstChild.data
                    if child_name in child2ref: # launch function modif dico
                        getattr(self, child_name)(name, child_data)
                except:
                    pass
                if child_name == 'drag_drop':
                    self.set_drag_drop(name)

    def GtkTextView(self, nom):
        pass

    def GtkLabel(self, nom):
        pass

    def pixbuf(self, nom, data):
        self.dic_img[nom] = data

    def active(self, nom, data):
        if data =='True':
            self.dic_widget[nom][2] = True

    def visible(self, nom, data):
        if data =='True':
            self.dic_widget[nom][1] = True

    def sensitive(self, nom, data):
        if data =='False':
            self.dic_widget[nom][0] = False

    def GtkWindow(self, nom):
        window=eval('self.%s' % (nom) )
        window.connect('realize', self.window_realize_cb)
        if gtkrc is not None:
            self.apply_gtkrc( window, gtkrc )
        screen = window.get_screen()
        self.screen_width, self.screen_height = (screen.get_width(),
                                                    screen.get_height())
        DIC_ENV['G2S_SCREEN_HEIGHT'] = str(self.screen_height)
        DIC_ENV['G2S_SCREEN_WIDTH'] = str(self.screen_width)

    def window_realize_cb(self, window):
        self.window_realized = True

    def GtkTreeView(self, nom):
        exec( 'treeview=self.%s' % (nom) )
        try:
            self.make_treeview(nom, treeview)
        except ValueError, e: 
            DEBUG('==== [[ ERROR ]] ===>> %s' % e)
        treeview.enable_model_drag_source( gtk.gdk.BUTTON1_MASK,
                                                self.CIBLES,
                                                gtk.gdk.ACTION_DEFAULT|
                                                gtk.gdk.ACTION_MOVE)
        treeview.enable_model_drag_dest( self.CIBLES,
                                            gtk.gdk.ACTION_DEFAULT)

    def GtkStatusbar(self, nom):
        exec("self.context_%s = self.%s.get_context_id('context_description')" % (nom,nom) )

    def GtkComboBox(self, nom):
        exec( 'combo=self.%s' % (nom) )
        try:
            self.make_combo(nom, combo)
        except ValueError, e: 
            DEBUG('==== [[ ERROR COMBO ]] ===>> %s' % e)

    def GtkComboBoxEntry(self, nom):
        exec( 'combo=self.%s' % (nom) )
        combo.child.set_name('%s_entry' % nom)
        setattr(self, '%s_entry' % nom, combo.child)
        try:
            self.make_combo(nom, combo)
        except ValueError, e: 
            DEBUG('==== [[ ERROR COMBO ]] ===>> %s' % e)


class GuiTreeview(object):
    '''
    ****************************
    *** Treeview creation    ***
    ****************************
    '''
    def make_treeview(self,name,treeview):
        '''
        dic_treeview[name] = ['ICON%%5%%clic%%check|ICON%%clic%%radio|Colonne%%50%%editable|CHECK%%check|RADIO%%radio|Colonne%%50|FONT|COMBO%%combo%%mp3%%ogg%%défaut','data|dtat|dtat|....']
        store_base=['str', 'str', 'str', 'bool', 'bool', 'str', 'str', 'str']
        dic_entet={'RADIO4': ['radio'], 'ICON0': ['5', 'clic', 'check'], 'ICON1': ['clic', 'radio'], 'COMBO7': ['combo', 'mp3', 'ogg', 'd\xc3\xa9faut'], 'Colonne5': ['50'], 'Colonne2': ['50', 'editable'], 'FONT6': [], 'FONT': 6, 'CHECK3': ['check']}
        liste_base=['ICON_0', 'ICON_1', 'Colonne_2', 'CHECK_3', 'RADIO_4', 'Colonne_5', 'FONT_6', 'COMBO_7']    
        '''
        DEBUG('[[ TREEVIEW ]] ==> Start make')
        store_base = []
        liste_base = []
        value_ent  = []
        self.dic_entet = {}
        FBF = ['FONT', 'BACK', 'FORE']
        dic_elem_entet = {'FONT':'str', 'BACK':'str', 'FORE':'str', 'CHECK':'bool',
                          'RADIO':'bool', 'PROGRESS':'int', 'HIDE':'str', 'FORE':'str',
                          'COMBO':'str', 'ICON':'str', 'IMG':'gtk.gdk.Pixbuf' }
        liste_treeview =  dic_treeview[name]
        #ref = ICON|colonne
        ref=liste_treeview.pop(0)
        liste_ref=ref.split('|')
        n=0
        for l in liste_ref:
            liste_l = l.split('%%')
            # ent = ICON, CHECK ...
            ent = liste_l.pop(0)
            # ent_n = ICON_1, CHECK_2 ...
            ent_n = '%s_%s' % (ent, n)
            try:
                # ajoute str, bool ...
                store_base.append( dic_elem_entet[ent] )
            except:
                store_base.append('str')
            liste_base.append( ent_n )
            self.dic_entet[ent_n] = liste_l
            if ent in FBF: #reference the column
                self.dic_entet[ent] = n
            n+=1
        DEBUG('[[ TREEVIEW ]] => %s colonnes' % n)
        
        var=','.join(store_base)
        exec( 'self.store_%s= gtk.TreeStore(%s)' % (name,var) )
        exec( 'mystore=self.store_%s' % (name) )
        l = []
        for ent in liste_base:
            n = ent.split('_')[1]
            call_fonction = ent.split('_')[0]
            try: #test if the header is a function
                vv = dic_elem_entet[call_fonction]
                value_ent = self.dic_entet[ent]
            except: #if not, it is a text column
                value_ent = [call_fonction]+self.dic_entet[ent]
                call_fonction = 'TEXT'
            titre_col=' '
            getattr(self, call_fonction)(name, treeview, mystore, int(n),
                                                    value_ent, titre_col)
        if liste_treeview: # if lines are passed as arguments, loads the TreeStore
            for ligne in liste_treeview:
                path = ligne.split('|')[0]
                parent, position = self.try_path(path, mystore)
                mystore.append(parent, self.modif_type(ligne, mystore) )
        treeview.set_model(mystore)
        DEBUG('[[ TREEVIEW ]] ==> Treeview Loaded')

    def try_path(self, position, mystore):
        try:
            parent, position = position.split(':')
            iter = mystore.get_iter(parent)
        except:
            iter = None
        return (iter, position)

    def IMG(self, name, treeview, mystore, num_col, l_value, titre):
        DEBUG('[[ TREEVIEW ]] ==> Image %s' % num_col)
        self.ICON(name, treeview, mystore, num_col, l_value, titre, False)

    def ICON(self, name, treeview, mystore, num_col, l_value, titre,
             flag_icon=True):
        DEBUG('[[ TREEVIEW ]] ==> Icon %s' % num_col)
        CLIC = False
        render = gtk.CellRendererPixbuf()
        for lm in l_value:
            try:  # if it is a number
                size = int(lm)
                render.set_property('stock_size', size )
                DEBUG('[[ TREEVIEW ]] => Icon > size %s' % size)
            except:
                if lm == 'clic': # make the icon clickable
                    DEBUG('[[ TREEVIEW ]] => Icon > clic')
                    CLIC=True
                else:
                    titre=lm
        if flag_icon:
            col = gtk.TreeViewColumn(titre, render, icon_name=num_col)
        else: col = gtk.TreeViewColumn(titre, render, pixbuf=num_col)
        if CLIC:
            treeview.connect_after('cursor-changed', self.rappel_clic, col,
                                   name, num_col)
        treeview.append_column(col)
        return True

    def CHECK(self, name, treeview, mystore, num_col, l_value, titre):
        DEBUG('[[ TREEVIEW ]] ==> Check %s' % num_col)
        if l_value: titre = l_value[0]
        render = gtk.CellRendererToggle()
        render.connect('toggled', self.rappel_toggled, mystore, num_col, name)
        col = gtk.TreeViewColumn(titre, render, active=num_col)
        treeview.append_column(col)

    def RADIO(self, name, treeview, mystore, num_col, l_value, titre):
        DEBUG('[[ TREEVIEW ]] ==> Radio %s' % num_col)
        if l_value: titre = l_value[0]
        render = gtk.CellRendererToggle()
        render.set_property('radio',True)
        render.connect('toggled', self.rappel_radio, mystore, num_col, name)
        col = gtk.TreeViewColumn(titre,render,active=num_col)
        treeview.append_column(col)
        self.DIC_RADIO[num_col]=0

    def COMBO(self, name, treeview, mystore, num_col, l_value, titre):
        DEBUG('[[ TREEVIEW ]] ==> Combo %s' % num_col)
        if l_value:
            titre = l_value.pop(0)
            for lm in l_value:
                try:
                    size = int(lm)
                    render.set_property('width', size )
                    DEBUG('[[ TREEVIEW ]] => Combo > size %s'% size)
                except:
                    pass
            liste_combo = [ [i] for i in l_value ]
        store_combo = gtk.ListStore(str)
        for li in liste_combo:
            store_combo.append(li)
        render = gtk.CellRendererCombo()
        render.set_property('model',store_combo)
        render.set_property('text-column', 0)
        render.set_property('editable',True)
        render.connect('edited', self.rappel_edited, name, mystore, num_col,
                                                            'combo',treeview)
        col=gtk.TreeViewColumn(titre, render, text=num_col)
        try:
            col_font = self.dic_entet['FONT']
            col.add_attribute(render,'font', col_font)
        except: pass
        treeview.append_column(col)
        DEBUG('[[ TREEVIEW ]] => Loaded')

    def PROGRESS(self, name, treeview, mystore, num_col, l_value, titre):
        DEBUG('[[ TREEVIEW ]] ==> Progressbar %s' % num_col)
        render = gtk.CellRendererProgress()
        if l_value:
            for lm in l_value:
                try:
                    size = int(lm)
                    render.set_property('width', size )
                    DEBUG('[[ TREEVIEW ]] => Progress > size %s'% size)
                except:
                    titre = lm
        col = gtk.TreeViewColumn(titre, render, value=num_col)
        treeview.append_column(col)

    def TEXT(self, name, treeview, mystore, num_col, l_value, titre):
        DEBUG('[[ TREEVIEW ]] ==> Texte %s' % num_col)
        render = gtk.CellRendererText()
        size = None
        self.column_sizing = True
        if l_value:
            titre = l_value.pop(0)
            for lm in l_value:
                try:
                    size = int(lm)
                    render.set_property('width', size )
                    self.column_sizing = False
                    DEBUG('[[ TREEVIEW ]] => Texte > colonne size %s'% size)
                except:
                    if lm == 'editable':
                        render.set_property('editable', True)
                        render.connect('edited', self.rappel_edited, name,
                                mystore, num_col, 'edit', treeview)
                        self.col_edit = num_col
                        DEBUG('[[ TREEVIEW ]] => Texte > editable %s'% num_col)
        #else: titre=elem
        col=gtk.TreeViewColumn(titre,render,markup=num_col)
        try:
            col_font = self.dic_entet['FONT']
            col.add_attribute(render,'font', col_font)
            DEBUG('[[ TREEVIEW ]] => Texte > font %s'% col_font)
        except: pass
        try:
            col_back = self.dic_entet['BACK']
            col.add_attribute(render,'background', col_back)
            DEBUG('[[ TREEVIEW ]] => Texte > backg %s'% col_back)
        except: pass
        try:
            col_fore = self.dic_entet['FORE']
            col.add_attribute(render,'foreground', col_fore)
            DEBUG('[[ TREEVIEW ]] => Texte > fore %s'% col_fore)
        except: pass
        col.set_resizable(True)
        col.set_sort_column_id(num_col)
        treeview.append_column(col)
        sel=treeview.get_selection()
        sel.set_mode(gtk.SELECTION_SINGLE)

    def HIDE(self, name, treeview, mystore, num_col, l_value, titre):
        DEBUG('[[ TREEVIEW ]] ==> hide %s'% num_col)
        return

    def FONT(self, name, treeview, mystore, num_col, l_value, titre):
        return

    def BACK(self, name, treeview, mystore, num_col, l_value, titre):
        return

    def FORE(self, name, treeview, mystore, num_col, l_value, titre):
        return

    '''
    **************************************************************
    *** Actions treeview column → icon, radio, check, edited   ***
    **************************************************************
    '''        
    def rappel_clic(self, widget, tree_column, tree_name, num_col):
        self.th.iter_select = ' '
        if widget.get_cursor()[1] == tree_column:  # si la colonne est régler sur clic
            list_str = self.th.retourne_selection(tree_name)
            if import_py is not None:
                list_str.prepend(num_col)
                t = ( (num_col, list_str[0]), list_str[1], 'clic' )
                getattr(self.IMPORT, tree_name)(*t)
                return True
            liste    = list_str.split('@')
            arg='%s,%s' % (liste.pop(0), num_col)
            list_str_re = '|'.join(liste)
            var = '%s clic@%s@%s' % (tree_name, arg, list_str_re)
            self.send_data( var )
        return True
    
    def rappel_radio(self, cellrender, path, store, col, name_tree):
        DEBUG(self.DIC_RADIO[col])
        self.th.iter_select = ' '
        old = self.DIC_RADIO[col]
        store[old][col]     = False
        store[path][col]    = True
        self.DIC_RADIO[col] = path
        DEBUG(self.DIC_RADIO[col])
        if import_py is not None:
            getattr(self.th.IMPORT, name_tree) (
                                                 (col, path),
                                                 list(store[path]),
                                                 'radio',
                                               )
            return
        liste = self.th.list_to_string( list(store[path]) )
        val = "%s radio@%s,%s@%s" % ( name_tree, path, col, liste )
        self.send_data( val )

    def rappel_toggled(self, cellrender, path, store, col, name_tree):
        etat = store[path][col]
        self.th.iter_select=' '
        if etat:
            cellrender.set_active(False)
            store[path][col]=False
        else:
            cellrender.set_active(True)
            store[path][col]=True
        if import_py is not None:
            getattr(self.th.IMPORT, name_tree) (
                                                 (col, path),
                                                 list(store[path]),
                                                 'toggle',
                                               )
            return
        liste = self.th.list_to_string( list(store[path]) )
        val   = "%s toggled@%s,%s@%s" % ( name_tree, path, col, liste )
        self.send_data( val )

    def rappel_edited(self,celltext, chemin, nouveau_texte, tree_name,
                                         mystore, col, style, treeview):
        ancien_texte = mystore[chemin][col]
        mystore[chemin][col] = nouveau_texte
        ligne = self.th.list_to_string( list(mystore[chemin]) )
        if import_py is not None:
            getattr(self.th.IMPORT, tree_name) ( 
                                        (col, chemin),
                                        (ancien_texte, ligne ),
                                        style,
                                                )
        else:
            val   = '%s %s@%s,%s@%s@%s' % (tree_name, style, chemin ,col,
                                                         ancien_texte, ligne)
            self.send_data( val )
        if self.column_sizing: treeview.columns_autosize()

    '''
    *******************************
    *** Tooltip of the treeview ***
    *******************************
    '''
    def query_tooltip(self,treeview, x, y, keyboard_mode, tooltip):
        y = y - self.size_cell  #To manage the lines lag
        store = treeview.get_model()
        name  = treeview.get_name()
        info  = treeview.get_path_at_pos(x, y)
        if info is None: return False  #If nothing in this position, we do not display
        line    = info[0][0]
        column  = info[1]
        columns = treeview.get_columns()  # gets all columns
        col     = columns.index(column)  # column number
        tuple_size     = column.cell_get_size()[4]  # column size 4 = cell height
        self.size_cell = tuple_size
        if line == -1 or col == -1: return False # If we are outside
        colonne = col # save num column
        try:
            dic_tooltip_name=dic_tooltip[name]  # {'treeview':{0:1,1:5,}, }
            if col in dic_tooltip_name:  # If wa assign a text of another column
                col  = dic_tooltip_name[col]
                flag = False  # OK, we can display
            else: flag = True
        except:
            flag=False  #By default we display, no option
        if flag: return False
        label = str( store[line][col] )
        if line == self.tooltip_line and colonne == self.tooltip_col:  #we are in the same column
            tooltip.set_markup( label )
            return True    # display
        self.tooltip_line = line
        self.tooltip_col  = colonne
        return False
    '''
    ******************************
    *** Drag & drop management ***
    ******************************
    '''
    
    def return_selection(self, treeview):
        name          = treeview.get_name()
        modele, iter  = treeview.get_selection().get_selected()
        row           = list(modele[iter])
        return (name, modele, iter, row)
    
    def drag_data_get(self, treeview, context, selection, id_cible,
                           etime):  # slide from a treeview
        '''
        @brief The treeview can drag selection
        @info add this to drag-data-get signal
        '''
        name, modele, iter, row = self.return_selection(treeview)
        text = '''%s %s''' % (name, str(row))
        #selection.set_text(text, -1)
        selection.set(selection.target, 8, text )

    def drag_data_received(self, treeview, context, x, y, selection,
                                info, etime):  # deposit into a treeview
        '''
        @brief The treeview can received drag selection
        @info  add this to drag-data-received signal
        '''
        
        iter_to_copy = False
        model = treeview.get_model()
        name = selection.data.rstrip()
        info_depot = treeview.get_dest_row_at_pos(x, y)
        try:
            tree_source  = getattr(self, name.split(' ')[0])
            ns, model_source, iter_to_copy, row_s = \
                                         self.return_selection(tree_source)
        except:
            row_s=[name]
        if info_depot: # if we are between the treeview lines
            chemin, position = info_depot
            iter = model.get_iter(chemin)
            if iter_to_copy: # from a tree
                if iter_to_copy != iter:
                    self.iter_copy(model_source, model, iter_to_copy,
                                  iter, position)
            else:
                self.add_iter_to_tree(model, iter, row_s, position)
        else: # drop in a empty tree
            model.append(None, row_s)       
        if context.action == DRAG_ACTION_MOVE:
            context.finish(True, True, etime)
            
        def check_path(model, path, iter, don): #search drop emplacement
            if list(model[iter]) == don[0]:
                DEBUG( '[[ D & D ]] => Find item, path: %s'% path[0])
                don[1].append(path)
        lref = []
        model.foreach(check_path, (row_s, lref) )
        chemin = lref[0]
        if import_py is not None:
            getattr(self.th.IMPORT, treeview.get_name()) (
                                                           chemin,
                                                           row_s,
                                                           'drop',
                                                         )
            return
        lt = self.th.list_to_string(row_s)
        self.send_data( '%s drop@%s@%s' % (  
                                          treeview.get_name(),
                                          chemin,
                                          lt,
                                          )
                      )
   
    def add_iter_to_tree(self, model, target_iter, data_to_copy, pos):
        if (pos == DRAG_INTO_OR_BEFORE or pos == DRAG_INTO_OR_AFTER):
            new_iter = model.prepend(target_iter)
            model[new_iter] = data_to_copy
        elif pos == DRAG_BEFORE:
            new_iter = model.insert_before(None, target_iter, data_to_copy)
        elif pos == DRAG_AFTER:
            new_iter = model.insert_after(None, target_iter, data_to_copy)
        return new_iter
        
    def iter_copy(self, model_source, model, iter_to_copy,
                 target_iter, pos):
        data_to_copy = list(model_source[iter_to_copy])
        new_iter = self.add_iter_to_tree(model, target_iter, data_to_copy, pos) 
        if model_source.iter_has_child(iter_to_copy):
            for i in range(0, model_source.iter_n_children(iter_to_copy)):
                next_iter_to_copy = model_source.iter_nth_child(iter_to_copy, i)
                self.iter_copy(model_source, model, next_iter_to_copy,
                               new_iter, DRAG_INTO_OR_BEFORE)    

class Gui(Callbacks, GuiWebkit, GuiXmlParser, GuiTreeview):
    '''
    @page callbacks Signals and callbacks
    '''
    '''
    *****************************************
    *** UI CREATION
    *****************************************
    '''
    CIBLES = [
        ('MY_TREE_MODEL_ROW', gtk.TARGET_SAME_WIDGET, 0),
        ('text/plain', 0, 1),
        ('TEXT', 0, 2),
        ('STRING', 0, 3),
        ]
    DIC_RADIO={}
    def __init__(self):
        self.dic_widget        = {}
        self.size_cell         = 24
        self.tooltip_col       = -1
        self.tooltip_line      = -1
        self.send_drop         = True
        self.flag_tooltip      = False
        self.window_realized   = False
        self.flag_right_clic   = False
        self.var_filechoose    = None
        self.old_label_tooltip = None
        self.glade2script_PID  = os.getpid()
        self.old_width_img, self.old_height_img      = (0, 0)
        self.old_scale_width, self.old_scale_height  = (0, 0)
        if os.path.exists(local_path):  # charger traduction
            if USERLIB == 'widget':
                DEBUG('[[ GTK LIB ]] ==> libglade > locale')
                gtk.glade.bindtextdomain(nom_appli, local_path)
                gtk.glade.textdomain(nom_appli)
                gettext.install(nom_appli)
                self.widgets = gtk.glade.XML(fname=f_glade, domain=nom_appli)
                self.widgets.signal_autoconnect(self)
            else:
                DEBUG('[[ GTK LIB ]] ==> GtkBuilder > locale')
                self.widgets = gtk.Builder()
                import locale
                locale.setlocale(locale.LC_ALL, '')
                locale.bindtextdomain(nom_appli, local_path)
                gettext.bindtextdomain(nom_appli, local_path)
                gettext.textdomain(nom_appli)
                #msgfmt --output-file=Test.mo Test.po
                #lang = gettext.translation(nom_appli, path)
                #_ = lang.gettext 
                _ = gettext.gettext
                #gettext.install(nom_appli)
                self.widgets.set_translation_domain(nom_appli)
                self.widgets.add_from_file(f_glade)
                self.widgets.connect_signals(self)
        else:
            if USERLIB == 'object':
                DEBUG('[[ GTK LIB ]] ==> GtkBuilder')
                self.widgets = gtk.Builder()
                self.widgets.add_from_file(f_glade)
                self.widgets.connect_signals(self)
            else:
                DEBUG('[[ GTK LIB ]] ==> libglade')
                self.widgets = gtk.glade.XML( f_glade )
                self.widgets.signal_autoconnect(self)
        if systray_icon:
            DEBUG('[[ SYSTRAY ]]')
            self.set_systray_icon()

        if clip is not None:
            DEBUG('[[ CLIPBOARD ]]')
            display = gtk.gdk.display_manager_get().get_default_display()
            self.clipboard = gtk.Clipboard(display, clip)
        self.parse_xml()
        
        if dic_trans:
            self.widgets_trans()

        if term_box is not None:
            DEBUG('[[ TERMINAL ]]')
            self.make_terminal()
        
        if embed is not None:
            DEBUG('[[ EMBED ]]')
            name, cmd = embed.split('@@')
            widget    = eval('self.%s' % name)
            self.app_embed = Embed(widget, cmd)

        if l_webkit:
            DEBUG('[[ WEBKIT ]]')
            for nav in l_webkit:
                self.make_navigateur(nav[0], nav[1])

        if dic_sourceview:
            for name, box in dic_sourceview.iteritems():
                DEBUG('[[ SOURCEVIEW ]] ==>> %s, %s' % (name, box))
                self.add_sourceview(name, box)
        
        if auto_config is not None:
            DIC_ENV.update( CONFIG_PARSER.load_config(self) )
            
        if load_config is not None and auto_config is None:
            DIC_ENV.update( CONFIG_PARSER.get_config(self) )
        
    '''
    ************************
    ***   GtkSourceView   ***
    ************************
    '''
    def add_sourceview(self, name, box):
        box    = getattr(self, box)
        style  = gtksourceview2.StyleSchemeManager()
        lang   = gtksourceview2.LanguageManager()
        buffer = gtksourceview2.Buffer()
        view   = gtksourceview2.View()
        view.set_property('name', name)
        view.set_buffer(buffer)
        setattr(self, name, view)
        setattr(self, '%s_LanguageManager'%name, lang)
        setattr(self, '%s_StyleSchemeManager'%name, style)
        box.add(view)
        view.show()
        DIC_ENV['G2S_SOURCEVIEW_LANG']  = ','.join(lang.get_language_ids())
        DIC_ENV['G2S_SOURCEVIEW_STYLE'] = ','.join(style.get_scheme_ids())
    '''
    ************************
    ***   Transparency   ***
    ************************
    '''
    def widgets_trans(self):
        for widget_name in dic_trans:
            widget = eval('self.%s' % widget_name)
            widget.connect('expose-event', self.expose)
            widget.set_colormap( self.get_screen_colormap(widget) )
            widget.set_app_paintable(True) 
            widget.realize()

    def get_screen_colormap(self, window):
        screen   = window.get_screen()
        colormap = screen.get_rgba_colormap()
        if colormap == None:
            colormap = screen.get_rgb_colormap()
        return colormap

    def expose(self, window, event):
        if window.is_composited():
            name = window.get_name()
            trans, color = dic_trans[name]
            #print dic_trans
            try:
                eval(color) # si eval passe, color = None, donc defaut noir
                r, g, b = (0.0, 0.0, 0.0)
            except:
                r, g, b = self.get_rgb_color(color)
            try:
                trans = float(trans)
            except:
                trans = eval(trans)
            cr = window.window.cairo_create()
            if trans is not None:
                cr.set_source_rgba(r, g, b, trans )
            else:
                cr.set_source_rgba(r, g, b, 0.0)
            cr.set_operator(cairo.OPERATOR_SOURCE)
            cr.paint()

    def get_rgb_color(self, full):
        """  split_col(full=24 bit color value) return tuple of three colour values being 0-1.
        Assume 0xFFFFFF=White=(1,1,1) 0x000000=Black=(0,0,0)
        http://www.linuxquestions.org/questions/programming-9/python-set_source_rgb-set_source_rgba-values-817981/ 
        """
        full    = full.replace('#','0x')
        full    = eval(full)
        r, g, b = ((full >> 16)/255.0,(255 & (full >> 8))/255.0,(255 & full)/255.0)
        return (r, g, b)
        
    '''
    *********************************
    *** Combobox list creation    ***
    *********************************
    '''
    def make_combo(self, nom, combo):
        DEBUG('[[ COMBO ]] ==> Start make')
        icon = False
        try:
            liste = dic_combo[nom]
        except:
            DEBUG('==== [[ ERROR COMBO ]] ===>> no list')
            return
        ref = liste.pop(0)
        combo.clear()
        try:
            item, icon = ref.split('|')
        except:
            item = ref
        if icon:
            self.add_icon_on_combo(item, icon, combo, liste)
            return
        liststore = gtk.ListStore(str)
        combo.set_model(liststore)
        cell = gtk.CellRendererText()
        combo.pack_end(cell, True)
        combo.add_attribute(cell, 'markup', 0)
        DEBUG('[[ COMBO ]] ==> Label')
        if liste:
            for item in liste:
                liststore.append( [item] )
            DEBUG('[[ COMBO ]] ==> Loaded')

    def add_icon_on_combo(self, item, icon, combo, liste):
        if 'ICON' in icon:
            DEBUG('[[ COMBO ]] ==> Icon')
            liststore = gtk.ListStore(str, str)
            combo.set_model(liststore)
            cell = gtk.CellRendererPixbuf()
            try:
                # si il y a un argument
                arg, size = icon.split('%%')
                size = int(size)
                cell.set_property('stock_size', size )
                DEBUG('[[ COMBO ]] => Icon > size %s'% size)
            except:
                pass
            self.pack_cells(cell, combo, 'icon_name')
            if liste:
                for item in liste:
                    liststore.append( item.split('|') )
                DEBUG('[[ COMBO ]] ==> Loaded')
        elif 'IMG' in icon:
            DEBUG('[[ COMBO ]] ==> Image')
            size      = False
            liststore = gtk.ListStore(str, gtk.gdk.Pixbuf)
            combo.set_model(liststore)
            cell = gtk.CellRendererPixbuf()
            try:
                arg, size = icon.split('%%')
                size=int(size)
                DEBUG('[[ COMBO ]] => Image > size %s' % size)
            except: pass
            self.pack_cells(cell, combo, 'pixbuf')
            if liste:
                for item in liste:
                    item, filename = item.split('|')
                    if size:
                        pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(filename, size, size)
                    else:
                        pixbuf = gtk.gdk.pixbuf_new_from_file(filename)
                    liststore.append( [item, pixbuf] )
                DEBUG('[[ COMBO ]] ==> Loaded')

    def pack_cells(self, cell, combo, arg):
        combo.pack_start(cell, False)
        combo.add_attribute(cell, arg, 1)
        cell = gtk.CellRendererText()
        combo.pack_end(cell, True)
        combo.add_attribute(cell, 'markup', 0)
        DEBUG('[[ COMBO ]] ==> Label')


    '''
    ********************
    *** VTE terminal ***
    ********************
    '''
    def make_terminal(self):
        '''
        Add a vte terminal.
            option --terminal='_hbox1:55x10'
            Container and dimension (width,height) in parameters.
            A viewport with callabck must be added in it for the automatic resize (in glade)
        '''
        self.flag_term    = True
        self.flag_event   = True
        self.terminal     = vte.Terminal()
        self.terminal_PID = self.terminal.fork_command()
        DIC_ENV['G2S_TERMINAL_PID'] = str(self.terminal_PID)
        lbox, size = term_box.split(':')
        self.term_width, self.term_height = size.split('x')
        box = eval('self.%s' % lbox)
        box.pack_start(self.terminal,False, True, 0)
        if term_redim:
            self.terminal.connect('char-size-changed',
                                   self.redim_container_from_font) 
            self.terminal.connect('status-line-changed', self.child_exited)
        if term_font is not None:
            self.terminal.set_font_from_string(term_font)
        self.terminal.show()
        box.show()

    def child_exited(self, widget, arg1=None, arg2=None):
        #print widget, arg1, arg2
        pass

    def redim_container_from_font(self, widget, width, height):
        '''
        Callback called during the terminal fonts change.
            widget = terminal
            width, height = necessary size for the new font, in pixels
        '''
        pere  = widget.get_parent()
        Gpere = pere.get_parent()
        if type(Gpere ) == gtk.Viewport:
            container_width  = width * widget.get_column_count()
            container_height = height * widget.get_row_count()
            gobject.idle_add(Gpere.set_size_request, container_width,
                             container_height)
            self.flag_term = True
    
    def redim_term(self, widget, rect):
        '''
        @brief Auto resize VTE terminal
        @info see <a href="options.html#--terminal-redim">--terminal-redim</a> option
        '''
        '''
        Callback of the size-allocate signal of the viewport.
        When the widget is resized
           widget = viewport
           rect = gtk.rectangle
        '''
        # Loads the dimensions for calculous base and default values,
        # resizes viewport and terminal, only once at the beginning.
        # Reinitialized during the fonts change thanks to the flag
        if self.flag_term: # flag to avoid the first signal
            self.flag_term = False
            self.defaut_width = int(self.term_width)
            self.defaut_hight = int(self.term_height)
            self.col_size  = self.terminal.get_char_width()
            self.line_size = self.terminal.get_char_height()
            nb_col  = self.defaut_width / self.col_size
            nb_line = self.defaut_hight / self.line_size
            gobject.idle_add(self.terminal.set_size, nb_col, nb_line)
            self.old_nb_col, self.old_nb_row = nb_col, nb_line 
            gobject.idle_add(widget.set_size_request, self.defaut_width,
                             self.defaut_hight)
            return
        x, y, w, h = list(rect)
        # col and row number for the new size
        new_w = int(float(w)/float(self.col_size))
        new_h = int(float(h)/float(self.line_size))
        # if a dimension is changed
        if new_w != self.old_nb_col or new_h != self.old_nb_row: 
            # flag to avoid the first signal
            if self.flag_event: self.flag_event = False 
            else: 
                gobject.idle_add(self.terminal.set_size, new_w, new_h )
        self.old_nb_col, self.old_nb_row = new_w, new_h

    '''
    ******************************
    *** Drag & drop management ***
    ******************************
    '''
    
    def set_drag_drop(self, nom):
        dd    = eval( "self.%s" % (nom) )
        dd.connect("drag-data-received", self.event_drag_data_received)
        dd.connect("drag-data-get", self.event_drag_data_get)
        dd.drag_dest_set(DRAG_DEST_DEFAULT, [], DRAG_ACTION_MOVE)
        dd.drag_source_set(DRAG_BTN_MASK, [], DRAG_ACTION_MOVE)
        dd.drag_dest_add_text_targets()
        dd.drag_source_add_text_targets()
    
    def event_drag_data_get(self, widget, drag_context, data, info, time):
        text = "%s@drag" % widget.get_name()
        data.set_text(text, -1)

    def drag_drop(self, wid, context, x, y, time): 
        '''
        @brief Used for drop in a widget
        @info  add this to drag-drop signal
        @return sh: drop@text/row
        @return py: ('drop', text/row)
        '''
        return True

    def event_drag_data_received(self, widget, context, x, y, selection,
                                info, etime):  # deposit in a widget
        data = selection.data.rstrip()
        try: # if it comes from a treeview, convert into string
            source_name, source_row = data.split(' ',1)
            data  = eval(source_row)
            st_lst = self.th.list_to_string(data)
            selec  = 'drop@%s' % st_lst
        except: selec='drop@%s' % data
        if import_py is not None:
            getattr(self.th.IMPORT, widget.get_name())('drop',data)
        else:
            self.send_data( '%s %s' % (widget.get_name(), selec) )
        
        if context.action == DRAG_ACTION_MOVE:
            context.finish(True, True, etime)
    
    '''
    *********************
    *** Miscellaneous ***
    *********************
    '''
    def set_systray_icon(self):
        for name, menu, icon, bulle in systray_icon:
            self.new_systray_icon(name, menu, icon, bulle)
    
    def new_systray_icon(self, name, menu, icon, bulle):
        systray = gtk.StatusIcon()
        systray.props.visible = False
        if '.' in icon:
            systray.set_from_file(icon)
        else:
            systray.set_from_icon_name(icon)
        if menu != 'None':
            menu = eval('self.widgets.get_%s' % USERLIB)(menu) 
            systray.connect('popup-menu', self.popup_menu_cb, menu)
        systray.connect('activate', self.send_data, name)
        systray.set_tooltip(bulle)
        setattr(self, name, systray)

    def popup_menu_cb(self, widget, button, time, menu=None):
        if button == 3:
            if menu:
                menu.show()
                menu.popup(None, None, gtk.status_icon_position_menu,
                                                     3, time, widget)

    def apply_gtkrc(self, widget, gtkrc):
        gtk.rc_parse(gtkrc)
        screen   = widget.get_screen()
        settings = gtk.settings_get_for_screen(screen)
        gtk.rc_reset_styles(settings)

    def modif_type(self, ligne, store):
        list_ligne = ligne.split('|')
        n=0
        for elem in list_ligne:
            if 'gchararray' in str(store.get_column_type(n)):
                value = elem
            else:
                value = eval(elem)
            index = list_ligne.index(elem)
            list_ligne[index] = value
            n+=1
        return list_ligne

    def go_thread(self):
        self.th = MyThread(self)
        self.th.start()

    def send_data(self, data, arg=None):
        if arg is not None:
            data = arg
        self.th.send(data)

    def set_widget(self, cmd):
        arg = 'self.%s' % (cmd)
        exec( arg )

    def set_color(self, widget, etat, color):
        couleur = gtk.gdk.color_parse(color)
        widget  = eval( 'self.%s' % (widget) )
        widget(eval(etat), couleur)

    def main(self):
        gtk.main()


    '''
    **********************************************
    *** GLADE2SCRIPT COMMANDS INTERPRETATION 
    **********************************************
    '''
class CmdCOMBO(object):
    '''
    *** COMBOBOX
    '''
    def COMBO(self, sortie, arg=False):
        cmd='COMBO%s' % sortie.split('@@')[1]
        names = sortie.split('@@')[2].split(',')
        for name in names:
            try:
                item = sortie.split('@@')[3]
            except:
                item = None
            combo, modele = self.return_tree_store(name)
            nb = len(modele)
            gobject.idle_add(getattr(self, cmd), nb, combo, modele, item)

    def COMBOIMG(self, nb, combo, modele, item):
        '''
        @name COMBO@@IMG
        @param @@combobox@@item|filename[|size]
        @brief Adds a line with image to the combo.
        @info size: in pixel, optional
        @info filename: relative or absolute path of the picture
        '''
        try:
            item, filename, size = item.split('|')
            pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(filename, int(size), int(size) )
        except:
            item, filename = item.split('|')
            pixbuf = gtk.gdk.pixbuf_new_from_file(filename)
        modele.append( [item, pixbuf] )

    def COMBOEND(self, nb, combo, modele, item):
        '''
        @name COMBO@@END
        @param @@combobox@@item[|icon]
        @brief Adds a line to the combo.
        @info icon: name of the image (gtk theme), optional
        '''
        modele.append( item.split('|') )

    def COMBOCLEAR(self, nb, combo, modele, item):
        '''
        @name COMBO@@CLEAR
        @param @@combobox[,combobo,...]
        @brief Deletes all the elements of the combobox
        '''
        for i in range(nb):
            combo.remove_text(0)

    def COMBOFINDDEL(self, nb, combo, modele, item):
        '''
        @name COMBO@@FINDDEL
        @param @@combobox@@item
        @brief Deletes one combobox element by its item.
        @info item: Regular expression
        '''
        liste = []
        modele.foreach(self.find_tree_item, ('0', item, liste) )
        #combo.set_active( liste[0] )
        try:
            del modele[ liste[0] ]
        except: pass

    def COMBOFINDSELECT(self, nb, combo, modele, item):
        '''
        @name COMBO@@FINDSELECT
        @param @@combobox@@item
        @brief Selects a combobox element by its item.
        @info item: Regular expression
        '''
        liste = []
        modele.foreach(self.find_tree_item, ('0', item, liste) )
        current_active = combo.get_active()
        try:
            if current_active == liste[0][0]:
                self.gui.on_combo(combo)
                return
            combo.set_active( liste[0][0] )
        except: pass

    def COMBODELEND(self, nb, combo, modele, item):
        '''
        @name COMBO@@DELEND
        @param @@combobox
        @brief Deletes the last element of the combobox.
        '''
        # minus because the input number is higher than the real one
        nb = nb -1
        combo.remove_text(nb)


class CmdTREEVIEW(object):
    '''
    *** TREEVIEW
    '''
    def TREE(self, sortie, arg=False):
        cmd='TREE%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd), sortie)

    def TREEINSERT(self, sortie):
        '''
        @name TREE@@INSERT
        @param @@treeview@@line@@data
        @brief insert a line in the treeview
        @info Indicate the --tree/-t option
        @info line: path (1 or 1:0)
        @info data: text|text|text
        '''
        name, path, value = sortie.split('@@',4)[2:]
        treeview, mystore = self.return_tree_store(name)
        iter, path = self.gui.try_path(path, mystore)    
        mystore.insert(iter, int(path), self.gui.modif_type(value, mystore) )

    def TREELOAD(self, sortie):
        '''
        @name TREE@@LOAD
        @param @@treeview@@fichier
        @brief Loads the treeview from a file
        @info Indicate the --tree/-t option
        @info fichier: absolute or relative file path
        '''
        name, path = sortie.split('@@')[2:]
        try:
            treeview, mystore = self.return_tree_store(name)
            #mystore.clear()
            for ligne in file(path,'r'):
                ligne    = ligne.strip()
                liste    = self.gui.modif_type(ligne, mystore)
                #print liste
                position = liste[0]
                parent_iter, path = self.gui.try_path(position, mystore)
                mystore.append(parent_iter, liste)
        except ValueError, e: 
            DEBUG('==== [[ ERROR ]] ===>> %s' % e)

    def TREEGET(self, sortie):
        '''
        @name TREE@@GET
        @param @@treeview
        @return variable and calls function, arg: line@data|data|data
        @brief Loads the selected line in a variable and calls the treeview function
        @info Python direct acces: <i>self.g2s.retourne_selection(treename)</i>
        @info Indicate the --tree/-t option
        '''
        name    = sortie.split('@@')[2]
        result  = self.retourne_selection(name)
        var_get = '''GET@%s="%s"''' % ( name,result )
        self.send( var_get )

    def TREECELL(self, sortie):
        '''
        @name TREE@@CELL
        @param @@treeview@@line[,col]@@data
        @brief Modify a cell or a line
        @info Indicate the --tree/-t option
        @info line: path (1 ou 1:0)
        @info col: colonne (optionnel)
        @info data: text|text|text
        '''
        # voir soucis path dans modif_cell_str
        name, place, value = sortie.split('@@',4)[2:]
        self.modif_cell_str(name, place, value)

    def TREEIMG(self, sortie):
        '''
        @name TREE@@IMG
        @param @@treeview@@data|data@@colonne@@size
        @example echo 'TREE@@IMG@@treeview1@@texte col 1|texte col 2|tux.png@@2@@150'
        @brief Adds a line containing an image
        @info Indicate the --tree/-t option
        @info column: where the image is
        @info size: in pixels
        '''
        # voir pour ne pas indiquer size
        name, value, col, size = sortie.split('@@')[2:]
        treeview, modele = self.return_tree_store(name)
        liste_data       = self.gui.modif_type(value, modele)
        filename         = liste_data[int(col)]
        pixbuf = gtk.gdk.pixbuf_new_from_file_at_size(filename, int(size), int(size) )
        liste_data[int(col)] = pixbuf
        modele.append(None, liste_data)
        num_row = len(list(modele))-1
        if num_row > 0:
            treeview.scroll_to_cell(num_row)

    def TREEEND(self, sortie):
        '''
        @name TREE@@END
        @param @@treeview@@data
        @brief Adds a line at the end of the treeview
        @info Indicate the --tree/-t option
        @info data: text|text|text
        '''
        name, value      = sortie.split('@@',3)[2:]
        treeview, modele = self.return_tree_store(name)
        liste            = self.gui.modif_type(value, modele)
        modele.append(None, liste )
        num_row = len(list(modele))-1
        if num_row > 0:
            treeview.scroll_to_cell(num_row)

    def TREEUP(self, sortie):
        '''
        @name TREE@@UP
        @param @@treeview[@@line]
        @brief Push up the selected line or the indicated line
        @info Indicate the --tree/-t option
        @info line: line number (optional)
        '''
        iter, path, model = self.tree_up_down(sortie)
        l  = list(path)
        #enleve 1 au dernier num du path
        n = int(l[-1]) -1
        if n == -1:
            path = (len(model)-1)
            new_iter = model.get_iter(path)
            model.move_after(iter, new_iter)
        else:
            l[-1]    = n
            path     = tuple(l)
            new_iter = model.get_iter(path)
            model.move_before(iter, new_iter)

    def TREEDOWN(self, sortie):
        '''
        @name TREE@@DOWN
        @param @@treeview[@@line]
        @brief Push down the selected line or the indicated line
        @info Indicate the --tree/-t option
        @info line: line number (optional)
        '''
        iter, path, model = self.tree_up_down(sortie)
        new_iter          = model.iter_next(iter)
        model.move_after(iter, new_iter)

    def TREETOP(self, sortie):
        '''
        @name TREE@@TOP
        @param @@treeview[@@line]
        @brief Push up in first position the selected line or the indicated line
        @info Indicate the --tree/-t option
        @info line: line number (optional)
        '''
        iter, path, model = self.tree_up_down(sortie)
        model.move_after(iter, None)

    def TREEBOTTOM(self, sortie):
        '''
        @name TREE@@BOTTOM
        @param @@treeview[@@line]
        @brief Push down in last position the selected line or the indicated line
        @info Indicate the --tree/-t option
        @info line: line number (optional)
        '''
        iter, path, model = self.tree_up_down(sortie)
        model.move_before(iter, None)

    def tree_up_down(self, sortie):
        base             = sortie.split('@@')
        name             = base[2]
        treeview, model  = self.return_tree_store(name)
        try:
            path = base[3]
            iter = model.get_iter(path)
        except:
            selection   = treeview.get_selection()
            model, iter = selection.get_selected()
            path        = model.get_path(iter)
        return (iter, path, model)

    def TREEPROG(self, sortie):
        '''
        @name TREE@@PROG
        @param @@treeview@@line,col@@value
        @example echo 'TREE@@PROG@@treeview1@@1,2@80'
        @brief Modify the value of a progressbar contained in the treeview
        @info Indicate the --tree/-t option
        @info value: 0 to 100
        '''
        name, place, value = sortie.split('@@')[2:]
        self.modif_cell_int(name, place, value)

    def TREESAVE(self, sortie):
        '''
        @name TREE@@SAVE
        @param @@treeview@@fichier
        @brief Saves the treeview in a file
        @info Indicate the --tree/-t option
        @info fichier: relative or absolute file path
        '''
        name, fichier    = sortie.split('@@')[2:]
        treeview, modele = self.return_tree_store(name)
        file(fichier,'w')
        self.fichier_save_tree = open(fichier,'a')
        modele.foreach(self.sauv_tree, fichier)
        self.fichier_save_tree.close()
        DEBUG('[[ TREE@@SAVE ]] Saved')

    def TREEHIZO(self, sortie, arg=False):
        '''
        @name TREE@@HIZO
        @param @@treeview
        @return sh: hizo@[path@]data|data@@[path@]data|data => the lines are separated by @@
        @return py: (None, [list], 'hizo')
        @brief Sends the treeview content to its function
        @info path will send if it's a real treeview (arborescence)
        @info With python to get return, call directly self.g2s.TREEHIZO('TREE@@HIZO@@treeview')
        @info Indicate the --tree/-t option
        '''
        name = sortie.split('@@')[2]
        self.list_hizo   = []
        treeview, modele = self.return_tree_store(name)
        modele.foreach(self.return_tree)
        if import_py is not None:
            if not arg:
                getattr(self.IMPORT, name) (None, self.list_hizo, 'hizo')
                return
            else:
                return (None, self.list_hizo, 'hizo')
        var  = '@@'.join(self.list_hizo)
        tree = """%s hizo@%s""" % (name, var)
        self.send(tree)

    def TREECLEAR(self, sortie):
        '''
        @name TREE@@CLEAR
        @param @@treeview
        @brief Deletes the treeview
        @info Indicate the --tree/-t option
        '''
        names = sortie.split('@@')[2].split(',')
        for name in names:
            mystore=eval('self.gui.store_%s' % (name) )
            mystore.clear()

    def TREEFIND(self, sortie, arg=False):
        '''
        @name TREE@@FIND
        @param @@treeview@@col/None@@motif
        @return sh: find@item|path|path|path...
        @return py: (None, [liste_find], 'find')
        @brief Finds and sends the lines according to a motif and a column
        @info Indicate the --tree/-t option
        @info col/None: if None, will be the entire line
        @info motif: Regular expression
        '''
        name, col, item  = sortie.split('@@',4)[2:]
        treeview, modele = self.return_tree_store(name)
        liste = []
        modele.foreach(self.find_tree_item, (col, item, liste) )
        liste_find = [item]
        for item in liste:
            liste_find.append( self.tup_path_to_str_path(item) )
        if import_py is not None:
            if not arg:
                getattr(self.IMPORT, name) (None, liste_find, 'find')
                return
            else:
                return (None, liste_find, 'find')
        liste_find = self.list_to_string(liste_find)
        cmd="""%s find@%s""" % (name, liste_find)
        self.send(cmd)

    def TREEFINDDEL(self, sortie, arg=False):
        '''
        @name TREE@@FINDDEL
        @param @@treeview@@col/None@@motif
        @return sh: finddel@path@linedata
        @return py: (path, [line], 'finddel')
        @brief Finds and deletes a line according to a motif and a column
        @info Indicate the --tree/-t option
        @info col/None: if None, will be the entire line
        @info motif: Regular expression
        '''
        name, col, item  = sortie.split('@@',4)[2:]
        treeview, modele = self.return_tree_store(name)
        liste = []
        modele.foreach(self.find_tree_item, (col, item, liste) )
        if liste:
            liste_ligne = list( modele[ liste[0] ] )
            del modele[ liste[0] ]
            if import_py is not None:
                if not arg:
                    getattr(self.IMPORT, name) (liste[0], liste_ligne, 'finddel')
                    return
                else:
                    return (liste[0], liste_ligne, 'finddel')
            liste_find  = self.list_to_string(liste_ligne)
            str_path    = self.tup_path_to_str_path( liste[0] )
            cmd = """%s finddel@%s@%s""" % (name, str_path, liste_find)
        else:
            if import_py is not None:
                if not arg:
                    getattr(self.IMPORT, name) (None, [], 'finddel')
                    return
                else:
                    return False
            cmd = """%s finddel@NoItemFind""" % name
        self.send(cmd)

    def tup_path_to_str_path(self, path):
        try:
            parent, child = path
            str_path = '%s:%s' % (parent, child)
        except:
            str_path = path[0]
        return str_path

    def TREEFINDSELECT(self, sortie):
        '''
        @name TREE@@FINDSELECT
        @param @@treeview@@col/None@@motif
        @brief Finds and selects a line according to a motif and a column
        @info Indicate the --tree/-t option
        @info col/None: if None, will be the entire line
        @info motif: Regular expression
        '''
        name, col, item  = sortie.split('@@',4)[2:]
        treeview, modele = self.return_tree_store(name)
        liste = []
        modele.foreach(self.find_tree_item, (col, item, liste) )
        if liste: treeview.set_cursor( liste[0] )

    def find_tree_item(self, liststore, path, iter, tup):
        col, item, liste = tup
        donnees=list(liststore[iter])
        try:
            if re.search(item.replace('(','\(').replace(')','\)'), donnees[int(col)]):
                liste.append(path)
        except:
            item = item.split('|')
            if item == donnees:
                liste.append(path)

    def return_tree_store(self, name):
        treeview = eval('self.gui.%s' % (name) )
        modele   = treeview.get_model()
        return treeview, modele

    def TREEFORCE_SELECT(self, sortie):
        '''
        @name TREE@@FORCE_SELECT
        @param @@treeview
        @brief Force the variable selection (security block)
        @info Indicate the --tree/-t option
        '''
        self.iter_select = True
        
    '''
    *****************
    *** UTILITIES
    *****************
    '''
    '''
    Convert a list into string for the treeview
    '''
    def list_to_string(self, donnees):
        l = []
        for item in donnees:
            try:
                eval('%s'%item)
                l.append(str(item))
            except:
                l.append(item)
        return '|'.join(l)

    def sauv_tree(self, liststore, path, iter, fichier):
        donnees = list(liststore[iter])
        ligne   = self.list_to_string(donnees)
        self.fichier_save_tree.write(ligne+'\n')
        
    def return_tree(self, liststore, path, iter):
        donnees = list(liststore[iter])
        ligne   = self.list_to_string(donnees)
        path    = liststore.get_string_from_iter(iter)
        if ':' in path:
            if import_py is not None:
                ligne = (path, donnees)
            else:
                ligne = '%s@%s' % (path, ligne)
        self.list_hizo.append(ligne)
        #DEBUG('[return_tree] hizo@'+ligne)

    def modif_cell_int(self, name, place, value):
        store    = eval('self.gui.store_%s' % (name) )
        row, col = place.replace(' ','').split(',')
        if ':' in row:
            row = tuple([eval(i) for i in row.split(':')])
        else:
            row = int(row)
        store[row][int(col)] = int(value)
        
    def modif_cell_str(self, name, place, value):
        if self.iter_select is None: return
        store    = eval('self.gui.store_%s' % (name) )
        treeview = eval('self.gui.%s' % (name) )
        if place:  # 3,1
            try:
                row, col = place.replace(' ','').split(',')
                if ':' in row:
                    row = tuple([eval(i) for i in row.split(':')])
                else:
                    row = int(row)
                store[row][int(col)] = value  #modif cellule
                #print "modif celluel", value
            except:
                if value:
                    liste = self.gui.modif_type(value, store)
                    #row = eval( '(%s)' % row.replace(':',',') )
                    #print 'modif', row
                    store[int(place)] = liste  # modif ligne
                else:
                    try:
                        #print "in try"
                        iter = store.get_iter(place)
                        store.remove(iter)  # supprimer ligne par son numéro
                        self.iter_select = None  # plus de selection
                    except: pass
        elif self.iter_select is not None: # supprimer ligne sélectionnée
            store.remove(self.iter_select)  
            self.iter_select=None
        if self.gui.column_sizing: treeview.columns_autosize()

    def retourne_selection(self,name):
        treeview = eval('self.gui.%s' % (name) )
        modele   = treeview.get_model()
        sel      = treeview.get_selection()
        ( model,iter )   = sel.get_selected()
        self.iter_select = iter
        if iter is not None:
            path     = model.get_string_from_iter(iter)
            #print model.get_string_from_iter(iter)
            liste    = list(model[iter])
            ligne    = str(path[0])
            list_str = self.list_to_string(liste)
            DEBUG( '>> [[ retourne_selection ]] : %s %s' % (path, list_str ))
            if import_py is not None:
                return (path, liste)
            return '%s@%s' % (path, list_str)
        else: return None  #['None']



class CmdTEXTVIEW(object):
    '''
    *** TEXTVIEW
    '''                
    def TEXT(self, sortie, arg=False):
        cmd = 'TEXT%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd), sortie)
        
    def TEXTAUTOUR(self, sortie, tag=False):
        '''
        @name TEXT@@AUTOUR
        @param @@textview@@texteAvant@@texteAprès
        @brief Circles a text selection
        '''
        name, avant, apres    = sortie.split('@@')[2:]
        textview, buffertexte = self.retourne_textview_buffer(name)
        start, end            = buffertexte.get_selection_bounds()
        self.insert_text(buffertexte, start, avant, tag)
        start, end = buffertexte.get_selection_bounds()
        self.insert_text(buffertexte, end, apres, tag)

    def TEXTAUTOURTAG(self, sortie):
        '''
        @name TEXT@@AUTOURTAG
        @param @@textview@@tag@@texteAvant@@texteAprès
        @brief Circles a text selection with tag
        '''
        name, tag, avant, apres = sortie.split('@@')[2:]
        self.TEXTAUTOUR('''TEXT@@AUTOUR@@%s@@%s@@%s''' % (name, avant, apres), tag)

    def TEXTCLEAR(self, sortie):
        '''
        @name TEXT@@CLEAR@@
        @param @@textview
        @brief Deletes the textview
        '''
        names = sortie.split('@@')[2].replace(' ','').split(',')
        for name in names:
            textview, buffertexte = self.retourne_textview_buffer(name)
            start, end            = buffertexte.get_bounds()
            buffertexte.delete(start, end)

    def TEXTCREATETAG(self, sortie):
        '''
        @name TEXT@@CREATETAG
        @param @@textview@@tagname@@args
        @example echo 'TEXT@@CREATETAG@@textview[,textview,...]@@redItalic@@style=pango.STYLE_ITALIC,foreground=red'
        @brief Creates a tag that can be used for the textview
        @info tagname: tag name
        @info args: see pygtk doc, e.g.: style=pango.STYLE_ITALIC
        '''
        name, tagname, args   = sortie.split('@@')[2:]
        for name in name.replace(' ','').split(','):
            textview, buffertexte = self.retourne_textview_buffer(name)
            tag_table             = buffertexte.get_tag_table()
            tag                   = gtk.TextTag(tagname)
            for arg in args.replace(' ','').split(','):
                nom, value = arg.split('=')
                try:
                    value = eval(value)
                except: pass
                tag.set_property(nom, value)
            tag.set_data('balise', tagname)
            tag_table.add(tag)

    def TEXTCURSOR(self, sortie, tag=False):
        '''
        @name TEXT@@CURSOR
        @param @@textview@@text
        @brief Adds some text at the cursor location
        '''
        name, text            = sortie.split('@@')[2:]
        textview, buffertexte = self.retourne_textview_buffer(name)
        iter = buffertexte.get_iter_at_mark( buffertexte.get_insert() )
        self.insert_text(buffertexte, iter, text, tag)

    def TEXTCURSORTAG(self, sortie):
        '''
        @name TEXT@@CURSORTAG
        @param @@textview@@tag@@text
        @brief Adds some text with tag at the cursor location
        '''
        name, tags, text = sortie.split('@@')[2:]
        self.TEXTCURSOR('''TEXT@@CURSOR@@%s@@%s''' % (name, text), tags)

    def TEXTDELEND(self,sortie):
        '''
        @name TEXT@@DELEND
        @param @@textview
        @brief Deletes the last line of the textview
        '''
        name                  = sortie.split('@@')[2]
        textview, buffertexte = self.retourne_textview_buffer(name)
        nombre_lignes         = buffertexte.get_line_count()
        debut_end  = buffertexte.get_iter_at_line(nombre_lignes-2)
        start, end = buffertexte.get_bounds()
        buffertexte.delete(debut_end, end)

    def TEXTDELTAG(self,sortie):
        '''
        @name TEXT@@DELTAG
        @param @@textview@@tag,tag
        @brief Deletes tag(s) of the textview
        @info Use ALL to delete all tags
        '''
        name, tags            = sortie.split('@@')[2:]
        textview, buffertexte = self.retourne_textview_buffer(name)
        start, end            = buffertexte.get_bounds()
        l_tags = tags.replace(' ','').split(',')
        for tag in l_tags:
            if tag == 'ALL':
                buffertexte.remove_all_tags(start, end)
                break
            buffertexte.remove_tag_by_name(tag, start, end)

    def TEXTEND(self, sortie, tag=False):
        '''
        @name TEXT@@END
        @param @@textview@@text
        @brief Adds at the end of the textview
        '''
        name, text            = sortie.split('@@',3)[2:]
        textview, buffertexte = self.retourne_textview_buffer(name)
        start, end            = buffertexte.get_bounds()
        text                  = text.replace('\\n', '\n')
        self.insert_text(buffertexte, end, text, tag)
        p_text_mark = buffertexte.create_mark ('p_buffer', end, False)
        textview.scroll_to_mark(p_text_mark,0.0)

    def TEXTENDTAG(self, sortie):
        '''
        @name TEXT@@ENDTAG
        @param @@textview@@text
        @example echo 'TEXT@@ENDTAG@@_textview1@@un text with &lt;redItalic&gt;tag&lt;/redItalic&gt;'
        @brief Adds at the end of the textview with a tag
        '''    
        def boucle(v):
            v   = v.split('<')
            deb = v.pop(0)
            self.insert_text(buffertexte, end, deb)
            v = '<'.join(v)
            v = v.split('>')
            tag  = v.pop(0)
            text = v.pop(0).split('</')[0]
            self.insert_text(buffertexte, end, text, tag)
            v = '>'.join(v)
            return v
        name, text            = sortie.split('@@',3)[2:]
        textview, buffertexte = self.retourne_textview_buffer(name)
        start, end            = buffertexte.get_bounds()
        texte                 = text.replace('\\n', '\n')
        while True:
            if '</' in texte:
                texte = boucle(texte)
            else:
                self.insert_text(buffertexte, end, texte)
                break
            p_text_mark = buffertexte.create_mark ('p_buffer', end, False)
            textview.scroll_to_mark(p_text_mark,0.0)

    def TEXTFIND(self, sortie):
        '''
        @name TEXT@@FIND
        @param @@textview@@text@@action
        @brief Search text
        @info text: text to find, use ^ or $ for starts or ends line search
        @info action: scroll, select, or tag name
        '''
        name, text, actions   = sortie.split('@@')[2:]
        textview, buffertexte = self.retourne_textview_buffer(name)
        start, end            = buffertexte.get_bounds()
        def get(iter, text):
            flag        = True
            starts_line = False
            ends_line   = False
            if text.startswith('^'):
                starts_line = True
                text = text[1:]
            elif text.endswith('$'):
                ends_line = True
                text = text[:-1]
            try:
                debut, fin = iter.forward_search(text, gtk.TEXT_SEARCH_TEXT_ONLY)
            except:
                return (start, end, flag)
            if starts_line:
                flag = debut.starts_line()
            elif ends_line:
                flag = fin.ends_line()
            if flag:
                for action in actions.replace(' ','').split(','):
                    if action == 'select':
                        buffertexte.select_range(debut, fin)
                    elif action == 'scroll':
                        p_text_mark = buffertexte.create_mark ('p_buffer', fin, False)
                        textview.scroll_to_mark(p_text_mark,0.0, True, 0.5, 0.0)
                    else:
                        buffertexte.apply_tag_by_name(action, debut, fin)
            return (debut, fin, flag)
        
        debut, fin, flag = get(start, text)
        while not flag:
            debut, fin, flag = get(fin, text)
        '''
        debut, fin            = start.forward_search(text,
                                                     gtk.TEXT_SEARCH_TEXT_ONLY,
                                                     limit=None)
        start_line = debut.starts_line()
        while not start_line:
            debut, fin = fin.forward_search(text,
                                            gtk.TEXT_SEARCH_TEXT_ONLY,
                                            limit=None)
            start_line = debut.starts_line()
        p_text_mark = buffertexte.create_mark ('p_buffer', fin, False)
        textview.scroll_to_mark(p_text_mark,0.0, True, 0.5, 0.0)
        '''

    def TEXTHIZO(self, sortie, arg=False):
        '''
        @name TEXT@@HIZO
        @param @@treeview
        @brief Calls the textview function with its content as argument
        @info The end-of-line will be replaced by some @@
        @return sh: hizo@texte@@texte@@texte...
        @return py: ('hizo', texte)
        '''
        name                  = sortie.split('@@')[2]
        textview, buffertexte = self.retourne_textview_buffer(name)
        start, end            = buffertexte.get_bounds()
        texte = buffertexte.get_text(start,end)
        if import_py is not None:
            if not arg:
                getattr(self.IMPORT, name)('hizo', texte)
                return
            else:
                return ('hizo', texte)
        texte = texte.replace("'","\\'").replace('"','\\"').replace('\n','@@')
        self.send( """%s hizo@%s""" % (name, texte) )

    def TEXTLOAD(self, sortie):
        '''
        @name TEXT@@LOAD
        @param @@textview@@fichier
        @brief Loads the textview from a file
        @info fichier: absolute or relative file path
        '''
        name, path = sortie.split('@@')[2:]
        try:
            textview, buffertexte = self.retourne_textview_buffer(name)
            fichier               = open(path, "r")
            chaine                = fichier.read()
            fichier.close()
            buffertexte.set_text(chaine)
        except: pass

    def TEXTRSELECT(self, sortie, tag=False):
        '''
        @name TEXT@@RSELECT
        @param @@textview@@newText
        @brief Replace the selected text
        '''
        name, text            = sortie.split('@@')[2:]
        textview, buffertexte = self.retourne_textview_buffer(name)
        start, end            = buffertexte.get_selection_bounds()
        buffertexte.delete(start, end)
        self.insert_text(buffertexte, start, text, tag)

    def TEXTRSELECTTAG(self, sortie, tag=False):
        '''
        @name TEXT@@RSELECTTAG
        @param @@textview@@tag@@newText
        @brief Replace the selected text with a tag
        '''
        name, tag, text = sortie.split('@@')[2:]
        self.TEXTSELECT( '''TEXT@@SELECT@@%s@@%s''' % (name,  text), tag)
        
    def TEXTSAVE(self, sortie):
        '''
        @name TEXT@@SAVE
        @param @@textview@@fichier
        @brief Saves the textview in a file
        @info fichier: absolute or relative file path
        '''
        name, path = sortie.split('@@')[2:]
        try:
            textview, buffertexte = self.retourne_textview_buffer(name)
            start, end            = buffertexte.get_bounds()
            texte                 = buffertexte.get_text(start,end)
            fichier = open(path, "w")
            fichier.writelines(texte)
            fichier.close()
        except: pass
        
    def TEXTSELECTTAG(self, sortie):
        '''
        @name TEXT@@SELECTTAG
        @param @@textview@@tag
        @brief Adds/remove one or several tag(s) to the selection
        '''
        name, tags            = sortie.split('@@')[2:]
        textview, buffertexte = self.retourne_textview_buffer(name)
        start, end            = buffertexte.get_selection_bounds()
        tag_table             = buffertexte.get_tag_table()
        
        for tag in tags.replace(' ','').split(','):
            tag = tag_table.lookup(tag)
            if start.begins_tag(tag) and end.ends_tag(tag):
                buffertexte.remove_tag(tag, start, end)
                continue
            buffertexte.apply_tag(tag, start, end)

    def TEXTAG(self, sortie):
        '''
        @name TEXT@@TAG
        @param @@textview@@tag,tag
        @brief Apply a tag to the entire textbuffer
        @info tag: name of the tag(s) previously created
        '''
        name, tags            = sortie.split('@@')[2:]
        textview, buffertexte = self.retourne_textview_buffer(name)
        start, end            = buffertexte.get_bounds()
        for tag in tags.replace(' ','').split(','):
            buffertexte.apply_tag_by_name(start, end, tag)

    def insert_text(self, buffertexte, iter, text, tag=False):
        if tag:
            buffertexte.insert_with_tags_by_name(iter, text, tag)
        else:
            buffertexte.insert(iter, text)

    def retourne_textview_buffer(self, name):
        textview    = eval('self.gui.%s' % (name) )
        buffertexte = textview.get_buffer()
        return (textview, buffertexte)
    
    def TEXTHIZOTAG(self, sortie, arg=False):
        '''
        @name TEXT@@HIZOTAG
        @param @@textview
        @brief Calls the textview function with its content as argument
        @info The end-of-line will be replaced by some @@
        @return sh: hizotag@texte@@texte@@texte...
        @return py: ('hizotag', texte)
        '''
        name = sortie.split('@@')[2]
        l_tags = []
        def get_tags(textag, data):
            l_tags.append(textag)
        textview, buffertexte = self.retourne_textview_buffer(sortie.split('@@')[2])
        tag_table       = buffertexte.get_tag_table()
        tmpBuffer       = gtk.TextBuffer(tag_table)
        deserialization = tmpBuffer.register_deserialize_tagset()
        tag_table.foreach(get_tags)
        tmpBuffer.deserialize(
                    tmpBuffer, deserialization, tmpBuffer.get_start_iter(),
                    buffertexte.serialize(
                                  buffertexte,
                                  "application/x-gtk-text-buffer-rich-text",
                                  buffertexte.get_start_iter(), 
                                  buffertexte.get_end_iter(),
                                         ),
                              )
        l_flags = []
        pos=0
        while pos != tmpBuffer.get_end_iter().get_offset():
            for tag in l_tags:
                bal = tag.get_data('balise')
                bo = "<%s>"%bal 
                bf = "</%s>"%bal
                #print bo, pos
                if (tmpBuffer.get_iter_at_offset(pos).begins_tag(tag)
                and bo not in l_flags):
                    tmpBuffer.insert(tmpBuffer.get_iter_at_offset(pos), bo)
                    pos=pos+len(bo)
                    l_flags.append(bo)
                if (tmpBuffer.get_iter_at_offset(pos).ends_tag(tag)
                and bo in l_flags):
                    tmpBuffer.insert(tmpBuffer.get_iter_at_offset(pos), bf)
                    #pos=pos+len(bf)
                    l_flags.remove(bo)
            pos=pos+1
        if l_flags:
            tmpBuffer.insert(tmpBuffer.get_iter_at_offset(pos), bf)
        texte = tmpBuffer.get_text(tmpBuffer.get_start_iter(),
                                   tmpBuffer.get_end_iter())
        #print texte
        #return
        if import_py is not None:
            if not arg:
                getattr(self.IMPORT, name)('hizotag', texte)
                return
            else:
                return ('hizotag', texte)
        texte = texte.replace("'","\\'").replace('"','\\"').replace('\n','@@')
        self.send( """%s hizotag@%s""" % (name, texte) )

    def TEXTSOURCE(self, sortie, arg=False):
        cmd = 'TEXTSOURCE%s' % sortie.split('@@')[2]
        getattr(self, cmd)(sortie)
        
    def TEXTSOURCELANG(self, sortie, arg=False):
        '''
        @name TEXT@@SOURCE@@LANG
        @param @@textview@@lang
        @brief Set the language code view
        @info Only with --sourceview option
        @info Environnement variable G2S_SOURCEVIEW_LANG loaded
        '''
        name, langname = sortie.split('@@')[3:]
        textview, buffertexte = self.retourne_textview_buffer(name)
        lang = getattr(self.gui,'%s_LanguageManager'%name).get_language(langname)
        buffertexte.set_language(lang)
    
    def TEXTSOURCESTYLE(self, sortie, arg=False):
        '''
        @name TEXT@@SOURCE@@STYLE
        @param @@textview@@style
        @brief Set the language code view
        @info Only with --sourceview option
        @info Environnement variable G2S_SOURCEVIEW_STYLE loaded
        '''
        name, stylename = sortie.split('@@')[3:]
        textview, buffertexte = self.retourne_textview_buffer(name)
        ssm = getattr(self.gui,'%s_StyleSchemeManager'%name)
        style = ssm.get_scheme(stylename)
        buffertexte.set_style_scheme(style)


class CmdWEBKIT(object):
    def WEBKIT(self, sortie, arg=False):
        cmd = 'WEBKIT%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd),sortie)

    def WEBKITSAVE(self, sortie, arg=False):
        '''
        @name WEBKIT@@SAVE
        @param @@webview
        @brief Calls the webview function with its content as argument
        @return sh: save@html_quoted
        @return py: ('save', html)
        '''
        name      = sortie.split('@@')[2]
        webview   = eval('self.gui.%s' % name)    
        old_titre = webview.get_main_frame().get_title()
        webview.execute_script("document.title=document.documentElement.innerHTML;")
        html = webview.get_main_frame().get_title()
        webview.execute_script('''document.title=%s''' % old_titre)
        if import_py is not None:
            if not arg:
                getattr(self.IMPORT, name)('save', html)
                return
            else:
                return ('save', html)
        self.send( '''%s save@%s''' % ( name, urllib.quote(html) ) )

    def WEBKITLOAD(self, sortie):
        '''
        @name WEBKIT@@LOAD
        @param @@name@@uri/html
        @brief Loads the webview
        @info uri: http://something;com or /home/folder/file.html
        @info html: html raw text
        '''
        name, uri = sortie.split('@@')[2:]
        self.load_uri_or_html(name, uri)

    def WEBKITDOWNLOAD(self, sortie):
        '''
        @name WEBKIT@@DOWNLOAD
        @param @@webview@@choice
        @brief Action to perform during a download request
        @info choice: UserChoose/UserSave/GetLink
        @info UserChoose calls the function with the save destination user choice
        @info UserSave: saves a file directly from the user choice, also calls the function
        @info GetLink: simple function call
        @return sh: UserChoose@destination, UserSave@destination, GetLink@url 
        @return py: (arg, value)
        '''
        name, choice          = sortie.split('@@')[2:]
        webview               = eval('self.gui.%s' % name)
        dic_webdownload[name] = choice
        idc = webview.connect("download-requested", self.gui.download_requested_cb)
        self.gui.add_signal_to_dic(name, "webdownload", idc)

    def WEBKITREQUEST(self, sortie):
        '''
        @name WEBKIT@@REQUEST
        @param @@webview@@pattern
        @brief Filters the http requests
        @info pattern: All / item
        @info All: calls the function with all the requests as argument
        @info item: filters via the regular expression (does not display the filtered requests in the webview)
        @return sh: request@http://...
        @return py: (request, http//...)
        '''
        name, exts           = sortie.split('@@')[2:]
        webview              = eval('self.gui.%s' % name)
        dic_webrequest[name] = exts
        idc = webview.connect("resource-request-starting", self.gui.resource_request_cb)
        self.gui.add_signal_to_dic(name, "webrequest", idc)

    def WEBKITCACHE(self, sortie):
        '''
        @name WEBKIT@@CACHE
        @param @@webview@@folder@@pattern@@dialog
        @brief Puts in cache filtered via the pattern
        @info dossier: folder path or None (/tmp/webcache)
        @info pattern: Regular expression
        @info dialog: verbose / quiet
        @return sh: cache@url
        @return py: (cache, url)
        '''
        name, dossier, exts, dialog = sortie.split('@@')[2:]
        if dossier == 'None': dossier = '/tmp/webcache'
        webview              = eval('self.gui.%s' % name)
        dic_webcache[name]   = [dossier, exts, dialog]
        self.gui.liste_cache = [i for i in os.listdir(dossier)]
        idc = webview.connect("resource-request-starting", self.gui.resource_cache_cb)
        self.gui.add_signal_to_dic(name, "webcache", idc)

    def WEBKITJSFILE(self, sortie):
        '''
        @name WEBKIT@@JSFILE
        @param @@webview@@file
        @brief Loads a JS file in a html environnement
        @info file: absolute and relative file path
        '''
        name, fichier = sortie.split('@@')[2:]
        webview       = eval('self.gui.%s' % name)
        webview.execute_script('''%s''' % file(fichier,'r').read() )

    def WEBKITLINKFILTER(self, sortie):
        '''
        @name WEBKIT@@LINKFILTER
        @param @@webview@@pattern
        @brief Filters each user click on links via the pattern
        @info pattern: Regular expression
        @return linkfilter@url
        '''
        name, pattern           = sortie.split('@@')[2:]
        dic_weblinkfilter[name] = pattern

    def WEBKITLOADED(self, sortie):
        '''
        @name WEBKIT@@LOADED
        @param @@webview,webview
        @brief Calls the function when the html is loaded
        @return loaded
        '''
        #l_webloaded = []
        for i in range(len(l_webloaded)): l_webloaded.pop(0)
        for l in sortie.split('@@')[2].replace(' ','').split(','):
            l_webloaded.append(l)

    def WEBKITOVERLINK(self, sortie):
        '''
        @name WEBKIT@@OVERLINK
        @param @@webview,webview
        @brief Calls the function when cursor goes above the links
        @return sh: overlink@url
        @return py: (overlink, url)
        '''
        for i in range(len(l_weboverlink)): l_weboverlink.pop(0)
        self.gui.old_hovering_link = None
        for name in sortie.split('@@')[2].replace(' ','').split(','):
            webview = eval('self.gui.%s' % name)
            l_weboverlink.append(name)
            idc = webview.connect_after("hovering-over-link",
                                        self.gui.hovering_over_link_cb)
            self.gui.add_signal_to_dic(name, "weboverlink", idc)

    def WEBKITMENU(self, sortie):
        '''
        @name WEBKIT@@MENU
        @param @@webview@@item::function::value/html@@...
        @brief Creates a context menu
        @info item:function:value/html
        @info item: menu label
        @info function: function to call
        @info value: value of the element under the cursor
        @info html: html of the element under the cursor
        @info separator:None:None
        '''
        name = sortie.split('@@')[2]
        dic_webmenu[name] = []
        for elem in sortie.split('@@')[3:]:
            dic_webmenu[name] += [elem.split('::')]
        webview = eval('self.gui.%s' % name)
        idc = webview.connect_after("populate-popup", self.gui.populate_popup_cb)
        self.gui.add_signal_to_dic(name, "webmenu", idc)

    def WEBKITSUBMENU(self, sortie):
        '''
        @name WEBKIT@@SUBMENU
        @param @@menuitem@@item::function::value/html@@...
        @brief Creates a context sub-menu
        @info menuitem: label of the context menu from where the sub-menu will appear
        @info item:function:value/html
        @info item: menu label
        @info function: function to call
        @info value: value of the element under the cursor
        @info html: html of the element under the cursor
        @info separator:None:None
        '''
        name = sortie.split('@@')[2]
        dic_websubmenu[name] = []
        for elem in sortie.split('@@')[3:]:
            dic_websubmenu[name] += [elem.split('::')]

    def WEBKITDISCONNECT(self, sortie):
        '''
        @name WEBKIT@@DISCONNECT
        @param @@webview@@webcache,webrequest,webmenu,...
        @brief disconnects all signals
        '''
        name, signaux = sortie.split('@@')[2:]
        webview       = eval('self.gui.%s' % name)
        #print dic_websignal
        for signal in signaux.split(','):
            if signal == 'webcache':
                #signal = 'resource-request-starting'
                self.del_dic_webkit(dic_webcache, name)
            elif signal == 'webrequest':
                #signal = 'resource-request-starting'
                self.del_dic_webkit(dic_webrequest, name)
            elif signal == 'webmenu':
                #signal = 'populate-popup'
                self.del_dic_webkit(dic_webmenu, name)
            elif signal == 'webdownload':
                #signal = 'download-requested'
                self.del_dic_webkit(dic_webdownload, name)
            elif signal == 'weblinkfilter':
                self.del_dic_webkit(dic_weblinkfilter, name)
                continue
            elif signal == 'weboverlink':
                for i in range(len(l_weboverlink)): l_weboverlink.pop(0)
                #signal = 'hovering-over-link'
            elif signal == 'webloaded':
                for i in range(len(l_webloaded)): l_webloaded.pop(0)
                continue
            try:
                webview.disconnect( dic_websignal[name][signal] )
                del dic_websignal[name][signal]
            except: pass

    def del_dic_webkit(self, dic, name):
        try:
            del dic[name]
        except:
            pass

    def load_uri_or_html(self, name, arg, div=None):
        webview = eval('self.gui.%s' % name)
        if arg.startswith('/'):
            arg = 'file://'+arg
        if arg.startswith('<'):
            webview.load_string( arg, 'text/xml', 'UTF-8',  'file:///')
        else:
            webview.load_uri(arg)


class Commandes(CmdCOMBO, CmdTREEVIEW, CmdTEXTVIEW, CmdWEBKIT):
    '''
    @page commandes Glade2script commands
    '''
    '''
    *** APP INDICATOR
    '''
    def APPINDICATOR(self, sortie, arg=False):
        '''
        @name APPINDICATOR@@
        @param name@@icon@@menu@@icon-path
        @brief Init new app indicator
        @info name: acces name
        @info icon: the icon name
        @info menu: the context menu
        @info path: additional icon theme path or None
        @info see exemple for usage
        '''
        name, icon, menu, path = sortie.split('@@')[1:]
        menu = getattr(self.gui, menu)
        args = ["example-simple-client","indicator-messages",
                appindicator.CATEGORY_APPLICATION_STATUS]
        if path != 'None':
            args.append(path)
        ind = appindicator.Indicator (*args)
        ind.set_icon(icon)
        ind.set_menu(menu)
        setattr(self.gui, name, ind)
        
    '''
    *** CLIPBOARD
    '''    
    def CLIP(self, sortie, arg=False):
        self.current_clipboard_text = None
        cmd = 'CLIP%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd),sortie, arg)
        if import_py is not None:
            if arg:
                self.IMPORT.clipboard(self.current_clipboard_text)
                return
            else:
                return self.current_clipboard_text
        self.send( 'clipboard %s' % texte)
    
    def CLIPGET(self, data=None, arg=False):
        '''
        @name CLIP@@GET
        @return sh: 'clipboard' function will be called with the clipboard content as argument.
        @return py: clipboard content
        @brief Get the clipboard content. Indicate the --clipboard option
        '''
        self.gui.clipboard.request_text(self.clipboard_texte)
        return self.current_clipboard_text

    def clipboard_texte(self, clipboard, texte, donnees):
        self.current_clipboard_text = texte
        return
        if import_py is not None:
            self.IMPORT.clipboard(texte)
            return
        self.send( 'clipboard %s' % texte)

    def CLIPSET(self, data=None, arg=False):
        '''
        @name CLIP@@SET
        @param @@My text
        @brief Loads 'My text' in the clipboard. Indicate the --clipboard option
        '''
        self.gui.clipboard.set_text( data.replace('CLIP@@SET@@','') )

    '''
    *** COLOR
    '''        
    def COLOR(self, sortie, arg=False):
        '''
        @name COLOR@@
        @param widget,widget@@modify@@gtk_state@@color
        @example echo 'COLOR@@_textview1.modify_base@@NORMAL@@black'
        @brief Changes the color of a widget, #FFFFFF or name color
        @info modify_base, modify_text, modify_bg, modify_fg
        @info NORMAL, SELECTED, ACTIVE, PRELIGHT
        '''
        widget, action, etat, color = sortie.split('@@')[1:]
        for wid in widget.replace(' ','').split(','):
            widget_action = '%s.%s' % (wid, action)
            etat = 'gtk.STATE_%s' % etat
            gobject.idle_add(self.gui.set_color, widget_action, etat, color)

    '''
    *** CONFIG
    '''
    def CONFIG(self, sortie, arg=False):
        cmd = 'CONFIG%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd), sortie)
    
    def CONFIGSAVE(self, sortie):
        '''
        @name CONFIG@@SAVE
        @param @@widget,section,...
        @info section: escape saving widgets/sections
        @brief Save widgets state into the configuration file
        @example echo 'CONFIG@@SAVE@@_hpaned1,WINDOW:window1'
        '''
        l = []
        try:
            blackliste = sortie.split('@@')[2]
            l = blackliste.replace(' ','').split(',')
        except:
            pass
        CONFIG_PARSER.save_config(l)

    def CONFIGSET(self, sortie):
        '''
        @name CONFIG@@SET
        @param @@section@@variable@@value
        @brief Set a variable in a section
        '''
        section, var, value = sortie.split('@@')[2:]
        CONFIG_PARSER.set(section, var, value)

    '''
    *** EXIT
    '''
    def EXIT(self, sortie, arg=False):
        '''
        @name EXIT@@
        @brief Exits without keeping variables
        @return EXIT='no' or exit code 1
        '''
        arg1 = sortie.split('@@')[1]
        if arg1:
            self.stop('yes')
        else: self.stop('no')

    def EXITSAVE(self, sortie, arg=False):
        '''
        @name EXIT@@SAVE
        @brief Exits with the variables
        @return EXIT='yes' or exit code 0
        '''
        self.EXIT(True)

    def EXEC(self, sortie, arg=False):
        arg = sortie.split('@@')[1]
        exec(arg)

    def EVAL(self, sortie, arg=False):
        arg = sortie.split('@@')[1]
        eval(arg)

    def FILE(self, sortie, arg=False):
        cmd = 'FILE%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd), sortie)

    def FILESETFILTER(self, sortie, arg=False):
        '''
        @name FILE@@FILTER
        @param @@filechooser@@add_mime_type@@text/plain,text/html
        @brief Adds a filter to fileselection
        @info add_mime_type => text/plain,text/html,...
        @info add_pattern   => *view*,*tray*,... (see pygtk doc for pattern syntax)
        '''
        nom, genre, filtre = sortie.split('@@')[2:]
        widget     = eval('self.gui.%s' % (nom) )
        filefilter = gtk.FileFilter()
        filtres    = filtre.replace(' ','').split(',')
        for filtre in filtres:
            getattr(filefilter, genre)(filtre)
        widget.set_filter(filefilter)

    '''
    *** WINDOW DIMENSION
    '''
    def GEO(self, sortie, arg=False):
        cmd='GEO%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd), sortie)

    def GEOGET(self, sortie, arg=False):
        '''
        @name GEO@@GET
        @param @@window
        @return sh: geo@width height X Y
        @return py: ('geo', (width, height, X, Y))
        @return window_geo variable loaded too
        @brief Dimensions and location of the window
        '''
        nom           = sortie.split('@@')[2]
        widget        = eval('self.gui.%s' % (nom) )
        X, Y          = widget.get_position()
        width, height = widget.get_size()
        if import_py is not None:
            if not arg:
                getattr(self.IMPORT, nom) ('geo', (width, height, X, Y))
                return
            #setattr(self.IMPORT, nom+'_geo', (width, height, X, Y))
            else:
                return ('geo', (width, height, X, Y))
        self.send( '''GET@%s_geo="%s %s %s %s"''' % (nom, width, height, X, Y) )
        self.send( '''%s geo@%s %s %s %s''' % (nom, width, height, X, Y) )

    def GEOSET(self, sortie):
        '''
        @name GEO@@SET
        @param @@window@@width height X Y 
        @brief Resizes and moves a window
        '''
        nom    = sortie.split('@@')[2]
        widget = eval('self.gui.%s' % (nom) )
        width, height, X, Y = sortie.split('@@')[3].split(' ')
        widget.resize(int(width), int(height) )
        widget.move(int(X), int(Y) )

    '''
    *** PYGTK
    '''
    def GET(self, sortie, arg=False):
        '''
        @name GET@
        @param widget.cmd()
        @return sh: The widget.cmd() command will load the ${widget_cmd} variable
        @return py: (value)
        @brief Gets a widget value via a pygtk command and loads a variable in the environnement
        '''
        sortie  = sortie.split('GET@')[1]
        widget  = sortie.split('(')[0].replace('.','_')
        var     = 'self.gui.%s' % (sortie)
        #print '_____________', var, self.gui.myvar
        result  = eval(var)
        if import_py is not None:
            if not arg:
                setattr(self.IMPORT, widget, result)
                return
            else:
                return result
        var_get = 'GET@%s="%s"' % ( widget, result )
        self.send(var_get)

    '''
    *** GTKRC
    '''
    def GTKRC(self, sortie, arg=False):
        '''
        @name GTKRC@@
        @param window@@rcfile
        @brief Loads a gtkrc-style file
        @info rcfile: relative or absolute path of the gtk-style file
        '''
        widget, rcfile = sortie.split('@@')[1:]
        widget = eval('self.gui.%s' % (widget) )
        self.gui.apply_gtkrc(widget, rcfile)

    '''
    *** IMAGE
    '''
    def IMG(self, sortie, arg=False):
        '''
        @name IMG@@
        @param img@@filename@@width@@height
        @example echo 'IMG@@_img_tux@@tux.png@@150@@150'
        @brief Modify an image
        @info filename: relatif or absolute path of the image
        @info width, height: image size in pixels
        '''
        widget, path, x, y = sortie.split('@@')[1:]
        if path:
            pixbuf = gtk.gdk.pixbuf_new_from_file_at_size( path, int(x), int(y) )
            self.gui.dic_img[widget] = path
            img = eval('self.gui.%s' % (widget) )
            gobject.idle_add(img.set_from_pixbuf, pixbuf)

    '''
    *** GET THE STATUS OF CHILD TOOGLE WIDGET
    '''
    def ISACTIVE(self, sortie, arg=False):
        '''
        @name ISACTIVE@@
        @param widget
        @brief Resends all the active toogles for the widget childs
        @return sh: isactive@widget widget widget
        @return py: (widgets_list)
        '''
        widget_name = sortie.split('@@')[1]
        self.list_is_active = []
        widget = eval( 'self.gui.%s' % widget_name )
        self.IS_container( widget )
        DEBUG('[ISACTIVE] %s'% self.list_is_active)
        if import_py is not None:
            if not arg:
                getattr(self.IMPORT, widget_name)(self.list_is_active)
                return
            else:
                return self.list_is_active
        self.send( '%s isactive@%s' % (widget_name, ' '.join(self.list_is_active) ) )

    def IS_container(self, widget):
        try:
            childs = widget.get_children()
        except:
            pass
        else:
            for child in childs:
                self.IS_container(child)
                self.IS_active(child)

    def IS_active(self, widget):
        try:
            value = widget.get_active()
        except:
            pass
        else:
            self.list_is_active.append( '%s:%s' % (widget.get_name(), value) )

    '''
    *** ITER
    '''
    def ITER(self, sortie, arg=False):
        '''
        @name ITER@@
        @param MyFunction
        @brief Calls a function of the associate script
        @info This allows to call a function in the environnement loaded with the new variables
        @info <a href="infos.html#ITER"> plus ...</a>
        '''
        arg = sortie.replace('ITER@@','')
        self.send( arg )

    '''
    *** MENU
    '''
    def MAKEMENU(self, sortie, arg=False):
        '''
        @name MAKEMENU@@
        @param widget@@menu_name@@item::fonction::arg@@...
        @brief Creates a context menu
        @info widget: the widget which will receive the menu
        @info menu_name: menu name
        @info item: menu label, function: function to be called, arg: function argument
        @info separator:None:None
        '''
        widget = eval( 'self.gui.%s' % sortie.split('@@')[1])
        menu_name = sortie.split('@@')[2]
        menu = gtk.Menu()
        idc  = widget.connect('button-press-event', self.dyn_menu_cb, menu)
        #widget.set_title('ouehhh')
        setattr(self.gui, menu_name, menu)
        for elem in sortie.split('@@')[3:]:
            item, function, arg = elem.split('::')
            if item == 'separator':
                separator = gtk.SeparatorMenuItem()
                menu.append( separator )
                separator.show()
            else:
                menuitem = gtk.MenuItem(label=item)
                menuitem.connect('activate', self.call_function_from_menu,
                                    item, function, arg)
                menuitem.props.name = item
                menu.append(menuitem)
                menuitem.show()

    def call_function_from_menu(self, menuitem, item, function, arg):
        if import_py is not None:
            getattr(self.IMPORT, function)(item, arg)
        else:
            self.send('%s %s@%s' % (function, item, arg) )

    def dyn_menu_cb(self, widget, event=None, menu=None, arg=None):
        if event.button == 3:
                menu.popup(None,None,None,event.button,event.time)

    def SUBMENU(self, sortie, arg=False):
        '''
        @name SUBMENU@@
        @param menu_name@@label_menuitem@@item::fonction::arg@@...
        @brief Creates a sub-menu
        @info menu_name: menu name
        @info label_menuitem: the menu label where the sub-menu will appear from
        '''
        top_menu       = eval('self.gui.%s' % sortie.split('@@')[1] )
        #print top_menu.get_children()
        label_menuitem = sortie.split('@@')[2]
        for menuitem in top_menu.get_children():
            #print menuitem.props.label, label_menuitem
            if type(menuitem) == gtk.SeparatorMenuItem: 
                #if no control, menu separator remplaced by space !!!!????
                continue
            #print str(menuitem.get_label()).replace('_',''), menuitem.props.label
            if menuitem.props.label == label_menuitem:
                menu = gtk.Menu()
                for elem in sortie.split('@@')[3:]:
                    item, function, arg = elem.split('::')
                    if item == 'separator':
                        separator = gtk.SeparatorMenuItem()
                        menuitem.append( separator )
                    else:
                        menuit = gtk.MenuItem(label=item, use_underline=False)
                        menuit.connect('activate', self.call_function_from_menu,
                                    item, function, arg)
                        menuit.props.name = item
                        menu.append(menuit)
                menuitem.set_submenu(menu)
                menu.show_all()
                break

    '''
    *** MULTIPLE COMMANDS
    '''
    def MULTI(self, sortie, arg=False):
        arg = sortie.replace('ITER@@','')
        cmd = 'MULTI%s' % sortie.split('@@')[1]
        return getattr(self, cmd)(sortie, arg)
    
    def MULTISET(self, sortie, arg):
        '''
        @name MULTI@@SET
        @param @@cmd()@@widget,widget
        @brief Runs the pygtk command on the widgets.
        @info Same principle as SET@, but simultaneously on several widgets
        '''
        cmd       = sortie.split('@@')[2]
        l_widgets = sortie.split('@@')[3].replace(' ','').split(',')
        for item in l_widgets:
            self.SET( 'SET@%s.%s' % (item, cmd) )

    def MULTIGET(self, sortie, arg):
        '''
        @name MULTI@@GET
        @param @@cmd()@@widget,widget
        @brief Runs the pygtk command on the widgets.
        @info Same principle as GET@, but simultaneously on several widgets
        @return same as GET@
        '''
        cmd       = sortie.split('@@')[2]
        l_widgets = sortie.split('@@')[3].replace(' ','').split(',')
        l = []
        if import_py is not None:
            for item in l_widgets:
                l.append(self.GET( 'GET@%s.%s' % (item, cmd), arg))
            return l
        else:
            for item in l_widgets:
                self.GET( 'GET@%s.%s' % (item, cmd))

    '''
    *** NOTIFY
    '''
    def NOTIFY(self, sortie, arg=False):
        '''
        @name NOTIFY@@
        @param timer@@titre@@texte@@icon
        @example echo 'NOTIFY@@2@@Titre@@Ligne1\\n<b>Ligne2</b>\\n<i>Ligne3</i>@@dialog-yes'
        @brief Displays a notify message
        @info timer: display delay in millisecondes
        @info titre: message title
        @info texte: text to display
        @info icon: image path or icon name
        @info dependancies: pynotify and libnotify
        '''
        delay, titre, message, icon = sortie.split('@@')[1:]
        message = message.replace('\\n','\n')
        if not pynotify.init("Multi Action Test"):
            return
        if icon:
            if '/' in icon:
                uri = "file://%s" % icon
            else:
                uri=icon
            n = pynotify.Notification(titre, message, uri)
        else:
            n = pynotify.Notification(titre, message)
        if systray_icon is not None:
            n.attach_to_status_icon(self.gui.systray)
        if delay: t = int(delay)*1000
        else: t = 3000
        n.set_timeout(t)
        n.show()
        if not n.show():
            DEBUG("Failed to send notification")

    def PLUGIN(self, sortie, arg=False):
        cmd = 'PLUGIN%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd), sortie)
    
    def PLUGININIT(self, sortie):
        '''
        @name PLUGIN@@INIT
        @param @@plugin@@name@@arg@@arg@@...
        @brief Starts plugin
        @info plugin the plugin name
        @info name the name used for the plugin instance
        '''
        l = sortie.split('@@')[2:]
        plugin = l.pop(0)
        name = l[0]
        exec('import %s.plugin as plug' % plugin)
        setattr(self, name, plug.Plugin(self, '@@'.join(l)) )
        return
        #print plugin
        #plug = __import__(plugin)
        for name in names:
            exec('import %s.plugin as plug' % plugin)
            arg = name+'@@'+'@@'.join(l)
            ll = [name]+l
            setattr(self, name, plug.Plugin(self, '@@'.join(ll)) )
        
    def PLUGINCMD(self, sortie):
        '''
        @name PLUGIN@@CMD
        @param @@name@@cmd
        @brief Execute a plugin command
        '''
        name, cmd = sortie.split('@@')[2:]
        #exec('self.%(name)s.CMD(%(cmd)s)')
        getattr(self, name).CMD(cmd)
        
    
    def POINTER(self, sortie, arg=False):
        cmd = 'POINTER%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd), sortie)

    def POINTERSTART(self, sortie):
        '''
        @name POINTER@@START
        @param @@delay@@widget
        @brief Starts the cursor monitoring on a widget
        @info delay: milliseconds
        @return sh: move@x y
        @return py-cb: ('move', x, y)
        '''
        delay, name = sortie.split('@@')[2:]
        widget          = eval( 'self.gui.%s' % name )
        rootwin         = widget.get_screen().get_root_window()
        x, y, mods      = rootwin.get_pointer()
        #self.flag_move  = True
        self.old_x_move = x
        self.old_y_move = y
        setattr(self, 'flag_move_%s' % name, True)
        gobject.timeout_add(int(delay), self.check_pointer, widget, name)

    def POINTERSTOP    (self, sortie):
        '''
        @name POINTER@@STOP
        @param @@widget
        @brief STops the cursor monitoring for the widget
        '''
        name = sortie.split('@@')[2]
        setattr(self, 'flag_move_%s' % name, False)
        self.flag_move = False

    def check_pointer(self, widget, name):
        rootwin    = widget.get_screen().get_root_window()
        x, y, mods = rootwin.get_pointer()
        if x != self.old_x_move or y != self.old_y_move:
            self.old_x_move = x
            self.old_y_move = y
            if import_py is not None:
                getattr(self.IMPORT, name) ('move', x, y)
            else:
                self.send('%s move@%s %s' % (name, x, y) )
        return eval('self.flag_move_%s' % name)

    '''
    *** SCREEN DIMENSION
    '''
    def SCREEN(self, sortie, arg=False):
        '''
        @name SCREEN@@
        @brief Loads the screen dimensions in the environment
        @info keep for retro-compatibility since 2.3.0
        @return screen_height="1200" screen_width="1800"
        @return py: (width, height)
        '''
        if import_py is not None:
            setattr(self.IMPORT, 'screen_width', self.gui.screen_width)
            setattr(self.IMPORT, 'screen_height', self.gui.screen_height)
            return (self.gui.screen_width, self.gui.screen_height)
        self.send('GET@screen_height="%s"' % self.gui.screen_height)
        self.send('GET@screen_width="%s"' % self.gui.screen_width)

    '''
    *** PYGTK
    '''
    def SET(self, sortie, arg=False):
        '''
        @name SET@
        @param widget.cmd()
        @brief runs a pygtk command (show(), hide(), ...)
        '''
        sortie = sortie.replace('SET@','')
        gobject.idle_add(self.gui.set_widget, sortie )

    '''
    *** STATUSBAR
    '''
    def STATUS(self, sortie, arg=False):
        '''
        @name STATUS@@
        @param statusbar@@My Text
        @brief Displays a text in a statusbar.
        '''
        widget, text = sortie.split('@@')[1:]
        statusbar = getattr(self.gui, widget)
        context = getattr(self.gui, 'context_%s'%widget)
        gobject.idle_add(statusbar.push, context, text)

    '''
    *** SYSTRAY
    '''
    def SYSTRAY(self, sortie, arg=False):
        '''
        @name SYSTRAY@@
        @param name@@menu@@icon@@infobulle
        @brief Displays a systray icon.
        @info name: acces name
        @info icon: the icon name
        @info menu: associated contextmenu or None
        @info infobulle: tootltip text
        @info Default hide, use pygtk command to show it and more (see exemple)
        '''
        l = sortie.split('@@')[1:]
        gobject.idle_add(self.gui.new_systray_icon, *l)

    '''
    *** TOGGLE
    '''
    def TOGGLE(self, sortie, arg=False):
        cmd = 'TOGGLE%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd), sortie)

    def TOGGLESENSITIVE(self, sortie):
        '''
        @name TOGGLE@@SENSITIVE
        @param @@widget,widget
        @brief Toggles the sensitive (grey) status of one or several widget(s)
        '''
        l_widgets = sortie.split('@@')[2].replace(' ','').split(',')
        for item in l_widgets:
            widget = eval('self.gui.%s' % (item) )
            self.gui.toggle_sensitive(widget)

    def TOGGLEEXPANDER(self, sortie):
        '''
        @name TOGGLE@@EXPANDER
        @param @@widget,widget
        @brief Opens or closes one or several expander(s)
        '''
        l_widgets = sortie.split('@@')[2].replace(' ','').split(',')
        for item in l_widgets:
            widget = eval('self.gui.%s' % (item) )
            if widget.get_expanded():
                widget.set_expanded(False)
            else:
                widget.set_expanded(True)

    def TOGGLEVISIBLE(self, sortie):
        '''
        @name TOGGLE@@VISIBLE
        @param @@widget,widget
        @brief Toggles the visibility status of one or several widget(s)
        '''
        l_widgets = sortie.split('@@')[2].replace(' ','').split(',')
        for item in l_widgets:
            widget = eval('self.gui.%s' % (item) )
            self.gui.toggle_visible(widget)

    def TOGGLEACTIVE(self, sortie):
        '''
        @name TOGGLE@@ACTIVE
        @param @@widget,widget
        @brief Toggle the active status of one or several widget(s) (check, radio, toggle)
        '''
        l_widgets = sortie.split('@@')[2].replace(' ','').split(',')
        for item in l_widgets:
            widget = eval('self.gui.%s' % (item) )
            self.gui.toggle_active(widget)

    '''
    *** TERMINAL
    '''
    def TERM(self, sortie, arg=False):
        cmd='TERM%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd),sortie)

    def TERMFONT(self, sortie):
        '''
        @name TERM@@FONT
        @param @@font
        @brief Modify the terminal font
        @info Indicate the --terminal option
        @info font: pangoFontDescription ex: serif,monospace bold italic condensed 10
        '''
        font = sortie.split('@@')[2]
        self.gui.terminal.set_font_from_string(font)

    def TERMKILL(self, sortie):
        '''
        @name TERM@@KILL
        @param [@@sig]
        @brief Kills the process launched in the terminal
        @info sig: numerical kill signal
        @info Indicate the --terminal option
        '''
        try:
            sig = sortie.split('@@')[2]
        except:
            sig = '9'
        self.gui.kill_term_child(int(sig))

    def TERMWRITE(self, data=None):
        '''
        @name TERM@@WRITE
        @param @@text
        @brief Writes in the terminal
        '''
        cmd = data.replace('TERM@@WRITE@@','').replace('\\n','\n').replace('\\r','\r')
        self.gui.terminal.feed(cmd)

    def TERMSEND(self, data=None):
        '''
        @name TERM@@SEND
        @param @@commande
        @brief Runs a command in the terminal
        '''
        cmd = data.replace('TERM@@SEND@@','').replace('\\n','\n').replace('\\r','\r')
        self.gui.terminal.feed_child(cmd)


    def TIMER(self, sortie, arg=False):
        cmd='TIMER%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd), sortie)

    def TIMERSTART(self, sortie):
        '''
        @name TIMER@@START
        @param @@delay@@function
        @brief Loop call of a function
        @info delay: milliseconds
        '''
        delay, function = sortie.split('@@')[2:]
        setattr(self, 'flag_timer_%s' % function, True)
        gobject.timeout_add(int(delay), self.check_timer, function)

    def TIMERSTOP(self, sortie):
        '''
        @name TIMER@@STOP
        @param @@function
        @brief Stops the loop call
        '''
        function = sortie.split('@@')[2]
        setattr(self, 'flag_timer_%s' % function, False) 

    def check_timer(self, function):
        if import_py is not None:
            getattr(self.IMPORT, function)
        else:
            self.send(function)
        return eval('self.flag_timer_%s' % function)

    def WINDOW(self, sortie, arg=False):
        cmd = 'WINDOW%s' % sortie.split('@@')[1]
        gobject.idle_add(getattr(self, cmd),sortie)

    def WINDOWBACKGROUND(self, sortie):
        '''
        @name WINDOW@@BACKGROUND
        @param @@name@@image
        @brief Uses an image as window background
        @info this command must be run before the window display,
        @info set the window on invisible then run a show().
        @info name: window name
        @info image: relative or absolute image path
        '''
        name, img    = sortie.split('@@')[2:]
        widget       = eval('self.gui.%s' % name)
        pixbuf       = gtk.gdk.pixbuf_new_from_file(img)
        pixmap, mask = pixbuf.render_pixmap_and_mask()
        del pixbuf
        widget.set_app_paintable(True)
        widget.shape_combine_mask(mask, 0, 0)
        #widget.realize()    
        widget.window.set_back_pixmap(pixmap, False)

    def WINDOWTRANS(self, sortie):
        '''
        @name WINDOW@@TRANS
        @param @@name@@trans@@color
        @brief Ajusts the transparency and color of the window background
        @info add the --transparent option
        @info name: window name
        @info trans: transparency (0 to 1)
        @info color: #ffffff or color name
        '''
        name, trans, color = sortie.split('@@')[2:]
        widget             = eval('self.gui.%s' % name)
        dic_trans[name]    = [trans, color]
        widget.queue_draw()


class MyThread(threading.Thread, Commandes):
    '''
    ********************************************************
    *** GLADE2SCRIPT COMMANDS RECEPTION FROM THE FIFO
    ********************************************************
    '''
    def __init__(self, gui):  
        threading.Thread.__init__(self)
        self.gui=gui
        self.Terminated=False
        self.iter_select=None
        self.n_break=0

    def test_fichier(self, fichier):
        l_file_splitted = fichier.split(' ')
        n = 0
        fichier_t = l_file_splitted.pop(0)
        while True:
            if os.path.exists( fichier_t ):
                arg = '''%s %s''' % ( fichier_t.replace(' ','\ '), ' '.join(l_file_splitted) )
                break
            fichier_t = '''%s %s''' % ( fichier_t, l_file_splitted.pop(0) )
        return shlex.split(arg)

    def run(self):
        if import_py is not None:
            module = os.path.splitext(import_py)[0]
            if os.path.isfile(import_py):
                path, module = os.path.split(module)
                sys.path.append(path)
            exec('import %s as myimport' % module)
            self.IMPORT = myimport.Action(self)
            self.IMPORT.start()
        else:
            args = self.test_fichier( s_bash )
            sb   = subprocess.Popen(args,
                                    stderr = subprocess.STDOUT,
                                    stdout = subprocess.PIPE,
                                    env    = os.environ.update(DIC_ENV),
                                    )
            PID  = sb.pid
            self.path_FIFO = '/tmp/FIFO%s' % (PID)
            while not self.Terminated:
                sortie = sb.stdout.readline().rstrip()
                DEBUG('=> [[ PY ]] => %s' % sortie)
                if sortie == '':
                    self.n_break += 1
                    if self.n_break == 10:
                        os.kill(PID, 9)
                        break
                    continue
                self.n_break = 0
                try:
                    cmd = sortie.split('@')[0]
                    getattr(self, cmd)(sortie)
                except: pass

    def from_import(self, sortie, arg=False):
        try:
            try:
                cmd = sortie.split('@')[0]
                return getattr(self, cmd)(sortie, arg)
            except:
                cmd = cmd+sortie.split('@')[1]
                return getattr(self, cmd)(sortie, arg)
        except ValueError, NameError:
            raise
        DEBUG('=> [[ PY ]] => : from import %s'% sortie)

    def send(self,data):
        if import_py is not None:
            DEBUG("=> [[ PY ]] => : Send from glade: %s"% data)
            #self.IMPORT.from_glade(data)
            return
        if data and self.gui.window_realized:
            time.sleep(0.001)
            i = open(self.path_FIFO,'w')
            i.write(data+'\n')
            #i.write(data)
            i.close()
            DEBUG("=> [[ PY ]] => :: FIFO write :: %s"% data)

    def stop(self,arg=None):
        if import_py is not None:
            self.IMPORT.quit_now()
        else:
            self.send('QuitNow')
            self.Terminated=True
            global EXIT
            if arg == 'no':
                #print 'EXIT="no"'
                EXIT = 'no'
            else:
                self.stop_save()
                print 'VERSION="glade2script 2.4.3, Copyright (C) 2010-2012, February 2012"'
                print 'EXIT="yes"'
                EXIT='yes'
        if term_box:
            self.gui.kill_term_child(9)
        gtk.main_quit()
        try:
         os.remove(self.path_FIFO)
        except: pass

    def stop_save(self):
        for item in l_sortie:
            wid = eval('self.gui.%s' % (item) )
            if 'GtkTreeView' in str(wid):
                retour = self.retourne_selection(item)
                if retour:
                    print '''%s="%s"''' % (item, retour)
                continue
            widget = item.replace('.','_')
            var    = 'self.gui.%s ()' % (item)
            result = eval(var)
            print '%s="%s"' % (widget , result)

USAGE = '''
Usage: %s [OPTIONS]

OPTIONS:
 --clipboard= PRIMARY or CLIPBOARD
\t Activate the clipboard

 --combobox=  @@combobox1@@col|IMG
\t Lists the combobox elements (one per line or per option)

 -d 
\t Debug

 --embed= _drawingarea1@@app
\t Embeds an application that supports it natively

 -g/--glade= file
\t glade file

 --gtkbuilder
\t Use the GtkBuilder librairy instead of Libglade (default)

 --gtkrc= rcfile
\t rc style file

 -h/--help 
\t Display the help

 --import= path
\t Import as module instead of using the FIFO

 --infobulle= @@treeview@@col1:col2,col:col2
\t to manage the tiptool of a treeview

 --libglade
\t Use the Libglade librairy instead of GtkBuilder (depreciated)

 --locale= path
\t Change the 'locale' folder (used for translation)

 -r/--retour= _text1.get_text, window1.get_position, treeview1
\t gtk commands for outputs

 -s/--sh= file
\t sh file

 --systray= menu@img@infobulle
\t Notify zone icon

 --terminal-font= serif,monospace bold italic condensed 10
\t Loads a font name string

 --terminal-redim 
\t Automatic terminal resize

 --terminal= widget:widthxheight
\t VTE terminal

 --transparent= name:trans/None:color/None
\t Background transparency

 -t/--tree= @@treeview@@option@@option@@option
\t Treeview elements list (one per line or per option)

 --webcache= webview:folder:pattern:dialog
\t Puts in cache filtered via the pattern

 --webdownload= webview:choice
\t Action to perform during a download request

 --webkit= name,box
\t Add webkit html interpreter

 --weblinkfilter= webview:pattern
\t Filters each user click on links via the pattern

 --webloaded= webview,webview
\t Calls the function when the html is loaded

 --webmenu= webview:item:function:value/html
\t Creates a context menu

 --weboverlink= webview,webview
\t Calls the function when cursor goes above the links

 --webrequest= webview:pattern
\t Filters the http requests

 --websubmenu= menuitem:item:function:value/html
\t Creates a context sub-menu
''' % sys.argv[0]


if __name__ == '__main__':
    def DEBUG(arg):
        if debug: print arg

    l_sortie      = []
    l_webkit      = []
    l_webloaded   = []
    l_weboverlink = []
    systray_icon  = []
    DIC_ENV  = {
                'G2S_SCREEN_WIDTH'  : '0',
                'G2S_SCREEN_HEIGHT' : '0',
                'G2S_TERMINAL_PID'  : '0',
                'G2S_SOURCEVIEW_LANG'  : 'None',
                'G2S_SOURCEVIEW_STYLE' : 'None',
                }
    init_dic  = [
                 'dic_treeview', 'dic_combo', 'dic_tooltip', 'dic_trans',
                 'dic_webcache','dic_webdownload', 'dic_webrequest',
                 'dic_weblinkfilter', 'dic_websignal', 'dic_webmenu',
                 'dic_websubmenu', 'dic_sourceview',
                 ]
    init_none = [
                 's_bash', 'gtkrc', 'clip', 'term_box',
                 'flag_term', 'embed', 'term_font', 'term_redim',
                 'import_py', 'local_path', 'auto_config', 'load_config',
                 ]

    for i in init_dic: exec('%s={}' % i)
    for i in init_none: exec('%s=None' % i)

    debug=False

    USERLIB = 'object'

    try:                                
        opts, args = getopt.getopt(sys.argv[1:], "hs:g:r:t:d",
            ["sh=", "glade=", "retour=","locale=","websubmenu=","libglade",
            "gtkrc=", "tree=","systray=","webcache=","webmenu=","auto-config=",
            "terminal=", "embed=", "import=","webrequest=","weboverlink=",
            "infobulle=","clipboard=", "webkit=","weblinkfilter=",
            "terminal-font=","terminal-redim","webdownload=","sourceview=",
            "gtkbuilder","combobox=","transparent=","webloaded=","load-config="]
                    )
    except getopt.GetoptError: 
        print 'error', USAGE
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"): 
            print USAGE
            sys.exit()
        elif opt in ("-s", "--sh"): 
            s_bash = arg
        elif opt == '-d':
            debug = True
        elif opt in ("-g", "--glade"): 
            f_glade = arg 
        elif opt in ("-r","--retour"):
            l_sortie=arg.replace(' ','').split(',')
        elif opt == "--gtkrc":
            gtkrc = arg
        elif opt == "--systray":
            systray_icon.append(arg.split('@'))
        elif opt == "--infobulle":
            name, coord= arg.split('@@')[1:]
            dic_tooltip[name]=eval('{%s}' % coord)
        elif opt in ("-t", "--tree"):
            liste_tree=[]
            for item in arg.split('\n'):
                if item.startswith('@@'):
                    if liste_tree:
                        dic_treeview[nom]=liste_tree
                        liste_tree=[]
                    nom, reference = item.split('@@')[1:]
                    liste_tree.append(reference)
                    continue
                liste_tree.append(item)
            dic_treeview[nom]=liste_tree
        elif opt == "--combobox":
            liste_combo=[]
            for item in arg.split('\n'):
                if item.startswith('@@'):
                    if liste_combo:
                        dic_treeview[nom]=liste_tree
                        liste_combo=[]
                    nom, reference = item.split('@@')[1:]
                    liste_combo.append(reference)
                    continue
                liste_combo.append(item)
            dic_combo[nom]=liste_combo
        elif opt == "--clipboard":
            clip = arg
        elif opt == "--terminal":
            import vte
            term_box = arg
        elif opt == "--terminal-font":
            term_font = arg
        elif opt == "--terminal-redim":
            term_redim = True
        elif opt == "--embed":
            embed = arg
        elif opt == "--import":
            import_py = arg
        elif opt == '--gtkbuilder':
            USERLIB = 'object'
        elif opt == '--libglade':
            USERLIB = 'widget'
            import gtk.glade
        elif opt == "--webkit":
            l_webkit.append( arg.split(',') )
            import webkit, urllib
        elif opt == "--sourceview":
            import gtksourceview2
            name, box = arg.replace(' ','').split(',')
            dic_sourceview[name] = box
        elif opt == '--transparent':
            name, trans, color = arg.split(':')
            dic_trans[name] = [ trans, color ]
        elif opt == '--locale':
            local_path = arg
        elif opt == '--webcache':
            name, dossier, ext, dialog = arg.split(':')
            if dossier == 'None':
                dossier = '/tmp/webcache'
                try:
                    os.mkdir(dossier)
                except: pass
            dic_webcache[name] = [dossier, ext, dialog]
        elif opt == '--webrequest':
            name, ext = arg.split(':')
            dic_webrequest[name] = ext
        elif opt == '--webdownload':
            name, value = arg.split(':')
            dic_webdownload[name] = value
        elif opt == '--weblinkfilter':
            l = arg.split(':')
            name = l.pop(0)
            filtre = ':'.join(l)
            dic_weblinkfilter[name] = filtre
        elif opt == '--webmenu':
            name, item, function, value = arg.split('::')
            try:
                dic_webmenu[name] += [[item, function, value]]
            except:
                dic_webmenu[name] = [[item, function, value]]
        elif opt == '--websubmenu':
            menuitem, item, function, value = arg.split('::')
            try:
                dic_websubmenu[menuitem] += [[item, function, value]]
            except:
                dic_websubmenu[menuitem] = [[item, function, value]]
        elif opt == '--webloaded':
            l_webloaded += arg.replace(' ','').split(',')
        elif opt == '--weboverlink':
            l_weboverlink += arg.replace(' ','').split(',')
        elif opt == '--load-config':
            load_config = arg
        elif opt == '--auto-config':
            auto_config = arg
    
    try:
        import pynotify
    except:
        DEBUG("You need to install pynotify to use notification")
    try:
        import appindicator
    except:
        DEBUG("You need to install appinicator to use app indicator")
    
    path_appli, appli_name = os.path.split( f_glade )
    nom_appli= os.path.splitext(appli_name)[0]
    os.chdir(path_appli)
    
    if dic_trans: import cairo
    
    if s_bash is None:
        s_bash = '%s.sh' % os.path.join(os.path.realpath(os.getcwd()), nom_appli)
    
    if local_path is None:
        local_path = os.path.join(os.path.realpath(os.getcwd()), 'locale')
    
    if load_config is not None or auto_config is not None:
        if auto_config is None: path = load_config
        else: path = auto_config
        CONFIG_PARSER = ParseConfig(path)
    
    DEBUG("glade2script 2.4.3, Copyright (C) 2010-2012, February 2012")
    m = Gui()
    m.go_thread()
    m.main()
    if import_py is None:
        if EXIT == 'yes': sys.exit(0)
        elif EXIT == 'no': sys.exit(1)
