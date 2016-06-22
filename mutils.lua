--[[
# The MIT License (MIT)

# Copyright (c) 2014-2015 Joel Robichaud

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from math import log
import random
import re


class InvalidNoteException(Exception):
    pass

class InvalidChordException(Exception):
    pass

class InvalidScaleException(Exception):
    pass
	


--]]
--[[
    function table.slice(tbl, first, last, step)
      local sliced = {}
 
      for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
      end
 
      return sliced
    end	
--]]	
--def _list_rotate(list, n):
--    return list[n:] + list[:n]

function _list_rotate(tbl, n)
  local sliced = {}

  for i = n, #tbl do
    sliced[table.getn(sliced)+1] = tbl[i]
  end
  for i = 1, n do
    sliced[table.getn(sliced)+1] = tbl[i]
  end

  return sliced
end




def _midi_to_hertz(midi):
    return 2.0 ** ((midi - 69.0) / 12.0) * 440.0

def _hertz_to_midi(hertz):
    return int(69.0 + 12.0 * log(hertz / 440.0, 2))

--]]
--_NOTE_PATTERN    = re.compile(r"^(?P<name>[A-G])(?P<accidental>x|#|##|b|bb)?(?P<octave>-1|[0-9])$")
_NOTE_MAP        = {
    "C"= 0,
    "D"= 2,
    "E"= 4,
    "F"= 5,
    "G"= 7,
    "A"= 9,
    "B"= 11,
}
_REVERSE_NOTE_MAP = {
    0=   "C",
    1=  ("C#", "Db"),
    2=   "D",
    3=  ("D#", "Eb"),
    4=   "E",
    5=   "F",
    6=  ("F#", "Gb"),
    7=   "G",
    8=  ("G#", "Ab"),
    9=   "A",
    10= ("A#", "Bb"),
    11=  "B",
}
--[[
def _midi_to_note(midi):
    name = _REVERSE_NOTE_MAP[int(midi) % 12]
    octave = str(int(midi) / 12 - 1)
    if type(name) is tuple:
        return " / ".join(item[0] + octave  for item in name)
    else:
        return name + octave

def _note_to_midi(note):
    if isinstance(note, Note):
        note = note.note
    note = note.split(" / ")[0]

    match = _NOTE_PATTERN.match(note)
    if match:
        name = match.group("name")
        accidental = match.group("accidental")
        octave = match.group("octave")

        midi = 12 * (int(octave) + 1) + _NOTE_MAP[name.upper()]
        if accidental != None:
            if accidental == "#": midi += 1
            elif accidental == "##" or accidental == "x": midi += 2
            elif accidental == "b": midi -= 1
            elif accidental == "bb": midi -= 2
        return int(midi)
    else:
        raise InvalidNoteException()

class Note():
    def __init__(self, note):
        self._note = note

    @property
    def note(self):
        return self._note

class MidiNote(float, Note):
    def __new__(cls, note):
        t = type(note)

        if t is MidiNote:
            return note
        elif t is FreqNote:
            return float.__new__(cls, _hertz_to_midi(note))
        elif t is float:
            return float.__new__(cls, note)
        else:
            return float.__new__(cls, _note_to_midi(note))

    def __init__(self, note):
        Note.__init__(self, note)

class FreqNote(float, Note):
    def __new__(cls, note):
        t = type(note)

        if t is MidiNote:
            return float.__new__(cls, _midi_to_hertz(note))
        elif t is FreqNote:
            return note
        elif t is float:
            return float.__new__(cls, note)
        else:
            return float.__new__(cls, _midi_to_hertz(_note_to_midi(note)))

    def __init__(self, note):
        Note.__init__(self, note)

--]]

_IONIAN_SCALE     = {2,2,1,2,2,2,1}
_HEX_SCALE        = {2,2,1,2,2,3}
_PENTATONIC_SCALE = {3,2,2,3,2}
_SCALE_MAP        = {
    "diatonic"          = _IONIAN_SCALE,
    "ionian"            = _IONIAN_SCALE,
    "major"             = _IONIAN_SCALE,
    "dorian"            = _list_rotate(_IONIAN_SCALE, 1),
    "phrygian"          = _list_rotate(_IONIAN_SCALE, 2),
    "lydian"            = _list_rotate(_IONIAN_SCALE, 3),
    "mixolydian"        = _list_rotate(_IONIAN_SCALE, 4),
    "aeolian"           = _list_rotate(_IONIAN_SCALE, 5),
    "minor"             = _list_rotate(_IONIAN_SCALE, 5),
    "locrian"           = _list_rotate(_IONIAN_SCALE, 6),
    "hex-major6"        = _HEX_SCALE,
    "hex-dorian"        = _list_rotate(_HEX_SCALE, 1),
    "hex-phrygian"      = _list_rotate(_HEX_SCALE, 2),
    "hex-major7"        = _list_rotate(_HEX_SCALE, 3),
    "hex-sus"           = _list_rotate(_HEX_SCALE, 4),
    "hex-aeolian"       = _list_rotate(_HEX_SCALE, 5),
    "minor-pentatonic"  = _PENTATONIC_SCALE,
    "yu"                = _PENTATONIC_SCALE,
    "major-pentatonic"  = _list_rotate(_PENTATONIC_SCALE, 1),
    "gong"              = _list_rotate(_PENTATONIC_SCALE, 1),
    "egyptian"          = _list_rotate(_PENTATONIC_SCALE, 2),
    "shang"             = _list_rotate(_PENTATONIC_SCALE, 2),
    "jiao"              = _list_rotate(_PENTATONIC_SCALE, 3),
    "pentatonic"        = _list_rotate(_PENTATONIC_SCALE, 4),
    "zhi"               = _list_rotate(_PENTATONIC_SCALE, 4),
    "ritusen"           = _list_rotate(_PENTATONIC_SCALE, 4),
    "whole-tone"        = {2,2,2,2,2,2},
    "whole"             = {2,2,2,2,2,2},
    "chromatic"         = {1,1,1,1,1,1,1,1,1,1,1,1},
    "harmonic-minor"    = {2,1,2,2,1,3,1},
    "melodic-minor-asc" = {2,1,2,2,2,2,1},
    "hungarian-minor"   = {2,1,3,1,1,3,1},
    "octatonic"         = {2,1,2,1,2,1,2,1},
    "messiaen1"         = {2,2,2,2,2,2},
    "messiaen2"         = {1,2,1,2,1,2,1,2},
    "messiaen3"         = {2,1,1,2,1,1,2,1,1},
    "messiaen4"         = {1,1,3,1,1,1,3,1},
    "messiaen5"         = {1,4,1,1,4,1},
    "messiaen6"         = {2,2,1,1,2,2,1,1},
    "messiaen7"         = {1,1,1,2,1,1,1,1,2,1},
    "super-locrian"     = {1,2,1,2,2,2,2},
    "hirajoshi"         = {2,1,4,1,4},
    "kumoi"             = {2,1,4,2,3},
    "neapolitan-major"  = {1,2,2,2,2,2,1},
    "bartok"            = {2,2,1,2,1,2,2},
    "bhairav"           = {1,3,1,2,1,3,1},
    "locrian-major"     = {2,2,1,1,2,2,2},
    "ahirbhairav"       = {1,3,1,2,2,1,2},
    "enigmatic"         = {1,3,2,2,2,1,1},
    "neapolitan-minor"  = {1,2,2,2,1,3,1},
    "pelog"             = {1,2,4,1,4},
    "augmented2"        = {1,3,1,3,1,3},
    "scriabin"          = {1,3,3,2,3},
    "harmonic-major"    = {2,2,1,2,1,3,1},
    "melodic-minor-desc"= {2,1,2,2,1,2,2},
    "romanian-minor"    = {2,1,3,1,2,1,2},
    "hindu"             = {2,2,1,2,1,2,2},
    "iwato"             = {1,4,1,4,2},
    "melodic-minor"     = {2,1,2,2,2,2,1},
    "diminished2"       = {2,1,2,1,2,1,2,1},
    "marva"             = {1,3,2,1,2,2,1},
    "melodic-major"     = {2,2,1,2,1,2,2},
    "indian"            = {4,1,2,3,2},
    "spanish"           = {1,3,1,2,1,2,2},
    "prometheus"        = {2,2,2,5,1},
    "diminished"        = {1,2,1,2,1,2,1,2},
    "todi"              = {1,2,3,1,1,3,1},
    "leading-whole"     = {2,2,2,2,2,1,1},
    "augmented"         = {3,1,3,1,3,1},
    "purvi"             = {1,3,2,1,1,3,1},
    "chinese"           = {4,2,1,4,1},
    "lydian-minor"      = {2,2,2,1,1,2,2},
}
--[[
class Scale(list):
    def __new__(cls, root, scale, note_t=MidiNote):
        root = note_t(root)

        if scale in _SCALE_MAP:
            scale = _SCALE_MAP[scale]

        if isinstance(scale, list):
            obj = list.__new__(cls)
            obj.append(root)

            interval = 0
            for semitones in scale:
                interval += semitones
                obj.append(note_t(_midi_to_note(MidiNote(root) + interval)))

            return obj
        else:
            raise InvalidScaleException()

    def __init__(self, root, scale, note_t=MidiNote):
        self._root = root
        self._scale = scale

    @staticmethod
    def random(root, note_t=MidiNote):
        return Scale(root, random.choice(_SCALE_MAP.keys()), note_t)

    @property
    def root(self):
        return self._root

    @property
    def scale(self):
        return self._scale

--]]
_MAJOR_CHORD  = {0,4,7}
_MINOR_CHORD  = {0,3,7}
_MAJOR7_CHORD = {0,4,7,11}
_DOM7_CHORD   = {0,4,7,10}
_MINOR7_CHORD = {0,3,7,10}
_AUG_CHORD    = {0,4,8}
_DIM_CHORD    = {0,3,6}
_DIM7_CHORD   = {0,3,6,9}
_CHORD_MAP    = {
    "major"      = _MAJOR_CHORD,
    "M"          = _MAJOR_CHORD,
    "minor"      = _MINOR_CHORD,
    "m"          = _MINOR_CHORD,
    "major7"     = _MAJOR7_CHORD,
    "M7"         = _MAJOR7_CHORD,
    "dom7"       = _DOM7_CHORD,
    "7"          = _DOM7_CHORD,
    "minor7"     = _MINOR7_CHORD,
    "m7"         = _MINOR7_CHORD,
    "augmented"  = _AUG_CHORD,
    "aug"        = _AUG_CHORD,
    "a"          = _AUG_CHORD,
    "diminished" = _DIM_CHORD,
    "dim"        = _DIM_CHORD,
    "i"          = _DIM_CHORD,
    "diminished7"=  _DIM7_CHORD,
    "dim7"       = _DIM7_CHORD,
    "i7"         = _DIM7_CHORD,
    "1"          = {0},
    "5"          = {0,7},
    "+5"         = {0,4,8},
    "m+5"        = {0,3,8},
    "sus2"       = {0,2,7},
    "sus4"       = {0,5,7},
    "6"          = {0,4,7,9},
    "m6"         = {0,3,7,9},
    "7sus2"      = {0,2,7,10},
    "7sus4"      = {0,5,7,10},
    "7-5"        = {0,4,6,10},
    "m7-5"       = {0,3,6,10},
    "7+5"        = {0,4,8,10},
    "m7+5"       = {0,3,8,10},
    "9"          = {0,4,7,10,14},
    "m9"         = {0,3,7,10,14},
    "m7+9"       = {0,3,7,10,14},
    "maj9"       = {0,4,7,11,14},
    "9sus4"      = {0,5,7,10,14},
    "6*9"        = {0,4,7,9,14},
    "m6*9"       = {0,3,9,7,14},
    "7-9"        = {0,4,7,10,13},
    "m7-9"       = {0,3,7,10,13},
    "7-10"       = {0,4,7,10,15},
    "9+5"        = {0,10,13},
    "m9+5"       = {0,10,14},
    "7+5-9"      = {0,4,8,10,13},
    "m7+5-9"     = {0,3,8,10,13},
    "11"         = {0,4,7,10,14,17},
    "m11"        = {0,3,7,10,14,17},
    "maj11"      = {0,4,7,11,14,17},
    "11+"        = {0,4,7,10,14,18},
    "m11+"       = {0,3,7,10,14,18},
    "13"         = {0,4,7,10,14,17,21},
    "m13"        = {0,3,7,10,14,17,21},
}
--[[ 
class Chord(list):
    def __new__(cls, root, chord, note_t=MidiNote):
        root = note_t(root)

        if chord in _CHORD_MAP:
            chord = _CHORD_MAP[chord]

        if isinstance(chord, list):
            obj = list.__new__(cls)
            obj.extend([note_t(_midi_to_note(MidiNote(root) + interval)) for interval in chord])
            return obj
        else:
            raise InvalidChordException()

    def __init__(self, root, chord, note_t=MidiNote):
        self._root = root
        self._chord = chord

    @staticmethod
    def random(root, note_t=MidiNote):
        return Chord(root, random.choice(_CHORD_MAP.keys()), note_t)

    @property
    def root(self):
        return self._root

    @property
    def chord(self):
        return self._chord
--]]