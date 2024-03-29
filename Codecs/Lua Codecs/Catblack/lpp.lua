-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Launchpad Pro Lua Codec and Remote Map
-- by Catblack@gmail.com
--
-- Please paypal me $20 if you like this!
-- 
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--	The Launchpad has 64 pads, in chromatic mode I'm starting it at C2 (note 24) and going to E7 (note 88)
--	leaving 2 octives down (24 down transpose) and 3 octives up (39 up transpose) G10 (127) is the highest, C0 (0) the lowest
-- 
-- Oct up/dn may be impl as shifted item of transpose button.
-- Different scales may go higher, but starting on 24 is probably best. 

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Set some variables

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--keep track of what's on in case mode, scale or transpose changes
Playing={}

-- keep track of buttons (for handoff between RPM and RDM
Pressed={}

-- Itemnum is the array set in remote_init for knowing what the item number is
-- when we need it for remote.handle_input
Itemnum={}

-- set in def_vars func after items are in remote.init(), used everywhere.
Pad={} -- x and y
Padindex={} -- 1 to 64

-- del, used in redrum right now
do_update_pads = 1
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--Not sure...
PitchBend={}

Modulation={}


-- putting things into state so I can dump it for debug
g={}
g.accent = 0
g.last_accent = 0
g.accent_dn = false
g.accent_count = 0

-- These are set in remote_on_auto_input() 
--g.last_input_time = 0
--g.last_input_item = nil



-- del from kong section	
global_scale = 0
global_transp = 0
scale_from_parse = false



--FOR REDRUM BLINKING LIGHTS
g.step_value = { 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 }
g.step_is_playing = { 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 }
-- FL: Add state for the latest LED/Pad MIDI messages sent
g.last_led_output = { 100,100,100,100, 100,100,100,100, 100,100,100,100, 100,100,100,100, 100,100,100,100, 100,100,100,100 }

noscaleneeded = false
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- all sysex msg vars use table.concat
sysex_header = "F0 00 20 29 02 10 "
sysex_setrgb = sysex_header.."0B" -- pad r g b
sysex_setled = sysex_header.."0A" -- pad color0-127
sysex_setrgbgrid = sysex_header.."15" -- 0=10x10;1=8x8 color0-127
sysex_scrolltext = sysex_header.."14" -- color0-127 loop1or0 asciitext
sysex_flashled = sysex_header.."23" -- pad color0-127
sysex_pulseled = sysex_header.."28" -- pad color0-127
sysend ="F7"
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Variable defs
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Black, white, puerto rican, everybody's just a freakin
-- white,yel,red,green
-- see function map_redrum_led(v)
pclr={}
pclr[0]=0
pclr[1]=3
pclr[2]=13
pclr[3]=5
pclr[4]=21



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- TODO piano keyboard white/black palettes
-- TODO more palettes
Palettes = {
		FifthsCircle = {
						[0]= {R="3F", G="00", B="00", },	--R  
						[1]= {R="00", G="32", B="15", },	--BG 
						[2]= {R="3F", G="09", B="00", },	--O  
						[3]= {R="09", G="00", B="36", },	--BV 
						[4]= {R="3F", G="3F", B="00", },	--Y  
						[5]= {R="29", G="00", B="20", },	--RV 
						[6]= {R="00", G="3F", B="00", },	--G  
						[7]= {R="1F", G="02", B="01", },	--RO 
						[8]= {R="00", G="00", B="3F", },	--B  
						[9]= {R="19", G="09", B="00", },	--YO 
						[10]={R="12", G="00", B="2D", },	--V  
						[11]={R="21", G="3F", B="00", },	--YG 
		},
		louisBertrandCastel = {
						[0]= {R="07", G="03", B="20", },		 -- blue
						[1]= {R="06", G="24", B="20", },		 -- blue-green
						[2]= {R="05", G="24", B="0C", },		 -- green
						[3]= {R="1C", G="24", B="09", },		 -- olive green
						[4]= {R="3D", G="3D", B="0F", },		 -- yellow
						[5]= {R="3D", G="34", B="0E", },		 -- yellow-orange
						[6]= {R="3E", G="20", B="04", },		 -- orange
						[7]= {R="3E", G="02", B="03", },		 -- red
						[8]= {R="28", G="03", B="02", },		 -- crimson
						[9]= {R="35", G="04", B="21", },		 -- violet
						[10]={R="12", G="03", B="1F", },		 -- agate
						[11]={R="1F", G="02", B="1F", },		 -- indigo
		},
		dDJameson = {
						[0]= {R="3E", G="02", B="03", },		 -- red
						[1]= {R="3D", G="11", B="04", },		 -- red-orange
						[2]= {R="3E", G="20", B="04", },		 -- orange
						[3]= {R="3D", G="34", B="0E", },		 -- orange-yellow
						[4]= {R="3D", G="3D", B="0F", },		 -- yellow
						[5]= {R="05", G="24", B="0C", },		 -- green
						[6]= {R="06", G="24", B="20", },		 -- green-blue
						[7]= {R="07", G="03", B="20", },		 -- blue
						[8]= {R="12", G="03", B="1F", },		 -- blue-purple
						[9]= {R="1F", G="02", B="1F", },		 -- purple
						[10]={R="29", G="05", B="21", },		 -- purple-violet
						[11]={R="35", G="04", B="21", },		 -- violet
		},
		theodorSeemann = {
						[0]= {R="1A", G="07", B="07", },		 -- carmine
						[1]= {R="3E", G="02", B="03", },		 -- scarlet
						[2]= {R="3F", G="1F", B="01", },		 -- orange
						[3]= {R="3F", G="35", B="0C", },		 -- yellow-orange
						[4]= {R="3D", G="3D", B="0F", },		 -- yellow
						[5]= {R="05", G="24", B="0D", },		 -- green
						[6]= {R="06", G="24", B="20", },		 -- green blue
						[7]= {R="07", G="03", B="20", },		 -- blue
						[8]= {R="1F", G="02", B="1F", },		 -- indigo
						[9]= {R="35", G="04", B="21", },		 -- violet
						[10]={R="1A", G="07", B="07", },		 -- brown
						[11]={R="04", G="04", B="04", },		 -- black
		},
		aWallaceRimington = {
						[0]= {R="3E", G="02", B="03", },		 -- deep red
						[1]= {R="28", G="03", B="02", },		 -- crimson
						[2]= {R="3D", G="11", B="04", },		 -- orange-crimson
						[3]= {R="3E", G="20", B="04", },		 -- orange
						[4]= {R="3D", G="3D", B="0F", },		 -- yellow
						[5]= {R="1C", G="24", B="09", },		 -- yellow-green
						[6]= {R="05", G="24", B="0C", },		 -- green
						[7]= {R="09", G="29", B="20", },		 -- blueish green
						[8]= {R="06", G="24", B="20", },		 -- blue-green
						[9]= {R="1F", G="02", B="1F", },		 -- indigo
						[10]={R="07", G="03", B="20", },		 -- deep blue
						[11]={R="35", G="04", B="21", },		 -- violet
		},
		hHelmholtz = {
						[0]= {R="3D", G="3D", B="0F", },		 -- yellow
						[1]= {R="05", G="24", B="0C", },		 -- green
						[2]= {R="06", G="24", B="20", },		 -- greenish blue
						[3]= {R="07", G="16", B="28", },		 -- cayan-blue
						[4]= {R="1F", G="02", B="1F", },		 -- indigo blue
						[5]= {R="35", G="04", B="21", },		 -- violet
						[6]= {R="27", G="03", B="15", },		 -- end of red
						[7]= {R="3E", G="02", B="03", },		 -- red
						[8]= {R="34", G="0B", B="02", },		 -- red
						[9]= {R="34", G="0B", B="02", },		 -- red
						[10]={R="36", G="06", B="14", },		 -- red orange
						[11]={R="3C", G="1E", B="03", },		 -- orange
		},
		aScriabin = {
						[0]= {R="3E", G="02", B="03", },		 -- red
						[1]= {R="35", G="04", B="21", },		 -- violet
						[2]= {R="3D", G="3D", B="0F", },		 -- yellow
						[3]= {R="16", G="15", B="21", },		 -- steely with the glint of metal
						[4]= {R="07", G="16", B="28", },		 -- pearly blue the shimmer of moonshine
						[5]= {R="28", G="03", B="02", },		 -- dark red
						[6]= {R="07", G="03", B="20", },		 -- bright blue
						[7]= {R="3E", G="20", B="04", },		 -- rosy orange
						[8]= {R="1F", G="02", B="1F", },		 -- purple
						[9]= {R="05", G="24", B="0C", },		 -- green
						[10]={R="16", G="15", B="21", },		 -- steely with a glint of metal
						[11]={R="07", G="16", B="28", },		 -- pearly blue the shimmer of moonshine
		},
		aBernardKlein = {
						[0]= {R="31", G="02", B="02", },		 -- dark red
						[1]= {R="3E", G="02", B="03", },		 -- red
						[2]= {R="3D", G="11", B="04", },		 -- red orange
						[3]= {R="3E", G="20", B="04", },		 -- orange
						[4]= {R="3D", G="3D", B="0F", },		 -- yellow
						[5]= {R="2F", G="38", B="0E", },		 -- yellow green
						[6]= {R="05", G="24", B="0C", },		 -- green
						[7]= {R="06", G="24", B="20", },		 -- blue-green
						[8]= {R="07", G="03", B="20", },		 -- blue
						[9]= {R="1E", G="06", B="21", },		 -- blue violet
						[10]={R="35", G="04", B="21", },		 -- violet
						[11]={R="27", G="03", B="15", },		 -- dark violet
		},
		iJBelmont = {
						[0]= {R="3E", G="02", B="03", },		 -- red
						[1]= {R="3D", G="11", B="04", },		 -- red-orange
						[2]= {R="3E", G="20", B="04", },		 -- orange
						[3]= {R="3D", G="34", B="04", },		 -- yellow-orange
						[4]= {R="3D", G="3D", B="0F", },		 -- yellow
						[5]= {R="2F", G="38", B="0E", },		 -- yellow-green
						[6]= {R="04", G="23", B="0C", },		 -- green
						[7]= {R="06", G="24", B="20", },		 -- blue-green
						[8]= {R="07", G="03", B="20", },		 -- blue
						[9]= {R="29", G="05", B="21", },		 -- blue-violet
						[10]={R="35", G="04", B="21", },		 -- violet
						[11]={R="2B", G="03", B="12", },		 -- red-violet
		},
		sZieverink = {
						[0]= {R="2F", G="38", B="0E", },		 -- yellow/green
						[1]= {R="05", G="24", B="0C", },		 -- green
						[2]= {R="06", G="24", B="20", },		 -- blue/green
						[3]= {R="07", G="03", B="20", },		 -- blue
						[4]= {R="1F", G="02", B="1F", },		 -- indigo
						[5]= {R="35", G="04", B="21", },		 -- violet
						[6]= {R="1B", G="03", B="11", },		 -- ultra violet
						[7]= {R="28", G="03", B="02", },		 -- infra red
						[8]= {R="3E", G="02", B="03", },		 -- red
						[9]= {R="3E", G="20", B="04", },		 -- orange
						[10]={R="3B", G="3C", B="21", },		 -- yellow/white
						[11]={R="3D", G="3D", B="0F", },		 -- yellow
		},
		Chromatic = {
						[0]= {R="3F", G="00", B="00", },	--R  
						[1]= {R="1F", G="02", B="01", },	--RO 
						[2]= {R="3F", G="09", B="00", },	--O  
						[3]= {R="19", G="09", B="00", },	--YO 
						[4]= {R="3F", G="3F", B="00", },	--Y  
						[5]= {R="21", G="3F", B="00", },	--YG 
						[6]= {R="00", G="3F", B="00", },	--G  
						[7]= {R="00", G="32", B="15", },	--BG 
						[8]= {R="00", G="00", B="3F", },	--B  
						[9]= {R="09", G="00", B="36", },	--BV 
						[10]={R="12", G="00", B="2D", },	--V  
						[11]={R="29", G="00", B="20", },	--RV 
		},
	}
Palettenames = {
'FifthsCircle',
'louisBertrandCastel',
'dDJameson',
'theodorSeemann',
'aWallaceRimington',
'hHelmholtz',
'aScriabin',
'aBernardKlein',
'iJBelmont',
'sZieverink',
'Chromatic',
}


-- Setting these two until I clean out the old code.


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Scales tbd
-- TODO fix and reorder them
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- From Livid
scales = {
	Chromatic = {0,1,2,3,4,5,6,7,8,9,10,11},
	DrumPad = {0,1,2,3, 16,17,18,19, 4,5,6,7, 20,21,22,23, 8,9,10,11, 24,25,26,27, 12,13,14,15, 28,29,30,31},
	Major = {0,2,4,5,7,9,11},
	Minor = {0,2,3,5,7,8,10},
	Dorian = {0,2,3,5,7,9,10},
	Mixolydian = {0,2,4,5,7,9,10},
	Lydian = {0,2,4,6,7,9,11},
	Phrygian = {0,1,3,5,7,8,10},
	Locrian = {0,1,3,4,7,8,10},
	Diminished = {0,1,3,4,6,7,9,10},
	Whole_half = {0,2,3,5,6,8,9,11},
	WholeTone = {0,2,4,6,8,10},
	MinorBlues = {0,3,5,6,7,10},
	MinorPentatonic = {0,3,5,7,10},
	MajorPentatonic = {0,2,4,7,9},
	HarmonicMinor = {0,2,3,5,7,8,11},
	MelodicMinor = {0,2,3,5,7,9,11},
	DominantSus = {0,2,5,7,9,10},
	SuperLocrian = {0,1,3,4,6,8,10},
	NeopolitanMinor = {0,1,3,5,7,8,11},
	NeopolitanMajor = {0,1,3,5,7,9,11},
	EnigmaticMinor = {0,1,3,6,7,10,11},
	Enigmatic = {0,1,4,6,8,10,11},
	Composite = {0,1,4,6,7,8,11},
	BebopLocrian = {0,2,3,5,6,8,10,11},
	BebopDominant = {0,2,4,5,7,9,10,11},
	BebopMajor = {0,2,4,5,7,8,9,11},
	Bhairav = {0,1,4,5,7,8,11},
	HungarianMinor = {0,2,3,6,7,8,11},
	MinorGypsy = {0,1,4,5,7,8,10},
	Persian = {0,1,4,5,6,8,11},  
	Hirojoshi = {0,2,3,7,8},
	InSen = {0,1,5,7,10},
	Iwato = {0,1,5,6,10},
	Kumoi = {0,2,3,7,9},
	Pelog = {0,1,3,4,7,8},
	Spanish = {0,1,3,4,5,6,8,10},
	CircleOfFifths ={0,7,2,9,4,11,6,1,8,3,10,5}
}
scalenames = {
			'Chromatic',
			'DrumPad','Major','Minor','Dorian','Mixolydian', 
			'Lydian','Phrygian', 
			'Locrian','Diminished','Whole_half','WholeTone','MinorBlues','MinorPentatonic','MajorPentatonic','HarmonicMinor','MelodicMinor','DominantSus','SuperLocrian','NeopolitanMinor','NeopolitanMajor','EnigmaticMinor','Enigmatic','Composite','BebopLocrian','BebopDominant','BebopMajor','Bhairav','HungarianMinor','MinorGypsy','Persian','Hirojoshi','InSen','Iwato','Kumoi','Pelog','Spanish',
			'CircleOfFifths'
			}
scaleabrvs = {
			Session='SS',Auto='AA',Chromatic='CH',DrumPad='DR',Major='MM',Minor='nn',Dorian='II',Mixolydian='V_',
			Lydian='IV',Phrygian='IH',Locrian='VH',Diminished='d-',Wholehalf='Wh',WholeTone='WT',MinorBlues='mB',
			MinorPentatonic='mP',MajorPentatonic='MP',HarmonicMinor='mH',MelodicMinor='mM',DominantSus='Ds',SuperLocrian='SL',
			NeopolitanMinor='mN',NeopolitanMajor='MN',EnigmaticMinor='mE',Enigmatic='ME',Composite='Cp',BebopLocrian='lB',
			BebopDominant='DB',BebopMajor='MB',Bhairav='Bv',HungarianMinor='mH',MinorGypsy='mG',Persian='Pr',
			Hirojoshi='Hr',InSen='IS',Iwato='Iw',Kumoi='Km',Pelog='Pg',Spanish='Sp',CircleOfFifths='C5'
			}
			

-- These from j74 ISO Controllers
Scales = {
Major = {0,2,4,5,7,9,11,12},
Dorian = {0,2,3,5,7,9,10,12},
Minor_Blues = {0,3,5,6,7,10,12,15},
Minor_Jipsy = {0,1,4,5,7,8,10,12},
Minor = {0,2,3,5,7,8,10,12},
Mixolydian = {0,2,4,5,7,9,10,12},
Lydian = {0,2,4,6,7,9,11,12},
Phrygian = {0,1,3,5,7,8,10,12},
Locrian = {0,1,3,5,6,8,10,12},
Diminished = {0,2,3,5,6,8,9,12},
Whole_half = {0,2,3,5,6,8,9,12},
Whole_tone = {0,2,4,6,8,10,12,12},
Minor_Pentatonic = {0,3,5,7,10,12,15,17},
Major_Pentatonic = {0,2,4,7,9,12,14,16},
Harmonic_Minor = {0,2,3,5,7,8,11,12},
Melodic_Minor = {0,2,3,5,7,9,11,12},
Super_Locrian = {0,1,3,4,6,8,10,12},
Bhairav = {0,1,4,5,7,8,11,12},
Hungarian_Minor = {0,2,3,6,7,8,11,12},
Hirojoshi = {0,2,3,7,8,12,14,15},
In_Sen = {0,1,5,7,10,12,13,17},
Iwato = {0,1,5,6,10,12,13,17},
Kumoi = {0,2,3,7,9,12,14,15},
Pelog = {0,1,3,6,10,11,12,13},
Spanish = {0,1,3,4,5,6,8,12},
Zirafkend = {0,2,3,5,7,8,9,12},
Algerian = {0,2,3,5,6,7,8,12},
Pneutral = {0,2,5,7,10,12,14,17},
Augmented = {0,3,4,7,8,11,12,15},
Enigmatic = {0,1,4,6,8,10,11,12},
LydianAug = {0,2,4,6,8,9,11,12},
NeopMaj = {0,1,3,5,7,9,11,12},
NeopMin = {0,1,3,5,7,8,10,12},
Prometheus = {0,2,4,6,9,10,12,14},
PromNeop = {0,1,4,6,9,10,12,13},
SixToneSym = {0,1,4,5,8,9,12,13},
LydianMin = {0,2,4,6,7,8,10,12},
LydianDim = {0,2,3,6,7,8,10,12},
NineTone = {0,2,3,4,6,7,8,12},
Overtone = {0,2,4,6,7,9,10,12}
}			
			

Scalenames = {'Major','Dorian','Minor_Blues','Minor_Jipsy','Minor','Mixolydian','Lydian','Phrygian','Locrian','Diminished','Whole_half','Whole_tone','Minor_Pentatonic','Major_Pentatonic','Harmonic_Minor','Melodic_Minor','Super_Locrian','Bhairav','Hungarian_Minor','Hirojoshi','In_Sen','Iwato','Kumoi','Pelog','Spanish','Zirafkend','Algerian','Pneutral','Augmented','Enigmatic','LydianAug','NeopMaj','NeopMin','Prometheus','PromNeop','SixToneSym','LydianMin','LydianDim','NineTone','Overtone'}
Scaleabrvs = scaleabrvs


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- if the mode depends on a scale, then note is a function 
-- and oct will get written by the note function
-- and the scale grid will be embedded in the function.
-- scalegrid based on pos in Scale table (normalized for 0-11, oct generated.)
-- note 0-11 note output with matching oct
Modes = {
CircleOfFifths = {
		color= {R="3F", G="00", B="00", },	--R

		note={
			{8,3,10,5,0,7,2,9},
			{0,7,2,9,4,11,6,1},
			{4,11,6,1,8,3,10,5},
			{8,3,10,5,0,7,2,9},
			{0,7,2,9,4,11,6,1},
			{4,11,6,1,8,3,10,5},
			{8,3,10,5,0,7,2,9},
			{0,7,2,9,4,11,6,1},
		},
		oct={
			{5,5,5,5,6,6,6,6},
			{5,5,5,5,5,5,5,5},
			{4,4,4,4,4,4,4,4},
			{3,3,3,3,4,4,4,4},
			{3,3,3,3,3,3,3,3},
			{2,2,2,2,2,2,2,2},
			{1,1,1,1,2,2,2,2},
			{1,1,1,1,1,1,1,1},
		},
	},
LPP_Note_mode =	{
		color= {R="3F", G="00", B="00", },	--R
		note={
			{11,0,1,2,3,4,5,6},
			{6,7,8,9,10,11,0,2},
			{1,2,3,4,5,6,7,8},
			{8,9,10,11,0,1,2,3},
			{3,4,5,6,7,8,9,10},
			{10,11,0,1,2,3,4,5},
			{5,6,7,8,9,10,11,0},
			{0,1,2,3,4,5,6,7},
		},
		oct={
			{3,4,4,4,4,4,4,4},
			{3,3,3,3,3,3,4,4},
			{3,3,3,3,3,3,3,3},
			{2,2,2,2,3,3,3,3},
			{2,2,2,2,2,2,2,2},
			{1,1,2,2,2,2,2,2},
			{1,1,1,1,1,1,1,2},
			{1,1,1,1,1,1,1,1},
		},
	},
--[[
Harmonic =	{ --http://hotchk155.blogspot.com/2010/01/poor-mans-harmonic-keyboard.html
		color= {R="3F", G="00", B="00", },	--R
		note={
			{1,10,2,11,3,0,4,1},
			{6,3,7,4,8,5,9,6},
			{11,8,0,9,1,10,2,11},
			{4,1,5,2,6,3,7,4},
			{9,6,10,7,11,8,0,9},
			{2,11,3,0,4,1,5,2},
			{7,4,8,5,9,6,10,7},
			{0,9,1,10,2,11,3,0},
		},
		oct={
			{5,4,5,4,5,5,5,5},
			{4,4,4,4,4,4,4,4},
			{3,3,4,3,4,3,4,3},
			{3,3,3,3,3,3,3,3},
			{2,2,2,2,2,2,3,2},
			{2,1,2,2,2,2,2,2},
			{1,1,1,1,1,1,1,1},
			{1,0,1,0,1,0,1,1},
		},
	},
--]]
Push = {
		color= {R="00", G="00", B="3F", },	--B  
		oct={
			{4,4,4,4,4,4,4,5},
			{3,3,3,4,4,4,4,4},
			{3,3,3,3,3,3,4,4},
			{2,2,3,3,3,3,3,3},
			{2,2,2,2,2,3,3,3},
			{1,2,2,2,2,2,2,2},
			{1,1,1,1,2,2,2,2},
			{1,1,1,1,1,1,1,2},
		},
		note=function(n)
			local octgrid={
				{4,4,4,4,4,4,4,5},
				{3,3,3,4,4,4,4,4},
				{3,3,3,3,3,3,4,4},
				{2,2,3,3,3,3,3,3},
				{2,2,2,2,2,3,3,3},
				{1,2,2,2,2,2,2,2},
				{1,1,1,1,2,2,2,2},
				{1,1,1,1,1,1,1,2},
			}
			local scalegrid ={
				{1,2,3,4,5,6,7,1},
				{5,6,7,1,2,3,4,5},
				{2,3,4,5,6,7,1,2},
				{6,7,1,2,3,4,5,6},
				{3,4,5,6,7,1,2,3},
				{7,1,2,3,4,5,6,7},
				{4,5,6,7,1,2,3,4},
				{1,2,3,4,5,6,7,1},
			}
			local notegrid={{},{},{},{},{},{},{},{}}
--vprint("in Push aka ... ",Modenames[n])
			for ve=1,8 do for ho=1,8 do
				local note =Scale.current[scalegrid[ve][ho]]
				if  note > 11 then
					notegrid[ve][ho]=note-12
					octgrid[ve][ho]=octgrid[ve][ho]+1
				else
					notegrid[ve][ho]=note
					octgrid[ve][ho]=octgrid[ve][ho]
				end	
			end end
			Modes[Modenames[n]].oct=octgrid
--grprint("in Push oct ..",Modes[Modenames[n]].oct)			
--grprint("in Push note ..",notegrid)			
			return notegrid
		end,
	},
Diatonic = {
		color= {R="00", G="00", B="3F", },	--B  
		oct={
			{4,4,4,4,4,4,4,5},
			{3,3,4,4,4,4,4,4},
			{3,3,3,3,4,4,4,4},
			{3,3,3,3,3,3,4,4},
			{2,3,3,3,3,3,3,3},
			{2,2,2,3,3,3,3,3},
			{2,2,2,2,2,3,3,3},
			{2,2,2,2,2,2,2,3},
		},
		note=function(n)
		local octgrid={
			{4,4,4,4,4,4,4,5},
			{3,3,4,4,4,4,4,4},
			{3,3,3,3,4,4,4,4},
			{3,3,3,3,3,3,4,4},
			{2,3,3,3,3,3,3,3},
			{2,2,2,3,3,3,3,3},
			{2,2,2,2,2,3,3,3},
			{2,2,2,2,2,2,2,3},
		}
		local scalegrid ={
			{1,2,3,4,5,6,7,1},
			{6,7,1,2,3,4,5,6},
			{4,5,6,7,1,2,3,4},
			{2,3,4,5,6,7,1,2},
			{7,1,2,3,4,5,6,7},
			{5,6,7,1,2,3,4,5},
			{3,4,5,6,7,1,2,3},
			{1,2,3,4,5,6,7,1},
		}
		local notegrid={{},{},{},{},{},{},{},{}}
--vprint("in Diatonic aka ... ",Modenames[n])
		for ve=1,8 do for ho=1,8 do
				local note =Scale.current[scalegrid[ve][ho]]
				if  note > 11 then
					notegrid[ve][ho]=note-12
					octgrid[ve][ho]=octgrid[ve][ho]+1
				else
					notegrid[ve][ho]=note
					octgrid[ve][ho]=octgrid[ve][ho]
				end	
			end end
			Modes[Modenames[n]].oct=octgrid
--grprint("in Diatonic oct ..",Modes[Modenames[n]].oct)			
--grprint("in Diatonic note ..",notegrid)			
			return notegrid
		end,
	},
Diagonal = {
		color= {R="00", G="00", B="3F", },	--B  
		oct={
			{3,3,3,3,3,3,3,4},
			{2,3,3,3,3,3,3,3},
			{2,2,3,3,3,3,3,3},
			{2,2,2,3,3,3,3,3},
			{2,2,2,2,3,3,3,3},
			{2,2,2,2,2,3,3,3},
			{2,2,2,2,2,2,3,3},
			{2,2,2,2,2,2,2,3},
		},
		note=function(n)
		octgrid={
			{3,3,3,3,3,3,3,4},
			{2,3,3,3,3,3,3,3},
			{2,2,3,3,3,3,3,3},
			{2,2,2,3,3,3,3,3},
			{2,2,2,2,3,3,3,3},
			{2,2,2,2,2,3,3,3},
			{2,2,2,2,2,2,3,3},
			{2,2,2,2,2,2,2,3},
		}
		local scalegrid ={
			{1,2,3,4,5,6,7,1},
			{7,1,2,3,4,5,6,7},
			{6,7,1,2,3,4,5,6},
			{5,6,7,1,2,3,4,5},
			{4,5,6,7,1,2,3,4},
			{3,4,5,6,7,1,2,3},
			{2,3,4,5,6,7,1,2},
			{1,2,3,4,5,6,7,1},
		}
		local notegrid={{},{},{},{},{},{},{},{}}
		for ve=1,8 do for ho=1,8 do
				local note =Scale.current[scalegrid[ve][ho]]
				if  note > 11 then
					notegrid[ve][ho]=note-12
					octgrid[ve][ho]=octgrid[ve][ho]+1
				else
					notegrid[ve][ho]=note
					octgrid[ve][ho]=octgrid[ve][ho]
				end	
			end end
			Modes[Modenames[n]].oct=octgrid
--grprint("in Diag oct ..",Modes[Modenames[n]].oct)			
--grprint("in Diag note ..",notegrid)			
		return notegrid
		end,
	},
Octave = {
		color= {R="00", G="00", B="3F", },	--B  
		oct={{},{},{},{},{},{},{},{}},
		note=function(n)
		local scalegrid ={
			{1,2,3,4,5,6,7,8},
			{1,2,3,4,5,6,7,8},
			{1,2,3,4,5,6,7,8},
			{1,2,3,4,5,6,7,8},
			{1,2,3,4,5,6,7,8},
			{1,2,3,4,5,6,7,8},
			{1,2,3,4,5,6,7,8},
			{1,2,3,4,5,6,7,8},
		}
		local notegrid={{},{},{},{},{},{},{},{}}
		local octgrid={{},{},{},{},{},{},{},{}}
		for ve=1,8 do for ho=1,8 do
			local note =Scale.current[scalegrid[ve][ho]]
			if  note > 11 then
				notegrid[ve][ho]=note-12
				octgrid[ve][ho]=(8-ve)+1
--Modes[Modenames[n]].oct[ve][ho]=ve-1
			else
				notegrid[ve][ho]=note
				octgrid[ve][ho]=8-ve
--Modes[Modenames[n]].oct[ve][ho]=ve
			end	
		end end
		Modes[Modenames[n]].oct=octgrid
		return notegrid
		end,
	},
Chromatic = {
		color= {R="3F", G="00", B="00", },	--R
		note={
			{8,9,10,11,0,1,2,3},
			{0,1,2,3,4,5,6,7},
			{4,5,6,7,8,9,10,11},
			{8,9,10,11,0,1,2,3},
			{0,1,2,3,4,5,6,7},
			{4,5,6,7,8,9,10,11},
			{8,9,10,11,0,1,2,3},
			{0,1,2,3,4,5,6,7},
		},
		oct={
			{5,5,5,5,6,6,6,6},
			{5,5,5,5,5,5,5,5},
			{4,4,4,4,4,4,4,4},
			{3,3,3,3,4,4,4,4},
			{3,3,3,3,3,3,3,3},
			{2,2,2,2,2,2,2,2},
			{1,1,1,1,2,2,2,2},
			{1,1,1,1,1,1,1,1},
		},
		xnote=function(n)
		local notegrid={{},{},{},{},{},{},{},{}}
		local index=0
		local scale=Scale.current
		local sc_len
		local root
			if scale[8] == 12 then -- 7 and below
				sc_len=7
				root = 12 
			elseif scale[7] == 12 then 
				sc_len=6
				root = 0 
			elseif scale[6] == 12 then -- 2 root notes
				table.insert(scale,1,0)
				scale_len = 6
				root = 0 
			else
				root = 24 
			end  
		
		for ve=1,8 do for ho=1,8 do
--vprint("sc cur sc in grid Chromatic",Scale.current[1+scalegrid[ve][ho]])
			local oct = math.floor(index/sc_len)
			local note = scale[1+modulo(index,sc_len)]
		Modes[Modenames[n]].oct[ve][ho]=oct
		notegrid[ve][ho]=note
		end end
		return notegrid
		end,
		
	},
Chromatic2 = {
		color= {R="00", G="00", B="3F", },	--B  
		oldnote={
			{8,9,10,11,0,1,2,3},
			{0,1,2,3,4,5,6,7},
			{4,5,6,7,8,9,10,11},
			{8,9,10,11,0,1,2,3},
			{0,1,2,3,4,5,6,7},
			{4,5,6,7,8,9,10,11},
			{8,9,10,11,0,1,2,3},
			{0,1,2,3,4,5,6,7},
		},
		oct={
			{5,5,5,5,6,6,6,6},
			{5,5,5,5,5,5,5,5},
			{4,4,4,4,4,4,4,4},
			{3,3,3,3,4,4,4,4},
			{3,3,3,3,3,3,3,3},
			{2,2,2,2,2,2,2,2},
			{1,1,1,1,2,2,2,2},
			{1,1,1,1,1,1,1,1},
		},
		note=function(n)
		local scalegrid ={
			{0,1,2,3,4,5,6,0},
			{0,1,2,3,4,5,6,0},
			{0,1,2,3,4,5,6,0},
			{0,1,2,3,4,5,6,0},
			{0,1,2,3,4,5,6,0},
			{0,1,2,3,4,5,6,0},
			{0,1,2,3,4,5,6,0},
			{0,1,2,3,4,5,6,0},
		}
		local notegrid={{},{},{},{},{},{},{},{}}
		for ve=1,8 do for ho=1,8 do
--vprint("sc cur sc in grid Chromatic2",Scale.current[1+scalegrid[ve][ho]])
		notegrid[ve][ho]=Scale.current[1+scalegrid[ve][ho]]
		end end
		return notegrid
		end,
	},
--TODO	
-- Scaleharp starts on the first row with a scale of 8
-- the next row up adds 1, etc
-- oct is note > 11 or modulo?
ScaleHarp =	{
		color= {R="00", G="00", B="3F", },	--B  
		note={
			{7,9,11,1,3,5,7,9},
			{6,8,10,0,2,4,6,8},
			{5,7,9,11,1,3,5,7},
			{4,6,8,10,0,2,4,6},
			{3,5,7,9,11,1,3,5},
			{2,4,6,8,10,0,2,4},
			{1,3,5,7,9,11,1,3},
			{0,2,4,6,8,10,0,2},
		},
		oct={
			{4,4,4,5,5,5,5,5},
			{4,4,4,5,5,5,5,5},
			{3,3,3,3,4,4,4,4},
			{3,3,3,3,4,4,4,4},
			{2,2,2,2,2,3,3,3},
			{2,2,2,2,2,3,3,3},
			{1,1,1,1,1,1,2,2},
			{1,1,1,1,1,1,2,2},
		},
	},
ChromaHarp =	{
		color= {R="00", G="00", B="3F", },	--B  
		note={
			{7,9,11,1,3,5,7,9},
			{6,8,10,0,2,4,6,8},
			{5,7,9,11,1,3,5,7},
			{4,6,8,10,0,2,4,6},
			{3,5,7,9,11,1,3,5},
			{2,4,6,8,10,0,2,4},
			{1,3,5,7,9,11,1,3},
			{0,2,4,6,8,10,0,2},
		},
		oct={
			{4,4,4,5,5,5,5,5},
			{4,4,4,5,5,5,5,5},
			{3,3,3,3,4,4,4,4},
			{3,3,3,3,4,4,4,4},
			{2,2,2,2,2,3,3,3},
			{2,2,2,2,2,3,3,3},
			{1,1,1,1,1,1,2,2},
			{1,1,1,1,1,1,2,2},
		},
	},
Guitar = {
		color= {R="3F", G="3F", B="00", },	--Y  
		oct={{},{},{},{},{},{},{},{}},
		note=function(n)
		local gmodes ={
			Guitar = {
					note={
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
						{7,8,9,10,11,0,1,2},
						{2,3,4,5,6,7,8,9},
						{9,10,11,0,1,2,3,4},
						{4,5,6,7,8,9,10,11},
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
					},
					oct={
						{3,3,3,3,3,3,3,3},
						{2,3,3,3,3,3,3,3},
						{2,2,2,2,2,3,3,3},
						{2,2,2,2,2,2,2,2},
						{1,1,1,2,2,2,2,2},
						{1,1,1,1,1,1,1,1},
						{3,3,3,3,3,3,3,3},
						{2,3,3,3,3,3,3,3},
					},
				},
			Guitar_2_iso = {
					note={
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
						{8,9,10,11,0,1,2,3},
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
						{4,5,6,7,8,9,10,11},
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
					},
					oct={
						{3,3,3,3,3,3,3,3},
						{2,3,3,3,3,3,3,3},
						{2,2,2,2,3,3,3,3},
						{2,2,2,2,2,2,2,2},
						{1,2,2,2,2,2,2,2},
						{1,1,1,1,1,1,1,1},
						{3,3,3,3,3,3,3,3},
						{2,3,3,3,3,3,3,3},
					},
				},
			Guitar_2 = {
					note={
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
						{7,8,9,10,11,0,1,2},
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
						{4,5,6,7,8,9,10,11},
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
					},
					oct={
						{3,3,3,3,3,3,3,3},
						{2,3,3,3,3,3,3,3},
						{2,2,2,2,2,3,3,3},
						{2,2,2,2,2,2,2,2},
						{1,2,2,2,2,2,2,2},
						{1,1,1,1,1,1,1,1},
						{3,3,3,3,3,3,3,3},
						{2,3,3,3,3,3,3,3},
					},
				},
			Guitar_Drop_D = {
					note={
						{2,3,4,5,6,7,8,9},
						{11,0,1,2,3,4,5,6},
						{7,8,9,10,11,0,1,2},
						{2,3,4,5,6,7,8,9},
						{9,10,11,0,1,2,3,4},
						{2,3,4,5,6,7,8,9},
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
					},
					oct={
						{3,3,3,3,3,3,3,3},
						{2,3,3,3,3,3,3,3},
						{2,2,2,2,2,3,3,3},
						{2,2,2,2,2,2,2,2},
						{1,1,1,2,2,2,2,2},
						{1,1,1,1,1,1,1,1},
						{3,3,3,3,3,3,3,3},
						{2,3,3,3,3,3,3,3},
					},
				},
			Guitar_low_Fsh_B = {
					note={
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
						{7,8,9,10,11,0,1,2},
						{2,3,4,5,6,7,8,9},
						{9,10,11,0,1,2,3,4},
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
						{6,7,8,9,10,11,0,1},
					},
					oct={
						{3,3,3,3,3,3,3,3},
						{2,3,3,3,3,3,3,3},
						{2,2,2,2,2,3,3,3},
						{2,2,2,2,2,2,2,2},
						{1,1,1,2,2,2,2,2},
						{1,1,1,1,1,1,1,1},
						{0,1,1,1,1,1,1,1},
						{0,0,0,0,0,0,1,1},
					},
				},
			Guitar_low_E_B = {
					note={
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
						{7,8,9,10,11,0,1,2},
						{2,3,4,5,6,7,8,9},
						{9,10,11,0,1,2,3,4},
						{4,5,6,7,8,9,10,11},
						{11,0,1,2,3,4,5,6},
						{4,5,6,7,8,9,10,11},
					},
					oct={
						{3,3,3,3,3,3,3,3},
						{2,3,3,3,3,3,3,3},
						{2,2,2,2,2,3,3,3},
						{2,2,2,2,2,2,2,2},
						{1,1,1,2,2,2,2,2},
						{1,1,1,1,1,1,1,1},
						{0,1,1,1,1,1,1,1},
						{0,0,0,0,0,0,0,0},
					},
				},
		}
--		error(tblprint(gmodes["Guitar"].note))
		local notegrid={}
		notegrid = gmodes["Guitar"].note 
		Modes["Guitar"].oct=gmodes["Guitar"].oct
		return notegrid
		end,
	},

Janko = {
		color= {R="3F", G="00", B="00", },	--R
		note={
			{1,3,5,7,9,11,1,3},
			{0,2,4,6,8,10,0,2},
			{2,4,6,8,10,0,2,4},
			{1,3,5,7,9,11,1,3},
			{0,2,4,6,8,10,0,2},
			{2,4,6,8,10,0,2,4},
			{1,3,5,7,9,11,1,3},
			{0,2,4,6,8,10,0,2},
		},
		oct={
			{4,4,4,4,4,4,5,5},
			{4,4,4,4,4,4,5,5},
			{3,3,2,2,3,4,4,4},
			{3,3,2,2,3,3,4,4},
			{3,3,2,2,3,3,4,4},
			{2,2,2,2,2,3,3,3},
			{2,2,2,2,2,2,3,3},
			{2,2,2,2,2,2,3,3},
		},
	},
Sixth_and_5th =	{
		color= {R="3F", G="00", B="00", },	--R
		note={
			{1,10,7,4,1,10,7,4},
			{6,3,0,9,6,3,0,9},
			{11,8,5,2,11,8,5,2},
			{4,1,10,7,4,1,10,7},
			{9,6,3,0,9,6,3,0},
			{2,11,8,5,2,11,8,5},
			{7,4,1,10,7,4,1,10},
			{0,9,6,3,0,9,6,3},
		},
		oct={
			{3,3,3,3,4,4,4,4},
			{3,3,3,3,4,4,4,4},
			{2,2,2,2,3,3,3,3},
			{2,2,2,2,3,3,3,3},
			{2,2,2,2,3,3,3,3},
			{1,1,1,1,2,2,2,2},
			{1,1,1,1,2,2,2,2},
			{1,1,1,1,2,2,2,2},
		},
	},
Fourth_and_5th =	{
		color= {R="3F", G="00", B="00", },	--R
		note={
			{1,5,9,1,5,9,1,5},
			{6,10,2,6,10,2,6,10},
			{11,3,7,11,3,7,11,3},
			{4,8,0,4,8,0,4,8},
			{9,1,5,9,1,5,9,1},
			{2,6,10,2,6,10,2,6},
			{7,11,3,7,11,3,7,11},
			{0,4,8,0,4,8,0,4},
		},
		oct={
			{3,3,3,4,4,4,5,5},
			{2,2,2,3,3,3,4,4},
			{2,2,2,3,3,3,4,4},
			{2,2,2,3,3,3,4,4},
			{1,1,1,2,2,2,3,3},
			{1,1,1,2,2,2,3,3},
			{1,1,1,2,2,2,3,3},
			{1,1,1,2,2,2,3,3},
		},
	},
Wicki_Hayden =	{
		color= {R="3F", G="00", B="00", },	--R
		note={
			{1,3,5,7,9,11,1,3},
			{6,8,10,0,2,4,6,8},
			{11,1,3,5,7,9,11,1},
			{4,6,8,10,0,2,4,6},
			{9,11,1,3,5,7,9,11},
			{2,4,6,8,10,0,2,4},
			{7,9,11,1,3,5,7,9},
			{0,2,4,6,8,10,0,2},
		},
		oct={
			{5,5,5,5,5,5,6,6},
			{4,4,4,5,5,5,5,5},
			{3,4,4,4,4,4,4,5},
			{3,3,3,3,4,4,4,4},
			{2,2,3,3,3,3,3,3},
			{2,2,2,2,2,3,3,3},
			{1,1,1,2,2,2,2,2},
			{1,1,1,1,1,1,2,2},
		},
	},
}
Modenames={
"CircleOfFifths",
"LPP_Note_mode",
--"Harmonic",
"Push",
"Diatonic",
"Diagonal",
"Octave",
"Chromatic",
"Chromatic2",
"ScaleHarp",
"ChromaHarp",
"Guitar",
"Janko",
"Sixth_and_5th",
"Fourth_and_5th",
"Wicki_Hayden",
}
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





                  

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--[[
Pad, , Palette, Transpose, Scale, Mode, Layout
Grid, Buttons 
State
Pressed, Playing

--]]
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- add some methods in at the points where I draw the color palette/scale to the pad to remember the current color; 
-- add a method into the point where I detect and transpose the note to keep an array of notes pressed and to send a method to display them; 

-- State keeps track of what notes are currently pressed/playing
-- and what button states we are in. (shift, click, shcl, etc.)
-- State.do_update(table) is the only way to change scale,mode,palette,transpose...
-- State.update is the can kicked down from function to function all the way to RDM! 
-- Scale is used in Mode, Transpose sets the midi output grid, and palette colors the pads (using modulo 12)
State = {
	trackname='',
	shift = 0,
	click = 0,
	shiftclick = 0,
	update=0,
	rotate=1,
	root=24,
	lighton={},
	lightoff={},
	do_update=function(st) --state table
		st = st or {}
--		State.update=1
		Scale.select(st.scale or Scale.last)
		Mode.select(st.mode or Mode.last,st.rotate or State.rotate) 
		Transpose.select(st.transpose or Transpose.last)
		Palette.select(st.palette or Palette.last)
	end,
}


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Grid is the array of pads, pad colors, notes, octives
-- Grid handles future rotation transforms
-- 1 is normal (1,1 on bottom left) 2-4 rotate counter clockwise.
-- could add flips.
-- newgrid=Grid[index].rotate(oldgrid)
-- TODO .new grid function that sets the current global rotation --DONE
-- newgrid =Grid.rotate[index](oldgrid) --takes a single 8x8 grid and rotates it.
-- Grid.current has 6 sub grids, with an additional table for duplicate notes.
-- refresh_midi counts duplicates and sets the output notes, 
-- also sets hi and lo for transpose check
-- and repeats with an adjustment to Transpose.last until everything is in range.
	Grid = {
			rotate = function(r,g) local ng={{},{},{},{},{},{},{},{}} 
--	rotate flip v 5-8 only one flip needed!			
				for ve=1,8 do for ho=1,8 do 
					if r==2 then
						ng[ve][ho]=g[ho][9-ve] -- 1cw
					elseif r==3 then
						ng[ve][ho]=g[9-ve][9-ho] --2cw
					elseif r==4 then
						ng[ve][ho]=g[9-ho][ve] -- 3cw
					elseif r>4 and r<9 then
						ng[ve][ho]=g[9-ve][ho] --flip v
					else
						ng[ve][ho]=g[ve][ho] -- no change 1 or gt 9
					end
				end end
--error(gridprint(gridprint('\nrotate '..r,g),ng))
				if r>4 and r<9 then
					ng=Grid.rotate(r-4,ng)
				end
				return ng end,

			new  = { note={{},{},{},{},{},{},{},{}},oct={{},{},{},{},{},{},{},{}} 
			},
			current = { -- CoF
						note={
							{8,3,10,5,0,7,2,9},
							{0,7,2,9,4,11,6,1},
							{4,11,6,1,8,3,10,5},
							{8,3,10,5,0,7,2,9},
							{0,7,2,9,4,11,6,1},
							{4,11,6,1,8,3,10,5},
							{8,3,10,5,0,7,2,9},
							{0,7,2,9,4,11,6,1},
						},
						oct={
							{5,5,5,5,6,6,6,6},
							{5,5,5,5,5,5,5,5},
							{4,4,4,4,4,4,4,4},
							{3,3,3,3,4,4,4,4},
							{3,3,3,3,3,3,3,3},
							{2,2,2,2,2,2,2,2},
							{1,1,1,1,2,2,2,2},
							{1,1,1,1,1,1,1,1},
						},
						midiout={{},{},{},{},{},{},{},{}},
						R={{},{},{},{},{},{},{},{}},
						G={{},{},{},{},{},{},{},{}},
						B={{},{},{},{},{},{},{},{}},
			},
		refresh_midiout =function()
				repeat
				local ok=true
				Grid.current.duplicatePads={}
				Grid.current.duplicateNotes={}
					local lo=Grid.current.note[1][1]+(12*Grid.current.oct[1][1])+State.root+Transpose.last --init val
					local hi=lo
--error(gridprint("test",Grid.current.note))
					for ve=1,8 do for ho=1,8 do
						local note= Grid.current.note[ve][ho]+(12*Grid.current.oct[ve][ho])+State.root+Transpose.last
						if note < 0 then -- because transpose sets the grid
							ok=false
							Transpose.last=Transpose.last+12 -- keep same transpose color/note
						elseif note > 127 then
							ok=false
							Transpose.last=Transpose.last-12
						else
							Grid.current.midiout[ve][ho]=note
							if note <= lo then
								lo=note
							elseif note >= hi then
								hi=note
							end
							if Grid.current.duplicateNotes[note] == nil then Grid.current.duplicateNotes[note]={} end
							table.insert(Grid.current.duplicateNotes[note],((9-ve)*10)+ho)
							Grid.current.midilo=lo
							Grid.current.midihi=hi
						end
					end end
					if ok then for _,v in pairs(Grid.current.duplicateNotes) do for a,b in pairs(v) do
						Grid.current.duplicatePads[b]=v
					end end end
				until ok==true
--error(gridprint('\nmidiout ',Grid.current.midiout))
				end,	
			}
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Palette has the methods for changing the Palette.
-- select takes from Grid.current.note 
Palette = { 
		length = table.getn(Palettenames),
		select=function(n) local new = 1+modulo(n-1,Palette.length) 
			if new ~= Palette.last or State.update ~= 0 then 
					Palette.current=Palettes[Palettenames[new]]
				for ve=1,8 do for ho=1,8 do 
if Grid.current.note[ve][ho] > 11 then
	error("SCALE NOTE OVER 11 ERROR mode "..Modenames[Mode.last].." scale "..Scalenames[Scale.last])
end
					Grid.current.R[ve][ho]=Palette.current[modulo(Grid.current.midiout[ve][ho],12)].R 
					Grid.current.G[ve][ho]=Palette.current[modulo(Grid.current.midiout[ve][ho],12)].G 
					Grid.current.B[ve][ho]=Palette.current[modulo(Grid.current.midiout[ve][ho],12)].B 
				end end 
				Palette.last=new
				table.insert(Pressed,93,1) -- button feedback
				table.insert(Pressed,91,1) -- button feedback
				State.update=1 
			end 
		end,
		}
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Transpose has methods for transposing the note. (by half step, sh by oct, shcl by fifth)
-- transpose select is different from others, can be negative.
-- Only place we call the midiout function, is adjusted up or down by an oct
-- when note output is out of bounds (From user input, buttons have a check in place)
Transpose = {
		current =0,
		select=function(new)
			if new ~= Transpose.last or State.update ~= 0 then 
				Transpose.last=new
				Grid.refresh_midiout() 
				table.insert(Pressed,93,1) -- button feedback
				State.update=1 
			end		
		end,
		}
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Scale has methods for changing the current Scale 
-- If the current Mode is set by a function, then Scale updates!
-- If so, we change Scale.last, then tell Mode.select to update!
Scale = {
		current = Scales[Scalenames[1]],
		length = table.getn(Scalenames),
		select=function(n) local new = 1+modulo(n-1,Scale.length) 
			if new ~= Scale.last or State.update ~= 0 then 
				Scale.last=new
				Scale.current=Scales[Scalenames[new]]
				table.insert(Pressed,91,1) -- button feedback
				State.update=1 
			end 
		end,
		}
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		
--[[

--]]

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Mode has methods for detecting/changing/remembering the current Mode. 
-- This refers to the different control layouts; chromatic, push, guitar, Co5, etc
-- Fader mode becomes avail if fader remotabable items do.
-- TODO baby mode
Mode = { 
		current = 0,
		select=function(n,r) 
			local new = 1+modulo(n-1,table.getn(Modenames)) 
			local ro
			if r then ro = 1+modulo(r-1,8) else ro=State.rotate end -- 8 rotate states
			local Mn=type(Modes[Modenames[new]].note)=="function" and Modes[Modenames[new]].note(new) or Modes[Modenames[new]].note
			local Mo=Modes[Modenames[new]].oct
			if new ~= Mode.last or ro~=State.rotate or State.update ~= 0 then 
				Grid.current.note=Grid.rotate(ro,Mn) 
				Grid.current.oct=Grid.rotate(ro,Mo) 
				Mode.last=new 
				State.rotate=ro
				State.update=1 
			end 
		end,		
		}
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Layout has methods for detecting/changing the current Layout. 
-- Layout refers to the LPP Note, Drum, Fader, Programming modes. 
-- LPP manual calls these layouts, but Reason remotemaps use a 
-- MODE column (which I use for the faders)
-- This is an internal designation detecting/setting sysex.
--Only programmer (3) and fader (2) modes enabled!
-- TODO drum layout flips to internal drum Mode
Layout={}
--Layout.mode = 3

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UTILITY FUNCTIONS UP HERE
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- FL: Helper function that combines the "Pad n" and "Pad n Playing" outputs
function make_led_value(index,a,b)
	local sw = (g.step_is_playing[index]>0) and 1 or 0 --range of value is 0-4, so we convert to 0-1
	local combined_value = g.step_value[index]*a + sw*b
	return combined_value
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function scroll_status(mess)
--	local mess = table.concat({'S',tostring(Scale.last),' M',tostring(Mode.last),' P',tostring(Palette.last),' T',tostring(Transpose.last)},'')
--[[
-- This code turns the lit playing pads off, but it's a lot os sysex right before the scrolling text
		if (table.getn(State.lightoff) ~= 0) then
			local padupdate=remote.make_midi(table.concat({sysex_setrgb,table.concat(State.lightoff," "),sysend}," "))
			table.insert(bfevent,padupdate)
			State.lightoff ={}	
		end
--]]
	local ssevent ={sysex_scrolltext, '32 00'}
		string.gsub(mess,".",function(c) 
			table.insert(ssevent,string.format("%02X",string.byte(c)))
		end)
	table.insert(ssevent,sysend)
		local bfevent={}
		table.insert(bfevent,remote.make_midi(table.concat(ssevent," ")))
		table.insert(bfevent,remote.make_midi("F0 00 20 29 02 10 0A 63 32 F7",{ port=1 })) --Front light purp
	return bfevent
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++












-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function exists(f, l) -- find element v of l satisfying f(v)
	for _, v in ipairs(l) do
		if v==f then
			return true
		end
	end
	return nil
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function vprint(strng,vari)
	remote.trace(strng .. ": "..tostring(vari)..'\n')
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function grprint(strng,grid)
	local a=strng..'\n'
	for xxx=1,8 do
		a=table.concat(grid[xxx]," ") .. '\n' .. a
	end
	remote.trace(a)
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- remote.trace contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
-- https://gist.github.com/ripter/4270799
function tprint (tbl, indent)
	if not indent then indent = 0 end
	if type(tbl) == "table" then
		 for k, v in pairs(tbl) do
			formatting = string.rep("  ", indent) .. k .. ": "
			if type(v) == "table" then
				remote.trace('\n'..formatting ..'\n')
				tprint(v, indent+1)
			elseif type(v) == 'boolean' then
				remote.trace(formatting .. tostring(v))		
			else
				remote.trace(formatting .. tostring(v) ..'\n')
			end
		 end
--[[
	else
		formatting = string.rep("  ", indent) .. type(tbl) .. ": "
		remote.trace(formatting .. tostring(v) ..'\n')
--]]
	end	
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- error(tblprint(tbl)) contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
-- https://gist.github.com/ripter/4270799
function tblprint (tbl, indent)
	local output = ''
	if not indent then indent = 0 end
	if type(tbl) == "table" then
		 for k, v in pairs(tbl) do
			formatting = string.rep("  ", indent) .. k .. ": "
			if type(v) == "table" then
				output = output..'\n'..formatting ..'\n'..
				tblprint(v, indent+1)
			elseif type(v) == 'boolean' then
				output=output..formatting .. tostring(v)		
			else
				output=output..formatting .. tostring(v) ..'\n'
			end
		 end
--[[
	else
		formatting = string.rep("  ", indent) .. type(tbl) .. ": "
		remote.trace(formatting .. tostring(v) ..'\n')
--]]
	end	
	return output
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function gridprint(strng,grid)
	local a=strng..'\n'
	for xxx=1,8 do
		a=table.concat(grid[xxx],",") .. '\n' .. a
	end
	return a..'\n'
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Thanks, Livid
--for some Reason (pun intended) I need to define a modulo function. just using the % operator was throwing errors :(
function modulo(a,b)
	local mo = a-math.floor(a/b)*b
	return mo
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function set_vel_color(newvel)
	if newvel > 0 then
		newvel=math.ceil(newvel/16)+87 --88 to 95
	end
	return newvel
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- depreciated
function set_scale(index)	
	scale_int = index
	scalename = scalenames[1+scale_int]
	scale = scales[scalename]
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function map_redrum_led(v)
	if(v<5) then
	 return pclr[v]
	end
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



 


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Remote Init here, set this up right
-- Button names are from programmer mode! (pg 17 in the prog ref
-- bottom left button is 1
-- bottom left pad is 11, top right pad is 88
-- left buttons end in 0
-- right buttons end in 9
-- top row 91 - 98
-- Press is aftertouch, Pad is note on, Playing is for displaying state
-- TODO revise these soon
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_init(manufacturer, model)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- this version
	if model=="LP Pro" or model=="Launchpad Pro" then
		local items={
--items
			{name="Keyboard",input="keyboard"},
			{name="_Scope", output="text", itemnum="scope"}, --device, e.g. "Thor"
			{name="_Var", output="text", itemnum="var"}, --variation, e.g. "Volume" or "Filters"
			{name="Pitch Bend", input="value", min=0, max=16383, itemnum="pitchbend"},
			{name="Modulation", input="value", min=0, max=127, itemnum="modulation"},
			{name="Channel Pressure", input="value", min=0, max=127, itemnum="channelpressure"},
			{name="TrackName", input="noinput", output="text", itemnum="trackname"},
--			{name="AllStop", input="button", output="nooutput", itemnum="allstop"},
			{name="Redo", input="button", output="nooutput", itemnum="redo"},
			{name="Undo", input="button", output="nooutput", itemnum="undo"},

			{name="Fader 1", input="value", min=0, max=127, output="value", modes={"Program","Fader"}, itemnum="first_fader"},
			{name="Fader 2", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 3", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 4", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 5", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 6", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 7", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 8", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
--[[
			{name="Pan 1", input="value", min=0, max=127, output="value"},
			{name="Pan 2", input="value", min=0, max=127, output="value"},
			{name="Pan 3", input="value", min=0, max=127, output="value"},
			{name="Pan 4", input="value", min=0, max=127, output="value"},
			{name="Pan 5", input="value", min=0, max=127, output="value"},
			{name="Pan 6", input="value", min=0, max=127, output="value"},
			{name="Pan 7", input="value", min=0, max=127, output="value"},
			{name="Pan 8", input="value", min=0, max=127, output="value"},
--]]
--From bottom left to top right
			{name="Press 11", input="value", min=0, max=127, output="value", itemnum="first_press"},
			{name="Press 12", input="value", min=0, max=127, output="value"},
			{name="Press 13", input="value", min=0, max=127, output="value"},
			{name="Press 14", input="value", min=0, max=127, output="value"},
			{name="Press 15", input="value", min=0, max=127, output="value"},
			{name="Press 16", input="value", min=0, max=127, output="value"},
			{name="Press 17", input="value", min=0, max=127, output="value"},
			{name="Press 18", input="value", min=0, max=127, output="value"},
			{name="Press 21", input="value", min=0, max=127, output="value"},
			{name="Press 22", input="value", min=0, max=127, output="value"},
			{name="Press 23", input="value", min=0, max=127, output="value"},
			{name="Press 24", input="value", min=0, max=127, output="value"},
			{name="Press 25", input="value", min=0, max=127, output="value"},
			{name="Press 26", input="value", min=0, max=127, output="value"},
			{name="Press 27", input="value", min=0, max=127, output="value"},
			{name="Press 28", input="value", min=0, max=127, output="value"},
			{name="Press 31", input="value", min=0, max=127, output="value"},
			{name="Press 32", input="value", min=0, max=127, output="value"},
			{name="Press 33", input="value", min=0, max=127, output="value"},
			{name="Press 34", input="value", min=0, max=127, output="value"},
			{name="Press 35", input="value", min=0, max=127, output="value"},
			{name="Press 36", input="value", min=0, max=127, output="value"},
			{name="Press 37", input="value", min=0, max=127, output="value"},
			{name="Press 38", input="value", min=0, max=127, output="value"},
			{name="Press 41", input="value", min=0, max=127, output="value"},
			{name="Press 42", input="value", min=0, max=127, output="value"},
			{name="Press 43", input="value", min=0, max=127, output="value"},
			{name="Press 44", input="value", min=0, max=127, output="value"},
			{name="Press 45", input="value", min=0, max=127, output="value"},
			{name="Press 46", input="value", min=0, max=127, output="value"},
			{name="Press 47", input="value", min=0, max=127, output="value"},
			{name="Press 48", input="value", min=0, max=127, output="value"},
--[[
			{name="Press 51", input="value", min=0, max=127, output="value"},
			{name="Press 52", input="value", min=0, max=127, output="value"},
			{name="Press 53", input="value", min=0, max=127, output="value"},
			{name="Press 54", input="value", min=0, max=127, output="value"},
			{name="Press 55", input="value", min=0, max=127, output="value"},
			{name="Press 56", input="value", min=0, max=127, output="value"},
			{name="Press 57", input="value", min=0, max=127, output="value"},
			{name="Press 58", input="value", min=0, max=127, output="value"},
			{name="Press 61", input="value", min=0, max=127, output="value"},
			{name="Press 62", input="value", min=0, max=127, output="value"},
			{name="Press 63", input="value", min=0, max=127, output="value"},
			{name="Press 64", input="value", min=0, max=127, output="value"},
			{name="Press 65", input="value", min=0, max=127, output="value"},
			{name="Press 66", input="value", min=0, max=127, output="value"},
			{name="Press 67", input="value", min=0, max=127, output="value"},
			{name="Press 68", input="value", min=0, max=127, output="value"},
			{name="Press 71", input="value", min=0, max=127, output="value"},
			{name="Press 72", input="value", min=0, max=127, output="value"},
			{name="Press 73", input="value", min=0, max=127, output="value"},
			{name="Press 74", input="value", min=0, max=127, output="value"},
			{name="Press 75", input="value", min=0, max=127, output="value"},
			{name="Press 76", input="value", min=0, max=127, output="value"},
			{name="Press 77", input="value", min=0, max=127, output="value"},
			{name="Press 78", input="value", min=0, max=127, output="value"},
			{name="Press 81", input="value", min=0, max=127, output="value"},
			{name="Press 82", input="value", min=0, max=127, output="value"},
			{name="Press 83", input="value", min=0, max=127, output="value"},
			{name="Press 84", input="value", min=0, max=127, output="value"},
			{name="Press 85", input="value", min=0, max=127, output="value"},
			{name="Press 86", input="value", min=0, max=127, output="value"},
			{name="Press 87", input="value", min=0, max=127, output="value"},
			{name="Press 88", input="value", min=0, max=127, output="value"},
--]]
--From bottom left to top right

			{name="Pad 11", input="value", min=0, max=127, output="value", itemnum="first_pad"},
			{name="Pad 12", input="value", min=0, max=127, output="value"},
			{name="Pad 13", input="value", min=0, max=127, output="value"},
			{name="Pad 14", input="value", min=0, max=127, output="value"},
			{name="Pad 15", input="value", min=0, max=127, output="value"},
			{name="Pad 16", input="value", min=0, max=127, output="value"},
			{name="Pad 17", input="value", min=0, max=127, output="value"},
			{name="Pad 18", input="value", min=0, max=127, output="value"},
			{name="Pad 21", input="value", min=0, max=127, output="value"},
			{name="Pad 22", input="value", min=0, max=127, output="value"},
			{name="Pad 23", input="value", min=0, max=127, output="value"},
			{name="Pad 24", input="value", min=0, max=127, output="value"},
			{name="Pad 25", input="value", min=0, max=127, output="value"},
			{name="Pad 26", input="value", min=0, max=127, output="value"},
			{name="Pad 27", input="value", min=0, max=127, output="value"},
			{name="Pad 28", input="value", min=0, max=127, output="value"},
			{name="Pad 31", input="value", min=0, max=127, output="value", itemnum="first_step_item"},
			{name="Pad 32", input="value", min=0, max=127, output="value"},
			{name="Pad 33", input="value", min=0, max=127, output="value"},
			{name="Pad 34", input="value", min=0, max=127, output="value"},
			{name="Pad 35", input="value", min=0, max=127, output="value"},
			{name="Pad 36", input="value", min=0, max=127, output="value"},
			{name="Pad 37", input="value", min=0, max=127, output="value"},
			{name="Pad 38", input="value", min=0, max=127, output="value"},
			{name="Pad 41", input="value", min=0, max=127, output="value"},
			{name="Pad 42", input="value", min=0, max=127, output="value"},
			{name="Pad 43", input="value", min=0, max=127, output="value"},
			{name="Pad 44", input="value", min=0, max=127, output="value"},
			{name="Pad 45", input="value", min=0, max=127, output="value"},
			{name="Pad 46", input="value", min=0, max=127, output="value"},
			{name="Pad 47", input="value", min=0, max=127, output="value"},
			{name="Pad 48", input="value", min=0, max=127, output="value"},
			{name="Pad 51", input="value", min=0, max=127, output="value"},
			{name="Pad 52", input="value", min=0, max=127, output="value"},
			{name="Pad 53", input="value", min=0, max=127, output="value"},
			{name="Pad 54", input="value", min=0, max=127, output="value"},
			{name="Pad 55", input="value", min=0, max=127, output="value"},
			{name="Pad 56", input="value", min=0, max=127, output="value"},
			{name="Pad 57", input="value", min=0, max=127, output="value"},
			{name="Pad 58", input="value", min=0, max=127, output="value"},
			{name="Pad 61", input="value", min=0, max=127, output="value"},
			{name="Pad 62", input="value", min=0, max=127, output="value"},
			{name="Pad 63", input="value", min=0, max=127, output="value"},
			{name="Pad 64", input="value", min=0, max=127, output="value"},
			{name="Pad 65", input="value", min=0, max=127, output="value"},
			{name="Pad 66", input="value", min=0, max=127, output="value"},
			{name="Pad 67", input="value", min=0, max=127, output="value"},
			{name="Pad 68", input="value", min=0, max=127, output="value"},
			{name="Pad 71", input="value", min=0, max=127, output="value"},
			{name="Pad 72", input="value", min=0, max=127, output="value"},
			{name="Pad 73", input="value", min=0, max=127, output="value"},
			{name="Pad 74", input="value", min=0, max=127, output="value"},
			{name="Pad 75", input="value", min=0, max=127, output="value"},
			{name="Pad 76", input="value", min=0, max=127, output="value"},
			{name="Pad 77", input="value", min=0, max=127, output="value"},
			{name="Pad 78", input="value", min=0, max=127, output="value"},
			{name="Pad 81", input="value", min=0, max=127, output="value"},
			{name="Pad 82", input="value", min=0, max=127, output="value"},
			{name="Pad 83", input="value", min=0, max=127, output="value"},
			{name="Pad 84", input="value", min=0, max=127, output="value"},
			{name="Pad 85", input="value", min=0, max=127, output="value"},
			{name="Pad 86", input="value", min=0, max=127, output="value"},
			{name="Pad 87", input="value", min=0, max=127, output="value"},
			{name="Pad 88", input="value", min=0, max=127, output="value"},

--From bottom left to top right

			{name="Pad 11 Playing", min=0, max=4, output="value"},
			{name="Pad 12 Playing", min=0, max=4, output="value"},
			{name="Pad 13 Playing", min=0, max=4, output="value"},
			{name="Pad 14 Playing", min=0, max=4, output="value"},
			{name="Pad 15 Playing", min=0, max=4, output="value"},
			{name="Pad 16 Playing", min=0, max=4, output="value"},
			{name="Pad 17 Playing", min=0, max=4, output="value"},
			{name="Pad 18 Playing", min=0, max=4, output="value"},
			{name="Pad 21 Playing", min=0, max=4, output="value"},
			{name="Pad 22 Playing", min=0, max=4, output="value"},
			{name="Pad 23 Playing", min=0, max=4, output="value"},
			{name="Pad 24 Playing", min=0, max=4, output="value"},
			{name="Pad 25 Playing", min=0, max=4, output="value"},
			{name="Pad 26 Playing", min=0, max=4, output="value"},
			{name="Pad 27 Playing", min=0, max=4, output="value"},
			{name="Pad 28 Playing", min=0, max=4, output="value"},
			{name="Pad 31 Playing", min=0, max=4, output="value", itemnum="first_step_playing_item"},
			{name="Pad 32 Playing", min=0, max=4, output="value"},
			{name="Pad 33 Playing", min=0, max=4, output="value"},
			{name="Pad 34 Playing", min=0, max=4, output="value"},
			{name="Pad 35 Playing", min=0, max=4, output="value"},
			{name="Pad 36 Playing", min=0, max=4, output="value"},
			{name="Pad 37 Playing", min=0, max=4, output="value"},
			{name="Pad 38 Playing", min=0, max=4, output="value"},
			{name="Pad 41 Playing", min=0, max=4, output="value"},
			{name="Pad 42 Playing", min=0, max=4, output="value"},
			{name="Pad 43 Playing", min=0, max=4, output="value"},
			{name="Pad 44 Playing", min=0, max=4, output="value"},
			{name="Pad 45 Playing", min=0, max=4, output="value"},
			{name="Pad 46 Playing", min=0, max=4, output="value"},
			{name="Pad 47 Playing", min=0, max=4, output="value"},
			{name="Pad 48 Playing", min=0, max=4, output="value"},
--[[
			{name="Pad 51 Playing", min=0, max=4, output="value"},
			{name="Pad 52 Playing", min=0, max=4, output="value"},
			{name="Pad 53 Playing", min=0, max=4, output="value"},
			{name="Pad 54 Playing", min=0, max=4, output="value"},
			{name="Pad 55 Playing", min=0, max=4, output="value"},
			{name="Pad 56 Playing", min=0, max=4, output="value"},
			{name="Pad 57 Playing", min=0, max=4, output="value"},
			{name="Pad 58 Playing", min=0, max=4, output="value"},
			{name="Pad 61 Playing", min=0, max=4, output="value"},
			{name="Pad 62 Playing", min=0, max=4, output="value"},
			{name="Pad 63 Playing", min=0, max=4, output="value"},
			{name="Pad 64 Playing", min=0, max=4, output="value"},
			{name="Pad 65 Playing", min=0, max=4, output="value"},
			{name="Pad 66 Playing", min=0, max=4, output="value"},
			{name="Pad 67 Playing", min=0, max=4, output="value"},
			{name="Pad 68 Playing", min=0, max=4, output="value"},
			{name="Pad 71 Playing", min=0, max=4, output="value"},
			{name="Pad 72 Playing", min=0, max=4, output="value"},
			{name="Pad 73 Playing", min=0, max=4, output="value"},
			{name="Pad 74 Playing", min=0, max=4, output="value"},
			{name="Pad 75 Playing", min=0, max=4, output="value"},
			{name="Pad 76 Playing", min=0, max=4, output="value"},
			{name="Pad 77 Playing", min=0, max=4, output="value"},
			{name="Pad 78 Playing", min=0, max=4, output="value"},
			{name="Pad 81 Playing", min=0, max=4, output="value"},
			{name="Pad 82 Playing", min=0, max=4, output="value"},
			{name="Pad 83 Playing", min=0, max=4, output="value"},
			{name="Pad 84 Playing", min=0, max=4, output="value"},
			{name="Pad 85 Playing", min=0, max=4, output="value"},
			{name="Pad 86 Playing", min=0, max=4, output="value"},
			{name="Pad 87 Playing", min=0, max=4, output="value"},
			{name="Pad 88 Playing", min=0, max=4, output="value"},
--]]
--left to right Top
			{name="Button 91", input="button", min=0, max=127, output="value", itemnum="first_button"},
			{name="Button 92", input="button", min=0, max=127, output="value"},
			{name="Button 93", input="button", min=0, max=127, output="value"},
			{name="Button 94", input="button", min=0, max=127, output="value"},
			{name="Button 95", input="button", min=0, max=127, output="value"},
			{name="Button 96", input="button", min=0, max=127, output="value"},
			{name="Button 97", input="button", min=0, max=127, output="value"},
			{name="Button 98", input="button", min=0, max=127, output="value"},
--left to right Bottom
			{name="Button 01", input="button", min=0, max=127, output="value"},
			{name="Button 02", input="button", min=0, max=127, output="value"},
			{name="Button 03", input="button", min=0, max=127, output="value"},
			{name="Button 04", input="button", min=0, max=127, output="value"},
			{name="Button 05", input="button", min=0, max=127, output="value"},
			{name="Button 06", input="button", min=0, max=127, output="value"},
			{name="Button 07", input="button", min=0, max=127, output="value"},
			{name="Button 08", input="button", min=0, max=127, output="value"},
--bottom to top Left
			{name="Button 10", input="button", min=0, max=127, output="value"},
			{name="Button 20", input="button", min=0, max=127, output="value"},
			{name="Button 30", input="button", min=0, max=127, output="value"},
			{name="Button 40", input="button", min=0, max=127, output="value"},
			{name="Button 50", input="button", min=0, max=127, output="value"},
			{name="Button 60", input="button", min=0, max=127, output="value"},
--[[
			{name="Button 70", input="button", min=0, max=127, output="value"},
			{name="Button 80", input="button", min=0, max=127, output="value"},
--]]
--bottom to top Right
			{name="Button 19", input="button", min=0, max=127, output="value"},
			{name="Button 29", input="button", min=0, max=127, output="value"},
			{name="Button 39", input="button", min=0, max=127, output="value"},
			{name="Button 49", input="button", min=0, max=127, output="value"},
			{name="Button 59", input="button", min=0, max=127, output="value"},
			{name="Button 69", input="button", min=0, max=127, output="value"},
			{name="Button 79", input="button", min=0, max=127, output="value"},
			{name="Button 89", input="button", min=0, max=127, output="value"},
			{name="Pad 32 Alt", input="value", min=0, max=2, output="value", itemnum="accent"},
			}

-- some items need to be noted, so here's where Itemnum.thing is set
for it=1,table.getn(items),1 do
	if items[it].itemnum ~= nil then
		Itemnum[items[it].itemnum]=it
	end
end

--remote.trace("here!")
		remote.define_items(items)

		local inputs={

--inputs
			{pattern="D? xx ??", name="Channel Pressure"},
			{pattern="b0 15 xx", name="Fader 1"},
			{pattern="b0 16 xx", name="Fader 2"},
			{pattern="b0 17 xx", name="Fader 3"},
			{pattern="b0 18 xx", name="Fader 4"},
			{pattern="b0 19 xx", name="Fader 5"},
			{pattern="b0 1a xx", name="Fader 6"},
			{pattern="b0 1b xx", name="Fader 7"},
			{pattern="b0 1c xx", name="Fader 8"},
--[[
			{pattern="b0 15 xx", name="Pan 1"},
			{pattern="b0 16 xx", name="Pan 2"},
			{pattern="b0 17 xx", name="Pan 3"},
			{pattern="b0 18 xx", name="Pan 4"},
			{pattern="b0 19 xx", name="Pan 5"},
			{pattern="b0 1a xx", name="Pan 6"},
			{pattern="b0 1b xx", name="Pan 7"},
			{pattern="b0 1c xx", name="Pan 8"},
--]]


--[[
-- Aftertouch
			{name="Press 11",  pattern="A? 0B xx"},
			{name="Press 12",  pattern="A? 0C xx"},
			{name="Press 13",  pattern="A? 0D xx"},
			{name="Press 14",  pattern="A? 0E xx"},
			{name="Press 15",  pattern="A? 0F xx"},
			{name="Press 16",  pattern="A? 10 xx"},
			{name="Press 17",  pattern="A? 11 xx"},
			{name="Press 18",  pattern="A? 12 xx"},
			{name="Press 21",  pattern="A? 15 xx"},
			{name="Press 22",  pattern="A? 16 xx"},
			{name="Press 23",  pattern="A? 17 xx"},
			{name="Press 24",  pattern="A? 18 xx"},
			{name="Press 25",  pattern="A? 19 xx"},
			{name="Press 26",  pattern="A? 1A xx"},
			{name="Press 27",  pattern="A? 1B xx"},
			{name="Press 28",  pattern="A? 1C xx"},
			{name="Press 31",  pattern="A? 1F xx"},
			{name="Press 32",  pattern="A? 20 xx"},
			{name="Press 33",  pattern="A? 21 xx"},
			{name="Press 34",  pattern="A? 22 xx"},
			{name="Press 35",  pattern="A? 23 xx"},
			{name="Press 36",  pattern="A? 24 xx"},
			{name="Press 37",  pattern="A? 25 xx"},
			{name="Press 38",  pattern="A? 26 xx"},
			{name="Press 41",  pattern="A? 29 xx"},
			{name="Press 42",  pattern="A? 2A xx"},
			{name="Press 43",  pattern="A? 2B xx"},
			{name="Press 44",  pattern="A? 2C xx"},
			{name="Press 45",  pattern="A? 2D xx"},
			{name="Press 46",  pattern="A? 2E xx"},
			{name="Press 47",  pattern="A? 2F xx"},
			{name="Press 48",  pattern="A? 30 xx"},
--]]
--[[
			{name="Press 51",  pattern="A? 33 xx"},
			{name="Press 52",  pattern="A? 34 xx"},
			{name="Press 53",  pattern="A? 35 xx"},
			{name="Press 54",  pattern="A? 36 xx"},
			{name="Press 55",  pattern="A? 37 xx"},
			{name="Press 56",  pattern="A? 38 xx"},
			{name="Press 57",  pattern="A? 39 xx"},
			{name="Press 58",  pattern="A? 3A xx"},
			{name="Press 61",  pattern="A? 3D xx"},
			{name="Press 62",  pattern="A? 3E xx"},
			{name="Press 63",  pattern="A? 3F xx"},
			{name="Press 64",  pattern="A? 40 xx"},
			{name="Press 65",  pattern="A? 41 xx"},
			{name="Press 66",  pattern="A? 42 xx"},
			{name="Press 67",  pattern="A? 43 xx"},
			{name="Press 68",  pattern="A? 44 xx"},
			{name="Press 71",  pattern="A? 47 xx"},
			{name="Press 72",  pattern="A? 48 xx"},
			{name="Press 73",  pattern="A? 49 xx"},
			{name="Press 74",  pattern="A? 4A xx"},
			{name="Press 75",  pattern="A? 4B xx"},
			{name="Press 76",  pattern="A? 4C xx"},
			{name="Press 77",  pattern="A? 4D xx"},
			{name="Press 78",  pattern="A? 4E xx"},
			{name="Press 81",  pattern="A? 51 xx"},
			{name="Press 82",  pattern="A? 52 xx"},
			{name="Press 83",  pattern="A? 53 xx"},
			{name="Press 84",  pattern="A? 54 xx"},
			{name="Press 85",  pattern="A? 55 xx"},
			{name="Press 86",  pattern="A? 56 xx"},
			{name="Press 87",  pattern="A? 57 xx"},
			{name="Press 88",  pattern="A? 58 xx"},
--]]

			{name="Pad 11",	 pattern="9? 0B xx"},
			{name="Pad 12",	 pattern="9? 0C xx"},
			{name="Pad 13",	 pattern="9? 0D xx"},
			{name="Pad 14",	 pattern="9? 0E xx"},
			{name="Pad 15",	 pattern="9? 0F xx"},
			{name="Pad 16",	 pattern="9? 10 xx"},
			{name="Pad 17",	 pattern="9? 11 xx"},
			{name="Pad 18",	 pattern="9? 12 xx"},
			{name="Pad 21",	 pattern="9? 15 xx"},
			{name="Pad 22",	 pattern="9? 16 xx"},
			{name="Pad 23",	 pattern="9? 17 xx"},
			{name="Pad 24",	 pattern="9? 18 xx"},
			{name="Pad 25",	 pattern="9? 19 xx"},
			{name="Pad 26",	 pattern="9? 1A xx"},
			{name="Pad 27",	 pattern="9? 1B xx"},
			{name="Pad 28",	 pattern="9? 1C xx"},
			{name="Pad 31",	 pattern="9? 1F xx"},
			{name="Pad 32",	 pattern="9? 20 xx"},
			{name="Pad 33",	 pattern="9? 21 xx"},
			{name="Pad 34",	 pattern="9? 22 xx"},
			{name="Pad 35",	 pattern="9? 23 xx"},
			{name="Pad 36",	 pattern="9? 24 xx"},
			{name="Pad 37",	 pattern="9? 25 xx"},
			{name="Pad 38",	 pattern="9? 26 xx"},
			{name="Pad 41",	 pattern="9? 29 xx"},
			{name="Pad 42",	 pattern="9? 2A xx"},
			{name="Pad 43",	 pattern="9? 2B xx"},
			{name="Pad 44",	 pattern="9? 2C xx"},
			{name="Pad 45",	 pattern="9? 2D xx"},
			{name="Pad 46",	 pattern="9? 2E xx"},
			{name="Pad 47",	 pattern="9? 2F xx"},
			{name="Pad 48",	 pattern="9? 30 xx"},
			{name="Pad 51",	 pattern="9? 33 xx"},
			{name="Pad 52",	 pattern="9? 34 xx"},
			{name="Pad 53",	 pattern="9? 35 xx"},
			{name="Pad 54",	 pattern="9? 36 xx"},
			{name="Pad 55",	 pattern="9? 37 xx"},
			{name="Pad 56",	 pattern="9? 38 xx"},
			{name="Pad 57",	 pattern="9? 39 xx"},
			{name="Pad 58",	 pattern="9? 3A xx"},
			{name="Pad 61",	 pattern="9? 3D xx"},
			{name="Pad 62",	 pattern="9? 3E xx"},
			{name="Pad 63",	 pattern="9? 3F xx"},
			{name="Pad 64",	 pattern="9? 40 xx"},
			{name="Pad 65",	 pattern="9? 41 xx"},
			{name="Pad 66",	 pattern="9? 42 xx"},
			{name="Pad 67",	 pattern="9? 43 xx"},
			{name="Pad 68",	 pattern="9? 44 xx"},
			{name="Pad 71",	 pattern="9? 47 xx"},
			{name="Pad 72",	 pattern="9? 48 xx"},
			{name="Pad 73",	 pattern="9? 49 xx"},
			{name="Pad 74",	 pattern="9? 4A xx"},
			{name="Pad 75",	 pattern="9? 4B xx"},
			{name="Pad 76",	 pattern="9? 4C xx"},
			{name="Pad 77",	 pattern="9? 4D xx"},
			{name="Pad 78",	 pattern="9? 4E xx"},
			{name="Pad 81",	 pattern="9? 51 xx"},
			{name="Pad 82",	 pattern="9? 52 xx"},
			{name="Pad 83",	 pattern="9? 53 xx"},
			{name="Pad 84",	 pattern="9? 54 xx"},
			{name="Pad 85",	 pattern="9? 55 xx"},
			{name="Pad 86",	 pattern="9? 56 xx"},
			{name="Pad 87",	 pattern="9? 57 xx"},
			{name="Pad 88",	 pattern="9? 58 xx"},


--left to right Top
			{name="Button 91",	pattern="B? 5B ?<???x>"},
			{name="Button 92",	pattern="B? 5C ?<???x>"},
			{name="Button 93",	pattern="B? 5D ?<???x>"},
			{name="Button 94",	pattern="B? 5E ?<???x>"},
			{name="Button 95",	pattern="B? 5F ?<???x>"},
			{name="Button 96",	pattern="B? 60 ?<???x>"},
			{name="Button 97",	pattern="B? 61 ?<???x>"},
			{name="Button 98",	pattern="B? 62 ?<???x>"},
--left to right Bottom
			{name="Button 01",  pattern="B? 01 ?<???x>"},
			{name="Button 02",  pattern="B? 02 ?<???x>"},
			{name="Button 03",  pattern="B? 03 ?<???x>"},
			{name="Button 04",  pattern="B? 04 ?<???x>"},
			{name="Button 05",  pattern="B? 05 ?<???x>"},
			{name="Button 06",  pattern="B? 06 ?<???x>"},
			{name="Button 07",  pattern="B? 07 ?<???x>"},
			{name="Button 08",  pattern="B? 08 ?<???x>"},
--bottom to top Left
			{name="Button 10",	 pattern="B? 0A ?<???x>"},
			{name="Button 20",	 pattern="B? 14 ?<???x>"},
			{name="Button 30",	 pattern="B? 1E ?<???x>"},
			{name="Button 40",	 pattern="B? 28 ?<???x>"},
			{name="Button 50",	 pattern="B? 32 ?<???x>"},
			{name="Button 60",	 pattern="B? 3C ?<???x>"},
--[[
			{name="Button 70",	 pattern="B? 46 ?<???x>"},
			{name="Button 80",	 pattern="B? 50 ?<???x>"},
--]]
--bottom to top Right
			{name="Button 19",  pattern="B? 13 ?<???x>"},
			{name="Button 29",  pattern="B? 1D ?<???x>"},
			{name="Button 39",  pattern="B? 27 ?<???x>"},
			{name="Button 49",  pattern="B? 31 ?<???x>"},
			{name="Button 59",  pattern="B? 3B ?<???x>"},
			{name="Button 69",  pattern="B? 45 ?<???x>"},
			{name="Button 79",  pattern="B? 4F ?<???x>"},
			{name="Button 89",  pattern="B? 59 ?<???x>"},

		}
		remote.define_auto_inputs(inputs)
		
		local outputs={

--ouputs

--[[
			{pattern="90 01 xx", name="Button 01", x="1+(126*value)"},
			{pattern="90 02 xx", name="Button 02", x="1+(31*value)"}, 
			{pattern="90 03 xx", name="Button 03", x="4+(28*value)"}, 
			{pattern="90 04 xx", name="Button 04", x="8+(8*value)"},
			{pattern="90 05 xx", name="Button 05", x="64*value"}, 
			{pattern="90 06 xx", name="Button 06", x="64*value"}, 
			{pattern="90 07 xx", name="Button 07", x="64*value"}, 
			{pattern="90 08 xx", name="Button 08", x="64*value"}, 
			
--]]
			--touch Faders
			{pattern="F0 00 20 29 02 10 2B 00 00 05 xx F7", name="Fader 1"},
			{pattern="F0 00 20 29 02 10 2B 01 00 05 xx F7", name="Fader 2"},
			{pattern="F0 00 20 29 02 10 2B 02 00 05 xx F7", name="Fader 3"},
			{pattern="F0 00 20 29 02 10 2B 03 00 05 xx F7", name="Fader 4"},
			{pattern="F0 00 20 29 02 10 2B 04 00 05 xx F7", name="Fader 5"},
			{pattern="F0 00 20 29 02 10 2B 05 00 05 xx F7", name="Fader 6"},
			{pattern="F0 00 20 29 02 10 2B 06 00 05 xx F7", name="Fader 7"},
			{pattern="F0 00 20 29 02 10 2B 07 00 05 xx F7", name="Fader 8"},


-- Aftertouch
			{name="Press 11",  pattern="90 0B xx"},
			{name="Press 12",  pattern="90 0C xx"},
			{name="Press 13",  pattern="90 0D xx"},
			{name="Press 14",  pattern="90 0E xx"},
			{name="Press 15",  pattern="90 0F xx"},
			{name="Press 16",  pattern="90 10 xx"},
			{name="Press 17",  pattern="90 11 xx"},
			{name="Press 18",  pattern="90 12 xx"},
			{name="Press 21",  pattern="90 15 xx"},
			{name="Press 22",  pattern="90 16 xx"},
			{name="Press 23",  pattern="90 17 xx"},
			{name="Press 24",  pattern="90 18 xx"},
			{name="Press 25",  pattern="90 19 xx"},
			{name="Press 26",  pattern="90 1A xx"},
			{name="Press 27",  pattern="90 1B xx"},
			{name="Press 28",  pattern="90 1C xx"},
			{name="Press 31",  pattern="90 1F xx"},
			{name="Press 32",  pattern="90 20 xx"},
			{name="Press 33",  pattern="90 21 xx"},
			{name="Press 34",  pattern="90 22 xx"},
			{name="Press 35",  pattern="90 23 xx"},
			{name="Press 36",  pattern="90 24 xx"},
			{name="Press 37",  pattern="90 25 xx"},
			{name="Press 38",  pattern="90 26 xx"},
			{name="Press 41",  pattern="90 29 xx"},
			{name="Press 42",  pattern="90 2A xx"},
			{name="Press 43",  pattern="90 2B xx"},
			{name="Press 44",  pattern="90 2C xx"},
			{name="Press 45",  pattern="90 2D xx"},
			{name="Press 46",  pattern="90 2E xx"},
			{name="Press 47",  pattern="90 2F xx"},
			{name="Press 48",  pattern="90 30 xx"},
--[[
			{name="Press 51",  pattern="90 33 xx"},
			{name="Press 52",  pattern="90 34 xx"},
			{name="Press 53",  pattern="90 35 xx"},
			{name="Press 54",  pattern="90 36 xx"},
			{name="Press 55",  pattern="90 37 xx"},
			{name="Press 56",  pattern="90 38 xx"},
			{name="Press 57",  pattern="90 39 xx"},
			{name="Press 58",  pattern="90 3A xx"},
			{name="Press 61",  pattern="90 3D xx"},
			{name="Press 62",  pattern="90 3E xx"},
			{name="Press 63",  pattern="90 3F xx"},
			{name="Press 64",  pattern="90 40 xx"},
			{name="Press 65",  pattern="90 41 xx"},
			{name="Press 66",  pattern="90 42 xx"},
			{name="Press 67",  pattern="90 43 xx"},
			{name="Press 68",  pattern="90 44 xx"},
			{name="Press 71",  pattern="90 47 xx"},
			{name="Press 72",  pattern="90 48 xx"},
			{name="Press 73",  pattern="90 49 xx"},
			{name="Press 74",  pattern="90 4A xx"},
			{name="Press 75",  pattern="90 4B xx"},
			{name="Press 76",  pattern="90 4C xx"},
			{name="Press 77",  pattern="90 4D xx"},
			{name="Press 78",  pattern="90 4E xx"},
			{name="Press 81",  pattern="90 51 xx"},
			{name="Press 82",  pattern="90 52 xx"},
			{name="Press 83",  pattern="90 53 xx"},
			{name="Press 84",  pattern="90 54 xx"},
			{name="Press 85",  pattern="90 55 xx"},
			{name="Press 86",  pattern="90 56 xx"},
			{name="Press 87",  pattern="90 57 xx"},
			{name="Press 88",  pattern="90 58 xx"},
--]]
--[[
-- Note on lights, note off turns off light. 

			{name="Pad 11",	 pattern="90 0B xx"},
			{name="Pad 12",	 pattern="90 0C xx"},
			{name="Pad 13",	 pattern="90 0D xx"},
			{name="Pad 14",	 pattern="90 0E xx"},
			{name="Pad 15",	 pattern="90 0F xx"},
			{name="Pad 16",	 pattern="90 10 xx"},
			{name="Pad 17",	 pattern="90 11 xx"},
			{name="Pad 18",	 pattern="90 12 xx"},
			{name="Pad 21",	 pattern="90 15 xx"},
			{name="Pad 22",	 pattern="90 16 xx"},
			{name="Pad 23",	 pattern="90 17 xx"},
			{name="Pad 24",	 pattern="90 18 xx"},
			{name="Pad 25",	 pattern="90 19 xx"},
			{name="Pad 26",	 pattern="90 1A xx"},
			{name="Pad 27",	 pattern="90 1B xx"},
			{name="Pad 28",	 pattern="90 1C xx"},
			{name="Pad 31",	 pattern="90 1F xx"},
			{name="Pad 32",	 pattern="90 20 xx"},
			{name="Pad 33",	 pattern="90 21 xx"},
			{name="Pad 34",	 pattern="90 22 xx"},
			{name="Pad 35",	 pattern="90 23 xx"},
			{name="Pad 36",	 pattern="90 24 xx"},
			{name="Pad 37",	 pattern="90 25 xx"},
			{name="Pad 38",	 pattern="90 26 xx"},
--]]
			{name="Pad 41",	 pattern="90 29 xx"},
			{name="Pad 42",	 pattern="90 2A xx"},
			{name="Pad 43",	 pattern="90 2B xx"},
			{name="Pad 44",	 pattern="90 2C xx"},
			{name="Pad 45",	 pattern="90 2D xx"},
			{name="Pad 46",	 pattern="90 2E xx"},
			{name="Pad 47",	 pattern="90 2F xx"},
			{name="Pad 48",	 pattern="90 30 xx"},
--[[
			{name="Pad 51",	 pattern="90 33 xx"},
			{name="Pad 52",	 pattern="90 34 xx"},
			{name="Pad 53",	 pattern="90 35 xx"},
			{name="Pad 54",	 pattern="90 36 xx"},
			{name="Pad 55",	 pattern="90 37 xx"},
			{name="Pad 56",	 pattern="90 38 xx"},
			{name="Pad 57",	 pattern="90 39 xx"},
			{name="Pad 58",	 pattern="90 3A xx"},
			{name="Pad 61",	 pattern="90 3D xx"},
			{name="Pad 62",	 pattern="90 3E xx"},
			{name="Pad 63",	 pattern="90 3F xx"},
			{name="Pad 64",	 pattern="90 40 xx"},
			{name="Pad 65",	 pattern="90 41 xx"},
			{name="Pad 66",	 pattern="90 42 xx"},
			{name="Pad 67",	 pattern="90 43 xx"},
			{name="Pad 68",	 pattern="90 44 xx"},
			{name="Pad 71",	 pattern="90 47 xx"},
			{name="Pad 72",	 pattern="90 48 xx"},
			{name="Pad 73",	 pattern="90 49 xx"},
			{name="Pad 74",	 pattern="90 4A xx"},
			{name="Pad 75",	 pattern="90 4B xx"},
			{name="Pad 76",	 pattern="90 4C xx"},
			{name="Pad 77",	 pattern="90 4D xx"},
			{name="Pad 78",	 pattern="90 4E xx"},
			{name="Pad 81",	 pattern="90 51 xx"},
			{name="Pad 82",	 pattern="90 52 xx"},
			{name="Pad 83",	 pattern="90 53 xx"},
			{name="Pad 84",	 pattern="90 54 xx"},
			{name="Pad 85",	 pattern="90 55 xx"},
			{name="Pad 86",	 pattern="90 56 xx"},
			{name="Pad 87",	 pattern="90 57 xx"},
			{name="Pad 88",	 pattern="90 58 xx"},
--]]

			{name="Pad 11 Playing",	 pattern="90 0B xx",  x="map_redrum_led(value)"},
			{name="Pad 12 Playing",	 pattern="90 0C xx",  x="map_redrum_led(value)"},
			{name="Pad 13 Playing",	 pattern="90 0D xx",  x="map_redrum_led(value)"},
			{name="Pad 14 Playing",	 pattern="90 0E xx",  x="map_redrum_led(value)"},
			{name="Pad 15 Playing",	 pattern="90 0F xx",  x="map_redrum_led(value)"},
			{name="Pad 16 Playing",	 pattern="90 10 xx",  x="map_redrum_led(value)"},
			{name="Pad 17 Playing",	 pattern="90 11 xx",  x="map_redrum_led(value)"},
			{name="Pad 18 Playing",	 pattern="90 12 xx",  x="map_redrum_led(value)"},
			{name="Pad 21 Playing",	 pattern="90 15 xx",  x="map_redrum_led(value)"},
			{name="Pad 22 Playing",	 pattern="90 16 xx",  x="map_redrum_led(value)"},
			{name="Pad 23 Playing",	 pattern="90 17 xx",  x="map_redrum_led(value)"},
			{name="Pad 24 Playing",	 pattern="90 18 xx",  x="map_redrum_led(value)"},
			{name="Pad 25 Playing",	 pattern="90 19 xx",  x="map_redrum_led(value)"},
			{name="Pad 26 Playing",	 pattern="90 1A xx",  x="map_redrum_led(value)"},
			{name="Pad 27 Playing",	 pattern="90 1B xx",  x="map_redrum_led(value)"},
			{name="Pad 28 Playing",	 pattern="90 1C xx",  x="map_redrum_led(value)"},
--[[
-- delete these

			{name="Pad 31 Playing",	 pattern="90 1F xx",  x="map_redrum_led(value)"},
			{name="Pad 32 Playing",	 pattern="90 20 xx",  x="map_redrum_led(value)"},
			{name="Pad 33 Playing",	 pattern="90 21 xx",  x="map_redrum_led(value)"},
			{name="Pad 34 Playing",	 pattern="90 22 xx",  x="map_redrum_led(value)"},
			{name="Pad 35 Playing",	 pattern="90 23 xx",  x="map_redrum_led(value)"},
			{name="Pad 36 Playing",	 pattern="90 24 xx",  x="map_redrum_led(value)"},
			{name="Pad 37 Playing",	 pattern="90 25 xx",  x="map_redrum_led(value)"},
			{name="Pad 38 Playing",	 pattern="90 26 xx",  x="map_redrum_led(value)"},
			{name="Pad 41 Playing",	 pattern="90 29 xx",  x="map_redrum_led(value)"},
			{name="Pad 42 Playing",	 pattern="90 2A xx",  x="map_redrum_led(value)"},
			{name="Pad 43 Playing",	 pattern="90 2B xx",  x="map_redrum_led(value)"},
			{name="Pad 44 Playing",	 pattern="90 2C xx",  x="map_redrum_led(value)"},
			{name="Pad 45 Playing",	 pattern="90 2D xx",  x="map_redrum_led(value)"},
			{name="Pad 46 Playing",	 pattern="90 2E xx",  x="map_redrum_led(value)"},
			{name="Pad 47 Playing",	 pattern="90 2F xx",  x="map_redrum_led(value)"},
			{name="Pad 48 Playing",	 pattern="90 30 xx",  x="map_redrum_led(value)"},
			{name="Pad 51 Playing",	 pattern="90 33 xx",  x="map_redrum_led(value)"},
			{name="Pad 52 Playing",	 pattern="90 34 xx",  x="map_redrum_led(value)"},
			{name="Pad 53 Playing",	 pattern="90 35 xx",  x="map_redrum_led(value)"},
			{name="Pad 54 Playing",	 pattern="90 36 xx",  x="map_redrum_led(value)"},
			{name="Pad 55 Playing",	 pattern="90 37 xx",  x="map_redrum_led(value)"},
			{name="Pad 56 Playing",	 pattern="90 38 xx",  x="map_redrum_led(value)"},
			{name="Pad 57 Playing",	 pattern="90 39 xx",  x="map_redrum_led(value)"},
			{name="Pad 58 Playing",	 pattern="90 3A xx",  x="map_redrum_led(value)"},
			{name="Pad 61 Playing",	 pattern="90 3D xx",  x="map_redrum_led(value)"},
			{name="Pad 62 Playing",	 pattern="90 3E xx",  x="map_redrum_led(value)"},
			{name="Pad 63 Playing",	 pattern="90 3F xx",  x="map_redrum_led(value)"},
			{name="Pad 64 Playing",	 pattern="90 40 xx",  x="map_redrum_led(value)"},
			{name="Pad 65 Playing",	 pattern="90 41 xx",  x="map_redrum_led(value)"},
			{name="Pad 66 Playing",	 pattern="90 42 xx",  x="map_redrum_led(value)"},
			{name="Pad 67 Playing",	 pattern="90 43 xx",  x="map_redrum_led(value)"},
			{name="Pad 68 Playing",	 pattern="90 44 xx",  x="map_redrum_led(value)"},
			{name="Pad 71 Playing",	 pattern="90 47 xx",  x="map_redrum_led(value)"},
			{name="Pad 72 Playing",	 pattern="90 48 xx",  x="map_redrum_led(value)"},
			{name="Pad 73 Playing",	 pattern="90 49 xx",  x="map_redrum_led(value)"},
			{name="Pad 74 Playing",	 pattern="90 4A xx",  x="map_redrum_led(value)"},
			{name="Pad 75 Playing",	 pattern="90 4B xx",  x="map_redrum_led(value)"},
			{name="Pad 76 Playing",	 pattern="90 4C xx",  x="map_redrum_led(value)"},
			{name="Pad 77 Playing",	 pattern="90 4D xx",  x="map_redrum_led(value)"},
			{name="Pad 78 Playing",	 pattern="90 4E xx",  x="map_redrum_led(value)"},
			{name="Pad 81 Playing",	 pattern="90 51 xx",  x="map_redrum_led(value)"},
			{name="Pad 82 Playing",	 pattern="90 52 xx",  x="map_redrum_led(value)"},
			{name="Pad 83 Playing",	 pattern="90 53 xx",  x="map_redrum_led(value)"},
			{name="Pad 84 Playing",	 pattern="90 54 xx",  x="map_redrum_led(value)"},
			{name="Pad 85 Playing",	 pattern="90 55 xx",  x="map_redrum_led(value)"},
			{name="Pad 86 Playing",	 pattern="90 56 xx",  x="map_redrum_led(value)"},
			{name="Pad 87 Playing",	 pattern="90 57 xx",  x="map_redrum_led(value)"},
			{name="Pad 88 Playing",	 pattern="90 58 xx",  x="map_redrum_led(value)"},

--]]
--[[


--left to right TOP
			{name="Button 91",	pattern="b0 5B xx"},
			{name="Button 92",	pattern="b0 5C xx"},
			{name="Button 93",	pattern="b0 5D xx"},
			{name="Button 94",	pattern="b0 5E xx"},
			{name="Button 95",	pattern="b0 5F xx"},
			{name="Button 96",	pattern="b0 60 xx"},
			{name="Button 97",	pattern="b0 61 xx"},
			{name="Button 98",	pattern="b0 62 xx"},
--left to right Bottom
			{name="Button 01",  pattern="b0 01 xx"},
			{name="Button 02",  pattern="b0 02 xx"},
			{name="Button 03",  pattern="b0 03 xx"},
			{name="Button 04",  pattern="b0 04 xx"},
			{name="Button 05",  pattern="b0 05 xx"},
			{name="Button 06",  pattern="b0 06 xx"},
			{name="Button 07",  pattern="b0 07 xx"},
			{name="Button 08",  pattern="b0 08 xx"},
--bottom to top Left
			{name="Button 10",	 pattern="b0 0A xx"},
			{name="Button 20",	 pattern="b0 14 xx"},
			{name="Button 30",	 pattern="b0 1E xx"},
			{name="Button 40",	 pattern="b0 28 xx"},
			{name="Button 50",	 pattern="b0 32 xx"},
			{name="Button 60",	 pattern="b0 3C xx"},
			{name="Button 70",	 pattern="b0 46 xx"},
			{name="Button 80",	 pattern="b0 50 xx"},
--bottom to top Right
			{name="Button 19",  pattern="b0 13 xx"},
			{name="Button 29",  pattern="b0 1D xx"},
			{name="Button 39",  pattern="b0 27 xx"},
			{name="Button 49",  pattern="b0 31 xx"},
			{name="Button 59",  pattern="b0 3B xx"},
			{name="Button 69",  pattern="b0 45 xx"},
			{name="Button 79",  pattern="b0 4F xx"},
			{name="Button 89",  pattern="b0 59 xx"},

--]]

		}
		remote.define_auto_outputs(outputs)
		
def_vars()

	end
end

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_process_midi(event)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Remember, RPM may get several inputs before RDM can output.
-------------------------------------------------------		
-------------------------------------------------------		
if (event.port==2 and event.size==3) then
-------------------------------------------------------
-- Take an external 2nd input note and display it.	
-------------------------------------------------------			
-- Lookup the note delivered based on the current scale grid and pad pressed.
---------------------------------------------------			
	ret = remote.match_midi("<100x>? yy zz",event) --note on or note off -- Reason sends 80 for note off, unlike LPP
	if(ret~=nil) then
			local dupes = Grid.current.duplicateNotes[ret.y]
			if (dupes) then
---------------------------------------------------			
-- Here is where we store sysex for displaying note press
-- must use a table because RDM doesn't fire off for every incoming event
---------------------------------------------------			
				for _,d in pairs(dupes) do
					local padx = Pad[d].x
					local pady = 9-Pad[d].y --because internal grids are t to b, lpp pads b to t
					if  ret.x==0 then
						table.insert(State.lightoff,table.concat({Pad[d].padhex,Grid.current.R[pady][padx],Grid.current.G[pady][padx],Grid.current.B[pady][padx]}," ")) -- Store the color of the pad for delivery later
					else 
						local rbvel=string.format("%02X",math.floor((.4*ret.z)+8))
						local gvel=string.format("%02X",math.floor(.5*ret.z))
						table.insert(State.lighton,table.concat({Pad[d].padhex,rbvel,gvel,rbvel}," "))
					end
				end
---------------------------------------------------			
-- Here is where send the translated note back to Reason
-- Saving this in case want to change it. 
-- currently just having note lane on playing track that is dup of ext midi instrm.
-- and not having it sent to Reason
---------------------------------------------------			
--				local msg={ time_stamp = event.time_stamp, item=1, value = ret.x, note = ret.y, velocity = ret.z }
--				remote.handle_input(msg)
---------------------------------------------------			
-- Now save the note for turning off notes on button press. 
---------------------------------------------------			
				Playing[ret.y] = (ret.z~=0) and ret.z or nil
			end -- dupes aka a note on grid
			return true -- absorb the incoming note
-------------------------------------------------------		
			--return false -- don't return this false, because incoming pad press is a midi note.
	end -- ret not nil
end --port is 2, size 3




-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
if event.port==1 then
-- -----------------------------------------------------------------------------------------------
-- Match buttons and notes and transpose notes.
-- -----------------------------------------------------------------------------------------------

if event.size==3 then -- Note, button, channel pressure, fader

-- 1001 is 90 (note on) 1011 is B0 (controller)	
	local ret = remote.match_midi("<10x1>? yy zz",event) --find a pad, button on or off, Not aftouch
	if(ret~=nil) then
		local button = ret.x --  check 1 = button
		ret.x = (ret.z==0) and 0 or 1 -- faking note on and off for the checks later. x is 'value', 0 or 1 for keyboard items.
		local vel_pad = ret.z

-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
		
-----------------------------------
-- handle buttons
-----------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- BUTTON HANDLE RPM
		if button==1 and (ret.y<21 or ret.y>29) then -- button, not fader mode
			table.insert(Pressed,ret.y,ret.z) -- keep track for Button[Pressed.y].RDM(z)
			local r,rhi = Button[ret.y].RPM(ret.z)
			if rhi then
				local msg={ time_stamp = event.time_stamp, item=rhi.item, value = rhi.value}
				remote.handle_input(msg)
			end
---if the pads have transposed, then we need to turn off the last note----------------------
-- This will need to move when we put in setup pages on the grid
-- but must go after the button handling
			if(State.update==1) then -- grid has changed
				for k,v in pairs(Playing) do
					local prev_off={ time_stamp = event.time_stamp, item=1, value = 0, note = k, velocity = 0 }
					remote.handle_input(prev_off)
					Playing[k]=nil --!!!
				end
--[[
-- not working
			local allstopmsg={ time_stamp = event.time_stamp, item=Itemnum.allstop, value = 1 }
			remote.handle_input(allstopmsg)
--]]
			end 


			if r then return r end -- If we need Reason not to see the press (sh,cl or shcl) then return true in the RPM func
		end
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------

--[[

			-- accent?
			local accent_pad = remote.match_midi("B? 32 zz",event) -- 50 delete
			-- make checks for these
-- -----------------------------------------------------------------------------------------------
-- Accent button
-- TODO: changing this to a pad, not button
-- -----------------------------------------------------------------------------------------------
			if(accent_pad) then
				if(accent_pad.z>0) then		  
				g.accent_dn = true
				g.accent_count = modulo(g.accent_count+1,3)
				local msg={ time_stamp = event.time_stamp, item=Itemnum.accent, value = g.accent_count, note = "32",velocity = accent_pad.z }
				remote.handle_input(msg)
				--g.note_delivered = noteout -- depreciated
				return true
				else
				return false
				end
			end
--]]

-----------------------------------
-- end handle buttons
-----------------------------------
--------------------------------------------------------------------------------------------------------------------------		
--------------------------------------------------------------------------------------------------------------------------		

	
--------------------------------------------------------------------------------------------------------------------------		
-- here's where the incoming note gets transposed!
--------------------------------------------------------------------------------------------------------------------------		
		if (button==0) then
-------------------------------------------------------		
-- NEW MODES test here
---------------------------------------------------			
-- Lookup the note delivered based on the current scale grid and pad pressed.
---------------------------------------------------			
			local padx = Pad[ret.y].x
			local pady = 9-Pad[ret.y].y --because internal grids are t to b, lpp pads b to t
			local noteout = Grid.current.midiout[pady][padx]


			if (noteout<128 and noteout>0) then
				local dupes = Grid.current.duplicatePads[ret.y] -- ret.y is pad num 11-88
---------------------------------------------------			
-- Here is where we store sysex for displaying note press
-- must use a table because RDM doesn't fire off for every incoming event
---------------------------------------------------			
				for _,d in pairs(dupes) do
					if  ret.z==0 then --note off
						table.insert(State.lightoff,table.concat({Pad[d].padhex,Grid.current.R[pady][padx],Grid.current.G[pady][padx],Grid.current.B[pady][padx]}," "))
					else 
						local vel=string.format("%02X",math.floor(.5*ret.z)) -- COLOR OF Playing Pads
						table.insert(State.lighton,table.concat({Pad[d].padhex,vel,vel,vel}," ")) -- Grey based on velocity
					end
				end
---------------------------------------------------			
-- Here is where send the translated note back to Reason
---------------------------------------------------			
				local msg={ time_stamp = event.time_stamp, item=1, value = ret.x, note = noteout,velocity = ret.z }
				remote.handle_input(msg)
---------------------------------------------------			
-- Now save the note for turning off notes on button press. 
---------------------------------------------------			
				Playing[noteout] = (ret.z~=0) and ret.z or nil
			end
			return true -- absorb the incoming note, even if it's transposed out of range
-------------------------------------------------------		
			--return false -- don't return this false, because incoming pad press is a midi note.
		end -- not button
	end -- ret not nil

-----------------------------------
-- 1010 is poly aftertouch
-- 1101 is channel aftertouch
-- TODO: map poly to chan, maybe display output
-- poly not supported in reason...	
-----------------------------------
-- return false here means chan aftert gets passed on to Reason
	return false
	
end -- eventsize=3
--3
-------------------------------------------------------

	
-- -----------------------------------------------------------------------------------------------
-- Return from scrolling text	
-- -----------------------------------------------------------------------------------------------
if event.size==8 then
	local textreturnswitch = remote.match_midi("F0 00 20 29 02 10 15 F7",event) --find if we are retuning from scrolling text
	if (textreturnswitch) then
		-- probably do nothing
		Layout.set_mode=4
		Layout.set_frlight=1-- should flash it back to frlight on
	end
	return true
end -- eventsize=8
--8
-------------------------------------------------------

-- -----------------------------------------------------------------------------------------------
-- Keep it in programmer mode	
-- -----------------------------------------------------------------------------------------------
-- TODO in the future we will allow other modes... fader, etc.

if event.size==9 then
	local modeswitch = remote.match_midi("F0 00 20 29 02 10 2F xx F7",event) --find what mode we are in
	local livemodeswitch = remote.match_midi("F0 00 20 29 02 10 2D xx F7",event) --find if we are in live mode (At startup, we turn on standalone, which fires this.)
	if (modeswitch) then
		Layout.mode=modeswitch.x
		if modeswitch.x ~=3 then
			Layout.set_mode=3
		end
	elseif (livemodeswitch) then 
			Layout.set_mode=3
	end
	
-- This next will only be sent on the 1st LPP midi channel, so it's not relevant here.
--[[
	local livemodeswitch = remote.match_midi("F0 00 20 29 02 10 2D xx F7",event) --find if we are in live mode
	if(livemodeswitch) then
		Layout.livemode=livemodeswitch.x
		if livemodeswitch.x ~=1 then
			Layout.set_livemode=1
		end
	
	end
--]]
	return true
end -- eventsize=9
--9
-- -----------------------------------------------------------------------------------------------
end -- event.port ==1





end --RPM
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_deliver_midi(maxbytes,port)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	if(port==1) then
		local lpp_events={}
		local padevent={}
		local padupdate={}
		local mode_event={}
		local frlight_event={}
		local iskong = false
		local isvarchange = false
		local istracktext = false

-- -----------------------------------------------------------------------------------------------
-- Keep it in programmer mode	FOR NOW
-- -----------------------------------------------------------------------------------------------
		if Layout.set_mode~=Layout.mode then
			mode_event = remote.make_midi("F0 00 20 29 02 10 2C xx F7",{ x = Layout.set_mode, port=1 })
			table.insert(lpp_events,mode_event)
			frlight_event = remote.make_midi("F0 00 20 29 02 10 0A 63 32 F7",{ port=1 }) --Front light purp
			table.insert(lpp_events,frlight_event)
			Layout.mode=Layout.set_mode
			Layout.set_frlight=1
			return lpp_events
		end
-- This next will switch the unit to the 1st LPP midi channel in Live mode, so it's not relevant here.
--[[
		if g.set_livemode~=g.livemode then
			local livemode_event = remote.make_midi("F0 00 20 29 02 10 21 xx F7",{ x = g.set_livemode, port=1 })
			table.insert(lpp_events,livemode_event)
			g.livemode=g.set_livemode
		end
--]]
		if Layout.set_frlight~=0 then
			frlight_event = remote.make_midi("F0 00 20 29 02 10 0A 63 32 F7",{ port=1 }) --Front light purp
			table.insert(lpp_events,frlight_event)
			Layout.set_frlight=0
--			return lpp_events
		end
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- BUTTON HANDLE RDM
	for k,v in pairs(Pressed) do
		for _,e in pairs(Button[k].RDM(v)) do table.insert(lpp_events,e) end
		Pressed[k]=nil -- !!!!
	end
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------

		
-- start del		
-- -----------------------------------------------------------------------------------------------
		--if vartext from _Var item in remotemap has changed	-----------------
-- -----------------------------------------------------------------------------------------------
-- unneeded
		if Variation_prev~=Variation then
			--Let the LCD know what the variation is
			local vartext = remote.get_item_text_value(Itemnum.var)



			Variation_prev = Variation
			isvarchange = true
		end

-- -----------------------------------------------------------------------------------------------
			--parse the text to see if there's any scale or transpose info----------------------------------------
-- -----------------------------------------------------------------------------------------------
			if istracktext==true then			
				--if scopetext from _Scope item has changed	
				if Scope_prev~=Scope then
	
					--detect Redrum
					--if(Scope=="Redrum") then
						--noscaleneeded = true	
						--do_update_pads = 0
						--g.clearpads = 1
					--else
						if(noscaleneeded == true) then						
							do_update_pads = 1
						end
						noscaleneeded = false
					--end
					--if we've landed on a Kong, _Scope reports "KONG" and we change to drum scale
					if(Scope=="Kong" and scale_int~=7) then
						if scale_from_parse==false then
							global_scale = scale_int
						end
--						set_scale(7) -- unused
						iskong = true
					else
						use_global_scale = true
					end
					Scope_prev = Scope
				end
			end
-- -----------------------------------------------------------------------------------------------
-- end del



-- -----------------------------------------------------------------------------------------------
-- color the pads if scale or transpose changed----------------------------------------
-- -----------------------------------------------------------------------------------------------		
		if (do_update_pads==1) or (State.update==1) then
-- TODO no more drumpad
--			if(Scope~='Redrum') then

				local padsysex = ""
				for ve=1,8 do for ho=1,8 do 
					local padnum = Padindex[((ve-1)*8)+ho].padhex --note# that the controller led responds to
					padsysex=table.concat({padsysex,padnum,Grid.current.R[9-ve][ho],Grid.current.G[9-ve][ho],Grid.current.B[9-ve][ho]}," ") -- lpp pads b to t, not t to b
				end end 

				padupdate=remote.make_midi(table.concat({sysex_setrgb,padsysex,sysend}," "))
				table.insert(lpp_events,padupdate)



--[[				
-- TODO no more drumpad
			elseif Scope=='Redrum' then

				--do drumpad color scheme
				for i=1,64,1 do
--					local padnum = string.format("%x",i+36) --note# that the controller led responds to
					local padnum = Padindex[i].padhex --note# that the controller led responds to
					local right = modulo(math.floor(i/4),2)
					--remote.trace("\nside "..right.." div "..math.floor(i/4).." i "..i)
					if(right==1) then
						padevent[i]=remote.make_midi("90 "..padnum.." 20")
						table.insert(lpp_events,padevent[i])
					else
						padevent[i]=remote.make_midi("90 "..padnum.." 40")
						table.insert(lpp_events,padevent[i])
					end
				end


--]]				
--			end -- drumpad or not
			
		do_update_pads=0
		State.update=0
			
		end --update_pads, State.update ==1
-- -----------------------------------------------------------------------------------------------
-- end if do_update_pads==1 or State.update==1
-- -----------------------------------------------------------------------------------------------


-- -----------------------------------------------------------------------------------------------
--ReDrum
--[[
--TODO
-- -----------------------------------------------------------------------------------------------
		if(Scope=="Redrum") then

--local padnotes = {60,61,62,63,64,65,66,67, 52,53,54,55,56,57,58,59, 44,45,46,47,48,49,50,51}
--			local padnotes = {31,32,33,34,35,36,37,38}
			--if we've just landed on Redrum, we need to clear out the 3rd row of pads, otherwise they maintain LEDs from pvs scope
			if g.clearpads==1 then
				for ve=1,8 do for ho=1,8 do 
					local padnum = Padindex[((ve-1)*8)+ho].padhex --note# that the controller led responds to
					padsysex=table.concat(padsysex,padnum,0,0,0," ")
				end end 

				padupdate=remote.make_midi(table.concat({sysex_setrgb,padsysex,sysend}," "))
				table.insert(lpp_events,padupdate)
		table.insert(lpp_events,remote.make_midi("F0 00 20 29 02 10 0E 00 F7")) -- Blank all

					g.clearpads=0
			end
		--flash drums playing on selected pads
			for dpad=1,8 do
				local led_value = 0
				led_value = make_led_value(dpad,4,32) --cyan/blue for drum selects
				local last_value = g.last_led_output[dpad]
				if led_value ~= last_value then
					-- send note
		--			local padnum = string.format("%02x",padnotes[pad])
		--			local padnum = Padindex[i].padhex
		--			local padnum = Padindex[padnotes[pad] ].padhex
					local padnum = Pad[dpad+30].padhex
					local event = remote.make_midi("90 "..padnum.." xx", { x=led_value })
					table.insert(lpp_events,event)
					-- FL: Change "sent", set last value
					g.last_led_output[pad] = led_value
				end
			end
		--Pad 32 controls the Accent 3way.
			local acc_colors = {3,13,5} --wh,yel,red
			if g.last_accent ~= g.accent then
				g.accent_dn = false
				local acccolor = acc_colors[(g.accent+1)]
		--		local accnote = string.format("%02x",43)
				local accnote = Padindex[32].padhex -- "30"
				local event = remote.make_midi("90 "..accnote.." xx", { x=acccolor })
				table.insert(lpp_events,event)
				g.last_accent = g.accent
			end
		end
-- -----------------------------------------------------------------------------------------------
--]]
---------------------------------------------------			
-- Here is where we send sysex for display note press
---------------------------------------------------			
		if (table.getn(State.lighton) ~= 0) then
			padupdate=remote.make_midi(table.concat({sysex_setrgb,table.concat(State.lighton," "),sysend}," "))
			table.insert(lpp_events,padupdate)
			for k,_ in pairs(State.lighton) do State.lighton[k] = nil end
			--State.lighton ={}
		end
		if (table.getn(State.lightoff) ~= 0) then
			padupdate=remote.make_midi(table.concat({sysex_setrgb,table.concat(State.lightoff," "),sysend}," "))
			table.insert(lpp_events,padupdate)
			for k,_ in pairs(State.lightoff) do State.lightoff[k] = nil end
			--State.lightoff ={}	
		end

---------------------------------------------------	
--Send out a bunch of MIDI to the Launchpad Pro
---------------------------------------------------	
		return lpp_events 
	end --end port==1
	
	
	if(port==2) then
--[[
		local le = lcd_events
		lcd_events ={}
		return le
--]]
	end


end -- RDM
-- 
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++







-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_probe()
	return {
	}
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_on_auto_input(item_index)
--	g.last_input_time = remote.get_time_ms()
--	g.last_input_item = item_index
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Caution, RSS fires off before RPM and RDM
function remote_set_state(changed_items)
--tprint(changed_items)

	--look for the _Scope constant. Kong reports "KONG". Could use for a variety of things
	Scope = remote.is_item_enabled(Itemnum.scope) and remote.get_item_text_value(Itemnum.scope) or ""
	Variation = remote.is_item_enabled(Itemnum.var) and remote.get_item_text_value(Itemnum.var) or ""


	-- FL: Collect all changed states for redrum "drum playing" - this part blinks the 3rd row drum selection pads

	for k,item_index in ipairs(changed_items) do
--[[
		if item_index == Itemnum.accent then
			g.accent = remote.get_item_value(item_index)
		end
	

		if item_index >= Itemnum.first_step_item and item_index < Itemnum.first_step_item+8 then
			local step_index = item_index - Itemnum.first_step_item + 1
			g.step_value[step_index] = remote.get_item_value(item_index)
			-- FL: Add this if the item can be disabled
			-- g.step_is_disabled[step_index] = remote.is_item_enabled(item_index)

		elseif item_index >= Itemnum.first_step_playing_item and item_index < Itemnum.first_step_playing_item+8 then
			local step_index = item_index - Itemnum.first_step_playing_item + 1
			g.step_is_playing[step_index] = remote.get_item_value(item_index)
		end
		
--]]

-- old trackname or 'copy' so the first time you get it it doesnt update, but if you click around it does.
-- so you can duplicate a device while in a new mode, sc, tr and no change

		if item_index == Itemnum.trackname then
			local tn = string.lower(remote.get_item_text_value(item_index))
			if tn ~= State.trackname then
--				if not (string.find(tn,"transport") or string.find(tn," copy")) then
				if not (string.find(tn,"transport") or string.find(tn," copy") or string.find(tn,State.trackname,1,true)) then
					if string.find(tn,"lpp") then
						local out={}
						out.scale = tonumber(string.match(tn,"s(%d+)"))
						out.mode = tonumber(string.match(tn,"m(%d+)")) 
						out.rotate = tonumber(string.match(tn,"r(%d)"))
						out.palette = tonumber(string.match(tn,"p(%d+)"))
						out.transpose = string.match(tn,"t(%-%d+)") or string.match(tn,"t(%d+)")
						out.transpose = tonumber(out.transpose)
						State.do_update(out)
					end
				end
				State.trackname=tn
--error(State.trackname)
			end
			-- error(remote.get_item_text_value(item_index))
		end
	
	end

end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_prepare_for_use()
	local retEvents={
		--default settings for Launchpad Pro

		remote.make_midi("F0 00 20 29 02 10 21 01 F7"), -- set standalone mode
		remote.make_midi("F0 00 20 29 02 10 0A 63 32 F7"), --Front light
--[[
		remote.make_midi("F0 00 20 29 02 10 2C 03 F7"), -- Programmer mode
		remote.make_midi("F0 00 20 29 02 10 0E 00 F7"), -- Blank all
--		remote.make_midi("F0 00 20 29 02 10 14 32 00 07 05 52 65 61 73 6F 6E F7"), -- scroll Reason
--		remote.make_midi("F0 00 20 29 02 10	 F7"),
--		remote.make_midi("F0 00 20 29 02 10	 F7"),
--send all local off on settings ch 16	191,122,64 
--		remote.make_midi("bF 7A 40")
--]]
	}
	State.do_update({scale=1,mode=1,palette=1,transpose=0,rotate=1})
	table.insert(Pressed,70,1) -- button feedback sh cl init light

	return retEvents
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_release_from_use()
	local retEvents={
--		remote.make_midi("F0 00 20 29 02 10 2C 03 F7"), -- P mode
	}
	return retEvents
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function def_vars()
	local index=1
	for ve=1,8 do --horizontal from bottom
		for ho=1,8 do -- vertical from left
			local thispad=(ve*10)+ho  --11-18 ... 81-88
			local thispadhex=string.format("%02X",thispad)

			table.insert(Pad,thispad,{
							padhex=thispadhex,
							index=index,
							itemindex=(index-1)+Itemnum.first_pad,
							x=ho,
							y=ve,
			})
			table.insert(Padindex,index,{
							pad=thispad,
							padhex=thispadhex,
							itemindex=(index-1)+Itemnum.first_pad,
							x=ho,
							y=ve,
			})
			index=index+1 --index so I can cycle through the 64 pads quickly.
		end
	end
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- button lookup!
-- I debated having shiftclick add 100,200,300 to the button numbers
-- and thus x4 the amount of functions. Decided against it.
-- shiftclick: 0=none, 1=shift 2=click 3=both
-- 
-- RPM,RDM takes in z (vel) so we can show things only while pressed.
-- RDM needs to return empty table or table of midi events.
--
-- If we need Reason not to see the press (sh,cl or shcl) 
-- then return true in the RPM func (Still passes to RDM though!)
-- RPM returns t|f, {rpi table item, value}
-- 
-- Add a button to sh or cl (Playing) if we need to display it 
-- to show that something has a different state when func buttons pressed
-- When adding (Pressed) use 1, actual press z is 127!
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Button = {
--left to right Top 
[91]={ -- scale_up
		RPM=function(z) 
			if z>0 then
				if State.shiftclick == 0 then
					State.do_update({mode=Mode.last+1})
				elseif State.shiftclick == 1 then -- scale
					State.do_update({scale=Scale.last+1})
				elseif State.shiftclick == 2 then -- ???
--TODO Enable track select????
					return false -- mapped to track select
				elseif State.shiftclick == 3 then -- color palette
					State.do_update({palette=Palette.last+1})
				end	
			end
			return true
		end,
		RDM=function(z) --91
				local bfevent={}
			if z>0 then
				if State.shiftclick == 0 then
					local color_ind = (modulo(Mode.last-1,12)) --change color every Note, show root -1 because pal start at 0
					local Mn = Modenames[1+modulo(Mode.last-1,table.getn(Modenames))]
					local Mc = Modes[Mn].color
					table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,
						"5B",Mc.R, Mc.G, Mc.B,
						"5C",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,sysend}," ")))
				elseif State.shiftclick == 1 then
					local color_ind = (modulo(Scale.last-1,12)) --change color every Note, show root
					table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,
						"5B",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,
						"5C",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,sysend}," ")))					
				elseif State.shiftclick == 2 then
					table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,"5B","3F","3F","3F",sysend}," ")))
					table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,"5C","3F","3F","3F",sysend}," ")))
				elseif State.shiftclick == 3 then
					local color_ind = (modulo(Palette.last-1,12)) --change color every Note, show root
					table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,
						"5B",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,
						"5C",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,sysend}," ")))
				end	
--error(tblprint(bfevent))
			end
				return bfevent
		end
	},
[92]={ -- scale_dn
		RPM=function(z) 
			if z>0 then
				if State.shiftclick == 0 then
					State.do_update({mode=Mode.last-1})
				elseif State.shiftclick == 1 then -- scale
					State.do_update({scale=Scale.last-1})
				elseif State.shiftclick == 2 then -- ???
					return false -- mapped to track select
--					State.do_update({rotate=State.rotate-1})
				elseif State.shiftclick == 3 then -- color palette
					State.do_update({palette=Palette.last-1})
				end	
			end
			return true
		end,
		RDM=function(z) --92
			return Button[91].RDM(1) -- same code for both
		end
	},
[93]={ -- tran_up
		RPM=function(z) 
			if z>0 then
				if State.shiftclick < 2 then
					local transchk=false
					if Grid.current.midihi+(1-State.shift)+(State.shift*12) > 127 then
						transchk=true
					end
					if transchk==false then
						State.do_update({transpose=Transpose.last+(1-State.shift)+(State.shift*12)}) -- if sh pressed, add 12, else just 1
					end
				elseif State.shiftclick == 2 then -- ???
					return false -- target prev track
				elseif State.shiftclick == 3 then -- rotate
					State.do_update({rotate=State.rotate+1})
				end	
			end
			return true
		end,
		RDM=function(z) --93
			local bfevent={}
			if z>0 then
				if State.shiftclick < 2 then
					local color_ind = (modulo(Transpose.last,12)) --change color every Note, show root
					if Transpose.last>0 then
						table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,"5D",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,"5E","00","00","00",sysend}," ")))
					elseif Transpose.last<0 then
						table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,"5D","00","00","00","5E",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,sysend}," ")))
					elseif Transpose.last==0 then
						table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,"5D",Palette.current[color_ind].R ,Palette.current[color_ind].G, Palette.current[color_ind].B,"5E",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,sysend}," ")))
					end	
				elseif State.shiftclick == 2 then
					table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,"5D","3F","3F","3F",sysend}," ")))
					table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,"5E","3F","3F","3F",sysend}," ")))
				elseif State.shiftclick == 3 then
					local color_ind = (modulo(State.rotate-1,12)) --change color every Note, show root
					table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,
						"5D",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,
						"5E",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,sysend}," ")))
				end	
--error(tblprint(bfevent))
			end
				return bfevent
		end
	},

[94]={ -- tran_dn
		RPM=function(z) 
			if z>0 then
				if State.shiftclick < 2 then
					local transchk=false
					if Grid.current.midilo-(1-State.shift)-(State.shift*12) < 0 then
						transchk=true
					end
					if transchk==false then
						State.do_update({transpose = Transpose.last-(1-State.shift)-(State.shift*12)}) -- if sh pressed, sub 12, else just 1
					end
				elseif State.shiftclick == 2 then -- ???
					return false -- target next track
				elseif State.shiftclick == 3 then -- rotate
					State.do_update({rotate=State.rotate-1})
				end	
			end
			return true
		end,
		RDM=function(z) --94
			return Button[93].RDM(1) -- same code for both
		end
	},

[95]={ --Session
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					return false
					
				elseif State.shiftclick == 1 then
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
			return true 
		end,
									
		RDM=function(z) --95
				local bfevent={}
			if z>1 then
				if     State.shiftclick == 0 then
				
				elseif State.shiftclick == 1 then
					bfevent = scroll_status(table.concat({"S",Scale.last," ", Scalenames[1+modulo(Scale.last-1,table.getn(Scalenames))]},''))
				elseif State.shiftclick == 2 then
					bfevent = scroll_status(table.concat({'M',tostring(Mode.last),' S',tostring(Scale.last),' T',tostring(Transpose.last),' R',tostring(State.rotate),' P',tostring(Palette.last)},''))	
				elseif State.shiftclick == 3 then
					bfevent = scroll_status(table.concat({"M",Mode.last," ", Modenames[1+modulo(Mode.last-1,table.getn(Modenames))]},''))

				end	
			elseif z==1 then -- sh cl lights
				if     State.shiftclick == 0 then
					table.insert(bfevent,remote.make_midi("90 5F 17")) --
				elseif State.shiftclick == 1 then
					local color_ind = (modulo(Scale.last-1,12)) --change color every Note, show root
					table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,"5F",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,sysend}," ")))					
				elseif State.shiftclick > 1 then
					local color_ind = (modulo(Mode.last-1,12)) --change color every Note, show root -1 because pal start at 0
					table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,"5F",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,sysend}," ")))
										
				end	
			end
		return bfevent end
	},

[96]={ --Note
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
-- TODO setup page					
				elseif State.shiftclick == 2 then
-- TODO setup page										
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z) --96
			local bfevent={}
			if z>0 then
				if     State.shiftclick == 0 then
-- TODO sysex
					table.insert(bfevent,remote.make_midi("90 60 07")) -- 

				end	
			end
		return bfevent end
	},

[97]={ --Device
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
			local bfevent={}
			if z>0 then
				if     State.shiftclick == 0 then
-- TODO sysex
					table.insert(bfevent,remote.make_midi("90 61 15")) -- 

			
				end	
			end
		return bfevent end
	},
	
[98]={ --User
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
			local bfevent={}
			if z>0 then
				if     State.shiftclick == 0 then
-- TODO sysex
					table.insert(bfevent,remote.make_midi("90 62 05")) -- 

			
				end	
			end
		return bfevent end
	},
	
--left to right Bottom
[01]={ -- record arm
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},
	
[02]={ -- track select
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[03]={ -- mute
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[04]={ -- solo
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[05]={ -- volume
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[06]={ -- pan
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[07]={ -- sends
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[08]={ -- stop clip
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

--bottom to top Left
[10]={ -- circle
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then -- pb
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
			local bfevent={}
			if z>1 then
				if     State.shiftclick == 0 then
				
				elseif State.shiftclick == 1 then

				elseif State.shiftclick == 2 then

				elseif State.shiftclick == 3 then


				end	
			elseif z==1 then -- sh cl lights
				if     State.shiftclick == 0 then
					table.insert(bfevent,remote.make_midi("90 5F 00")) -- off   
				elseif State.shiftclick == 1 then
					local color_ind = (modulo(Scale.last-1,12)) --change color every Note, show root
					table.insert(bfevent,remote.make_midi(table.concat({sysex_setrgb,"5F",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,sysend}," ")))					
				elseif State.shiftclick > 1 then
					local color_ind = (modulo(Mode.last-1,12)) --change color every Note, show root -1 because pal start at 0
					table.insert(bfevent,remote  
					.make_midi(table.concat({sysex_setrgb,"5F",Palette.current[color_ind].R, Palette.current[color_ind].G, Palette.current[color_ind].B,sysend}," ")))
										
				end	
			end
		return bfevent end
	},

[20]={ -- double
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then -- pb
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[30]={ -- duplicate
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then -- pb
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[40]={ -- quantize
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then -- pb
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[50]={ -- delete
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then -- pb
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[60]={ -- undo
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then -- pb
					
				elseif State.shiftclick == 1 then
					local handle={ item=Itemnum.redo, value = 1 }
					return true,handle 
				elseif State.shiftclick == 2 then
					local handle={ item=Itemnum.undo, value = 1 }
					return true,handle 
				elseif State.shiftclick == 3 then
					
				end	
			end
			return true 
		end,
									
		RDM=function(z)
		return {} end
	},
-----------------------------------
[70]={ -- Click
		RPM=function(z)
			State.click = z>0 and 1 or 0
			State.shiftclick = State.shift + (2*State.click)  -- 0,1,2,3                         
			return true
		end,
		RDM=function(z)
			local colors = {"21","21","05","31"} -- green, red, purp
			local bfevent={}                                                                            
			table.insert(bfevent,remote.make_midi("90 46 "..colors[1+(2*State.click)+State.shift])) -- 1234   
			table.insert(bfevent,remote.make_midi("90 50 "..colors[1+(2*State.shift)+State.click])) -- 1324
-- Here we list the buttons that are changed on sh/cl.
-- We have to add to pressed and let that handle the function on the next event,
-- bfevent from other RDM function could be multiple.
			table.insert(Pressed,91,1) -- button feedback
			table.insert(Pressed,93,1) -- button feedback
			table.insert(Pressed,95,1) -- button feedback
			table.insert(Pressed,96,1) -- button feedback
			table.insert(Pressed,97,1) -- button feedback
			table.insert(Pressed,98,1) -- button feedback
--error(tblprint(Pressed))

			return bfevent
		end
	},
[80]={ -- Shift
		RPM=function(z)
			State.shift = z>0 and 1 or 0
			State.shiftclick = State.shift + (2*State.click)  -- 0,1,2,3                      
			return true
		end,
		RDM=function(z)
--[[
			local colors = {"21","21","05","31"} -- green, red, purp
			local bfevent={}
			table.insert(bfevent,remote.make_midi("90 50 "..colors[1+(2*State.shift)+State.click])) -- 1324
			table.insert(bfevent,remote.make_midi("90 46 "..colors[1+(2*State.click)+State.shift])) -- 1234    
			return bfevent
--]]
			return Button[70].RDM(1) -- same for both
		end
	},
-----------------------------------
--bottom to top Right
[19]={
		RPM=function(z)
		end,
									
		RDM=function(z)
				local bfevent={}
--			if z>0 then
				if     State.shiftclick == 0 then
					bfevent = scroll_status(table.concat({'M',tostring(Mode.last),' S',tostring(Scale.last),' T',tostring(Transpose.last),' P',tostring(Palette.last),' r',tostring(State.rotate)},''))
				elseif State.shiftclick == 1 then
					bfevent = scroll_status(table.concat({"M",Mode.last," ", Modenames[1+modulo(Mode.last,table.getn(Modenames))]},''))
					
				elseif State.shiftclick == 2 then
					bfevent = scroll_status(table.concat({"New TN is _", State.trackname},''))					
				elseif State.shiftclick == 3 then
					
				end	
--			end
				Layout.set_frlight=1
			
		return bfevent end
	},

[29]={
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[39]={
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[49]={
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[59]={
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[69]={
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[79]={
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then
					
				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},

[89]={
		RPM=function(z)
			if z>0 then
				if     State.shiftclick == 0 then

				elseif State.shiftclick == 1 then
					
				elseif State.shiftclick == 2 then
					
				elseif State.shiftclick == 3 then
					
				end	
			end
		end,
									
		RDM=function(z)
		return {} end
	},



}
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
