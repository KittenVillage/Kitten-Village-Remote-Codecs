-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Launchpad Pro Lua Codec and Remote Map
-- by Catblack@gmail.com
--
-- Please paypal me $10 if you like this!
--
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Variable defs
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The default pallette for the Launchpad Pro is based on Ableton Live
-- and it's kind of a mess. 
-- These color names will work for now.
--[[
padcolor = {}
padcolor.BLACK = 0
padcolor.DARK_GREY = 1
padcolor.GREY = 2
padcolor.WHITE = 3
padcolor.RED = 5
padcolor.RED_HALF = 7
padcolor.ORANGE = 9
padcolor.ORANGE_HALF = 11
padcolor.AMBER = 96
padcolor.AMBER_HALF = 14
padcolor.YELLOW = 13
padcolor.YELLOW_HALF = 15
padcolor.DARK_YELLOW = 17
padcolor.DARK_YELLOW_HALF = 19
padcolor.GREEN = 21
padcolor.GREEN_HALF = 27
padcolor.MINT = 29
padcolor.MINT_HALF = 31
padcolor.LIGHT_BLUE = 37
padcolor.LIGHT_BLUE_HALF = 39
padcolor.BLUE = 45
padcolor.BLUE_HALF = 47
padcolor.DARK_BLUE = 49
padcolor.DARK_BLUE_HALF = 51
padcolor.PURPLE = 53
padcolor.PURPLE_HALF = 55
padcolor.DARK_ORANGE = 84
--]]

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
-- Scales tbd
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
scales = {
	Chromatic = {0,1,2,3,4,5,6,7,8,9,10,11},
	DrumPad = {0,1,2,3, 16,17,18,19, 4,5,6,7, 20,21,22,23, 8,9,10,11, 24,25,26,27, 12,13,14,15, 28,29,30,31},
	Major = {0,2,4,5,7,9,11,12},
	Minor = {0,2,3,5,7,8,10,12},
	Dorian = {0,2,3,5,7,9,10,12},
	Mixolydian = {0,2,4,5,7,9,10,12},
	Lydian = {0,2,4,6,7,9,11,12},
	Phrygian = {0,1,3,5,7,8,10,12},
	Locrian = {0,1,3,4,7,8,10,12},
	Diminished = {0,1,3,4,6,7,9,10,12},
	Whole_half = {0,2,3,5,6,8,9,11,12},
	WholeTone = {0,2,4,6,8,10,12},
	MinorBlues = {0,3,5,6,7,10,12},
	MinorPentatonic = {0,3,5,7,10,12},
	MajorPentatonic = {0,2,4,7,9,12},
	HarmonicMinor = {0,2,3,5,7,8,11,12},
	MelodicMinor = {0,2,3,5,7,9,11,12},
	DominantSus = {0,2,5,7,9,10,12},
	SuperLocrian = {0,1,3,4,6,8,10,12},
	NeopolitanMinor = {0,1,3,5,7,8,11,12},
	NeopolitanMajor = {0,1,3,5,7,9,11,12},
	EnigmaticMinor = {0,1,3,6,7,10,11,12},
	Enigmatic = {0,1,4,6,8,10,11,12},
	Composite = {0,1,4,6,7,8,11,12},
	BebopLocrian = {0,2,3,5,6,8,10,11,12},
	BebopDominant = {0,2,4,5,7,9,10,11,12},
	BebopMajor = {0,2,4,5,7,8,9,11,12},
	Bhairav = {0,1,4,5,7,8,11,12},
	HungarianMinor = {0,2,3,6,7,8,11,12},
	MinorGypsy = {0,1,4,5,7,8,10,12},
	Persian = {0,1,4,5,6,8,11,12},
	Hirojoshi = {0,2,3,7,8,12},
	InSen = {0,1,5,7,10,12},
	Iwato = {0,1,5,6,10,12},
	Kumoi = {0,2,3,7,9,12},
	Pelog = {0,1,3,4,7,8,12},
	Spanish = {0,1,3,4,5,6,8,10,12}
}
scalenames = {
			'Major','Minor','Dorian','Mixolydian', 
			'Lydian','Phrygian','Chromatic','DrumPad', 
			'Locrian','Diminished','Whole_half','WholeTone','MinorBlues','MinorPentatonic','MajorPentatonic','HarmonicMinor','MelodicMinor','DominantSus','SuperLocrian','NeopolitanMinor','NeopolitanMajor','EnigmaticMinor','Enigmatic','Composite','BebopLocrian','BebopDominant','BebopMajor','Bhairav','HungarianMinor','MinorGypsy','Persian','Hirojoshi','InSen','Iwato','Kumoi','Pelog','Spanish'
			}
scaleabrvs = {
			Session='SS',Auto='AA',Chromatic='CH',DrumPad='DR',Major='MM',Minor='nn',Dorian='II',Mixolydian='V_',
			Lydian='IV',Phrygian='IH',Locrian='VH',Diminished='d-',Wholehalf='Wh',WholeTone='WT',MinorBlues='mB',
			MinorPentatonic='mP',MajorPentatonic='MP',HarmonicMinor='mH',MelodicMinor='mM',DominantSus='Ds',SuperLocrian='SL',
			NeopolitanMinor='mN',NeopolitanMajor='MN',EnigmaticMinor='mE',Enigmatic='ME',Composite='Cp',BebopLocrian='lB',
			BebopDominant='DB',BebopMajor='MB',Bhairav='Bv',HungarianMinor='mH',MinorGypsy='mG',Persian='Pr',
			Hirojoshi='Hr',InSen='IS',Iwato='Iw',Kumoi='Km',Pelog='Pg',Spanish='Sp'
			}

--[[
sevseg = {
		A='0a',B='0b',C='0c',D='0d',E='0e',F='0f',G='10',H='11',I='12',J='13',K='14',L='15',M='16',N='17',O='18',P='19',Q='1a',R='1b',S='1c',T='1d',U='1e',V='1f',W='20',X='21',Y='22',Z='23',
		a='0a',b='0b',c='0c',d='0d',e='0e',f='0f',g='10',h='11',i='12',j='13',k='14',l='15',m='16',n='17',o='18',p='19',q='1a',r='1b',s='1c',t='1d',u='1e',v='1f',w='20',x='21',y='22',z='23'
		}
sevseg[0]='00'
sevseg[1]='01'
sevseg[2]='02'
sevseg[3]='03'
sevseg[4]='04'
sevseg[5]='05'
sevseg[6]='06'
sevseg[7]='07'
sevseg[8]='08'
sevseg[9]='09'
sevseg['-']='2A'
sevseg['_']='27'
sli_start=4
sli_end=12
--]]
-- These are set in remote_on_auto_input() 
g_last_input_time=0
g_last_input_item = nil

g_delivered_transpose=0 --for change filter
transpose = 0
-- tran_rst = true -- stops transpose











-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--WHAT TO KEEP??

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


shift = 0
root = 36
scalename = 'Major'
scale = scales[scalename]
scale_int = 0;
g_delivered_scale=0 --for change filter
drum_mode = 0;
--drum_tog = true -- force drums
g_delivered_shift=0 --for change filter
tranup_btn = 0 --transpose up button state up or down
trandn_btn = 0 --transpose down button state up or down
transpose_changed = false
init=1
global_scale = 0
global_transp = 0
scale_from_parse = false

g_is_lcd_enabled = false
--g_lcd_state = string.format("%-16.16s","L C D")
g_lcd_state = "LCD"
--g_delivered_lcd_state = string.format("%-16.16s","#")
g_delivered_lcd_state = "#"
g_delivered_note = 0
g_scope_item_index = 2 -- "_Scope" is item 2 in the table
g_var_item_index = 3 -- "_Var" is item 3 in the table

--FOR REDRUM BLINKING LIGHTS
g_step_value = { 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 }
g_step_is_playing = { 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 }
-- FL: Add state for the latest LED/Pad MIDI messages sent
g_last_led_output = { 100,100,100,100, 100,100,100,100, 100,100,100,100, 100,100,100,100, 100,100,100,100, 100,100,100,100 }

-- FL: Assign to these the index to the first the corresponding items according
-- to the definition list in remote_init. (Or assign them when defining the items, depending on how you do that.)
k_first_step_item = 61
k_first_step_playing_item = 94
k_accent = 77
----Tbtn starts at item 121 in the items index, 10 is the note number of Tbtn1. wonky way to get item #
g_Tbtn_firstitem = 121
g_accent = 0
g_last_accent = 0
g_accent_dn = false
g_accent_count = 0


colors = {"02","04","08","10","20","40","7F"}

noscaleneeded = false
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
lcd_events={}















-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Remote Init here, set this up right
-- Button names are from programmer mode! (pg 17 in the prog ref
-- bottom left button is 1
-- bottom left pad is 11, top right pad is 88
-- left buttons end in 0
-- right buttons end in 9
-- top row 91 - 98
-- Press is aftertouch, Pad is note on, Playing is for displaying state
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_init(manufacturer, model)
-- this version
	if model=="Launchpad Pro" then
		local items={
--items
			{name="Keyboard",input="keyboard"},
			{name="Channel Pressure", input="value", min=0, max=127},
			{name="_Scope", output="text"}, --device, e.g. "Thor"
			{name="_Var", output="text"}, --variation, e.g. "Volume" or "Filters"
--From bottom left to top right
--[[
			{name="Press 11", input="value", min=0, max=127, output="value"},
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

			{name="Pad 11", input="value", min=0, max=127, output="value"},
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
			{name="Pad 31", input="value", min=0, max=127, output="value"},
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

--[[
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
			{name="Pad 31 Playing", min=0, max=4, output="value"},
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
			{name="Button 91", input="button", min=0, max=127, output="value"},
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
			{name="Button 70", input="button", min=0, max=127, output="value"},
			{name="Button 80", input="button", min=0, max=127, output="value"},
--bottom to top Right
			{name="Button 19", input="button", min=0, max=127, output="value"},
			{name="Button 29", input="button", min=0, max=127, output="value"},
			{name="Button 39", input="button", min=0, max=127, output="value"},
			{name="Button 49", input="button", min=0, max=127, output="value"},
			{name="Button 59", input="button", min=0, max=127, output="value"},
			{name="Button 69", input="button", min=0, max=127, output="value"},
			{name="Button 79", input="button", min=0, max=127, output="value"},
			{name="Button 89", input="button", min=0, max=127, output="value"},





			}
		remote.define_items(items)


		local inputs={

--inputs
			{pattern="d? xx", name="Channel Pressure"},
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

			{name="Pad 11",	 pattern="<100x>? 0B yy"},
			{name="Pad 12",	 pattern="<100x>? 0C yy"},
			{name="Pad 13",	 pattern="<100x>? 0D yy"},
			{name="Pad 14",	 pattern="<100x>? 0E yy"},
			{name="Pad 15",	 pattern="<100x>? 0F yy"},
			{name="Pad 16",	 pattern="<100x>? 10 yy"},
			{name="Pad 17",	 pattern="<100x>? 11 yy"},
			{name="Pad 18",	 pattern="<100x>? 12 yy"},
			{name="Pad 21",	 pattern="<100x>? 15 yy"},
			{name="Pad 22",	 pattern="<100x>? 16 yy"},
			{name="Pad 23",	 pattern="<100x>? 17 yy"},
			{name="Pad 24",	 pattern="<100x>? 18 yy"},
			{name="Pad 25",	 pattern="<100x>? 19 yy"},
			{name="Pad 26",	 pattern="<100x>? 1A yy"},
			{name="Pad 27",	 pattern="<100x>? 1B yy"},
			{name="Pad 28",	 pattern="<100x>? 1C yy"},
			{name="Pad 31",	 pattern="<100x>? 1F yy"},
			{name="Pad 32",	 pattern="<100x>? 20 yy"},
			{name="Pad 33",	 pattern="<100x>? 21 yy"},
			{name="Pad 34",	 pattern="<100x>? 22 yy"},
			{name="Pad 35",	 pattern="<100x>? 23 yy"},
			{name="Pad 36",	 pattern="<100x>? 24 yy"},
			{name="Pad 37",	 pattern="<100x>? 25 yy"},
			{name="Pad 38",	 pattern="<100x>? 26 yy"},
			{name="Pad 41",	 pattern="<100x>? 29 yy"},
			{name="Pad 42",	 pattern="<100x>? 2A yy"},
			{name="Pad 43",	 pattern="<100x>? 2B yy"},
			{name="Pad 44",	 pattern="<100x>? 2C yy"},
			{name="Pad 45",	 pattern="<100x>? 2D yy"},
			{name="Pad 46",	 pattern="<100x>? 2E yy"},
			{name="Pad 47",	 pattern="<100x>? 2F yy"},
			{name="Pad 48",	 pattern="<100x>? 30 yy"},
			{name="Pad 51",	 pattern="<100x>? 33 yy"},
			{name="Pad 52",	 pattern="<100x>? 34 yy"},
			{name="Pad 53",	 pattern="<100x>? 35 yy"},
			{name="Pad 54",	 pattern="<100x>? 36 yy"},
			{name="Pad 55",	 pattern="<100x>? 37 yy"},
			{name="Pad 56",	 pattern="<100x>? 38 yy"},
			{name="Pad 57",	 pattern="<100x>? 39 yy"},
			{name="Pad 58",	 pattern="<100x>? 3A yy"},
			{name="Pad 61",	 pattern="<100x>? 3D yy"},
			{name="Pad 62",	 pattern="<100x>? 3E yy"},
			{name="Pad 63",	 pattern="<100x>? 3F yy"},
			{name="Pad 64",	 pattern="<100x>? 40 yy"},
			{name="Pad 65",	 pattern="<100x>? 41 yy"},
			{name="Pad 66",	 pattern="<100x>? 42 yy"},
			{name="Pad 67",	 pattern="<100x>? 43 yy"},
			{name="Pad 68",	 pattern="<100x>? 44 yy"},
			{name="Pad 71",	 pattern="<100x>? 47 yy"},
			{name="Pad 72",	 pattern="<100x>? 48 yy"},
			{name="Pad 73",	 pattern="<100x>? 49 yy"},
			{name="Pad 74",	 pattern="<100x>? 4A yy"},
			{name="Pad 75",	 pattern="<100x>? 4B yy"},
			{name="Pad 76",	 pattern="<100x>? 4C yy"},
			{name="Pad 77",	 pattern="<100x>? 4D yy"},
			{name="Pad 78",	 pattern="<100x>? 4E yy"},
			{name="Pad 81",	 pattern="<100x>? 51 yy"},
			{name="Pad 82",	 pattern="<100x>? 52 yy"},
			{name="Pad 83",	 pattern="<100x>? 53 yy"},
			{name="Pad 84",	 pattern="<100x>? 54 yy"},
			{name="Pad 85",	 pattern="<100x>? 55 yy"},
			{name="Pad 86",	 pattern="<100x>? 56 yy"},
			{name="Pad 87",	 pattern="<100x>? 57 yy"},
			{name="Pad 88",	 pattern="<100x>? 58 yy"},


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
			{name="Button 70",	 pattern="B? 46 ?<???x>"},
			{name="Button 80",	 pattern="B? 50 ?<???x>"},
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

-- NO AUTO OUTS FOR NOW

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
--[[
-- Note on lights, note off turns off light. 
-- might have to set this to <100x>?

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
--]]
--[[

			{name="Pad 11 Playing",	 pattern="9? 0B xx",  x="map_redrum_led(value)"},
			{name="Pad 12 Playing",	 pattern="9? 0C xx",  x="map_redrum_led(value)"},
			{name="Pad 13 Playing",	 pattern="9? 0D xx",  x="map_redrum_led(value)"},
			{name="Pad 14 Playing",	 pattern="9? 0E xx",  x="map_redrum_led(value)"},
			{name="Pad 15 Playing",	 pattern="9? 0F xx",  x="map_redrum_led(value)"},
			{name="Pad 16 Playing",	 pattern="9? 10 xx",  x="map_redrum_led(value)"},
			{name="Pad 17 Playing",	 pattern="9? 11 xx",  x="map_redrum_led(value)"},
			{name="Pad 18 Playing",	 pattern="9? 12 xx",  x="map_redrum_led(value)"},
			{name="Pad 21 Playing",	 pattern="9? 15 xx",  x="map_redrum_led(value)"},
			{name="Pad 22 Playing",	 pattern="9? 16 xx",  x="map_redrum_led(value)"},
			{name="Pad 23 Playing",	 pattern="9? 17 xx",  x="map_redrum_led(value)"},
			{name="Pad 24 Playing",	 pattern="9? 18 xx",  x="map_redrum_led(value)"},
			{name="Pad 25 Playing",	 pattern="9? 19 xx",  x="map_redrum_led(value)"},
			{name="Pad 26 Playing",	 pattern="9? 1A xx",  x="map_redrum_led(value)"},
			{name="Pad 27 Playing",	 pattern="9? 1B xx",  x="map_redrum_led(value)"},
			{name="Pad 28 Playing",	 pattern="9? 1C xx",  x="map_redrum_led(value)"},
			{name="Pad 31 Playing",	 pattern="9? 1F xx",  x="map_redrum_led(value)"},
			{name="Pad 32 Playing",	 pattern="9? 20 xx",  x="map_redrum_led(value)"},
			{name="Pad 33 Playing",	 pattern="9? 21 xx",  x="map_redrum_led(value)"},
			{name="Pad 34 Playing",	 pattern="9? 22 xx",  x="map_redrum_led(value)"},
			{name="Pad 35 Playing",	 pattern="9? 23 xx",  x="map_redrum_led(value)"},
			{name="Pad 36 Playing",	 pattern="9? 24 xx",  x="map_redrum_led(value)"},
			{name="Pad 37 Playing",	 pattern="9? 25 xx",  x="map_redrum_led(value)"},
			{name="Pad 38 Playing",	 pattern="9? 26 xx",  x="map_redrum_led(value)"},
			{name="Pad 41 Playing",	 pattern="9? 29 xx",  x="map_redrum_led(value)"},
			{name="Pad 42 Playing",	 pattern="9? 2A xx",  x="map_redrum_led(value)"},
			{name="Pad 43 Playing",	 pattern="9? 2B xx",  x="map_redrum_led(value)"},
			{name="Pad 44 Playing",	 pattern="9? 2C xx",  x="map_redrum_led(value)"},
			{name="Pad 45 Playing",	 pattern="9? 2D xx",  x="map_redrum_led(value)"},
			{name="Pad 46 Playing",	 pattern="9? 2E xx",  x="map_redrum_led(value)"},
			{name="Pad 47 Playing",	 pattern="9? 2F xx",  x="map_redrum_led(value)"},
			{name="Pad 48 Playing",	 pattern="9? 30 xx",  x="map_redrum_led(value)"},
			{name="Pad 51 Playing",	 pattern="9? 33 xx",  x="map_redrum_led(value)"},
			{name="Pad 52 Playing",	 pattern="9? 34 xx",  x="map_redrum_led(value)"},
			{name="Pad 53 Playing",	 pattern="9? 35 xx",  x="map_redrum_led(value)"},
			{name="Pad 54 Playing",	 pattern="9? 36 xx",  x="map_redrum_led(value)"},
			{name="Pad 55 Playing",	 pattern="9? 37 xx",  x="map_redrum_led(value)"},
			{name="Pad 56 Playing",	 pattern="9? 38 xx",  x="map_redrum_led(value)"},
			{name="Pad 57 Playing",	 pattern="9? 39 xx",  x="map_redrum_led(value)"},
			{name="Pad 58 Playing",	 pattern="9? 3A xx",  x="map_redrum_led(value)"},
			{name="Pad 61 Playing",	 pattern="9? 3D xx",  x="map_redrum_led(value)"},
			{name="Pad 62 Playing",	 pattern="9? 3E xx",  x="map_redrum_led(value)"},
			{name="Pad 63 Playing",	 pattern="9? 3F xx",  x="map_redrum_led(value)"},
			{name="Pad 64 Playing",	 pattern="9? 40 xx",  x="map_redrum_led(value)"},
			{name="Pad 65 Playing",	 pattern="9? 41 xx",  x="map_redrum_led(value)"},
			{name="Pad 66 Playing",	 pattern="9? 42 xx",  x="map_redrum_led(value)"},
			{name="Pad 67 Playing",	 pattern="9? 43 xx",  x="map_redrum_led(value)"},
			{name="Pad 68 Playing",	 pattern="9? 44 xx",  x="map_redrum_led(value)"},
			{name="Pad 71 Playing",	 pattern="9? 47 xx",  x="map_redrum_led(value)"},
			{name="Pad 72 Playing",	 pattern="9? 48 xx",  x="map_redrum_led(value)"},
			{name="Pad 73 Playing",	 pattern="9? 49 xx",  x="map_redrum_led(value)"},
			{name="Pad 74 Playing",	 pattern="9? 4A xx",  x="map_redrum_led(value)"},
			{name="Pad 75 Playing",	 pattern="9? 4B xx",  x="map_redrum_led(value)"},
			{name="Pad 76 Playing",	 pattern="9? 4C xx",  x="map_redrum_led(value)"},
			{name="Pad 77 Playing",	 pattern="9? 4D xx",  x="map_redrum_led(value)"},
			{name="Pad 78 Playing",	 pattern="9? 4E xx",  x="map_redrum_led(value)"},
			{name="Pad 81 Playing",	 pattern="9? 51 xx",  x="map_redrum_led(value)"},
			{name="Pad 82 Playing",	 pattern="9? 52 xx",  x="map_redrum_led(value)"},
			{name="Pad 83 Playing",	 pattern="9? 53 xx",  x="map_redrum_led(value)"},
			{name="Pad 84 Playing",	 pattern="9? 54 xx",  x="map_redrum_led(value)"},
			{name="Pad 85 Playing",	 pattern="9? 55 xx",  x="map_redrum_led(value)"},
			{name="Pad 86 Playing",	 pattern="9? 56 xx",  x="map_redrum_led(value)"},
			{name="Pad 87 Playing",	 pattern="9? 57 xx",  x="map_redrum_led(value)"},
			{name="Pad 88 Playing",	 pattern="9? 58 xx",  x="map_redrum_led(value)"},

--]]
--[[


--left to right TOP
			{name="Button 91",	pattern="B? 5B xx"},
			{name="Button 92",	pattern="B? 5C xx"},
			{name="Button 93",	pattern="B? 5D xx"},
			{name="Button 94",	pattern="B? 5E xx"},
			{name="Button 95",	pattern="B? 5F xx"},
			{name="Button 96",	pattern="B? 60 xx"},
			{name="Button 97",	pattern="B? 61 xx"},
			{name="Button 98",	pattern="B? 62 xx"},
--left to right Bottom
			{name="Button 01",  pattern="B? 01 xx"},
			{name="Button 02",  pattern="B? 02 xx"},
			{name="Button 03",  pattern="B? 03 xx"},
			{name="Button 04",  pattern="B? 04 xx"},
			{name="Button 05",  pattern="B? 05 xx"},
			{name="Button 06",  pattern="B? 06 xx"},
			{name="Button 07",  pattern="B? 07 xx"},
			{name="Button 08",  pattern="B? 08 xx"},
--bottom to top Left
			{name="Button 10",	 pattern="B? 0A xx"},
			{name="Button 20",	 pattern="B? 14 xx"},
			{name="Button 30",	 pattern="B? 1E xx"},
			{name="Button 40",	 pattern="B? 28 xx"},
			{name="Button 50",	 pattern="B? 32 xx"},
			{name="Button 60",	 pattern="B? 3C xx"},
			{name="Button 70",	 pattern="B? 46 xx"},
			{name="Button 80",	 pattern="B? 50 xx"},
--bottom to top Right
			{name="Button 19",  pattern="B? 13 xx"},
			{name="Button 29",  pattern="B? 1D xx"},
			{name="Button 39",  pattern="B? 27 xx"},
			{name="Button 49",  pattern="B? 31 xx"},
			{name="Button 59",  pattern="B? 3B xx"},
			{name="Button 69",  pattern="B? 45 xx"},
			{name="Button 79",  pattern="B? 4F xx"},
			{name="Button 89",  pattern="B? 59 xx"},

--]]

		}
		remote.define_auto_outputs(outputs)
	end
end

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- TBD
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_process_midi(event)

	ret = remote.match_midi("<100x>? yy zz",event) --find a note on or off
	if(ret~=nil) then
-- tran????????
	tran_btn = ret.z
		local notein = ret.y
		local valin = ret.x	  
-- changed
		local shiftbtn = remote.match_midi("<100x>? 0A zz",event) --find F8
-- What is the accent pad?
--		local accent_pad = remote.match_midi("<100x>? 50 zz",event) --find Pad 32
		--fbtn note ons are velocity 64----------
-- changed
		scale_up = remote.match_midi("B? 5B 7F",event) --find Top Button 91
		scale_dn = remote.match_midi("B? 5C 7F",event) --find Top Button 92
		tran_up  = remote.match_midi("B? 5D 7F",event) --find Top Button 93
		tran_dn  = remote.match_midi("B? 5E 7F",event) --find Top Button 94
--[[
		
		if(accent_pad and noscaleneeded) then
			if(accent_pad.z>10) then		  
				g_accent_dn = true
				g_accent_count = modulo(g_accent_count+1,3)
				local msg={ time_stamp = event.time_stamp, item=k_accent, value = g_accent_count, note = "2B",velocity = accent_pad.z }
				remote.handle_input(msg)
				g_delivered_note = noteout
				return true
			else
				return false
			end
		end
--]]

		if (shiftbtn) then
			if shiftbtn.z>0 then
				shift = 1 --momentary like a computer's shift key
			else
				shift = 0
			end
		end
--[[

		if(tran_up) then
			transpose = transpose+(1-shift)+(shift*12)
			global_transp = transpose
			transpose_changed = true
		end
		if(tran_dn) then
			transpose = transpose-(1-shift)-(shift*12)
			global_transp = transpose
			transpose_changed = true
		end
		if(scale_up) then
			scale_int = modulo(scale_int+1,8)
			scalename = scalenames[1+scale_int]
			scale = scales[scalename]
			global_scale = scale_int
			scale_from_parse = false
			--remote.trace("scale up "..scalename)
		end
		if(scale_dn) then
			scale_int = modulo(scale_int-1,8) --only use the first 8 scales
			scalename = scalenames[1+scale_int]
			scale = scales[scalename]
			global_scale = scale_int
			scale_from_parse = false
			--remote.trace("scale dn "..scalename)
		end
--]]



--[[

		if(drum_tog) then
			drum_mode = 1-drum_mode
		end
--]]



--[[

		--if(tran_rst) then
		--	transpose=0
		--end
--]]



--[[

		--now handle the pads)
		if (notein>35 and notein<68) and (noscaleneeded==false) then
			---if the pads have transposed, then we need to turn off the last note----------------------
			if(transpose_changed == true) then
				local prev_off={ time_stamp = event.time_stamp, item=1, value = valin, note = g_delivered_note,velocity = 0 }
				remote.handle_input(prev_off)
				transpose_changed = false
			end
			local padid = notein-36
			local scale_len = table.getn(scale)
			local ind = 1+modulo(padid,scale_len)  --modulo using the operator % gave me trouble in reason, so I wrote a custom fcn
			local oct = math.floor(padid/scale_len)
			local addnote = scale[ind]
			local noteout = root+transpose+(12*oct)+addnote
			if (noteout<127 or noteout>0) then
				local msg={ time_stamp = event.time_stamp, item=1, value = valin, note = noteout,velocity = ret.z }
				remote.handle_input(msg)
				g_delivered_note = noteout
				return true
			end
		elseif (notein<25 and shift==1) then --f7 buttons and top buttons
			local noteout = notein + 100 --offset note by 100
			itemno = g_Tbtn_firstitem+(notein-10) --Tbtn starts at item 121 in the items index, 10 is the note number of Tbtn1. wonky way to get item #
			if(ret.z>0) then
				local msg={ time_stamp = event.time_stamp, item=itemno, value = valin, note = noteout,velocity = ret.z }		
				remote.handle_input(msg)
			end
			return true
		else
			return false -- nothing changed
		end  -- change scale and transposed note
--]]
-- added
	return false


	end

	return false


end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Check this TBD
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_deliver_midi(maxbytes,port)



	if(port==1) then
		local lpp_events={}
		local upevent={}
		local dnevent={}
		local padevent={}
		local ltevent={}
		local rtevent={}
		local shevent={}
		local iskong = false
		local isvarchange = false
		local istracktext = false
		local do_update_pads = 0
-- Need to output shift a better way
-- maybe change it's color!

		--if we have pressed shift or there's a change in transpose, we need to show that in the seven seg display on Base:----------------------------------------
		if (g_delivered_shift~=shift or g_delivered_transpose~=transpose)  then
			local shcolors = {"40","7F"}
--			shevent = remote.make_midi("90 19 "..shcolors[shift+1])
			if(tran_btn~=nil) then
				if shift==1 or tran_btn>0 then
--[[

--this needs to change to some color output
				--show transpose in 7seg
					local xpose = string.format("%02i",math.abs(transpose) )
					local c_one = string.format("%02x", string.sub(xpose,1,1) )
					local c_two = string.format("%02x", string.sub(xpose,2,2) )
					ltevent = remote.make_midi("b0 22 "..c_one)
					table.insert(lpp_events,ltevent)
					rtevent = remote.make_midi("b0 23 "..c_two)
					table.insert(lpp_events,rtevent)
--]]
					local transpose_event = make_lcd_midi_message("/Reason/0/LPP/0/display/3/display/ "..transpose)
					table.insert(lcd_events,transpose_event)
				else
					--return to scale
--[[
					local scale_abrv = scaleabrvs[scalename]
					local c_one = string.sub(scale_abrv,1,1)
					local c_two = string.sub(scale_abrv,2,2)
					ltevent = remote.make_midi("b0 22 "..sevseg[c_one])
					table.insert(lpp_events,ltevent)
					rtevent = remote.make_midi("b0 23 "..sevseg[c_two])
					table.insert(lpp_events,rtevent)
--]]
					local scalename_event = make_lcd_midi_message("/Reason/0/LPP/0/display/2/display/ "..scalename)
					table.insert(lcd_events,scalename_event)
				end
			end
		
			table.insert(lpp_events,shevent)
--]]
			g_delivered_shift = shift
		end


--this needs to change to some color output
		--if scale changes, we update the LCD--------------------------------------------------------------------------------
		if ( (g_delivered_scale~=scale_int or g_delivered_transpose~=transpose) and shift~=1 and tran_btn==0) then
--[[
			local scale_abrv = scaleabrvs[scalename]
			local c_one = string.sub(scale_abrv,1,1)
			local c_two = string.sub(scale_abrv,2,2)
			ltevent = remote.make_midi("b0 22 "..sevseg[c_one])
			table.insert(lpp_events,ltevent)
			rtevent = remote.make_midi("b0 23 "..sevseg[c_two])
			table.insert(lpp_events,rtevent)
--]]
			g_delivered_scale = scale_int
			local scalename_event = make_lcd_midi_message("/Reason/0/LPP/0/display/2/display/ "..scalename)
			table.insert(lcd_events,scalename_event)
			if(noscaleneeded == false) then
				do_update_pads = 1
			end
			--remote.trace(scalename)
		end
--[[
--]]
		--if transpose changes, we transpose--------------------------------------------------------------------------------
		if g_delivered_transpose~=transpose then

			local color_len = table.getn(colors)
			local color_ind=1 + (modulo( math.floor(math.abs(transpose)/12),color_len) ) --change color every octave
			local color = colors[color_ind]
--[[
			if transpose>0 then
				upevent = remote.make_midi("90 17 "..color)
				table.insert(lpp_events,upevent)
				dnevent = remote.make_midi("90 18 00")
				table.insert(lpp_events,dnevent)
			elseif transpose<0 then
				upevent = remote.make_midi("90 17 00")
				table.insert(lpp_events,upevent)
				dnevent = remote.make_midi("90 18 "..color)
				table.insert(lpp_events,dnevent)
			elseif transpose==0 then
				upevent = remote.make_midi("90 17 00")
				table.insert(lpp_events,upevent)
				dnevent = remote.make_midi("90 18 00")
				table.insert(lpp_events,dnevent)
			end	
--]]
			g_delivered_transpose = transpose
			do_update_pads = 1
		end
		

		--if vartext from _Var item in remotemap has changed	-----------------
		if g_vartext_prev~=g_vartext then
			--Let the LCD know what the variation is
			local vartext = remote.get_item_text_value(g_var_item_index)
			local var_event = make_lcd_midi_message("/Reason/0/LPP/0/display/1/display "..vartext)
			table.insert(lcd_events,var_event)
			g_vartext_prev = g_vartext
			isvarchange = true
		end
		--lcd event and text parsing for scale detection from text in track name----------------------------------------
		local new_text = g_lcd_state
		if g_delivered_lcd_state~=new_text then
			g_delivered_lcd_state = new_text
			local use_global_scale = false
			istracktext = string.find(new_text,"Track") == 1 --The word "track" is the first word
			if (istracktext==false) then
--[[
				if(g_lcd_index>=sli_start and g_lcd_index<=sli_end) then --if it's a Slider
					--we'll make the parameter/value/unit list into two arrays for our LCD, then send a long string to LCD
					update_slider(g_lcd_index)	
				end
--]]
			end


			--parse the text to see if there's any scale or transpose info----------------------------------------
			if istracktext==true then			
				--if scopetext from _Scope item has changed	
				if g_scopetext_prev~=g_scopetext then
					--Let the LCD know what the device is
					local const_event = make_lcd_midi_message("/Reason/0/LPP/0/display/4/display "..g_scopetext)
					table.insert(lcd_events,const_event)
					--detect Redrum
					if(g_scopetext=="Redrum") then
						noscaleneeded = true	
						do_update_pads = 0
						g_clearpads = 1
					else
						if(noscaleneeded == true) then						
							do_update_pads = 1
						end
						noscaleneeded = false
					end
					--if we've landed on a Kong, _Scope reports "KONG" and we change to drum scale
					if(g_scopetext=="KONG" and scale_int~=7) then
						if scale_from_parse==false then
							global_scale = scale_int
						end
						set_scale(7)
						iskong = true
					else
						use_global_scale = true
					end
					g_scopetext_prev = g_scopetext
				end
			
				--send LCD the Track name text----------------------------------------------------------------
				local track_event = make_lcd_midi_message("/Reason/0/LPP/0/display/0/display "..new_text)
				table.insert(lcd_events,track_event)
				--see if there's a scale in the track text
				local result = ""
				scsearch = string.find(new_text, 'scale')
				eqsearch = string.find(new_text, '=%d') --look for an index
				if(scsearch) then
					if(eqsearch==nil) then --if we didn't find a number, search for a word after =
						eqsearch = string.find(new_text, '=%w')			--from the first char after '=' ...
						spsearch = string.find(new_text, '%s',eqsearch) or -1 --...to the next space (or end of line) is a 'word'
						result = string.sub(new_text,eqsearch+1,spsearch)
						local sindex=0;
						for i,v in pairs(scalenames) do	 --find the index that the scalename is at
							if v == result then
								sindex = i-1
								break
							end
						end
						set_scale(sindex)
						--local scalename_event = make_lcd_midi_message("SCALE_TEXT "..result.." # "..sindex)
						--table.insert(lcd_events,scalename_event)
					else --otherwise it's an index
						result = string.sub(new_text,eqsearch+1,eqsearch+2)
						set_scale(result)
						--local scaleint_event = make_lcd_midi_message("SCALE_INT "..result.." # "..sindex)
						--table.insert(lcd_events,scaleint_event)
					end
					use_global_scale = false
					scale_from_parse = true
				else
					scale_from_parse = false
					use_global_scale = true
				end
				--send scale name to LCD----------------------------------------
				local scalename_event = make_lcd_midi_message("/Reason/0/LPP/0/display/2/display/ "..scalename)
				table.insert(lcd_events,scalename_event)
		
				---If it's not a Kong, and there's no scale in the Track name, set to global_scale
				if use_global_scale and iskong==false then
					set_scale(global_scale)
					--local prev_event = make_lcd_midi_message("PREV SCALE "..global_scale.." "..g_delivered_scale)
					--table.insert(lcd_events,prev_event)
				end

				--see if there's a transpose in the track text----------------------------------------
				local transp = ""
				tsearch = string.find(new_text, 'trans') or string.find(new_text, 'transpose')
				eqtsearch = string.find(new_text, '=%d',tsearch) --look for a value
				if(tsearch and eqtsearch) then
					--global_transp = transpose
					trans_parsed = tonumber( string.sub(new_text,eqtsearch+1,eqtsearch+2) )
					if(transpose~=trans_parsed) then
						transpose = trans_parsed
						transpose_changed = true
					end
				else
					if(transpose~=global_transp) then
						transpose = global_transp
						transpose_changed = true
					end
				end
				--send LCD transpose value
				if(transpose_changed) then
					local transpose_event = make_lcd_midi_message("/Reason/0/LPP/0/display/1/display/ "..transpose)
					table.insert(lcd_events,transpose_event)
				end
			end
			--done looking at "Track" labels------------------------------------------------------
		end

--[[

		if istracktext==true or isvarchange==true then
		--refresh LCD with all the parameters and values for the sliders when a new track is selected----------------------------------------
			for i = sli_start,sli_end do
				--update_slider(i)
			end
		end
--]]
--[[
		
		-- color the pads if scale or transpose changed----------------------------------------
		if(do_update_pads==1) then
	  table.insert(lcd_events,upd_event)
			if(scalename~='DrumPad') then
				for i=1,32,1 do
					local padid = i-1
					local scale_len = table.getn(scale)
					local oct = math.floor(padid/scale_len)
					local addnote = scale[1+modulo(i-1,scale_len)]
					local outnote = root+transpose+(12*oct)+addnote --note that gets played by synth
					local outnorm = modulo(outnote,12) --normalized to 0-11 range
					local padnum = string.format("%x",i+35) --note# that the controller led responds to
					local keycolors = {"02","40","20"} --white,yellow,blue
					local whites = {2, 4, 5, 7, 9, 11}
					--remote.trace("\n i: "..i.." padid: "..padid.." outnorm "..outnorm.." outnote "..outnote.." xpose "..transpose.." addnote "..addnote)
					--if outnorm is 0 , make it yellow. if it's a white key, make it white, else blue
					if outnorm==0 then
						padevent[i]=remote.make_midi("90 "..padnum.." "..keycolors[2])
						table.insert(lpp_events,padevent[i])
					elseif exists(outnorm, whites) then
						padevent[i]=remote.make_midi("90 "..padnum.." "..keycolors[1])
						table.insert(lpp_events,padevent[i])
					else
						padevent[i]=remote.make_midi("90 "..padnum.." "..keycolors[3])
						table.insert(lpp_events,padevent[i])
					end
				end
			else
				--do drumpad color scheme
				for i=0,31,1 do
					local padnum = string.format("%x",i+36) --note# that the controller led responds to
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
			end
		end
--]]

		
	if(g_scopetext=="Redrum") then
--local padnotes = {60,61,62,63,64,65,66,67, 52,53,54,55,56,57,58,59, 44,45,46,47,48,49,50,51}
	  local padnotes = {44,45,46,47,48,49,50,51}
	  --if we've just landed on Redrum, we need to clear out the 3rd row of pads, otherwise they maintain LEDs from pvs scope
	  if g_clearpads==1 then
		for pad=1,8 do
		  local padnum = string.format("%02x",padnotes[pad])
		  local event = remote.make_midi("90 "..padnum.." 00")
		  table.insert(lpp_events,event)
		end	 
		g_clearpads=0
	  end
	  --flash drums playing on selected pads
	  for pad=1,8 do
		local led_value = 0
		led_value = make_led_value(pad,4,32) --cyan/blue for drum selects
		local last_value = g_last_led_output[pad]
		if led_value ~= last_value then
		  -- send note
		  local padnum = string.format("%02x",padnotes[pad])
		  local event = remote.make_midi("90 "..padnum.." xx", { x=led_value })
		  table.insert(lpp_events,event)
		  -- FL: Change "sent", set last value
		  g_last_led_output[pad] = led_value
		end
	  end
	  --Pad 32 controls the Accent 3way.
	  local acc_colors = {1,64,16} --wh,yel,red
	  if g_last_accent ~= g_accent then
		g_accent_dn = false
		local acccolor = acc_colors[(g_accent+1)]
		local accnote = string.format("%02x",43)
		local event = remote.make_midi("90 "..accnote.." xx", { x=acccolor })
		table.insert(lpp_events,event)
		g_last_accent = g_accent
		end
	end

--[[

		--initialize colors:
		if init==1 then
			local firstcolors={
				--set 7 seg display for major scale MA:
				remote.make_midi("b0 22 16"),
				remote.make_midi("b0 23 16"),



				--function btns w,w,off,c,c,b,b,y
				remote.make_midi("B0 5B 30"),
				remote.make_midi("B0 5C 30"),
				remote.make_midi("B0 5D 30"),
				remote.make_midi("B0 5E 30"),
				remote.make_midi("B0 5F 30"),
				remote.make_midi("B0 60 30"),
				remote.make_midi("B0 61 30"),
				remote.make_midi("B0 62 30"),
--]]

--[[				
				remote.make_midi("90 12 02"),
				remote.make_midi("90 13 02"),
				remote.make_midi("90 14 00"),
				remote.make_midi("90 15 04"),
				remote.make_midi("90 16 04"),
				remote.make_midi("90 17 20"),
				remote.make_midi("90 18 20"),
				remote.make_midi("90 19 40"),
				--top rt runner leds for variations w,w,w
				remote.make_midi("90 48 02"),
				remote.make_midi("90 49 02"),
				remote.make_midi("90 4A 02"),
				remote.make_midi("90 4B 02"),
				--initialize pads
			}
			local first_len = table.getn(firstcolors)
			for i=1,first_len,1 do
				table.insert(lpp_events,firstcolors[i])
			end	

-- This needs to change for 64 pads  
			if noscaleneeded==false then
		--notes 36 to 67 for pads
				local padevent = {}
				for i=1,32,1 do
					local padnum = string.format("%x",i+35)
					local modd = modulo(i-1,8)
					local keycolor="02"
					if(modd==0 or modd==7) then
						keycolor="40"
					end
--				padevent[i]=remote.make_midi("90 "..padnum.." "..keycolor)
--				table.insert(lpp_events,padevent[i])
					local transpose_event = make_lcd_midi_message("/INIT "..transpose)
					table.insert(lcd_events,transpose_event)
				end
			end
			init=0
		end
--]]

		return lpp_events --send out a bunch of MIDI to the Launchpad Pro
	end --end port==1





	if(port==2) then
		local le = lcd_events
		lcd_events = {}
		return le
	end
--[[
--]]







end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_on_auto_input(item_index)
	g_last_input_time = remote.get_time_ms()
	g_last_input_item = item_index
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


--we'll fetch the items that have changed in Remote----------------------------------------
g_scopetext = "none"
g_scopetext_prev = "none"
g_vartext = "none"
g_vartext_prev = "none"
g_lcd_index = -1
g_clearpads = 0



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- From the REASON SDK p 28, 21, 33
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_set_state(changed_items)


	--look for the _Scope constant. Kong reports "KONG". Could use for a variety of things

	if remote.is_item_enabled(g_scope_item_index) then
		local scope_text = remote.get_item_text_value(g_scope_item_index)
		g_scopetext = scope_text
	else
		g_scopetext = ""
	end
	
	if remote.is_item_enabled(g_var_item_index) then
		local var_text = remote.get_item_text_value(g_var_item_index)
		g_vartext = var_text
	else
		g_vartext = ""
	end
	
	if(g_last_input_item~=nil) then
		if remote.is_item_enabled(g_last_input_item) then
			local feedback_text = remote.get_item_name_and_value(g_last_input_item)
			if string.len(feedback_text)>0 then
				g_feedback_enabled = true
				--g_lcd_state = string.format("%-16.16s",feedback_text)
				g_lcd_state = feedback_text
				g_lcd_index = g_last_input_item
			end
		end
	end

  -- FL: Collect all changed states for redrum "drum playing" - this part blinks the 3rd row drum selection pads
	for k,item_index in ipairs(changed_items) do
	if item_index == k_accent then
	  g_accent = remote.get_item_value(item_index)
	end

		if item_index >= k_first_step_item and item_index < k_first_step_item+8 then
			local step_index = item_index - k_first_step_item + 1
			g_step_value[step_index] = remote.get_item_value(item_index)
			-- FL: Add this if the item can be disabled
			-- g_step_is_disabled[step_index] = remote.is_item_enabled(item_index)

		elseif item_index >= k_first_step_playing_item and item_index < k_first_step_playing_item+8 then
			local step_index = item_index - k_first_step_playing_item + 1
			g_step_is_playing[step_index] = remote.get_item_value(item_index)
		end
	end
--[[
--]]

end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- FL: Helper function that combines the "Pad n" and "Pad n Playing" outputs
function make_led_value(index,a,b)
  local sw = (g_step_is_playing[index]>0) and 1 or 0 --range of value is 0-4, so we convert to 0-1
	local combined_value = g_step_value[index]*a + sw*b
	return combined_value
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--make a message to send to livid LCD----------------------------------------
-- TODO still not sure where this would output
function make_lcd_midi_message(text)
	local event = remote.make_midi("F0 23 23 ") --header for SysexReader
--	local event = remote.make_midi("F0 00 20 29 02 10 14") --header for Launchpad Pro, product ID 0
--	local event = remote.make_midi("f0 00 01 61 00") --header for Livid LCD, product ID 0
	start=4
	stop=4+string.len(text)-1
	for i = start,stop do
		sourcePos = i-start+1
		event[i] = string.byte(text,sourcePos)
	end
	event[stop+1] = 247			-- hex f7
	return event
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- NEW FUNCTION UNUSED
-- Modified to scroll text across
function make_scrolltext_midi_message(text)
	local event = remote.make_midi("F0 00 20 29 02 10 14") --header for Launchpad Pro, product ID 0
	start=8
	stop=8+string.len(text)-1
	for i = start,stop do
		sourcePos = i-start+1
		event[i] = string.byte(text,sourcePos)
	end
	event[stop+1] = 247			-- hex f7
	return event
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function set_scale(index)	
	scale_int = index
	scalename = scalenames[1+scale_int]
	scale = scales[scalename]
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Unused
function exists(f, l) -- find element v of l satisfying f(v)
  for _, v in ipairs(l) do
	if v==f then
	  return true
	end
  end
  return nil
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--for some Reason (pun intended) I need to define a modulo function. just using the % operator was throwing errors :(
function modulo(a,b)
	local mo = a-math.floor(a/b)*b
	return mo
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--done ===============
function remote_probe(manufacturer,model)
	if model=="Launchpad Pro" then
		return {
			request="f0 7e 7f 06 01 f7",
			response="f0 7e 00 06 02 00 20 29 51 00 00 00 ?? ?? ?? ?? f7"
		}
	end
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- pclr at top of file
function map_redrum_led(v)
  if(v<5) then
   return pclr[v]
  end
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- UTILITY: convert a string to a hex-string (of the ASCII representation)
--
local function convert_to_hex(msg)
  local hex_str = ""
  for c in string.gmatch(msg, ".") do
	hex_str = hex_str .. string.format("%X", c:byte())
  end
  return hex_str
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--UTILITY: make a subtable of a table:
function table_slice (values,i1,i2)
	local res = {}
	local n = table.getn(values) --# provides length
	-- default values for range
	i1 = i1 or 1
	i2 = i2 or n
	if i2 < 0 then
		i2 = n + i2 + 1
	elseif i2 > n then
		i2 = n
	end
	if i1 < 1 then
		i1 = n + i1 + 1
		i2 = n
	end
	if i1 > n then
		return {}
	end
	local k = 1
	for i = i1,i2 do
		res[k] = values[i]
		k = k + 1
	end
	return res
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Not done yet!
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_prepare_for_use()
	g_delivered_lcd_state = string.format("%-16.16s","Launchpad Pro")
	local retEvents={
		--default settings for Launchpad Pro
		remote.make_midi("F0 00 20 29 02 10 21 01 F7", { port=1 }), -- set standalone mode
		remote.make_midi("F0 00 20 29 02 10 2C 03 F7", { port=1 }), -- Programmer mode
		remote.make_midi("F0 00 20 29 02 10 0E 00 F7", { port=1 }), -- Blank all
		remote.make_midi("F0 00 20 29 02 10 0A 63 32 F7", { port=1 }), --Front light
--		remote.make_midi("F0 00 20 29 02 10 14 32 00 07 05 52 65 61 73 6F 6E F7", { port=1 }), -- scroll Reason
		remote.make_midi("F0 00 20 29 02 10 0A 63 32 F7", { port=1 }), --Front light
--		remote.make_midi("F0 00 20 29 02 10	 F7"),
--		remote.make_midi("F0 00 20 29 02 10	 F7"),
--send all local off on settings ch 16	191,122,64 
--		remote.make_midi("bF 7A 40")
	}
	init=1
	return retEvents
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Not Needed
--UTILITY: this function is called when we need to update a slider LCD
function update_slider(item)
	local thetext = remote.get_item_name_and_value(item)
	local textarray = {}
	local p_path = ""
	local v_path = ""
	local p_text = ""
	local v_text = ""
	--local tlcd_event = make_lcd_midi_message("item "..item.." text "..thetext.." len "..#thetext )
	--table.insert(lcd_events,tlcd_event)
	if(string.len(thetext)>0) then
		--strip any percent symbols
		local pctsearch = string.find(thetext, '%%')
		if(pctsearch~=nil) then
			thetext = string.sub(thetext,1,pctsearch-1).." pct"
		end
		local wordcount = 1
		--make a table of words so we can break the track name_and_value into "name" and "value"
		for j in string.gmatch(thetext, "%S+") do
			textarray[wordcount] = j
			wordcount = wordcount+1
		end
		wordcount = wordcount-1 --because wordcount is really an index starting at 1, to get the true count, we subtract 1
		p_path = "/Reason/0/LPP/0/Fader/"..(item-sli_start).."/lcd_name " -- "sli_start" (-4) because the sliders start at index 3 in table items, but we start our OSC Slider names at 0.
		v_path = "/Reason/0/LPP/0/Fader/"..(item-sli_start).."/lcd_value "
		if(wordcount>2) then
			p_text = string.format( table.concat( table_slice(textarray,1,-3)," " ) ) --from first element to 3rd to last element (everything but last 2 elements)
			v_text = string.format( table.concat( table_slice(textarray,-2)," " ) ) --last 2 elements
		else
			p_text = string.format(textarray[1]) --1st element, like "Mode"
			v_text = string.format(textarray[2]) --2nd elemnt, like "10%" (with % stripped out)
		end
		local p_lcd_event = make_lcd_midi_message(p_path..p_text)
		local v_lcd_event = make_lcd_midi_message(v_path..v_text)
		table.insert(lcd_events,p_lcd_event) --put the lcd_text (e.g. "Drum 1" or "Filter Freq" into the table of midi events 
		table.insert(lcd_events,v_lcd_event) --put the lcd_text (e.g. "Tone 16" or "220 hz" into the table of midi events	
	end
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
