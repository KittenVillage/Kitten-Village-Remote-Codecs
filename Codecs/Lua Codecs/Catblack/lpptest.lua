-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Launchpad Pro Lua Codec and Remote Map
-- by Catblack@gmail.com
--
-- Please paypal me $10 if you like this!
--
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--	The Launchpad has 64 pads, in chromatic mode I"m starting it at C2 (note 24) and going to E7 (note 88)
--	leaving 2 octives down (24 down transpose) and 3 octives up (39 up transpose) G10 (127) is the highest, C0 (0) the lowest
-- 
-- Oct up/dn may be impl as shifted item of transpose button.
-- Different scales may go higher, but starting on 24 is probably best. 


-- TODO place util trasport remotables (undo, redo, track sel) as non-auto in out items, add them to itemnum index
-- TODO CLASSes
-- TODO velocity feedback
-- TODO midi note playing feedback.

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
			'Chromatic','DrumPad','Major','Minor','Dorian','Mixolydian', 
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




-- Thought I'd try the colors from virtuosoism.com
colorscale={}
colorscale[0]= {interval=0,  color=7,   hcolor="07", R="06", G="00", B="00", col="R ", notename="C",} -- 5 too bright
colorscale[1]= {interval=1,  color=65,  hcolor="41", R="00", G="15", B="0D", col="BG", notename="C#",}
colorscale[2]= {interval=2,  color=96,  hcolor="60", R="3F", G="1F", B="00", col="O ", notename="D",}
colorscale[3]= {interval=3,  color=49,  hcolor="31", R="15", G="00", B="3F", col="BV", notename="D#",}
colorscale[4]= {interval=4,  color=97,  hcolor="61", R="2E", G="2C", B="00", col="Y ", notename="E",}
colorscale[5]= {interval=5,  color=57,  hcolor="39", R="3F", G="00", B="15", col="RV", notename="F",}
colorscale[6]= {interval=6,  color=21,  hcolor="15", R="00", G="3F", B="00", col="G ", notename="F#",}
colorscale[7]= {interval=7,  color=60,  hcolor="3C", R="3F", G="05", B="00", col="RO", notename="G",}
colorscale[8]= {interval=8,  color=45,  hcolor="2D", R="00", G="00", B="3F", col="B ", notename="G#",}
colorscale[9]= {interval=9,  color=126, hcolor="7E", R="2C", G="17", B="00", col="YO", notename="A",}
colorscale[10]={interval=10, color=55,  hcolor="37", R="06", G="00", B="06", col="V ", notename="A#",}
colorscale[11]={interval=11, color=18,  hcolor="12", R="07", G="16", B="00", col="YG", notename="B",}
-- colors = {"07","3C","96","7E","61","12","15","41","2D","31","37","39"} -- BY HUE



-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Set some variables

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- putting things into state so I can dump it for debug
g = {}
g.button = {}
g.scope = {}


g.button.shift = 0
g.button.shift_delivered = 0 --for change filter

g.button.click = 0
g.button.click_delivered = 0

g.button.tranup = 0
g.button.trandn = 0
g.palette={}



-- These are set in remote_on_auto_input() 
g.last_input_time = 0
g.last_input_item = nil

g.transpose_delivered = 0 --for change filter
g.transpose = 0
transpose_changed = false
-- tran_rst = true -- stops transpose
tranup_btn = 0 --transpose up button state up or down
trandn_btn = 0 --transpose down button state up or down



--scalename = 'Major'
scalename = 'Chromatic'
scale = scales[scalename]
scale_int = 0 
g.scale_delivered = 0 --for change filter









root = 12  -- not 36


drum_mode = 0;
--drum_tog = true -- force drums



  
init = 1
global_scale = 0
global_transp = 0
scale_from_parse = false

g.is_lcd_enabled = false
--g.lcd_state = string.format("%-16.16s","L C D")
g.lcd_state = "LCD"
--g.lcd_state_delivered = string.format("%-16.16s","#")
g.lcd_state_delivered = "#"
g.note_delivered = 0

g.scope_item_index = 2 -- "_Scope" is item 2 in the table
g.var_item_index = 3 -- "_Var" is item 3 in the table

--FOR REDRUM BLINKING LIGHTS
g.step_value = { 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 }
g.step_is_playing = { 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 }
-- FL: Add state for the latest LED/Pad MIDI messages sent
g.last_led_output = { 100,100,100,100, 100,100,100,100, 100,100,100,100, 100,100,100,100, 100,100,100,100, 100,100,100,100 }


-- used in scale modes
--colors = {"02","04","08","10","20","40","7F"}
colors = {"07","41","60","31","61","39","15","3C","2D","7E","37","12",}
--red,o,y,g,b,d b,v
noscaleneeded = false
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
lcd_events = {}




--g.last_notevelocity_delivered={}
--g.last_note_delivered={}
g.last_note_delivered = 0
g.last_notevelocity_delivered = 0
g.current_notevelocity = 0
--livemodeswitch=nil
--modeswitch=nil


-- all sysex msg vars use table.concat
sysex_header = "F0 00 20 29 02 10"
sysex_setrgb = sysex_header.."0B" -- pad r g b
sysex_setled = sysex_header.."0A" -- pad color0-127
sysex_setrgbgrid = sysex_header.."15" -- 0=10x10;1=8x8 color0-127
sysex_scrolltext = sysex_header.."14" -- color0-127 loop1or0 asciitext
sysex_flashled = sysex_header.."23" -- pad color0-127
sysex_pulseled = sysex_header.."28" -- pad color0-127

sysend ="F7"

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--[[
Pad, , Palette, Transpose, Scale, Mode, Layout
Grid, Buttons 
Global or state





--]]
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- add some methods in at the points where I draw the color palette/scale to the pad to remember the current color; 
-- add a method into the point where I detect and transpose the note to keep an array of notes pressed and to send a method to display them; 
-- add a button class which will get inherited with what to do with each button. 
--[[
padcountindex=1
Pad ={}
Pad.__index = Pad
function Pad:new(o,ho,ve) 
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.thispad=(ho*10)+ve  --11-18 ... 81-88
	self.thispadhex=string.format("%02X",self.thispad)
	self.thisnote=notemode[ho]+ve
	self.thisdrum= ve>4 and drummode[ho]+ve or drummode[ho]+ve+28
--	if ve>4 then -- drum mode is 4 4x4 grids
--		thisdrum=thisdrum+28
--	end
	if note[self.thisnote] == nil then
		note[self.thisnote]={}
	end
	
	--return setmetatable({ x = x or 0, y = y or 0 }, Pad)
	return o
end

function Pad:makeSound()
  print('I say ' .. self.sound)
end

mrDog = Pad:new() 
mrDog:makeSound()









setmetatable(Pad, { __call = function(_, ...) return Pad.new(...) end })

function Pad.new(x, y)
  return setmetatable({ x = x or 0, y = y or 0 }, Pad)
end

Button = {}
Button.__index = Button
function Button:new(o,indx) 
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end
function Button:press()
	-- if (buttonindex[ret.y]~=nil
end
function Button:release()

end
Button:light()

end
Button:flash()

end




setmetatable(Button, { __call = function(_, ...) return Button.new(...) end })

Grid = {}


setmetatable(Grid, { __call = function(_, ...) return Grid.new(...) end })

--]]


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- FL: Assign to these the index to the first the corresponding items according
-- to the definition list in remote_init. (Or assign them when defining the items, depending on how you do that.)
-- g.btn_firstitem = 141 -- first -1 ! 
g.accent = 0
g.last_accent = 0
g.accent_dn = false
g.accent_count = 0
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Set some variables for later!
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
notemode = {35,40,45,50,55,60,65,70} -- left column -1
drummode = {35,39,43,47,51,55,59,63} -- left column -1
pad = {}
padindex = {} 
note = {}
drum = {}
buttonindex = {}
g.itemnum = {}
padpress = {} -- to display pressed

			do_update_pads = 1

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function def_vars()

	local index=1
	for ho=1,8 do --horizontal from bottom
		for ve=1,8 do -- vertical from left
			local thispad=(ho*10)+ve  --11-18 ... 81-88
			local thispadhex=string.format("%02X",thispad)
			local thisnote=notemode[ho]+ve
			local thisdrum=drummode[ho]+ve
			if ve>4 then -- drum mode is 4 4x4 grids
				thisdrum=thisdrum+28
			end
			if note[thisnote] == nil then
				note[thisnote]={}
			end
			table.insert(note[thisnote],thispad) --In note mode, a single note can be on one or two pads.	
			table.insert(pad,thispad,{
							padhex=thispadhex,
							note=thisnote,
							drum=thisdrum,
							index=index,
							itemindex=(index-1)+g.itemnum.first_pad,
							x=ho,
							y=ve,
							color=0,
							newcolor=0
			})
			table.insert(padindex,index,{
							pad=thispad,
							padhex=thispadhex,
							note=thisnote,
							drum=thisdrum,
							itemindex=(index-1)+g.itemnum.first_pad,
							x=ho,
							y=ve,
							color=0,
							newcolor=0
			})
			table.insert(drum,thisdrum,{
							pad=thispad,
							note=thisnote,
							index=index,
							x=ho,
							y=ve,
							color=0,
							newcolor=0
			})
			index=index+1 --index so I can cycle through the 64 pads quickly.
		end
		--items here.
		buttonindex[90+ho]=(g.itemnum.first_button-1)+ho
		buttonindex[ho]=(g.itemnum.first_button-1)+ho+8
		buttonindex[10*ho]=(g.itemnum.first_button-1)+ho+16
		buttonindex[(10*ho)+9]=(g.itemnum.first_button-1)+ho+24	
	end
	--[[
	remote.trace("start note\n")
	tprint(note)
	remote.trace("end note\n")
	--remote.trace(table.concat(note.pos, ", "))
	--remote.trace(table.concat(note, ", "))
	--remote.trace(table.concat(note.pos, ", "))
	--]]
	--tprint(buttonindex)
	--remote.trace(padindex[11].pad)
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function set_colorscales()
	for s,st in pairs(scales) do
		if type(st) == 'table' then
			--for u,r in ipairs(st) do
			local scale_len = table.getn(st)
			if scale_len == 7 then -- 7 and below
				root = 12 
			elseif scale_len == 6 then 
				root = 0 
			elseif scale_len == 5 then -- 2 root notes
				table.insert(0,1,st)
				scale_len = 6
			else
				root = 24 
			end  
			for pd=1,64,1 do
				local oct = math.floor((pd-1)/scale_len)
				local addnote = scale[1+modulo(i-1,scale_len)]
				local outnote = root+g.transpose+(12*oct)+addnote --note that gets played by synth
				local outnorm = modulo(outnote,12) --normalized to 0-11 range
				local padnum = padindex[i].padhex --note# that the controller led responds to
				
				
			end
		end
			
		
	end

end
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
--make a message to send ---------------------------------------
-- TODO still not sure where this would output
function make_lcd_midi_message(text)

remote.trace(text)
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
--UTILITY: this function is called when we need to update a slider LCD
function update_slider(item)
--[[
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
		p_path = "/Reason/0/LPP/0/Fader_"..(item-sli_start).."/lcd_name " -- "sli_start" (-4) because the sliders start at index 3 in table items, but we start our OSC Slider names at 0.
		v_path = "/Reason/0/LPP/0/Fader_"..(item-sli_start).."/lcd_value "
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
--]]
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




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
function vprint (strng,vari)
	remote.trace(strng .. ": "..tostring(vari)..'\n')
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
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_init(manufacturer, model)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- this version
	if model=="LP Pro" then
		local items={
--items
			{name="Keyboard",input="keyboard"},
			{name="_Scope", output="text", itemnum="scope"}, --device, e.g. "Thor"
			{name="_Var", output="text", itemnum="var"}, --variation, e.g. "Volume" or "Filters"
			{name="Pitch Bend", input="value", min=0, max=16383, itemnum="pitchbend"},
			{name="Modulation", input="value", min=0, max=127, itemnum="modulation"},
			{name="Channel Pressure", input="value", min=0, max=127, itemnum="channelpressure"},
			{name="Fader 1", input="value", min=0, max=127, output="value", modes={"Program","Fader"}, itemnum="first_fader"},
			{name="Fader 2", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 3", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 4", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 5", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 6", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 7", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
			{name="Fader 8", input="value", min=0, max=127, output="value", modes={"Program","Fader"}},
--			{name="Fader 9", input="value", min=0, max=127, output="value"},
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
--left to right Top
			{name="Shift Button 91", input="button", min=0, max=127, output="value"},
			{name="Shift Button 92", input="button", min=0, max=127, output="value"},
			{name="Shift Button 93", input="button", min=0, max=127, output="value"},
			{name="Shift Button 94", input="button", min=0, max=127, output="value"},
			{name="Shift Button 95", input="button", min=0, max=127, output="value"},
			{name="Shift Button 96", input="button", min=0, max=127, output="value"},
			{name="Shift Button 97", input="button", min=0, max=127, output="value"},
			{name="Shift Button 98", input="button", min=0, max=127, output="value"},
--left to right Bottom
			{name="Shift Button 01", input="button", min=0, max=127, output="value"},
			{name="Shift Button 02", input="button", min=0, max=127, output="value"},
			{name="Shift Button 03", input="button", min=0, max=127, output="value"},
			{name="Shift Button 04", input="button", min=0, max=127, output="value"},
			{name="Shift Button 05", input="button", min=0, max=127, output="value"},
			{name="Shift Button 06", input="button", min=0, max=127, output="value"},
			{name="Shift Button 07", input="button", min=0, max=127, output="value"},
			{name="Shift Button 08", input="button", min=0, max=127, output="value"},
			{name="Pad 32 Alt", input="value", min=0, max=2, output="value", itemnum="accent"},





			}
 --tprint(items) --Useful for counting
-- some items need to be noted, so here's where g.itemnum["thing"] is set
for it=1,table.getn(items),1 do
	if items[it].itemnum ~= nil then
		g.itemnum[items[it].itemnum]=it
	end
end
--vprint("fp",g.itemnum.first_pad)
--vprint("acc",g.itemnum.accent)
--[[
first_fader
first_press
first_pad
first_step_item
first_step_playing_item 
accent
first_button 
--]] 
--tprint(g.itemnum)
		remote.trace("here!")
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


			{pattern="90 01 xx", name="Button 01", x="1+(126*value)"},
			{pattern="90 02 xx", name="Button 02", x="1+(31*value)"}, 
			{pattern="90 03 xx", name="Button 03", x="4+(28*value)"}, 
			{pattern="90 04 xx", name="Button 04", x="8+(8*value)"},
			{pattern="90 05 xx", name="Button 05", x="64*value"}, 
			{pattern="90 06 xx", name="Button 06", x="64*value"}, 
			{pattern="90 07 xx", name="Button 07", x="64*value"}, 
			{pattern="90 08 xx", name="Button 08", x="64*value"}, 
			
			{pattern="90 01 xx", name="Shift Button 01", x="1+(126*value)"},
			{pattern="90 02 xx", name="Shift Button 02", x="1+(31*value)"}, 
			{pattern="90 03 xx", name="Shift Button 03", x="4+(28*value)"}, 
			{pattern="90 04 xx", name="Shift Button 04", x="8+(8*value)"},
			{pattern="90 05 xx", name="Shift Button 05", x="64*value"}, 
			{pattern="90 06 xx", name="Shift Button 06", x="64*value"}, 
			{pattern="90 07 xx", name="Shift Button 07", x="64*value"}, 
			{pattern="90 08 xx", name="Shift Button 08", x="64*value"}, 

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
		set_palettes()
	end
end

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


























-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_process_midi(event)
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--remote.trace(event.size)
--remote.trace("evsize")


-- -----------------------------------------------------------------------------------------------
-- Match buttons and notes and transpose notes.
-- -----------------------------------------------------------------------------------------------

--[[
if event.size==3 then -- Note, button, channel pressure

-- 1001 is 90 (note on) 1011 is B0 (controller) 
	ret =    remote.match_midi("<10x1>? yy zz",event) --find a pad, button on or off
	if(ret~=nil) then
tprint(ret)
		tran_pad = ret.z
		local notein = ret.y
		local valuein = ret.x	  



			local new_note = ret.y 
			local new_notevelocity = ret.z 
			if (g.last_notevelocity_delivered~=new_notevelocity) and (g.last_note_delivered~=new_note) then -- draw new notevelocity
				g.current_note=new_note
				g.current_notevelocity=new_notevelocity
				
			
			end
--]]
--[[


				local msg={ time_stamp = event.time_stamp, item=g.itemnum.accent, value = g.accent_count, note = "2B",velocity = accent_pad.z }
				remote.handle_input(msg)
				g.note_delivered = noteout
				return true


--	elseif ret
			local var_event = make_lcd_midi_message("New Note "..new_note)
			table.insert(lcd_events,var_event)
	end -- ret, button not nil
--]]
	
	
	
	
	
	
	
	
	
-----------------------------------
--
-----------------------------------
if event.size==3 then -- Note, button, channel pressure

-- 1001 is 90 (note on) 1011 is B0 (controller)	

	ret =    remote.match_midi("<10x1>? yy zz",event) --find a pad, button on or off, Not aftouch
	if(ret~=nil) then
		button = ret.x --  check 1 = button
		
		if ret.z == 0 then -- faking note on and off for the checks later. x is 'value', 0 or 1 for keyboard items.
			ret.x =0
		else
			ret.x =1
		end
		tran_pad = ret.z
		
-----------------------------------
-- handle buttons
-----------------------------------
		if button==1 then

			local shiftbtn = remote.match_midi("B? 50 zz",event) -- 80 Shift
			local clickbtn = remote.match_midi("B? 46 zz",event) -- 70 Shift
			local undobtn  = remote.match_midi("B? 3C zz",event) -- 70 Shift
			-- accent?
			local accent_pad = remote.match_midi("B? 32 zz",event) -- 50 delete
			-- make checks for these
			local scale_up = remote.match_midi("B? 5B zz",event) --find 91 up
			local scale_dn = remote.match_midi("B? 5C zz",event) --find 92 dn
			local tran_up =  remote.match_midi("B? 5D zz",event) --find 93 left
			local tran_dn =  remote.match_midi("B? 5E zz",event) --find 94 right


-- -----------------------------------------------------------------------------------------------
-- Accent button
-- TODO: changing this to a pad, not button
-- 
-- -----------------------------------------------------------------------------------------------

			if(accent_pad) then
			  if(accent_pad.z>0) then		  
				g.accent_dn = true
				g.accent_count = modulo(g.accent_count+1,3)
				local msg={ time_stamp = event.time_stamp, item=g.itemnum.accent, value = g.accent_count, note = "32",velocity = accent_pad.z }
				remote.handle_input(msg)
				--g.note_delivered = noteout
				return true
			  else
				return false
			  end
			end
-- -----------------------------------------------------------------------------------------------
-- Shift button
-- -----------------------------------------------------------------------------------------------
			if (shiftbtn) then
				if shiftbtn.z>0 then
					g.button.shift = 1 --momentary like a computer's shift key
				else
					g.button.shift = 0
				end
			end
-- -----------------------------------------------------------------------------------------------
-- Click button
-- -----------------------------------------------------------------------------------------------
			if (clickbtn) then
				if clickbtn.z>0 then
					g.button.click = 1 --momentary like a computer's shift key
				else
					g.button.click = 0
				end
			end
-- -----------------------------------------------------------------------------------------------
-- shiftclick button
-- -----------------------------------------------------------------------------------------------
			if (g.button.click == 1)  and (g.button.shift == 1) then
				g.button.shiftclick = 1 --momentary like a computer's shift key
			else
				g.button.shiftclick = 0
			end
	-- -----------------------------------------------------------------------------------------------
-- check below per button, then we check each for shift and click with elseif
-- 
-- -----------------------------------------------------------------------------------------------
		
			if(tran_up) then
				if tran_up.z>0 then
					if g.button.shiftclick_delivered == 0 then
						g.transpose = g.transpose+(1-g.button.shift)+(g.button.shift*12) -- if sh pressed, add 12, else just 1
						global_transp = g.transpose
						transpose_changed = true
					elseif g.button.shiftclick_delivered == 1 then -- 

-- transpose by circle of fifths!
						local cof ={0,7,2,9,4,11,6,1,8,3,10,5}
						local tr_note = 1+modulo(math.abs(global_transp),12)
						local tr_oct = math.abs(math.floor(global_transp/12))
						local cof_tr = tr_oct < 3 and 5 or -7
vprint("global_transp",global_transp)
vprint("tr_note",tr_note)
vprint("tr_oct",tr_oct)
vprint("cof_tr",cof_tr)
vprint("g-cof",g.transpose-cof_tr)

						g.transpose = g.transpose+cof_tr
--						g.transpose = cof_tr
						global_transp = g.transpose
					end	
				end
			end
			if(tran_dn) then
				if tran_dn.z>0 then
					if g.button.shiftclick_delivered == 0 then
						g.transpose = g.transpose-(1-g.button.shift)-(g.button.shift*12)
						global_transp = g.transpose
						transpose_changed = true
					elseif g.button.shiftclick_delivered == 1 then -- 
-- transpose by circle of fifths!
-- we cirlce around the root note here, so if root = F#, we cycle back to a lower/higher octave, rather than run out of notes. 
						local cof ={0,7,2,9,4,11,6,1,8,3,10,5}
						local tr_note =1+modulo(math.abs(global_transp),12)
						local tr_oct = math.floor(global_transp/12)
						local cof_tr = tr_oct < 3 and -5 or 7
vprint("global_transp",global_transp)
vprint("tr_note",tr_note)
vprint("tr_oct",tr_oct)
vprint("cof_tr",cof_tr)
vprint("g-cof",g.transpose-cof_tr)
--						g.transpose = g.transpose-cof_tr
						g.transpose = g.transpose-cof_tr
						global_transp = g.transpose
						transpose_changed = true

					end	
				end
			end
			if(scale_up) then
				if scale_up.z>0 then
					if g.button.shiftclick_delivered == 0 then
--						scale_int = modulo(scale_int+1,36) --only use the first 36 scales
vprint("scale was ",global_scale)
						scale_int = modulo(global_scale+1,38) --only use the first 37 scales
vprint("scale is ",scale_int)
						scalename = scalenames[1+scale_int]
						scale = scales[scalename]
						global_scale = scale_int
						scale_from_parse = false
remote.trace("scale up "..scalename)
					elseif g.button.shiftclick_delivered == 1 then -- color palette
						g.palette_selected = g.palette_selected+1
						g.palette_global = 1 + (modulo(g.palette_selected,g.palettes_length))
						palette_changed = true
					end	
				end
			end
			if(scale_dn) then
				if scale_dn.z>0 then
					if g.button.shiftclick_delivered == 0 then
--						scale_int = modulo(scale_int-1,36) --only use the first 36 scales
vprint("scale was ",global_scale)
						scale_int = modulo(global_scale-1,38) --only use the first 38 scales
vprint("scale is ",scale_int)
						scalename = scalenames[1+scale_int]
						scale = scales[scalename]
						global_scale = scale_int
						scale_from_parse = false
remote.trace("scale dn "..scalename)
					elseif g.button.shiftclick_delivered == 1 then -- color palette
						g.palette_selected = g.palette_selected-1
	--					g.palette_global = 1 + (modulo(math.abs(g.palette_selected),g.palettes_length)) -- +1 mod from 0
						g.palette_global = 1 + (modulo(g.palette_selected,g.palettes_length)) -- +1 mod from 0
						palette_changed = true
					end	
				end
			end
-- -----------------------------------------------------------------------------------------------
-- more buttons go here
-- TODO modulation bottom row
-- TODO pitch






----------------------------------------------------
-- TODO, comment more
-- detecting buttons here, but only if shift pressed?

		
		if (buttonindex[ret.y]~=nil and g.button.shift==1) then -- buttons
			local noteout = ret.y --no offset
			local itemno = buttonindex[ret.y].itemindex -- items index.
			if(ret.z>0) then
				local msg={ time_stamp = event.time_stamp, item=itemno, value = ret.x, note = noteout,velocity = ret.z }
				remote.handle_input(msg)
			end
			return true
		end







--[[

			if(drum_tog) then
				drum_mode = 1-drum_mode
			end
--]]
--[[
			if(tran_rst) then
				g.transpose=0
			end
--]]
		-- change this!
		
		

		end -- button
--------------------------------------------------------------------------------------------------------------------------		
--------------------------------------------------------------------------------------------------------------------------		












		
--------------------------------------------------------------------------------------------------------------------------		
-- here's where the incoming note gets transposed!
--------------------------------------------------------------------------------------------------------------------------		
		
		if (ret.y>10 and ret.y<89) and (noscaleneeded==false) and (button==0) then -- 11 to 88, but not button


			---if the pads have transposed, then we need to turn off the last note----------------------
			if(transpose_changed == true) then
				local prev_off={ time_stamp = event.time_stamp, item=1, value = ret.x, note = g.note_delivered, velocity = 0 }
				remote.handle_input(prev_off)
				transpose_changed = false
			end 
			
---------------------------------------------------			
-- Calculate the note delivered based on the current scale and pad pressed.
-- TODO add an else to keep noteout in this range
---------------------------------------------------			
			local padid = pad[ret.y].index-1
			local scale_len = table.getn(scale)
----------------------------------------------------			
			if scale_len == 7 then -- 7 and below
				root = 12 
			elseif scale_len == 6 then 
				root = 0 
			elseif scale_len == 5 then -- 2 root notes
				table.insert(scale,1,0)
				scale_len = 6
			else
				root = 24 
			end  
----------------------------------------------------			
			local ind = 1+modulo(padid,scale_len)  --modulo using the operator % gave me trouble in reason, so I wrote a custom fcn
			local oct = math.floor(padid/scale_len)
			local addnote = scale[ind]
			local noteout = root+g.transpose+(12*oct)+addnote
----------------------------------------------------			
--[[
vprint("padid",padid)
vprint("oct",oct)
vprint("addnote",addnote)
vprint("ind",ind)
vprint("noteout",noteout)
--]]
----------------------------------------------------			
			if (noteout<127 and noteout>0) then
				local msg={ time_stamp = event.time_stamp, item=1, value = ret.x, note = noteout,velocity = ret.z }
				remote.handle_input(msg)
				g.note_delivered = noteout
				return true
			end
----------------------------------------------------
-- here we display the pressed note
----------------------------------------------------
			local new_note = ret.y 
			local new_notevelocity = ret.z 
			if (g.last_notevelocity_delivered~=new_notevelocity) and (g.last_note_delivered~=new_note) then -- draw new notevelocity
				g.current_note=new_note
				g.current_notevelocity=new_notevelocity	
			end
----------------------------------------------------			






			

--[[
--]]
		else
			return false
		end
	end -- ret not nil
	

-----------------------------------
-- 1010 is poly aftertouch
-- 1101 is channel aftertouch
-- TODO: map poly to chan, maybe display output
-- poly not supported in reason...	
-----------------------------------

	return false
	

-------------------------------------------------------

	
end -- eventsize=3


	
-- -----------------------------------------------------------------------------------------------
-- Return from scrolling text	
-- -----------------------------------------------------------------------------------------------
if event.size==8 then
	local textreturnswitch = remote.match_midi("F0 00 20 29 02 10 15 F7",event) --find if we are retuning from scrolling text
	if (textreturnswitch) then
		-- probably do nothing
		g.set_mode=1 -- should flash it back to frlight on
	end
	return true
end -- eventsize=8

	
-- -----------------------------------------------------------------------------------------------
-- Keep it in programmer mode	
-- -----------------------------------------------------------------------------------------------
-- in the furture we will allow other modes... fader, etc.

if event.size==9 then
	local modeswitch = remote.match_midi("F0 00 20 29 02 10 2F xx F7",event) --find what mode we are in
	local livemodeswitch = remote.match_midi("F0 00 20 29 02 10 2D xx F7",event) --find if we are in live mode (At startup, we turn on standalone, which fires this.)
	if (modeswitch) then
--remote.trace(modeswitch.x)
		g.mode=modeswitch.x
		if modeswitch.x ~=3 then
			g.set_mode=3
		end
	elseif (livemodeswitch) then 
			g.set_mode=3
	end
	
-- This next will only be sent on the 1st LPP midi channel, so it's not relevant here.
--[[
	livemodeswitch = remote.match_midi("F0 00 20 29 02 10 2D xx F7",event) --find if we are in live mode
	if(livemodeswitch) then
remote.trace(livemodeswitch.x)
		g.livemode=livemodeswitch.x
		if livemodeswitch.x ~=1 then
			g.set_livemode=1
		end
	
	end
--]]
	return true
end -- eventsize=9
-- -----------------------------------------------------------------------------------------------





end
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
		local upevent={}
		local dnevent={}
		local padevent={}
		local ltevent={}
		local rtevent={}
		local shevent={}
		local clevent={}
		local shclevent={}
		local padupdate={}
		local mode_event={}
		local frlight_event={}
		local iskong = false
		local isvarchange = false
		local istracktext = false
		local do_update_pads = 0

-- -----------------------------------------------------------------------------------------------
-- Keep it in programmer mode	FOR NOW
-- -----------------------------------------------------------------------------------------------
		if g.set_mode~=g.mode then
			mode_event = remote.make_midi("F0 00 20 29 02 10 2C xx F7",{ x = g.set_mode, port=1 })
			table.insert(lpp_events,mode_event)
			frlight_event = remote.make_midi("F0 00 20 29 02 10 0A 63 32 F7",{ port=1 }) --Front light purp
			table.insert(lpp_events,frlight_event)
			g.mode=g.set_mode
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
-- -----------------------------------------------------------------------------------------------




-- Need to output shift a better way
-- maybe change it's color!



-- -----------------------------------------------------------------------------------------------
-- Shift button
-- -----------------------------------------------------------------------------------------------

		--if we have pressed shift 
		if g.button.shift_delivered~=g.button.shift  then
			local shcolors = {"21","05"} -- green, red
			shevent = remote.make_midi("90 50 "..shcolors[g.button.shift+1])		
			table.insert(lpp_events,shevent)
			g.button.shift_delivered = g.button.shift
		end
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- Click button
-- -----------------------------------------------------------------------------------------------

		--if we have pressed click----------------------------------------
		if g.button.click_delivered~=g.button.click  then
			local clcolors = {"21","05"} -- green, red
			clevent = remote.make_midi("90 46 "..clcolors[g.button.click+1])	
			table.insert(lpp_events,clevent)
			g.button.click_delivered = g.button.click
		end
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- shiftclick button
-- -----------------------------------------------------------------------------------------------

		--if we have pressed click and shift----------------------------------------
		if g.button.shiftclick_delivered~=g.button.shiftclick  then
			local shclcolors = {"21","05","31"} -- green, red, purp
			shclevent = remote.make_midi("90 50 "..shclcolors[g.button.shiftclick+g.button.shift+1])		
			table.insert(lpp_events,shclevent)
			shclevent = remote.make_midi("90 46 "..shclcolors[g.button.shiftclick+g.button.click+1])	
			table.insert(lpp_events,shclevent)
			g.button.shiftclick_delivered = g.button.shiftclick
-- both buttons pressed reveal other options, display here

		end
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- Transpose display
-- -----------------------------------------------------------------------------------------------
--[[

		--if there's a change in transpose, we need to show that
		if g.transpose_delivered~=g.transpose  then
			local shcolors = {"21","05"} -- green, red
			shevent = remote.make_midi("90 50 "..shcolors[g.button.shift+1])
			if(tran_pad~=nil) then
				if g.button.shift==1 or tran_pad>0 then

--this needs to change to some color output
-- maybe side buttons
				--show transpose in 7seg
					local xpose = string.format("%02i",math.abs(g.transpose) )
					local c_one = string.format("%02x", string.sub(xpose,1,1) )
					local c_two = string.format("%02x", string.sub(xpose,2,2) )
					ltevent = remote.make_midi("b0 22 "..c_one)
					table.insert(lpp_events,ltevent)
					rtevent = remote.make_midi("b0 23 "..c_two)
					table.insert(lpp_events,rtevent)
					local transpose_event = make_lcd_midi_message("/Reason/0/LPP/0/display/3/display/ "..g.transpose)
					table.insert(lcd_events,transpose_event)
				else
					--return to scale
					local scale_abrv = scaleabrvs[scalename]
					local c_one = string.sub(scale_abrv,1,1)
					local c_two = string.sub(scale_abrv,2,2)
					ltevent = remote.make_midi("b0 22 "..sevseg[c_one])
					table.insert(lpp_events,ltevent)
					rtevent = remote.make_midi("b0 23 "..sevseg[c_two])
					table.insert(lpp_events,rtevent)
					local scalename_event = make_lcd_midi_message("/Reason/0/LPP/0/display/2/display/ "..scalename)
					table.insert(lcd_events,scalename_event)
				end
			end
		
			table.insert(lpp_events,shevent)
			g.button.shift_delivered = g.button.shift
		end
---]]
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
--this needs to change to some color output
		--if scale changes, we update the LCD
--------------------------------------------------------------------------------
		if ( (g.scale_delivered~=scale_int or g.transpose_delivered~=g.transpose) and g.button.shift~=1 and tran_pad==0) then
--[[
			local scale_abrv = scaleabrvs[scalename]
			local c_one = string.sub(scale_abrv,1,1)
			local c_two = string.sub(scale_abrv,2,2)
			ltevent = remote.make_midi("b0 22 "..sevseg[c_one])
			table.insert(lpp_events,ltevent)
			rtevent = remote.make_midi("b0 23 "..sevseg[c_two])
			table.insert(lpp_events,rtevent)
--]]
			g.scale_delivered = scale_int
--[[
			local scalename_event = make_lcd_midi_message("/Reason/0/LPP/0/display/2/display/ "..scalename)
			table.insert(lcd_events,scalename_event)
--]]
			if(noscaleneeded == false) then
				do_update_pads = 1
			end
			--remote.trace(scalename)
vprint("scalename",scalename)
		end
--[[
--]]
-- -----------------------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------------------
		--if transpose changes, we transpose--------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
		if g.transpose_delivered~=g.transpose then
--vprint("g.transpose",g.transpose)
--tprint(palette)
--			local color_len = g.palettes_length
--			local color_len = table.getn(colors)
			local color_len = 12
--			local color_ind=1 + (modulo( math.floor(math.abs(g.transpose)/12),color_len)) --change color every octave
--			local color_ind=1 + (modulo(g.transpose,color_len)) --change color every Note, show root
--			local color_ind = (modulo(math.abs(g.transpose),color_len)) --change color every Note, show root
			local color_ind = (modulo(g.transpose,color_len)) --change color every Note, show root
--vprint("color_ind",color_ind)

--			local color = colors[color_ind]




			if g.transpose>0 then
				--upevent = remote.make_midi("90 5D "..color)
				dnevent = remote.make_midi(table.concat({sysex_setrgb,"5D",g.palette[color_ind].R, g.palette[color_ind].G, g.palette[color_ind].B,sysend}," "))
				table.insert(lpp_events,dnevent)
				dnevent = remote.make_midi("90 5E 00")
				table.insert(lpp_events,dnevent)
			elseif g.transpose<0 then
				upevent = remote.make_midi("90 5D 00")
				table.insert(lpp_events,upevent)
				--dnevent = remote.make_midi("90 5E "..color)
				dnevent = remote.make_midi(table.concat({sysex_setrgb,"5E",g.palette[color_ind].R, g.palette[color_ind].G, g.palette[color_ind].B,sysend}," "))
				table.insert(lpp_events,dnevent)
			elseif g.transpose==0 then
				upevent = remote.make_midi(table.concat({sysex_setrgb,"5D",g.palette[color_ind].R ,g.palette[color_ind].G, g.palette[color_ind].B,"5E",g.palette[color_ind].R, g.palette[color_ind].G, g.palette[color_ind].B,sysend}," "))
				table.insert(lpp_events,upevent)
			end	
--[[
--]]
--[[
--]]
			g.transpose_delivered = g.transpose
			do_update_pads = 1
vprint("g.transpose 1",g.transpose)
vprint("color_ind",color_ind)
		end
-- -----------------------------------------------------------------------------------------------
		
-- -----------------------------------------------------------------------------------------------
		--if palette changes, we transpose
--------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
		if g.palette_delivered~=g.palette_selected then
-- or palette_changed = true ??????????????????

			g.palette = palettes[palettenames[g.palette_global]] --glo changed at button

--			local palette_len = table.getn(palettenames)
--			local palette_len = g.palettes_length
--			local palette_ind=1 + (modulo(math.abs(g.palette_selected),palette_len)) -- +1 because mod is from 0 ???g.palette_global
--not displaying here
--[[
			if g.palette>0 then
				upevent = remote.make_midi("90 5D "..color)
				table.insert(lpp_events,upevent)
				dnevent = remote.make_midi("90 5E 00")
				table.insert(lpp_events,dnevent)
			elseif g.palette<0 then
				upevent = remote.make_midi("90 5D 00")
				table.insert(lpp_events,upevent)
				dnevent = remote.make_midi("90 5E "..color)
				table.insert(lpp_events,dnevent)
			elseif g.palette==0 then
				upevent = remote.make_midi("90 5D 00")
				table.insert(lpp_events,upevent)
				dnevent = remote.make_midi("90 5E 00")
				table.insert(lpp_events,dnevent)
			end	
--]]
			g.palette_delivered = g.palette_selected
			do_update_pads = 1
vprint("palette_glo",g.palette_global)
vprint("palette_sel",g.palette_selected)
vprint("palette",palettenames[g.palette_global])
--vprint("palette_ind",palette_ind)
--vprint("g.palette",g.palette)
--vprint("pal",table.getn(palettes))
--tprint(palette[1])
		end
-- -----------------------------------------------------------------------------------------------
		
		
-- -----------------------------------------------------------------------------------------------
		--if vartext from _Var item in remotemap has changed	-----------------
-- -----------------------------------------------------------------------------------------------
		if g.vartext_prev~=g.vartext then
			--Let the LCD know what the variation is
			local vartext = remote.get_item_text_value(g.var_item_index)
--[[
			local var_event = make_lcd_midi_message("/Reason/0/LPP/0/display/1/display "..vartext)
			table.insert(lcd_events,var_event)
--]]
			g.vartext_prev = g.vartext
			isvarchange = true
		end
		
		
		
--[[
-- -----------------------------------------------------------------------------------------------
		--lcd event and text parsing for scale detection from text in track name----------------------------------------
-- -----------------------------------------------------------------------------------------------
		local new_text = g.lcd_state
		if g.lcd_state_delivered~=new_text then
			g.lcd_state_delivered = new_text
			local use_global_scale = false
			istracktext = string.find(new_text,"Track") == 1 --The word "track" is the first word
			if (istracktext==false) then
--]]
--[[
				if(g.lcd_index>=sli_start and g.lcd_index<=sli_end) then --if it's a Slider
					--we'll make the parameter/value/unit list into two arrays for our LCD, then send a long string to LCD
					update_slider(g.lcd_index)	
				end
--]]
--[[

			end
-- -----------------------------------------------------------------------------------------------
--]]

-- -----------------------------------------------------------------------------------------------
			--parse the text to see if there's any scale or transpose info----------------------------------------
-- -----------------------------------------------------------------------------------------------
			if istracktext==true then			
				--if scopetext from _Scope item has changed	
				if g.scopetext_prev~=g.scopetext then
	
--[[
					--Let the LCD know what the device is
					local const_event = make_lcd_midi_message("/Reason/0/LPP/0/display/4/display "..g.scopetext)
					table.insert(lcd_events,const_event)
--]]
					--detect Redrum
					if(g.scopetext=="Redrum") then
						noscaleneeded = true	
						do_update_pads = 0
						g.clearpads = 1
					else
						if(noscaleneeded == true) then						
							do_update_pads = 1
						end
						noscaleneeded = false
					end
					--if we've landed on a Kong, _Scope reports "KONG" and we change to drum scale
					if(g.scopetext=="KONG" and scale_int~=7) then
						if scale_from_parse==false then
							global_scale = scale_int
						end
						set_scale(7)
						iskong = true
					else
						use_global_scale = true
					end
					g.scopetext_prev = g.scopetext
				end
--[[
--]]	
--[[			
-- -----------------------------------------------------------------------------------------------
				--send LCD the Track name text----------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
				local track_event = make_lcd_midi_message("/Reason/0/LPP/0/display/0/display "..new_text)
				table.insert(lcd_events,track_event)
--]]
--[[
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
--]]
--[[
-- -----------------------------------------------------------------------------------------------
				--send scale name to LCD----------------------------------------
-- -----------------------------------------------------------------------------------------------
				local scalename_event = make_lcd_midi_message("/Reason/0/LPP/0/display/2/display/ "..scalename)
				table.insert(lcd_events,scalename_event)
--]]
				---If it's not a Kong, and there's no scale in the Track name, set to global_scale
				if use_global_scale and iskong==false then
					set_scale(global_scale)
--[[
					--local prev_event = make_lcd_midi_message("PREV SCALE "..global_scale.." "..g.scale_delivered)
					--table.insert(lcd_events,prev_event)
--]]
				end
--[[
-- -----------------------------------------------------------------------------------------------
				--see if there's a transpose in the track text----------------------------------------
-- -----------------------------------------------------------------------------------------------

				local transp = ""
				tsearch = string.find(new_text, 'trans') or string.find(new_text, 'transpose')
				eqtsearch = string.find(new_text, '=%d',tsearch) --look for a value
				if(tsearch and eqtsearch) then
					--global_transp = g.transpose
					trans_parsed = tonumber( string.sub(new_text,eqtsearch+1,eqtsearch+2) )
					if(g.transpose~=trans_parsed) then
						g.transpose = trans_parsed
						transpose_changed = true
					end
				else
					if(g.transpose~=global_transp) then
						g.transpose = global_transp
						transpose_changed = true
					end
				end
--]]
				--send LCD transpose value
				if(transpose_changed) then
--[[
					local transpose_event = make_lcd_midi_message("/Reason/0/LPP/0/display/1/display/ "..g.transpose)
					table.insert(lcd_events,transpose_event)
--]]
				end
--[[
			end
			--done looking at "Track" labels------------------------------------------------------
--]]
		end
-- -----------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
--[[
		if istracktext==true or isvarchange==true then
		--refresh LCD with all the parameters and values for the sliders when a new track is selected----------------------------------------
			for i = sli_start,sli_end do
				--update_slider(i)
			end
		end
--]]
-- -----------------------------------------------------------------------------------------------


--[[
--]]
-- -----------------------------------------------------------------------------------------------
		-- color the pads if scale or transpose changed----------------------------------------
-- -----------------------------------------------------------------------------------------------		
		if(do_update_pads==1) then
--	  table.insert(lcd_events,upd_event)
			if(scalename~='DrumPad') then
				local padsysex = ""
				for i=1,64,1 do
					local padid = i-1
					local scale_len = table.getn(scale)
					if scale_len == 7 then -- 7 and below
						root = 12 
					elseif scale_len == 6 then 
						root = 0 
					elseif scale_len == 5 then -- 2 root notes
						table.insert(scale,1,0)
						scale_len = 6
					else
						root = 24 
					end  

					local oct = math.floor(padid/scale_len)
					local addnote = scale[1+modulo(i-1,scale_len)]
					local outnote = root+g.transpose+(12*oct)+addnote --note that gets played by synth
					local outnorm = modulo(outnote,12) --normalized to 0-11 range
--					local padnum = string.format("%x",i+35) --note# that the controller led responds to
					local padnum = padindex[i].padhex --note# that the controller led responds to
--					local keycolors = {"03","0D","2D"} --white,yellow,blue
--					local whites = {2, 4, 5, 7, 9, 11}
--[[
vprint("padid",padid)
vprint("oct",oct)
vprint("addnote",addnote)
vprint("outnote",outnote)
vprint("outnorm",outnorm)
--vprint("",)
--]]
					--remote.trace("\n i: "..i.." padid: "..padid.." outnorm "..outnorm.." outnote "..outnote.." xpose "..g.transpose.." addnote "..addnote)
-- -----------------------------------------------------------------------------------------------
--[[
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
-- -----------------------------------------------------------------------------------------------
-- NEW					
						padevent[i]=remote.make_midi("90 "..padnum.." "..  colorscale[outnorm].hcolor)
						table.insert(lpp_events,padevent[i])
--]]

-- EVEN NEWER
-- Something something sysex
--						padsysex=padsysex..padnum.." "..colorscale[outnorm].R .." ".. colorscale[outnorm].G .." "..colorscale[outnorm].B
--						padsysex=padsysex..padnum.." "..g.palette[outnorm].R .." ".. g.palette[outnorm].G .." "..g.palette[outnorm].B
						padsysex=table.concat({padsysex,padnum,g.palette[outnorm].R,g.palette[outnorm].G,g.palette[outnorm].B}," ")
-- even even new, keep a list of all the pads, and which are pressed, and colors they return to.


						
				end --end for 1,64
				padupdate=remote.make_midi(table.concat({sysex_header,"0B",padsysex,sysend}," "))
				table.insert(lpp_events,padupdate)
				--error(padsysex)








			elseif scalename=='DrumPad' then

				--do drumpad color scheme
				for i=1,64,1 do
--					local padnum = string.format("%x",i+36) --note# that the controller led responds to
					local padnum = padindex[i].padhex --note# that the controller led responds to
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
				
				
			end -- drumpad or not
			
			
			
		end --update_pads ==1
-- -----------------------------------------------------------------------------------------------






--[[
--]]
-- -----------------------------------------------------------------------------------------------
--Redrum

--TODO
-- -----------------------------------------------------------------------------------------------
		if(g.scopetext=="Redrum") then

--local padnotes = {60,61,62,63,64,65,66,67, 52,53,54,55,56,57,58,59, 44,45,46,47,48,49,50,51}
--			local padnotes = {31,32,33,34,35,36,37,38}
			--if we've just landed on Redrum, we need to clear out the 3rd row of pads, otherwise they maintain LEDs from pvs scope
			if g.clearpads==1 then
				for pad=1,8 do
		--			local padnum = string.format("%02x",padnotes[pad])
		--			local padnum = padindex[i].padhex
		--			local padnum = padindex[padnotes[pad]].padhex
					local padnum = pad[i+30].padhex
					local event = remote.make_midi("90 "..padnum.." 00")
					table.insert(lpp_events,event)
				end	 
				g.clearpads=0
			end
		--flash drums playing on selected pads
			for pad=1,8 do
				local led_value = 0
				led_value = make_led_value(pad,4,32) --cyan/blue for drum selects
				local last_value = g.last_led_output[pad]
				if led_value ~= last_value then
					-- send note
		--			local padnum = string.format("%02x",padnotes[pad])
		--			local padnum = padindex[i].padhex
		--			local padnum = padindex[padnotes[pad]].padhex
					local padnum = pad[i+30].padhex
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
				local accnote = padindex[32].padhex -- "30"
				local event = remote.make_midi("90 "..accnote.." xx", { x=acccolor })
				table.insert(lpp_events,event)
				g.last_accent = g.accent
			end
		end
-- -----------------------------------------------------------------------------------------------















-- -----------------------------------------------------------------------------------------------
		--initialize colors:
-- -----------------------------------------------------------------------------------------------
		if init==1 then
		remote.trace("in init!")
			local padsysex = ""
--[[
			padsysex=padsysex.."50 3D 3D 0F "
			padsysex=padsysex.."46 3D 3D 0F "
--]]
			local firstcolors={
				--remote.make_midi(sysex_header .."0E 10 F7"),
				remote.make_midi("90 50 21"),
				remote.make_midi("90 46 21"),
			}
			local first_len = table.getn(firstcolors)
			for i=1,first_len,1 do
				table.insert(lpp_events,firstcolors[i])
			end	
--tprint(firstcolors)
-- -----------------------------------------------------------------------------------------------
				--initialize pads
g.palettes_length = table.getn(palettenames)
palettename = 'Catblack'
g.palette = palettes[palettenames[10]]
palette_int = 0 
g.palette_delivered = 9 --for change filter
g.palette_selected = 9 -- record of presses, goes up and dn
g.palette_global = 9 -- current pal
					local scale_len = table.getn(scale)
					if scale_len == 7 then -- 7 and below
						root = 12 
					elseif scale_len == 6 then 
						root = 0 
					elseif scale_len == 5 then -- 2 root notes
						table.insert(scale,1,0)
						scale_len = 6
					else
						root = 24 
					end  
				for i=1,64,1 do
					local padid = i-1

					local oct = math.floor(padid/scale_len)
					local addnote = scale[1+modulo(i-1,scale_len)]
					local outnote = root+g.transpose+(12*oct)+addnote --note that gets played by synth
					local outnorm = modulo(outnote,12) --normalized to 0-11 range
					local padnum = padindex[i].padhex --note# that the controller led responds to
						padsysex=padsysex..padnum.." "..g.palette[outnorm].R .." ".. g.palette[outnorm].G .." "..g.palette[outnorm].B.." "
				end --end for 1,64
				padupdate=remote.make_midi(sysex_header.."0B "..padsysex.." F7")
				table.insert(lpp_events,padupdate)
-- -----------------------------------------------------------------------------------------------
--[[
			if noscaleneeded==false then
--				local padevent = {}
				for i=1,64,1 do
					--local padnum = string.format("%x",i+35)
--remote.trace(string.format("%02x",padindex[i].pad))
					local padnum = padindex[i].padhex
--vprint("padnum",padnum)

					local modd = modulo(i-1,8)
					local keycolor="02"
					if(modd==0 or modd==7) then
						keycolor="40"
					end
--				padevent[i]=remote.make_midi("90 "..padnum.." "..keycolor)
--				table.insert(lpp_events,padevent[i])
				local padev=remote.make_midi("90 "..padnum.." "..keycolor)
				table.insert(lpp_events,padev)
--]]
--[[
					local transpose_event = make_lcd_midi_message("/INIT "..g.transpose)
					table.insert(lcd_events,transpose_event)
--]]
--[[
--vprint("padnum",padnum)
--vprint("",)
--vprint("",)
				end
			end
--]]
			 
-- -----------------------------------------------------------------------------------------------
tprint(lpp_events)
			init=0
			do_update_pads = 1
		end
-- -----------------------------------------------------------------------------------------------

		


























--[[
		if g.vartext_prev~=g.vartext then
			--Let the LCD know what the variation is
			local vartext = remote.get_item_text_value(g.var_item_index)
			local var_event = make_lcd_midi_message("/Reason/0/LPP/0/display/1/display "..vartext)
			table.insert(lcd_events,var_event)
			g.vartext_prev = g.vartext
			isvarchange = true
		end
--]]


--Test velocity output
--[[
--]]
------------------------------------------------------------------------------------------------------
-- Change this
-----------------------------------------------------------------------------------------------------
--[[
		if (g.last_notevelocity_delivered~=g.current_notevelocity) or (g.last_note_delivered~=g.current_note) then
			lpp_event={
				remote.make_midi("b0 xx yy",{ x = g.current_note, y = set_vel_color(g.current_notevelocity), port=1 }),
			}
			g.current_notevelocity=g.last_notevelocity_delivered
			g.current_note=g.last_note_delivered
			--local var_event = make_lcd_midi_message("New Note "..g.current_notevelocity)
			--table.insert(lpp_events,var_event)

		end
--]]
--remote.trace("remdevmidi 1\n")





--tprint(lpp_events)
		
		return lpp_events --send out a bunch of MIDI to the Launchpad Pro
	end --end port==1





	if(port==2) then
		local le = lcd_events
		lcd_events = {}
--remote.trace("remdevmidi 2 \n")
		return le
	end
--[[
--]]







end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++







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
	g.last_input_time = remote.get_time_ms()
	g.last_input_item = item_index
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_set_state(changed_items)
--tprint(changed_items)

--[[
--]]


	--look for the _Scope constant. Kong reports "KONG". Could use for a variety of things

	if remote.is_item_enabled(g.itemnum.scope) then
		local scope_text = remote.get_item_text_value(g.itemnum.scope)
		g.scopetext = scope_text
	else
		g.scopetext = ""
	end
	
	if remote.is_item_enabled(g.itemnum.var) then
		local var_text = remote.get_item_text_value(g.itemnum.var)
		g.vartext = var_text
	else
		g.vartext = ""
	end

	if(g.last_input_item~=nil) then
		if remote.is_item_enabled(g.last_input_item) then
			local feedback_text = remote.get_item_name_and_value(g.last_input_item)
			if string.len(feedback_text)>0 then
				g.feedback_enabled = true
				--g.lcd_state = string.format("%-16.16s",feedback_text)
				g.lcd_state = feedback_text
				g.lcd_index = g.last_input_item
			end
		end
	end

  -- FL: Collect all changed states for redrum "drum playing" - this part blinks the 3rd row drum selection pads
	for k,item_index in ipairs(changed_items) do
	if item_index == g.itemnum.accent then
	  g.accent = remote.get_item_value(item_index)
	end


		if item_index >= g.itemnum.first_step_item and item_index < g.itemnum.first_step_item+8 then
			local step_index = item_index - g.itemnum.first_step_item + 1
			g.step_value[step_index] = remote.get_item_value(item_index)
			-- FL: Add this if the item can be disabled
			-- g.step_is_disabled[step_index] = remote.is_item_enabled(item_index)

		elseif item_index >= g.itemnum.first_step_playing_item and item_index < g.itemnum.first_step_playing_item+8 then
			local step_index = item_index - g.itemnum.first_step_playing_item + 1
			g.step_is_playing[step_index] = remote.get_item_value(item_index)
		end
	end
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_prepare_for_use()
--	g.lcd_state_delivered = string.format("%-16.16s","Launchpad Pro")
	local retEvents={
		--default settings for Launchpad Pro

		remote.make_midi("F0 00 20 29 02 10 21 01 F7"), -- set standalone mode
--[[
		remote.make_midi("F0 00 20 29 02 10 2C 03 F7"), -- Programmer mode
		remote.make_midi("F0 00 20 29 02 10 0E 00 F7"), -- Blank all
		remote.make_midi("F0 00 20 29 02 10 0A 63 32 F7"), --Front light
--		remote.make_midi("F0 00 20 29 02 10 14 32 00 07 05 52 65 61 73 6F 6E F7"), -- scroll Reason
--		remote.make_midi("F0 00 20 29 02 10	 F7"),
--		remote.make_midi("F0 00 20 29 02 10	 F7"),
--send all local off on settings ch 16	191,122,64 
--		remote.make_midi("bF 7A 40")
--]]
	}
	init=1
	return retEvents
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function remote_release_from_use()
	local retEvents={
--		remote.make_midi("F0 00 20 29 02 10 2C 00 F7"), -- Note mode
	}
	return retEvents
end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function set_palettes()
palettes = {
		louisBertrandCastel = {
						[0]={R="07", G="03", B="20", },		 -- blue
						[1]={R="06", G="24", B="20", },		 -- blue-green
						[2]={R="05", G="24", B="0C", },		 -- green
						[3]={R="1C", G="24", B="09", },		 -- olive green
						[4]={R="3D", G="3D", B="0F", },		 -- yellow
						[5]={R="3D", G="34", B="0E", },		 -- yellow-orange
						[6]={R="3E", G="20", B="04", },		 -- orange
						[7]={R="3E", G="02", B="03", },		 -- red
						[8]={R="28", G="03", B="02", },		 -- crimson
						[9]={R="35", G="04", B="21", },		 -- violet
						[10]={R="12", G="03", B="1F", },		 -- agate
						[11]={R="1F", G="02", B="1F", },		 -- indigo
		},
		dDJameson = {
						[0]={R="3E", G="02", B="03", },		 -- red
						[1]={R="3D", G="11", B="04", },		 -- red-orange
						[2]={R="3E", G="20", B="04", },		 -- orange
						[3]={R="3D", G="34", B="0E", },		 -- orange-yellow
						[4]={R="3D", G="3D", B="0F", },		 -- yellow
						[5]={R="05", G="24", B="0C", },		 -- green
						[6]={R="06", G="24", B="20", },		 -- green-blue
						[7]={R="07", G="03", B="20", },		 -- blue
						[8]={R="12", G="03", B="1F", },		 -- blue-purple
						[9]={R="1F", G="02", B="1F", },		 -- purple
						[10]={R="29", G="05", B="21", },		 -- purple-violet
						[11]={R="35", G="04", B="21", },		 -- violet
		},
		theodorSeemann = {
						[0]={R="1A", G="07", B="07", },		 -- carmine
						[1]={R="3E", G="02", B="03", },		 -- scarlet
						[2]={R="3F", G="1F", B="01", },		 -- orange
						[3]={R="3F", G="35", B="0C", },		 -- yellow-orange
						[4]={R="3D", G="3D", B="0F", },		 -- yellow
						[5]={R="05", G="24", B="0D", },		 -- green
						[6]={R="06", G="24", B="20", },		 -- green blue
						[7]={R="07", G="03", B="20", },		 -- blue
						[8]={R="1F", G="02", B="1F", },		 -- indigo
						[9]={R="35", G="04", B="21", },		 -- violet
						[10]={R="1A", G="07", B="07", },		 -- brown
						[11]={R="04", G="04", B="04", },		 -- black
		},
		aWallaceRimington = {
						[0]={R="3E", G="02", B="03", },		 -- deep red
						[1]={R="28", G="03", B="02", },		 -- crimson
						[2]={R="3D", G="11", B="04", },		 -- orange-crimson
						[3]={R="3E", G="20", B="04", },		 -- orange
						[4]={R="3D", G="3D", B="0F", },		 -- yellow
						[5]={R="1C", G="24", B="09", },		 -- yellow-green
						[6]={R="05", G="24", B="0C", },		 -- green
						[7]={R="09", G="29", B="20", },		 -- blueish green
						[8]={R="06", G="24", B="20", },		 -- blue-green
						[9]={R="1F", G="02", B="1F", },		 -- indigo
						[10]={R="07", G="03", B="20", },		 -- deep blue
						[11]={R="35", G="04", B="21", },		 -- violet
		},
		hHelmholtz = {
						[0]={R="3D", G="3D", B="0F", },		 -- yellow
						[1]={R="05", G="24", B="0C", },		 -- green
						[2]={R="06", G="24", B="20", },		 -- greenish blue
						[3]={R="07", G="16", B="28", },		 -- cayan-blue
						[4]={R="1F", G="02", B="1F", },		 -- indigo blue
						[5]={R="35", G="04", B="21", },		 -- violet
						[6]={R="27", G="03", B="15", },		 -- end of red
						[7]={R="3E", G="02", B="03", },		 -- red
						[8]={R="34", G="0B", B="02", },		 -- red
						[9]={R="34", G="0B", B="02", },		 -- red
						[10]={R="36", G="06", B="14", },		 -- red orange
						[11]={R="3C", G="1E", B="03", },		 -- orange
		},
		aScriabin = {
						[0]={R="3E", G="02", B="03", },		 -- red
						[1]={R="35", G="04", B="21", },		 -- violet
						[2]={R="3D", G="3D", B="0F", },		 -- yellow
						[3]={R="16", G="15", B="21", },		 -- steely with the glint of metal
						[4]={R="07", G="16", B="28", },		 -- pearly blue the shimmer of moonshine
						[5]={R="28", G="03", B="02", },		 -- dark red
						[6]={R="07", G="03", B="20", },		 -- bright blue
						[7]={R="3E", G="20", B="04", },		 -- rosy orange
						[8]={R="1F", G="02", B="1F", },		 -- purple
						[9]={R="05", G="24", B="0C", },		 -- green
						[10]={R="16", G="15", B="21", },		 -- steely with a glint of metal
						[11]={R="07", G="16", B="28", },		 -- pearly blue the shimmer of moonshine
		},
		aBernardKlein = {
						[0]={R="31", G="02", B="02", },		 -- dark red
						[1]={R="3E", G="02", B="03", },		 -- red
						[2]={R="3D", G="11", B="04", },		 -- red orange
						[3]={R="3E", G="20", B="04", },		 -- orange
						[4]={R="3D", G="3D", B="0F", },		 -- yellow
						[5]={R="2F", G="38", B="0E", },		 -- yellow green
						[6]={R="05", G="24", B="0C", },		 -- green
						[7]={R="06", G="24", B="20", },		 -- blue-green
						[8]={R="07", G="03", B="20", },		 -- blue
						[9]={R="1E", G="06", B="21", },		 -- blue violet
						[10]={R="35", G="04", B="21", },		 -- violet
						[11]={R="27", G="03", B="15", },		 -- dark violet
		},
		iJBelmont = {
						[0]={R="3E", G="02", B="03", },		 -- red
						[1]={R="3D", G="11", B="04", },		 -- red-orange
						[2]={R="3E", G="20", B="04", },		 -- orange
						[3]={R="3D", G="34", B="04", },		 -- yellow-orange
						[4]={R="3D", G="3D", B="0F", },		 -- yellow
						[5]={R="2F", G="38", B="0E", },		 -- yellow-green
						[6]={R="04", G="23", B="0C", },		 -- green
						[7]={R="06", G="24", B="20", },		 -- blue-green
						[8]={R="07", G="03", B="20", },		 -- blue
						[9]={R="29", G="05", B="21", },		 -- blue-violet
						[10]={R="35", G="04", B="21", },		 -- violet
						[11]={R="2B", G="03", B="12", },		 -- red-violet
		},
		sZieverink = {
						[0]={R="2F", G="38", B="0E", },		 -- yellow/green
						[1]={R="05", G="24", B="0C", },		 -- green
						[2]={R="06", G="24", B="20", },		 -- blue/green
						[3]={R="07", G="03", B="20", },		 -- blue
						[4]={R="1F", G="02", B="1F", },		 -- indigo
						[5]={R="35", G="04", B="21", },		 -- violet
						[6]={R="1B", G="03", B="11", },		 -- ultra violet
						[7]={R="28", G="03", B="02", },		 -- infra red
						[8]={R="3E", G="02", B="03", },		 -- red
						[9]={R="3E", G="20", B="04", },		 -- orange
						[10]={R="3B", G="3C", B="21", },		 -- yellow/white
						[11]={R="3D", G="3D", B="0F", },		 -- yellow
		},
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
--[[
		FifthsCircleOld = {
						[0]={R="06", G="00", B="00", },		--R 
						[1]={R="00", G="15", B="0D", },		--BG
						[2]={R="3F", G="1F", B="00", },		--O 
						[3]={R="15", G="00", B="3F", },		--BV
						[4]={R="2E", G="2C", B="00", },		--Y 
						[5]={R="3F", G="00", B="15", },		--RV
						[6]={R="00", G="3F", B="00", },		--G 
						[7]={R="3F", G="05", B="00", },		--RO
						[8]={R="00", G="00", B="3F", },		--B 
						[9]={R="2C", G="17", B="00", },		--YO
						[10]={R="06", G="00", B="06", },	--V 
						[11]={R="07", G="16", B="00", },	--YG
		},
--]]		
	}
palettenames = {
'louisBertrandCastel',
'dDJameson',
'theodorSeemann',
'aWallaceRimington',
'hHelmholtz',
'aScriabin',
'aBernardKlein',
'iJBelmont',
'sZieverink',
'FifthsCircle',
}
g.palettes_length = table.getn(palettenames)
palettename = 'FifthsCircle'
g.palette = palettes[palettenames[10]]
palette_int = 0 
g.palette_delivered = 9 --for change filter
g.palette_selected = 9 -- record of presses, goes up and dn
g.palette_global = 9 -- current pal
palette_changed = false

--tprint(g.palette)

end
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

