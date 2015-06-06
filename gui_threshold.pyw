#!/usr/bin/python


# RPKM Threshold GUI
# Marc Ferrell

from Tkinter import *
import tkFileDialog
import os

def get_alpha():
    alpha = alphavar.get()
    return alpha

def get_scripts():
    scripts = tkFileDialog.askdirectory()
    label4 = Label(app, text = scripts)
    label4.grid(row=4,column=2)
    global scripts

def get_dir():
    dir = tkFileDialog.askdirectory()
    label4 = Label(app, text = dir)
    label4.grid(row=8,column=2)
    global dir

def begin():
    alpha = get_alpha()
    label7 = Label(app, text = "Processing...")
    label7.grid(row=12, column=2)
    
    os.system("%s/threshold.sh %s %s %s" % (scripts,scripts,dir,str(alpha)))
    #print "%s/threshold.sh %s %s %s" % (scripts,scripts,dir,str(alpha))
    label8 = Label(app, text = "Done")
    label8.grid(row=13, column=2)

#Create window
root = Tk()

#Create window features
root.title("RPKM Threshold Finder")
root.geometry("650x300")
app = Frame(root)
app.grid()

label1 = Label(app, text = "Move all .xprs and .fpkm_tracking files to one folder, then select the folder below")
label1.grid(row=2,column=2)

button0 = Button(app, text = "Select Threshold Finder Location", command = get_scripts)
button0.grid(row=3, column=2)

button = Button(app, text = "Select Data Folder", command = get_dir)
button.grid(row=7,column=2)
label3 = Label(app, text = "Enter Alpha Level")
label3.grid(row=9,column=2)
alphavar = StringVar()
entry = Entry(app, textvariable=alphavar, width = 5)
entry.grid(row=10,column=2)

button1 = Button(app, text = "Execute", command = begin)
button1.grid(row=11,column=2)


# Initialize Window
root.mainloop()
