
# test code for PyPortMidi
# a port of a subset of test.c provided with PortMidi
# John Harrison
# harrison [at] media [dot] mit [dot] edu

# March 15, 2005: accommodate for SysEx messages and preferred list formats
#                 SysEx test code contributed by Markus Pfaff 
# February 27, 2005: initial release

from pygame import pypm
import array
import time

NUM_MSGS = 9999 # number of MIDI messages for input before closing

INPUT=0
OUTPUT=1

Message=""

def PrintDevices(InOrOut):
    for loop in range(pypm.CountDevices()):
        interf,name,inp,outp,opened = pypm.GetDeviceInfo(loop)
        if ((InOrOut == INPUT) & (inp == 1) |
            (InOrOut == OUTPUT) & (outp ==1)):
            print loop, name," ",
            if (inp == 1): print "(input) ",
            else: print "(output) ",
            if (opened == 1): print "(opened)"
            else: print "(unopened)"
    print
    
def TestInput():
    PrintDevices(INPUT)
    dev = int(raw_input("Type input number: "))
    MidiIn = pypm.Input(dev)
    print "Midi Input opened. Reading ",NUM_MSGS," Midi messages..."
#    MidiIn.SetFilter(pypm.FILT_ACTIVE | pypm.FILT_CLOCK)
    for cntr in range(1,NUM_MSGS+1):
        while not MidiIn.Poll(): pass
        MidiData = MidiIn.Read(1) # read only 1 message at a time
        print "Got message ",cntr,": time ",MidiData[0][1],", ",
        print  MidiData[0][0][0]," ",MidiData[0][0][1]," ",MidiData[0][0][2], MidiData[0][0][3]
        # NOTE: most Midi messages are 1-3 bytes, but the 4 byte is returned for use with SysEx messages.
    del MidiIn
    
def ReadSysex():
    global Message
    PrintDevices(INPUT)
    dev = int(raw_input("Type input number: "))
    MidiIn = pypm.Input(dev)
    print "Midi Input opened. Reading ",NUM_MSGS,"(4 byte) Midi messages..."
#    MidiIn.SetFilter(pypm.FILT_ACTIVE | pypm.FILT_CLOCK)
    for cntr in range(1,NUM_MSGS+1):
        while not MidiIn.Poll(): pass
        MidiData = MidiIn.Read(1) # read only 1 message at a time
        for i in range(4):
            if ((MidiData[0][0][i] == 240) & (len(Message) == 0)):
                Message = '{:<3}{:>15}{}'.format(cntr,str(MidiData[0][1]),' : ')
            elif ((MidiData[0][0][i] == 10) | (MidiData[0][0][i] == 13) ): #Newlines 0A or 0D
                Message += '\n'
                Message += '{:>18}{}'.format(str(MidiData[0][1]),' : ')
            elif ((MidiData[0][0][i] > 31) & (MidiData[0][0][i] < 127) ):
                Message += chr(MidiData[0][0][i])
            elif MidiData[0][0][i] == 247:
                print Message
                Message=""
        # NOTE: most Midi messages are 1-3 bytes, but the 4 byte is returned for use with SysEx messages.
    del MidiIn
    
def TestOutput():
    latency = int(raw_input("Type latency: "))
    print
    PrintDevices(OUTPUT)
    dev = int(raw_input("Type output number: "))
    MidiOut = pypm.Output(dev, latency)
    print "Midi Output opened with ",latency," latency"
    dummy = raw_input("ready to send program 1 change... (type RETURN):")
    MidiOut.Write([[[0xc0,0,0],pypm.Time()]])
    dummy = raw_input("ready to note-on... (type RETURN):")
    MidiOut.Write([[[0x90,60,100],pypm.Time()]])
    dummy = raw_input("read to note-off... (type RETURN):")
    MidiOut.Write([[[0x90,60,0],pypm.Time()]])
    dummy = raw_input("ready to note-on (short form)... (type RETURN):")
    MidiOut.WriteShort(0x90,60,100)
    dummy = raw_input("ready to note-off (short form)... (type RETURN):")
    MidiOut.WriteShort(0x90,60,0)
    print
    print "chord will arpeggiate if latency > 0"
    dummy = raw_input("ready to chord-on/chord-off... (type RETURN):")
    chord = [60, 67, 76, 83, 90]
    ChordList = []
    MidiTime = pypm.Time()
    for i in range(len(chord)):
        ChordList.append([[0x90,chord[i],100], MidiTime + 1000 * i])
    MidiOut.Write(ChordList)
    while pypm.Time() < MidiTime + 1000 + len(chord) * 1000 : pass
    ChordList = []
    # seems a little odd that they don't update MidiTime here...
    for i in range(len(chord)):
        ChordList.append([[0x90,chord[i],0], MidiTime + 1000 * i])
    MidiOut.Write(ChordList)
    print("Sending SysEx messages...")
    # sending with timestamp = 0 should be the same as sending with
    # timestamp = pypm.Time()
    dummy = raw_input("ready to send a SysEx string with timestamp = 0 ... (type RETURN):")
    MidiOut.WriteSysEx(0,'\xF0\x7D\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\xF7')
    dummy = raw_input("ready to send a SysEx list with timestamp = pypm.Time() ... (type RETURN):")
    MidiOut.WriteSysEx(pypm.Time(), [0xF0, 0x7D, 0x10, 0x11, 0x12, 0x13, 0xF7])
    dummy = raw_input("ready to close and terminate... (type RETURN):")
    del MidiOut

# main code begins here
pypm.Initialize() # always call this first, or OS may crash when you try to open a stream
x=0
while (x<1) | (x>3):
    print """
enter your choice...
1: test input
2: test output
3: Read Ascii Sysexs 
    """
    x=int(raw_input())
    if x==1: TestInput()
    if x==2: TestOutput()
    else: ReadSysex()
    pypm.Terminate()
